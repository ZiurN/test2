trigger OpportunityTrigger on Opportunity (before insert, before update, after update, after insert)  {
 
    String recordTypeIdIndividuos = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
    String recordTypeIdIndividalCorp = XappiaHelper.getRecordType('Opportunity', 'Individual_Corporativo').Id;
    String recordTypeIdCorporativo = XappiaHelper.getRecordType('Opportunity', 'Corporativo').Id;
    Id perfilFrontId = XappiaHelper.getProfileIdByName('Front');
    Id rolEjecutivoId = [SELECT Id FROM UserRole WHERE DeveloperName = 'Ejecutivo_de_cuenta_corporativo' LIMIT 1].Id; 

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            Map<String, List<Opportunity>> oportunidadCorporativaIdOportunidadMap = new Map<String, List<Opportunity>>();
            
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            Map<String, Id> idsOppAccMap = new Map<String, Id>();

            Map<String, Id> idsOppAccFromLeadMap = new Map<String, Id>();
            List<Opportunity> oppsToUpdateToLead = new List<Opportunity>();
            
            List<Opportunity> oppsLocChanged = new List<Opportunity>();
            List<Opportunity> oppsToCheckReingreso = new List<Opportunity>();

            for (Opportunity oportunidad : Trigger.new) {
                
                
                Boolean userNoEjecutivo = UserInfo.getUserRoleId() != rolEjecutivoId;
                    
                Boolean oppIndToCheck = (oportunidad.RecordTypeId == recordTypeIdIndividuos ||
                oportunidad.RecordTypeId == recordTypeIdIndividalCorp) && userNoEjecutivo;
    
                Boolean oppCorpToCheck = oportunidad.RecordTypeId == recordTypeIdCorporativo && userNoEjecutivo;

                
                if((oportunidad.Localidad_new__c != null &&
                    !oportunidad.Es_corporativo__c) && (oppIndToCheck || oppCorpToCheck)) {
                    oppsLocChanged.add(oportunidad);
                }

                if (oportunidad.RecordTypeId == recordTypeIdIndividalCorp) {
                    oppsToCheckReingreso.add(oportunidad);
                    if(oportunidadCorporativaIdOportunidadMap.keySet().contains(oportunidad.Oportunidad_Corporativa__c)) {
                        List<Opportunity> opportunitysFromMap = oportunidadCorporativaIdOportunidadMap.get(oportunidad.Oportunidad_Corporativa__c);
                        opportunitysFromMap.add(oportunidad);
                        oportunidadCorporativaIdOportunidadMap.put(oportunidad.Oportunidad_Corporativa__c, opportunitysFromMap);
                    } else {
                        oportunidadCorporativaIdOportunidadMap.put(oportunidad.Oportunidad_Corporativa__c, new List<Opportunity>{oportunidad});
                    }
                }
                System.debug('opportunity ' + oportunidad.Tipo_de_Solicitud__c);
                Boolean shouldMapOrgFromAcc = (oportunidad.Tipo_de_Solicitud__c != null ?
                    oportunidad.Tipo_de_Solicitud__c.contains('REINGR') : false ) && UserInfo.getProfileId() != perfilFrontId;
            
                Boolean shouldMapIfAltaFromClosed = (oportunidad.Tipo_de_Solicitud__c != null ?
                oportunidad.Tipo_de_Solicitud__c.contains('ALTA') : false ) && UserInfo.getProfileId() != perfilFrontId && oportunidad.Account.Codigo_de_Afiliado__c == null;

                Boolean shouldMapOrgFromAccIfIndCoorp = UserInfo.getProfileId() != perfilFrontId && oportunidad.RecordTypeId == recordTypeIdIndividalCorp;
                
                if( shouldMapOrgFromAcc || shouldMapOrgFromAccIfIndCoorp || shouldMapIfAltaFromClosed) {
                    System.debug('oportunidad');
                    //idsOppAccMap.put(opp.Id, opp.Account);
                    idsOppAccMap.put(oportunidad.Id, oportunidad.AccountId);
                    oppsToUpdate.add(oportunidad);
                }   
        
            }

            if(!oportunidadCorporativaIdOportunidadMap.isEmpty()) {
                OpportunityHelper.addAccountToOpportunityWithRecordTypeIndividualCorporativo(oportunidadCorporativaIdOportunidadMap);
            }
            if(!idsOppAccMap.isEmpty()) {
                OpportunityHelper.copyPasteDataFromAccountToOpportunity(oppsToUpdate, idsOppAccMap);
            }
            if(!oppsLocChanged.isEmpty()){
                OpportunityHelper.validateRoleInLoc(oppsLocChanged);
            }

            if(!oppsToCheckReingreso.isEmpty()){
                OpportunityHelper.checkReintegroIndCorp(oppsToCheckReingreso);
            }
            

        }
         
        if(Trigger.isUpdate){
            OpportunityHelper.checkIfIsAcceptedByAsociado(Trigger.new);
            List<Opportunity> oppsToSetImporte = new List<Opportunity>();
            List<Id> oppsToUpdate = new List<Id>();
            List<Opportunity> oppsValidateRol = new List<Opportunity>();
            List<Opportunity> oppsLocChanged = new List<Opportunity>();
            List<Opportunity> oppsOwnerChanged = new List<Opportunity>();
            List<Opportunity> oppsWithDNIChanged = new List<Opportunity>();
            Map<Opportunity, Id> localidadIdsByOpp = new Map<Opportunity, Id>();

            for(Opportunity opp : Trigger.new) {
                Opportunity oldOpp = Trigger.oldMap.get(opp.Id);

                if(opp.Localidad_new__c != null && opp.Localidad_new__c != oldOpp.Localidad_new__c) {
                    
                    Boolean userNoEjecutivo = UserInfo.getUserRoleId() != rolEjecutivoId;
                    
                    Boolean oppIndToCheck = (opp.RecordTypeId == recordTypeIdIndividuos ||
                        opp.RecordTypeId == recordTypeIdIndividalCorp) && userNoEjecutivo;

                    Boolean oppCorpToCheck = opp.RecordTypeId == recordTypeIdCorporativo && userNoEjecutivo;

                    oppsLocChanged.add(opp);
                    if(oppIndToCheck || oppCorpToCheck) {
                        oppsValidateRol.add(opp);
                    }

                    localidadIdsByOpp.put(opp, opp.Localidad_new__c);
                }
                if(opp.Cotizacion_elegida__c != Trigger.oldMap.get(opp.Id).Cotizacion_elegida__c){
                    oppsToSetImporte.add(opp);
                }
                if(opp.OwnerId != Trigger.oldMap.get(opp.Id).OwnerId){
                    System.debug('Cambio owner');
                    oppsOwnerChanged.add(opp);
                }
                if(opp.StageName == 'Cerrada ganada'
                    && opp.StageName != Trigger.oldMap.get(opp.Id).StageName
                ) {
                    oppsToUpdate.add(opp.Id);
                }
                if(opp.Numero_de_documento__c != oldOpp.Numero_de_documento__c 
                    && String.isNotBlank(opp.AccountId)
                    && opp.RecordTypeId == recordTypeIdIndividuos
                ) {
                    oppsWithDNIChanged.add(opp);
                }
            }
            
            if(!oppsToSetImporte.isEmpty()) {
                OpportunityHelper.setImporteToOpps(oppsToSetImporte);
            }

            if(!oppsValidateRol.isEmpty()) {
                OpportunityHelper.validateRoleInLoc(oppsValidateRol);
            }

            if(!oppsOwnerChanged.isEmpty()) {
                OpportunityHelper.checkNewOwner(oppsOwnerChanged);
            }

            if(!oppsWithDNIChanged.isEmpty()) {
                OpportunityHelper.updateDNIInAccount(oppsWithDNIChanged);
            }

            if(!oppsLocChanged.isEmpty()) {
                OpportunityHelper.changeOganizadorInOpp(localidadIdsByOpp);
            }
            
            //if(!oppsToUpdate.isEmpty()){
                //OpportunityHelper.getNroAsociadoForIntegrantes(oppsToUpdate);
            //}      
         }
    }
    else {
        if (Trigger.isInsert) {
            Map<Id, List<Opportunity>> opportunitiesByUserId = new Map<Id, List<Opportunity>>();
            for (Opportunity opp : Trigger.new) {
                if (!opportunitiesByUserId.containsKey(opp.OwnerId)) {
                    opportunitiesByUserId.put(opp.OwnerId, new List<Opportunity>());
                }
                opportunitiesByUserId.get(opp.OwnerId).add(new Opportunity(Id = opp.Id));
            }
            if (!opportunitiesByUserId.isEmpty()) {
                OpportunityHelper.assignDelegacionFromUser(opportunitiesByUserId);
            }
        }
        if(Trigger.isUpdate) {
            List<Opportunity> oppsToActivateThePersonAccountList = new List<Opportunity>();
            List<Opportunity> oppsToUpdateRTIndvCorp = new List<Opportunity>();
            List<Id> oppsToUpdateRTIndividuos = new List<Id>();

            OpportunityHelper.validateSubestadoDDJJ(Trigger.new,Trigger.oldMap);

            for(Opportunity opp : Trigger.new){
                if(opp.StageName == 'Cerrada ganada'
                    && opp.StageName != Trigger.oldMap.get(opp.Id).StageName){
                    if(opp.RecordTypeId == recordTypeIdIndividalCorp){
                        if(opp.Tipo_de_Solicitud__c == 'ALTA'){
                            oppsToUpdateRTIndvCorp.add(opp);
                        }
                        else{
                            oppsToUpdateRTIndividuos.add(opp.Id);
                            oppsToActivateThePersonAccountList.add(opp);
                        }
                    }else if(opp.RecordTypeId == recordTypeIdIndividuos){
                        oppsToUpdateRTIndividuos.add(opp.Id);
                        //oppsToActivateThePersonAccountList.add(opp);
                    }
                }
                if(opp.RecordTypeId == recordTypeIdIndividuos 
                    && opp.Estado_de_solicitud__c == 'Transformada' 
                    && String.isNotBlank(opp.Nro_de_asociado__c)
                    && String.isNotBlank(opp.AccountId)
                ) {
                    oppsToActivateThePersonAccountList.add(opp);
                }
            }
            if(!oppsToUpdateRTIndvCorp.isEmpty()) {
                OpportunityHelper.createAccWhenOpportunityIndividualCorporativoChangedToClosedWin(oppsToUpdateRTIndvCorp);
            }
            if(!oppsToUpdateRTIndividuos.isEmpty()){
                OpportunityHelper.createGrupoFamiliarWhenOpportunityIndividuosChangedToClosedWin(oppsToUpdateRTIndividuos,null);
            }
            if(!oppsToActivateThePersonAccountList.isEmpty()) {
                OpportunityHelper.activateThePersonAccounts(oppsToActivateThePersonAccountList);
            }
            
        }

    }

}