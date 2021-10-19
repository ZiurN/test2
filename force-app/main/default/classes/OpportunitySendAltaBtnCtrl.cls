public without sharing class OpportunitySendAltaBtnCtrl { 

    public static Profile perfilUsuario =  [
            SELECT Id,Name
            FROM Profile
            WHERE Id = :UserInfo.getProfileId()
            LIMIT 1
        ];
    @AuraEnabled
    public static Response sendAltaToSS(String oppId) {
        System.debug('ID: ' + oppId);
        Opportunity oppFromSF = [
            SELECT Id, Medio_de_cobro__c, Fecha_de_vigencia_de_solicitud__c, Plan_del_grupo_familiar__c, Segmento_del_Grupo_Familiar__c,
                Tipo_de_Solicitud__c, Agencia__r.Codigo_de_delegacion__c, Obra_social_del_titular__r.Codigo_de_obra_social__c, Estado_Civil__c,
                Sexo__c, Fecha_de_Nacimiento__c, Nacionalidad__c, Localidad__c, Calle__c, Numero_de_documento__c, Piso__c, Tipo_de_Documento__c,
                Nmero_de_tarjeta_de_credito__c, Indicador_de_contratacion_de_emergencia__c, Indicador_de_Afiliacion_de_Inmediata__c, Account.Type,
                Account.LastName, Account.FirstName, Account.PersonEmail, Account.Phone, Account.PersonDepartment, Account.Actividad_codigo__c,Nuevo_titular__r.Codigo_de_Afiliado__c,
                Account.Tipo_de_Telefono__c, Account.Referido__c, Account.Codigo_de_Afiliado__c, Account.Parentesco__c, Nro_CBU_para_cobro_de_cuota__c, OwnerId, 
                Aportes_del_titular__c, Nro_de_solicitud__c, ActividadProfesion_del_titular__c, RecordTypeId, Description, CUIT__c,Codigo_de_empresa__c,
                Condicion_IVA__c, Numero__c, Codigo_Postal__c, Cotizacion_elegida__r.CP__c, Cotizacion_elegida__r.Provincia__c, Tipo_CBU__c,CreatedById,
                Cotizacion_elegida__r.Telfono__c, Cotizacion_elegida__r.Tipo_de_Telefono__c, Cotizacion_elegida__r.Correo_electronico__c,Usuario_error__c,
                Nro_asociado_titular_anterior__c, Amount, StageName, Tarjeta_de_credito__c, Reingresa_como__c, Cotizacion_elegida__c,Cobertura_anterior__c,
                Cotizacion_elegida__r.Plan_a_cotizar__c, Localidad_new__c, Localidad_new__r.Codigo_Postal__c, Localidad_new__r.Loc_Id__c, Owner.CommunityNickname,
                Localidad_new__r.Organizador_lookup__c, Dpto__c, Telefono__c, Correo_Electronico__c, LeadSource, Edad__c, Tipo_de_Asociado__c,Name,Sin_cotizacion__c,
                Apellido_INDCOR__c, Nombre_INDCORP__c,Cotizacion_elegida__r.Tipo_de_afiliado__c,Subestado_de_DDJJ__c,Cobertura_anterior__r.Codigo_de_obra_social__c,
                Parentesco__c, CUIL_del_CBU__c,Activar_seleccionar_archivos__c,RecordType.DeveloperName,Asociado_ReferenteOpp__r.Afi_Id__c,
                (
                    SELECT Apellido__c, Nombre__c, Indicador_de_aporte__c, Tipo_de_relacion_con_titular__c, Nacionalidad__c, Integrante_tipo_asociado__c,
                        Fecha_de_Nacimiento__c, Sexo__c, Estado_Civil__c, Nro_de_documento__c, Tipo_de_Documento__c, Aportes__c, Edad__c,
                        CUIT_Sin_guiones__c, Nro_de_asociado__c,Obra_social_actual__r.Codigo_de_obra_social__c,Discapacitado__c
                    FROM Integrantes__r
                )
            FROM Opportunity
            WHERE Id = :oppId
        ];
        User usuario = oppFromSF.Owner;
        User currentUser = [SELECT CommunityNickname, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        String body;
         List<String> idContentVersionList = new List<String>(); 
         List<ContentDocumentLink> linksList;
        Boolean isFront = false;

        if(currentUser.Profile.Name == 'Front') {
            usuario = currentUser;
            isFront = true;
        }
        System.debug(oppFromSF.RecordType.DeveloperName);
        if(oppFromSF.RecordTypeId != XappiaHelper.getRecordType('Opportunity','Corporativo').Id){
            Response validacionResp = validationsBeforeCallingToSS(usuario, oppFromSF, isFront);

            if(String.isNotEmpty(validacionResp.message)) {
                return validacionResp;
            }

            ResponseFiles respAtt = validateFiles(oppFromSF);
            if(respAtt.hasError){
                return new Response(respAtt.hasError,respAtt.message);
            }

        }

         linksList = [
              SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ShareType,
                  ContentDocument.FileType, ContentDocument.FileExtension
              FROM ContentDocumentLink
              WHERE LinkedEntityId =: oppFromSF.Id
         ];

        Map<String, Nota_de_Auditoria__c> idExtNotaMap = new Map<String, Nota_de_Auditoria__c>();
        List<Nota_de_Auditoria__c> notas = [
            SELECT Id, Nota__c, Id_externo_solicitudes__c, Oportunidad__c, CreatedBy.CommunityNickname
            FROM Nota_de_Auditoria__c 
            WHERE Oportunidad__c =: oppFromSF.Id
        ];

        for(Nota_de_Auditoria__c nota : notas) {
            idExtNotaMap.put(nota.Id_externo_solicitudes__c, nota); 
        }

         for(ContentDocumentLink cdl : linksList) {
          idContentVersionList.add(cdl.ContentDocument.LatestPublishedVersionId);
         }

        List<ContentVersion> cvList = [
        	SELECT Id
        	FROM ContentVersion 
        	WHERE Id IN :idContentVersionList AND Enviado__c = false 
        ];
        if(oppFromSF.RecordTypeId == XappiaHelper.getRecordType('Opportunity','Individuos').Id && !oppFromSF.Sin_cotizacion__c){
            
            List<Id> linksCotId = new List<Id>();
            List<ContentDocumentLink> linkCot = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :oppFromSF.Cotizacion_elegida__c];
            for(ContentDocumentLink link : linkCot){
                linksCotId.add(link.ContentDocumentId);
            }
            List<ContentVersion> cot = [
                SELECT Id, VersionData, FileExtension, FileType, ContentUrl, Title, PathOnClient, Description, 
                    Enviado__c, ContentDocumentId
                FROM ContentVersion 
                WHERE ContentDocumentId IN :linksCotId
                AND IsLatest = true
                ORDER BY LastModifiedDate DESC 
            ];
            if(!cot.isEmpty()){
            	if(cot.get(0).Enviado__c == false) {
            	    cvList.add(cot.get(0));
            	}
           	}
        }
        else{
            if(oppFromSF.Tipo_de_Solicitud__c == null){
                oppFromSF.Tipo_de_Solicitud__c = 'ALTA';
            }
        }
        // System.debug('cvList: ' + cvList);
        System.debug('notas: ' + notas);
        Response respuesta;

        //TODO: EN ALTA ENVIAR ID PARA LA ACTUALIZACION
        //ENCOLAR AttachmentQueueable
        If(oppFromSF.Tipo_de_Solicitud__c == 'ALTA') {
            Map<String,Object> bodyMap = generateJSON(usuario.CommunityNickname.toUpperCase(), oppFromSF, oppFromSF.Localidad_new__r.Loc_Id__c, notas);
            body = JSON.serialize(bodyMap);
            WSOpportunitySendAlta.Response resp = WSOpportunitySendAlta.sendAlta(body);
            //respuesta = handleResponseAlta(oppFromSF, idExtNotaMap, resp, null, bodyMap);
            respuesta = handleResponseAlta(oppFromSF, idExtNotaMap, resp, cvList, bodyMap);
        } else if(oppFromSF.Tipo_de_Solicitud__c == 'REING_GFAM') {
            Map<String,Object> bodyMap = generateJSON(usuario.CommunityNickname.toUpperCase(), oppFromSF, oppFromSF.Localidad_new__r.Loc_Id__c, notas);
            body = JSON.serialize(bodyMap);
            WSOpportunityReingresoGFam.Response resp = WSOpportunityReingresoGFam.enviarReingresoGrupoFamiliar(body);
            respuesta = handleResponseReingGFam(oppFromSF, idExtNotaMap, resp, cvList, bodyMap);
        } else if(oppFromSF.Tipo_de_Solicitud__c == 'REINGRESO') {
            Map<String, Object> bodyMap = generateReingresoJSON(usuario.CommunityNickname.toUpperCase(), oppFromSF, oppFromSF.Localidad_new__r.Loc_Id__c, notas);
            body = JSON.serialize(bodyMap);
            WSOpportunityReingreso.Response resp = WSOpportunityReingreso.sendReingreso(body);
            respuesta = handleResponseReingreso(oppFromSF, idExtNotaMap, resp, cvList, bodyMap);
        } else {
            return new Response(false, 'Debe seleccionar qué tipo de solicitud desea enviar');
        }
        System.debug('THE BODY: ' + body);
        return respuesta;
        
    }

        private static Response updateOppAndNotes(
            Opportunity oppFromSF, 
            Map<String, Nota_de_Auditoria__c> idExtNotaMap, 
            OpportunitySolicitudData data,
            String messageResp,
            List<ContentVersion> cvList
    ) {
        List<Nota_de_Auditoria__c> notasToUpdate = new List<Nota_de_Auditoria__c>();
        List<Nota_de_Auditoria__c> notasToInsert = new List<Nota_de_Auditoria__c>();
        List<ContentVersion> versionsToUpdate = new List<ContentVersion>();
        String mensaje = 'ok';

        oppFromSF.Cambio_Manual__c = false;
        oppFromSF.Estado_de_solicitud__c = data.estado_sol;
        oppFromSF.Nro_de_asociado__c = data.codigo_as;
        oppFromSF.Nro_de_solicitud__c = data.solafi_id;
        oppFromSF.Subestado_de_DDJJ__c = data.estado_dj;
        oppFromSF.Codigo_de_empresa__c = data.empresa_codigo;
        
        if (oppFromSF.Estado_de_solicitud__c == 'Transformada') {
            oppFromSF.StageName = 'Cerrada ganada';
        } else if(oppFromSF.Estado_de_solicitud__c == 'Incompleta') {
            mensaje = messageResp;
        }

        System.debug(data.notas);
        for(OpportunitySolicitudData.Notas notaWS : data.notas) {
            if(notaWS.sf_id != null  || idExtNotaMap.containsKey(notaWS.nota_id)){
                Nota_de_Auditoria__c notaToUpsert = new Nota_de_Auditoria__c();
                notaToUpsert.Id = notaWS.sf_id != null ? notaWS.sf_id : idExtNotaMap.get(notaWS.nota_id).Id;
                notaToUpsert.Id_externo_solicitudes__c = notaWS.nota_id;
                notaToUpsert.Nota__c = notaWS.texto_nota;
                notaToUpsert.Oportunidad__c = oppFromSF.Id;
                notasToUpdate.add(notaToUpsert);
            }
            else{
                Nota_de_Auditoria__c notaToUpsert = new Nota_de_Auditoria__c();
                notaToUpsert.Id_externo_solicitudes__c = notaWS.nota_id;
                notaToUpsert.Nota__c = notaWS.texto_nota;
                notaToUpsert.Oportunidad__c = oppFromSF.Id;
                notasToInsert.add(notaToUpsert);
            }

        }
        
        System.debug(oppFromSF);
        OpportunityUpdateNotes.updateNotesAndIntegrantes(oppFromSF,new List<Integrante__c>{},notasToUpdate,notasToInsert);

        
        User usuario = [SELECT CommunityNickname FROM User WHERE ID = :UserInfo.getUserId()];
        List<Id> versionIds = new List<Id>();
        if(cvList != null){
			for(ContentVersion ver : cvList){
           		versionIds.add(ver.Id);
        	}    
        }

        if(cvList != null){
                 if (!cvList.isEmpty()){
            System.enqueueJob(new AttachmentQueueable(usuario.CommunityNickname.toUpperCase(), VersionIds, oppFromSF, oppFromSF.Nro_de_solicitud__c));
       		}  
        }
 

        return new Response(false, mensaje);
    }


    private static Response updateOppAndNotesAlta(
        Opportunity oppFromSF, 
        Map<String, Nota_de_Auditoria__c> idExtNotaMap, 
        List<OpportunitySolicitudData> data,
        String messageResp,
        List<ContentVersion> cvList
    ) {
        List<Nota_de_Auditoria__c> notasToUpdate = new List<Nota_de_Auditoria__c>();
        List<Nota_de_Auditoria__c> notasToInsert = new List<Nota_de_Auditoria__c>();
        List<Integrante__c> integrantesToUpdate = new List<Integrante__c>();
        List<ContentVersion> versionsToUpdate = new List<ContentVersion>();
        String mensaje = 'ok';
        Map<Id,Integrante__c> integrantesMap = new Map<Id,Integrante__c>();
        for(Integrante__c integrante : oppFromSF.Integrantes__r){
            integrantesMap.put(integrante.Id,integrante);
        }
        for(OpportunitySolicitudData sol : data){
            if(sol.sf_id == oppFromSF.Id){
                oppFromSF.Cambio_Manual__c = false;
                oppFromSF.Estado_de_solicitud__c = sol.estado_sol;
                oppFromSF.Nro_de_asociado__c = sol.codigo_as;
                oppFromSF.Nro_de_solicitud__c = sol.solafi_id;
                oppFromSF.Codigo_de_empresa__c = sol.empresa_codigo;
                oppFromSF.Subestado_de_DDJJ__c = sol.estado_dj;
                if (oppFromSF.Estado_de_solicitud__c == 'Transformada') {
                    oppFromSF.StageName = 'Cerrada ganada';
                } else if(oppFromSF.Estado_de_solicitud__c == 'Incompleta') {
                    mensaje = messageResp;
                }

                for(OpportunitySolicitudData.Notas notaWS : sol.notas) {

                    if(notaWS.sf_id != null  || idExtNotaMap.containsKey(notaWS.nota_id)){
                        Nota_de_Auditoria__c notaToUpsert = new Nota_de_Auditoria__c();
                        notaToUpsert.Id = notaWS.sf_id != null ? notaWS.sf_id : idExtNotaMap.get(notaWS.nota_id).Id;
                        notaToUpsert.Id_externo_solicitudes__c = notaWS.nota_id;
                        notaToUpsert.Nota__c = notaWS.texto_nota;
                        notaToUpsert.Oportunidad__c = oppFromSF.Id;
                        notasToUpdate.add(notaToUpsert);
                    }
                    else{
                        Nota_de_Auditoria__c notaToUpsert = new Nota_de_Auditoria__c();
                        notaToUpsert.Id_externo_solicitudes__c = notaWS.nota_id;
                        notaToUpsert.Nota__c = notaWS.texto_nota;
                        notaToUpsert.Oportunidad__c = oppFromSF.Id;
                        notasToInsert.add(notaToUpsert);
                    }
                }
            }
            else{
                if(integrantesMap.containsKey(sol.sf_id)){
                    Integrante__c inte = integrantesMap.get(sol.sf_id);
                    inte.Nro_de_asociado__c = sol.codigo_as;
                }
            }
        }
        
        System.debug(oppFromSF);

        OpportunityUpdateNotes.updateNotesAndIntegrantes(oppFromSF,integrantesToUpdate,notasToUpdate,notasToInsert);

        /*Archivo_url__c[] files = [
            SELECT Id, Link__c, Ruta_relativa__c, Name, Enviado__c
            FROM Archivo_url__c 
            WHERE Oportunidad__c = :oppFromSF.Id
                    AND Enviado__c = false
        ];

        System.debug('THE FILES: ' + files);*/
        
        User usuario = [SELECT CommunityNickname FROM User WHERE ID = :UserInfo.getUserId()];
        List<Id> versionIds = new List<Id>();
        for(ContentVersion ver : cvList){
            versionIds.add(ver.Id);
        }
        System.debug(versionIds);
        if (!cvList.isEmpty()){
            System.enqueueJob(new AttachmentQueueable(usuario.CommunityNickname.toUpperCase(), versionIds, oppFromSF, oppFromSF.Nro_de_solicitud__c));
        }
        //-----------------------------------------------------------------------------------
        return new Response(false, mensaje);
    }

    private static Response handleResponseReingGFam(
            Opportunity oppFromSF, 
            Map<String, Nota_de_Auditoria__c> idExtNotaMap, 
            WSOpportunityReingresoGFam.Response resp,
            List<ContentVersion> cvList,
            Map<String, Object> bodyMap
    ) {
        if(!resp.hasError) {
            List<Integrante__c> familiaresToUpdate = new List<Integrante__c>();
            Integer i = 0;
            OpportunitySolicitudData titularData;
            for(OpportunitySolicitudData data : resp.result.data) {
                    if(data.sf_id == oppFromSF.Id){
                        titularData = data;
                    }
                    for(Integrante__c integrante : oppFromSF.Integrantes__r) {
                        if(data.sf_id == integrante.Id) {
                            integrante.Nro_de_asociado__c = data.codigo_as;
                            familiaresToUpdate.add(integrante);
                        }
                    }
                
            }
            OpportunityUpdateNotes.updateIntegrantes(familiaresToUpdate);
            //updateArchivosUrl(oppFromSF);
            return updateOppAndNotes(oppFromSF, idExtNotaMap, titularData, resp.result.message, cvList);
        } 

        return new Response(true, resp.message);
    }

    private static Response handleResponseReingreso(
            Opportunity oppFromSF, 
            Map<String, Nota_de_Auditoria__c> idExtNotaMap, 
            WSOpportunityReingreso.Response resp,
            List<ContentVersion> cvList,
            Map<String, Object> bodyMap
    ) {
        if(!resp.hasError) {
            List<Integrante__c> familiaresToUpdate = new List<Integrante__c>();
            Integer i = 0;
            OpportunitySolicitudData titularData;
            for(OpportunitySolicitudData data : resp.result.data) {
                    System.debug(data.sf_id); System.debug(oppFromSF.Id);
                    if(data.sf_id == oppFromSF.Id){
                        titularData = data;
                    }
                    for(Integrante__c integrante : oppFromSF.Integrantes__r) {
                        if(data.sf_id == integrante.Id) {
                            integrante.Nro_de_asociado__c = data.codigo_as;
                            familiaresToUpdate.add(integrante);
                        }
                    }
                
            }
            OpportunityUpdateNotes.updateIntegrantes(familiaresToUpdate);
            //updateArchivosUrl(oppFromSF);
            return updateOppAndNotes(oppFromSF, idExtNotaMap, titularData, resp.result.message, cvList);
        } 

        return new Response(true, resp.message);
    }

    private static Response handleResponseAlta(
            Opportunity oppFromSF, 
            Map<String, Nota_de_Auditoria__c> idExtNotaMap, 
            WSOpportunitySendAlta.Response resp,
            List<ContentVersion> cvList,
            Map<String, Object> bodyMap
    ) {
        if(!resp.hasError) {
            //updateArchivosUrl(oppFromSF);
            return updateOppAndNotesAlta(oppFromSF, idExtNotaMap, resp.result.data, resp.result.message, cvList);
        } 
        System.debug('resp.message: ' + resp.message);

        return new Response(true, resp.message);
    }

    private static Response validationsBeforeCallingToSS(User usuario, Opportunity opp, Boolean isFront) {
    
        String recordTypeIndividuos = XappiaHelper.getRecordType('Opportunity','Individuos').Id;
        String recordTypeCorporativo = XappiaHelper.getRecordType('Opportunity','Corporativo').Id; 
        String recordTypeIndividualCorp = XappiaHelper.getRecordType('Opportunity','Individual_Corporativo').Id;
        String errors = '';
        
        if(opp.StageName != 'En tramitación' && opp.StageName != 'En Negociación') {
            return new Response(false, 'La oportunidad debe estar en etapa "En tramitación" o "En Negociación" para poder enviarla');
        }
		System.debug('front ' + isFront);
		System.debug('correo ' + opp.Correo_electronico__c);
        if(opp.Agencia__c == null) {
            errors += 'Agencia: No puede estar vacío.\n';
        }
        if(opp.Fecha_de_vigencia_de_solicitud__c == null) {
            errors += 'Fecha de vigencia de solicitud: No puede estar vacío.\n';
        }
        if(!isFront && opp.Correo_Electronico__c == null) {
            errors += 'Correo Electrónico: no puede estar vacío.\n';                
        }
        if(opp.RecordTypeId == XappiaHelper.getRecordType('Opportunity','Individuos').Id){
            if(opp.Cotizacion_elegida__c == null && !opp.Sin_cotizacion__c) {
                errors += 'Cotizacion elegida: No puede estar vacío.\n';
            }
            if(opp.Plan_del_grupo_familiar__c != opp.Cotizacion_elegida__r.Plan_a_cotizar__c && !opp.Sin_cotizacion__c) {
                errors += 'El plan de la oportunidad no coincide con el de la cotización elegida.\n';
            }
        }
        if(opp.Sexo__c == null) {
            errors += 'Sexo: no puede estar vacío.\n';
        }

        if(opp.Tipo_de_Solicitud__c == 'ALTA' || opp.Tipo_de_Solicitud__c == 'REING_GFAM') {
            if(opp.Fecha_de_Nacimiento__c == null) {
                errors += 'Fecha de Nacimiento: no puede estar vacía.\n';
            }
            if(opp.Telefono__c == null) {
                errors += 'Telefono: no puede estar vacío.\n';
            }
            if(opp.Telefono__c != null && opp.Telefono__c.length() != 10) {
                errors += 'Telefono: debe contener 10 caracteres, asegúrese que contenga el código de área sin el 0.\n';
            }
            //------------------------------------------------------
            if(opp.Localidad_new__c == null) {
                errors += 'Localidad: no puede estar vacía.\n';
            }
            if(opp.Nacionalidad__c == null) {
                errors += 'Nacionalidad: No puede estar vacía.\n';
            }
            //if(opp.Localidad__c == null) {
                //errors += 'Localidad: No puede estar vacía.\n';
            //}
            //if(opp.Codigo_Postal__c == null) {
                //errors += 'Codigo Postal: No puede estar vacía.\n';
            //}
            if(opp.Tipo_de_Solicitud__c == null) {
                errors += 'Tipo de Solicitud: No puede estar vacío.\n';
            }
            //if(opp.Asesor_comercial__c == null) {
                //opp.Asesor_comercial__c.addError('No puede estar vacío.');
            //}

            if(opp.Condicion_IVA__c == '1' && opp.CUIT__c == null) {
                errors += 'CUIT: No puede estar vacío.\n';
            }
            if(opp.Tipo_de_Documento__c == null) {
                errors += 'Tipo de Documento: No puede estar vacío.\n';
            }
            if(opp.Numero_de_documento__c == null) {
                errors += 'Número de documento: No puede estar vacío.\n';
            }
            //if(opp.Estado_Civil__c == 'C' && opp.Edad_cnyuge__c == null) {
                //opp.Edad_cnyuge__c.addError('No puede estar vacía si el Estado civil es Casado.');
            //}
            //if(opp.Tipo_de_Asociado__c == null) {
                //opp.Tipo_de_Asociado__c.addError('No puede estar vacío.');
            //}
            //if(opp.Tipo_contacto__c == null) {
                //opp.Tipo_contacto__c.addError('No puede estar vacío.');
            //}
            //if(opp.Provincia__c == null) {
                //opp.Provincia__c.addError('No puede estar vacío.');
            //}
            if(opp.Calle__c == null) {
                errors += 'Calle: No puede estar vacío.\n';
            }
            if(opp.Numero__c == null) {
                errors += 'Número: No puede estar vacío.\n';
            }
            if((opp.Segmento_del_Grupo_Familiar__c == 'OBLDIR' || opp.Segmento_del_Grupo_Familiar__c == 'OBLEMP') 
                    && opp.Aportes_del_titular__c == null
            ) {
                errors += 'Aportes del titular: No puede estar vacío.\n';
            }
            if(opp.Segmento_del_Grupo_Familiar__c == null) {
                errors += 'Segmento del grupo familiar: No puede estar vacío.\n';
            }
            if(opp.Condicion_IVA__c == null) {
                errors += 'Condición IVA: No puede estar vacío.\n';
            }
            if(opp.Plan_del_grupo_familiar__c == null) {
                errors += 'Plan del grupo familiar: No puede estar vacío.\n';
            }
            if(opp.ActividadProfesion_del_titular__c == null) {
                errors += 'Actividad Profesional: No puede estar vacío.\n';
            }
            if(opp.Medio_de_cobro__c == null) {
                errors += 'Medio de cobro: No puede estar vacío.\n';
            }
            if(opp.Nmero_de_tarjeta_de_credito__c == null && opp.Medio_de_cobro__c == 'Tarjeta') {
                errors += 'Número de tarjeta de crédito: No puede estar vacío.\n';
            }
            if(opp.Tarjeta_de_credito__c == null && opp.Medio_de_cobro__c == 'Tarjeta') {
                errors += 'Tarjeta de crédito: No puede estar vacía.\n';
            }
            if(opp.Nro_CBU_para_cobro_de_cuota__c == null && opp.Medio_de_cobro__c == 'CBU') {
                errors += 'Nro CBU para cobro de cuota: No puede estar vacío.\n';
            }
            if(opp.Tipo_CBU__c == null && opp.Medio_de_cobro__c == 'CBU') {
                errors += 'Tipo CBU: No puede estar vacío.\n';
            }
            //if(oppFromSF.Obra_social_del_titular__r.Codigo_de_obra_social__c == null) {
                //errors += 'Obra social del titular: No puede estar vacío.\n';
            //}
            
        }

        if(opp.Tipo_de_Solicitud__c == 'REING_GFAM' || opp.Tipo_de_Solicitud__c == 'REINGRESO') {
            if(opp.Account.Codigo_de_Afiliado__c == null) {
                errors += 'En la Cuenta, Código de Afiliado: No puede estar vacío.\n';
            }
        }

        if(opp.Tipo_de_Solicitud__c == 'REINGRESO') {
            if(opp.Nro_de_solicitud__c == null) {
                if(!isFront && opp.ActividadProfesion_del_titular__c == null) {
                    errors += 'Actividad/Profesión del titular: No puede estar vacía.\n';
                }
                if(opp.Segmento_del_Grupo_Familiar__c == null) {
                    errors += 'Segmento del grupo familiar: No puede estar vacío.\n';
                }
                //if(opp.Medio_de_cobro__c == null) {
                    //errors += 'Medio de cobro: No puede estar vacío.\n';
                //}
                if(opp.Estado_Civil__c == null) {
                    errors += 'Estado Civil: No puede estar vacío.\n';
                }
            }
            if(opp.Reingresa_como__c == 'Familiar') {
                if(isFront) {
                    if(opp.Parentesco__c == null) {
                        errors += 'Parentesco: No puede estar vacío.\n';
                    }
                }
                else {
                    if(opp.Nro_asociado_titular_anterior__c == null) {
                        errors += 'Nro asociado titular anterior: No puede estar vacío.\n';
                    } 
                    if(opp.Account.Parentesco__c == null) {
                        errors += 'En la Cuenta, Parentesco: No puede estar vacío.\n';
                    }
                }
            } else if(opp.Reingresa_como__c == 'Titular') {
                if(opp.Correo_Electronico__c == null) {
                    errors += 'Correo Electrónico: no puede estar vacío.\n';                
                }
                if(opp.Obra_social_del_titular__r.Codigo_de_obra_social__c == null) {
                    errors += 'Obra social del titular: No puede estar vacío.\n';
                }
                if(opp.Plan_del_grupo_familiar__c == null) { 
                    errors += 'Plan del grupo familiar: No puede estar vacío.\n';
                }
                if(opp.Medio_de_cobro__c == null) {
                    errors += 'Medio de cobro: No puede estar vacío.\n';
                }
                if(opp.Nmero_de_tarjeta_de_credito__c == null && opp.Medio_de_cobro__c == 'Tarjeta') {
                    errors += 'Número de tarjeta de crédito: No puede estar vacío.\n';
                }
                if(opp.Tarjeta_de_credito__c == null && opp.Medio_de_cobro__c == 'Tarjeta') {
                    errors += 'Tarjeta de crédito: No puede estar vacía.\n';
                }
                if(opp.Nro_CBU_para_cobro_de_cuota__c == null && opp.Medio_de_cobro__c == 'CBU') {
                    errors += 'Nro CBU para cobro de cuota: No puede estar vacío.\n';
                }
                if(opp.Tipo_CBU__c == null && opp.Medio_de_cobro__c == 'CBU') {
                    errors += 'Tipo CBU: No puede estar vacío.\n';
                }
                if(opp.Condicion_IVA__c == null) {
                    errors += 'Condición IVA: No puede estar vacío.\n';
                } else if(opp.Condicion_IVA__c == '1' && opp.CUIT__c == null) {
                    errors += 'CUIT: No puede estar vacío.\n';
                }

            } else if(opp.Reingresa_como__c == null) {
                errors += 'Reingresa como: No puede estar vacío.\n';
            }
        }

        return new Response(false, errors);
    }
    
    public static Map<String, Object> generateReingresoJSON(
                                                String usuario, 
                                                Opportunity oppFromSF, 
                                                String loc,
                                                List<Nota_de_Auditoria__c> allNotas
    ) {
        List<Nota_de_Auditoria__c> notas = new List<Nota_de_Auditoria__c>();
        List<Object> encabezadoListStr = new List<Object>();
        String jsonS;
        String cobroCodigo;
        String aa2 = 'OTROS';
        String cobroNro;

        for(Nota_de_Auditoria__c nota : allNotas) {
            if(nota.Id_externo_solicitudes__c == null) {
                notas.add(nota);
            }
        }
        String tel = XappiaHelper.stringToNumericString(oppFromSF.Telefono__c);
        if (tel.length() > 10 && tel.indexOf('0') == 0) {
            tel = tel.substring(1);
        }
        System.debug('****tel ' + tel);

        Map<String, Object> encabezado = new Map<String, Object> {
            'civa_codigo' => oppFromSF.Condicion_IVA__c,
            'sexo' => oppFromSF.Sexo__c,
            'e_civil' => oppFromSF.Estado_Civil__c,
            'fecha_vigencia' => oppFromSF.Fecha_de_vigencia_de_solicitud__c != null 
                                    ? oppFromSF.Fecha_de_vigencia_de_solicitud__c.format() : null,
            'agencia_codigo' => oppFromSF.Agencia__r.Codigo_de_delegacion__c,
            'usuario' => usuario,
			'referente_id' => oppFromSF.Asociado_ReferenteOpp__c != null ? oppFromSF.Asociado_ReferenteOpp__r.Afi_Id__c : null,
            'emergencia' => oppFromSF.Indicador_de_contratacion_de_emergencia__c ? 'S' : 'N',
            'afi_codigo' => oppFromSF.Account.Codigo_de_Afiliado__c,
            'tel_numero' => tel,
            //'tel_tipo' => oppFromSF.Account.Tipo_de_Telefono__c,
            //'tel_tipo' => oppFromSF.Cotizacion_elegida__r.Tipo_de_Telefono__c,
            'tel_tipo' => 'TEL',
            'localidad' => loc,
            'sf_id' => oppFromSF.Id
        };
            
        if(oppFromSF.Piso__c != null){
            encabezado.put('doc_piso', oppFromSF.Piso__c);
        }

        if(oppFromSF.Dpto__c != null){
            encabezado.put('doc_depto', oppFromSF.Dpto__c);
        }

        if(notas.size() > 0) {
            encabezado.put('notas', notas[0].Nota__c);
        }
        
        if(oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLDIR' || oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLEMP') { 
            encabezado.put('importe', oppFromSF.Aportes_del_titular__c);
        }
        
        if(oppFromSF.Nro_de_solicitud__c != null) { 
            encabezado.put('solicitud_id', oppFromSF.Nro_de_solicitud__c);
            encabezado.put('estado_dj', oppFromSF.Subestado_de_DDJJ__c);
        }

        if(oppFromSF.Reingresa_como__c == 'Titular') {
            if(oppFromSF.Medio_de_cobro__c == 'Tarjeta') {
                cobroCodigo = oppFromSF.Tarjeta_de_credito__c;
                aa2 = cobroCodigo != null ? 'DEBAUT' : 'OTROS';
                cobroNro = oppFromSF.Nmero_de_tarjeta_de_credito__c;
            } else if(oppFromSF.Medio_de_cobro__c == 'CBU') {
                cobroNro = oppFromSF.Nro_CBU_para_cobro_de_cuota__c;
                cobroCodigo = oppFromSF.Tipo_CBU__c;
                encabezado.put('cuil_cbu', oppFromSF.CUIL_del_CBU__c);

                if (oppFromSF.Segmento_del_Grupo_Familiar__c == 'VOLDIR' 
                        || oppFromSF.Segmento_del_Grupo_Familiar__c == 'VOLEMP') {
                    aa2 = 'CBUVOL';
                } else {
                    aa2 = 'DEBAUT';
                }
            } else if(oppFromSF.Medio_de_cobro__c == 'Otros') {
                cobroNro = null;
            }

            encabezado.put('dom_numero', oppFromSF.Numero__c != null ? String.valueOf(oppFromSF.Numero__c) : null);
            encabezado.put('dom_calle', oppFromSF.Calle__c);
            encabezado.put('tipo_reingreso', 'TIT');
            encabezado.put('aa_codigo', oppFromSF.Segmento_del_Grupo_Familiar__c);
            encabezado.put('acti_codigo', oppFromSF.ActividadProfesion_del_titular__c);
            encabezado.put('aa3_codigo', 'SC');
            encabezado.put('aa2_codigo', aa2);
            encabezado.put('email', oppFromSF.Correo_Electronico__c);
            encabezado.put('codigo_obrasocial', oppFromSF.Obra_social_del_titular__r.Codigo_de_obra_social__c);
            encabezado.put('codigo_plan', oppFromSF.Plan_del_grupo_familiar__c);
            encabezado.put('cobro_medio', cobroCodigo);
            encabezado.put('cobro_numero', cobroNro);
            if(oppFromSF.CUIT__c != null) {
                encabezado.put('cuit', oppFromSF.CUIT__c);
            }
        } else if(oppFromSF.Reingresa_como__c == 'Familiar') {
            encabezado.put('tipo_reingreso', 'FAM');
            encabezado.put('afi_codigo_tit', oppFromSF.Nuevo_titular__r.Codigo_de_Afiliado__c); 
            encabezado.put('parentesco', oppFromSF.Parentesco__c);
            //encabezado.put('parentesco', oppFromSF.Account.Parentesco__c);
            encabezado.put('codigo_obrasocial', oppFromSF.Obra_social_del_titular__r.Codigo_de_obra_social__c);
            
            if(oppFromSF.CUIT__c != null) {
                encabezado.put('cuit', oppFromSF.CUIT__c);
            }
            
            

        }
        List<Object> familiaresListStr = new List<Object>();
        List<Object> notasListStr = new List<Object>();
        for(Integrante__c familiar : oppFromSF.Integrantes__r) {
            Map<String, Object> familiarJSON = new Map<String, Object> {
                    'deriva_aportes' => familiar.Indicador_de_aporte__c ? 'V' : 'F',
                    'parentesco' => familiar.Tipo_de_relacion_con_titular__c,
                    'nacionalidad' => familiar.Nacionalidad__c,
                    'fecha_nac' => familiar.Fecha_de_Nacimiento__c != null ? familiar.Fecha_de_Nacimiento__c.format() : null,
                    'sexo' => familiar.Sexo__c,
                    'e_civil' => familiar.Estado_Civil__c,
                    'doc_numero' => familiar.Nro_de_documento__c,
                    'doc_tipo' => familiar.Tipo_de_Documento__c,
                    'nombres' => familiar.Nombre__c,
                    'apellido' => familiar.Apellido__c,
                    'sf_id' => familiar.Id
            };

            if(oppFromSF.Tipo_de_Solicitud__c == 'REING_GFAM') {
                familiarJSON.put('afi_codigo', familiar.Nro_de_asociado__c);
            }
            if(familiar.Indicador_de_aporte__c) {
                familiarJSON.put('cuit', familiar.CUIT_Sin_guiones__c);
                familiarJSON.put('importe_aportes', familiar.Aportes__c);
            }

            familiaresListStr.add(familiarJSON);
        }

        for(Nota_de_Auditoria__c nota : notas) {
            String nick = String.isBlank(nota.CreatedBy.CommunityNickname) ? null : nota.CreatedBy.CommunityNickname.toUpperCase();
            Map<String, Object> notaJSON = new Map<String, Object> {
                'usuario_nota' => nick,
                'sf_id' => nota.Id,
                'texto' => nota.Nota__c
            };

            notasListStr.add(notaJSON);
        }
    
        List<Object> archivosListStr = new List<Object>(); 

        encabezadoListStr.add(encabezado);
        
        return new Map<String, Object> {
                'notas' => notasListStr,
                'familiares' => familiaresListStr,
                'archivos' => archivosListStr,
                'encabezado' => encabezadoListStr
            };
    }

    /*public static List<Object> generateFilesJSON(Opportunity oppFromSF) {
        Archivo_url__c[] files = [
            SELECT Id, Link__c, Ruta_relativa__c, Name, Enviado__c
            FROM Archivo_url__c 
            WHERE Oportunidad__c = :oppFromSF.Id
                    AND Enviado__c = false
        ];
        List<Object> filesJSON = new List<Object>();
        for(Archivo_url__c file : files) {
            //System.debug('file.Name: ' + file.Name);
            Map<String, Object> fileJSON = new Map<String, Object> {
                'url_absoluta' => file.Link__c,
                'url' => file.Ruta_relativa__c,
                'nombre' => file.Name.toUpperCase()
            };

            filesJSON.add(fileJSON);
        }

        System.debug('****filesJSON: ' + filesJSON);
        return filesJSON;
    }

    public static void updateArchivosUrl(Opportunity oppFromSF) {
        Archivo_url__c[] files = [
            SELECT Id, Enviado__c
            FROM Archivo_url__c 
            WHERE Oportunidad__c = :oppFromSF.Id
                    AND Enviado__c = false
        ];

        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        for(Archivo_url__c file : files) {
            file.Enviado__c = true;
        }

        update files;
    }*/

    public static Map<String,Object> generateJSON(
                                        String usuario, 
                                        Opportunity oppFromSF, 
                                        String loc, 
                                        List<Nota_de_Auditoria__c> allNotas
    ) {

        List<Nota_de_Auditoria__c> notas = new List<Nota_de_Auditoria__c>();
        for(Nota_de_Auditoria__c nota : allNotas) {
            if(nota.Id_externo_solicitudes__c == null) {
                notas.add(nota);
            }
        }

        System.debug('****notas ' + notas);
        String jsonS;
        List<Object> encabezadoListStr = new List<Object>();
        List<Object> familiaresListStr = new List<Object>();
        List<Object> notasListStr = new List<Object>();
        String cobroCodigo;
        String aa2 = 'OTROS';
        String cobroNro;

        String tel = XappiaHelper.stringToNumericString(oppFromSF.Telefono__c);
        if (tel.length() > 10 && tel.indexOf('0') == 0) {
            tel = tel.substring(1);
        }
        System.debug('****tel ' + tel);
        
        if(oppFromSF.Medio_de_cobro__c == 'Tarjeta') {
            cobroCodigo = oppFromSF.Tarjeta_de_credito__c;
            aa2 = cobroCodigo != null ? 'DEBAUT' : 'OTROS';
            cobroNro = oppFromSF.Nmero_de_tarjeta_de_credito__c;
        } else if(oppFromSF.Medio_de_cobro__c == 'CBU') {
            cobroNro = oppFromSF.Nro_CBU_para_cobro_de_cuota__c;
            cobroCodigo = oppFromSF.Tipo_CBU__c;

            if (oppFromSF.Segmento_del_Grupo_Familiar__c == 'VOLDIR' 
                    || oppFromSF.Segmento_del_Grupo_Familiar__c == 'VOLEMP') {
                aa2 = 'CBUVOL';
            } else {
                aa2 = 'DEBAUT';
            }
        } else if(oppFromSF.Medio_de_cobro__c == 'Otros') {
            cobroNro = null;
        }
        
        for(Nota_de_Auditoria__c nota : notas) {
            String nick = String.isBlank(nota.CreatedBy.CommunityNickname) ? null : nota.CreatedBy.CommunityNickname.toUpperCase();
            Map<String, Object> notaJSON = new Map<String, Object> {
                'usuario_nota' => nick,
                'sf_id' => nota.Id,
                'texto' => nota.Nota__c

            };

            notasListStr.add(notaJSON);
        }

        Map<String, Object> encabezado = new Map<String, Object> {
                'cobro_medio' => cobroCodigo,
                'cobro_numero' => cobroNro,
                'referido' => oppFromSF.LeadSource == '15' ? 'R' : 'NR',
                'asoc_inmediata' => oppFromSF.Indicador_de_Afiliacion_de_Inmediata__c ? 'S' : 'N', 
                'emergencia' => oppFromSF.Indicador_de_contratacion_de_emergencia__c ? 'S' : 'N', 
                'civa_codigo' => oppFromSF.Condicion_IVA__c,
                'referente_id' => oppFromSF.Asociado_ReferenteOpp__c != null ? oppFromSF.Asociado_ReferenteOpp__r.Afi_Id__c : null,
                'doc_numero' => oppFromSF.Numero_de_documento__c,
                'doc_tipo' => oppFromSF.Tipo_de_Documento__c,
                //'email' => oppFromSF.Account.PersonEmail,
                'email' => oppFromSF.Correo_Electronico__c,
                //'tel_numero' => oppFromSF.Account.Phone,
                'tel_numero' => tel,
                //'tel_tipo' => oppFromSF.Account.Tipo_de_Telefono__c,
                //'tel_tipo' => oppFromSF.Cotizacion_elegida__r.Tipo_de_Telefono__c,
                'tel_tipo' => 'TEL',
                'dom_numero' => oppFromSF.Numero__c != null ? String.valueOf(oppFromSF.Numero__c) : null,
                'dom_calle' => oppFromSF.Calle__c,
                'localidad' => loc,
                'nacionalidad' => oppFromSF.Nacionalidad__c,
                'fecha_nac' => oppFromSF.Fecha_de_Nacimiento__c != null ? oppFromSF.Fecha_de_Nacimiento__c.format() : null,
                'sexo' => oppFromSF.Sexo__c,
                'e_civil' => oppFromSF.Estado_Civil__c,
                'nombres' => oppFromSF.Nombre_INDCORP__c != null ? oppFromSF.Nombre_INDCORP__c : oppFromSF.Name.substringAfter(' ') ,
                'apellidos' => oppFromSF.Apellido_INDCOR__c != null ? oppFromSF.Apellido_INDCOR__c : oppFromSF.Name.substringBefore(' '),
                'aa_codigo' => oppFromSF.Segmento_del_Grupo_Familiar__c,
                'acti_codigo' => oppFromSF.ActividadProfesion_del_titular__c,
                'aa3_codigo' => 'SC',
                'aa2_codigo' => aa2,
                'codigo_plan' => oppFromSF.Plan_del_grupo_familiar__c,
                'codigo_obrasocial' => oppFromSF.Obra_social_del_titular__r.Codigo_de_obra_social__c,
                'usuario' => usuario,
                'agencia_codigo' => oppFromSF.Agencia__r.Codigo_de_delegacion__c,
                'fecha_vigencia' => oppFromSF.Fecha_de_vigencia_de_solicitud__c != null 
                                        ? oppFromSF.Fecha_de_vigencia_de_solicitud__c.format() : null,
                'sf_id' => oppFromSF.Id
                
        };

        if(oppFromSF.Cobertura_anterior__c != null){
            encabezado.put('codigo_obrasocial_ant', oppFromSF.Cobertura_anterior__r.Codigo_de_obra_social__c);
        }

        if(oppFromSF.Piso__c != null){
            encabezado.put('doc_piso', oppFromSF.Piso__c);
        }

        if(oppFromSF.Dpto__c != null){
            encabezado.put('doc_depto', oppFromSF.Dpto__c);
        }

        if(oppFromSF.CUIT__c != null) {
            encabezado.put('cuit', oppFromSF.CUIT__c);
        }
        if(oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLDIR' || oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLEMP') { 
            encabezado.put('importe', oppFromSF.Aportes_del_titular__c);
        }
        if(oppFromSF.Nro_de_solicitud__c != null) { 
            encabezado.put('solicitud_id', oppFromSF.Nro_de_solicitud__c);
            encabezado.put('estado_dj', oppFromSF.Subestado_de_DDJJ__c);
        }
        if(oppFromSF.Tipo_de_Solicitud__c == 'REING_GFAM') {
            encabezado.put('afi_codigo', oppFromSF.Account.Codigo_de_Afiliado__c);
        }
        if(oppFromSF.Medio_de_cobro__c == 'CBU') {
            encabezado.put('cuil_cbu', oppFromSF.CUIL_del_CBU__c);
        }

        encabezadoListStr.add(encabezado);

        for(Integrante__c familiar : oppFromSF.Integrantes__r) {
            Map<String, Object> familiarJSON = new Map<String, Object> {
                    'deriva_aportes' => familiar.Indicador_de_aporte__c ? 'V' : 'F',
                    'parentesco' => familiar.Tipo_de_relacion_con_titular__c,
                    'nacionalidad' => familiar.Nacionalidad__c,
                    'fecha_nac' => familiar.Fecha_de_Nacimiento__c != null ? familiar.Fecha_de_Nacimiento__c.format() : null,
                    'sexo' => familiar.Sexo__c,
                    'e_civil' => familiar.Estado_Civil__c,
                    'doc_numero' => familiar.Nro_de_documento__c,
                    'doc_tipo' => familiar.Tipo_de_Documento__c,
                    'nombres' => familiar.Nombre__c,
                    'apellido' => familiar.Apellido__c,
                    'sf_id' => familiar.Id,
                    'codigo_obrasocial' => familiar.Obra_social_actual__r.Codigo_de_obra_social__c
            };

            if(familiar.Discapacitado__c != null){
                String disc = familiar.Discapacitado__c == 'Si' ? 'V' : 'F';
                familiarJSON.put('discapacitado', disc);
            }

            if(oppFromSF.Tipo_de_Solicitud__c == 'REING_GFAM') {
                familiarJSON.put('afi_codigo', familiar.Nro_de_asociado__c);
            }
            if(familiar.Indicador_de_aporte__c) {
                familiarJSON.put('cuit', familiar.CUIT_Sin_guiones__c);
                familiarJSON.put('importe_aportes', familiar.Aportes__c);
            }

            familiaresListStr.add(familiarJSON);
        }
        
        List<Object> archivosListStr;
        archivosListStr = new List<Object>();
        
        return new Map<String, Object> {
                    'notas' => notasListStr,
                    'archivos' => archivosListStr,
                    'familiares' => familiaresListStr,
                    'encabezado' => encabezadoListStr
            };
    }


    private static ResponseFiles validateFiles(Opportunity oppFromSF){
        List<String> prefijosTitular = new List<String>();
        Map<String, List<String>> prefijosIntegrantesMap = new Map<String, List<String>>();
        List<Id> docsToSend = new List<Id>();
        String tipo_solicitud = null;
        if(oppFromSF.RecordTypeId == XappiaHelper.getRecordType('Opportunity','Individual_Corporativo').Id || oppFromSF.Sin_cotizacion__c){
            tipo_solicitud = oppFromSF.Tipo_de_Asociado__c;
        }
        else{
            tipo_solicitud = oppFromSF.Cotizacion_elegida__r.Tipo_de_afiliado__c;
        }
        User usuario = [SELECT Profile.Name FROM User WHERE Id = :oppFromSF.OwnerId];
        //if(usuario.Profile.Name == 'Front'){
            //prefijosTitular.add('nota de aceptacion_');
        //}

        System.debug(oppFromSf.Activar_seleccionar_archivos__c);
        System.debug(perfilUsuario);
       	Boolean isVentas = perfilUsuario.Name == 'Lider de Ventas' || perfilUsuario.Name == 'Agente de Ventas';
        if( !isVentas || (isVentas && oppFromSF.Nro_de_solicitud__c == null )){
            if((oppFromSF.Segmento_del_Grupo_Familiar__c != null && !isVentas) || (isVentas && oppFromSF.Activar_seleccionar_archivos__c)){
                prefijosTitular.add('Sola_');
                prefijosTitular.add('Solb_');
                prefijosTitular.add('DDJJa_');
                prefijosTitular.add('DDJJb_');
                
            }
            if(oppFromSF.Segmento_del_Grupo_Familiar__c != null && !oppFromSF.Activar_seleccionar_archivos__c  && usuario.Profile.Name != 'Front' && oppFromSF.Nro_de_solicitud__c == null){
                prefijosTitular.add('Avalian - Solicitud de ingreso y DDJJ completa.pdf');
            
                
            }
            
            if(oppFromSF.Segmento_del_Grupo_Familiar__c != null){
                prefijosTitular.add('dni_titular_');
            }
            
            //Documentacion requerida cuando reingresa como familiar
            if(oppFromSF.Reingresa_como__c == 'Familiar'){
                if((oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLDIR' || oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLEMP') && oppFromSF.Parentesco__c == 'HI'){
                    prefijosTitular.add('cert_nacimiento_');
                    prefijosTitular.add('cert_negativa_');
                }
                if((oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLDIR' || oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLEMP') && oppFromSF.Parentesco__c == 'CO'){
                    prefijosTitular.add('cert_matrimonio_');
                    prefijosTitular.add('cert_negativa_');
                    System.debug('DOCUMENTACION');
                    System.debug(oppFromSF.Aportes_del_titular__c > 0 && tipo_solicitud == 'Relacion de Dependencia');
                    System.debug(tipo_solicitud);
                    if(oppFromSF.Aportes_del_titular__c > 0){
                        if(tipo_solicitud == 'Relacion de Dependencia'){
                            System.debug('Relacion DEP');
                            prefijosTitular.add('ultimo_recibo_sueldo_');
                            //prefijosTitular.add('codem_');
                        }
                
                        if(tipo_solicitud == 'Monotributista'){
                            //prefijosTitular.add('codem_');
                            prefijosTitular.add('monotributo_152_');
                            prefijosTitular.add('monotributo_184_');
                            prefijosTitular.add('ultimos_pagos_mono_');
                        }
                    }
                }
                
            }
    
            if(oppFromSF.Segmento_del_Grupo_Familiar__c == 'VOLDIR' && (oppFromSF.Edad__c < 18 && oppFromSF.Edad__c > 2) && oppFromSF.Reingresa_como__c != 'Familiar'){
                prefijosTitular.add('formulario_' );
            }
    
            if((oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLDIR' || oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLEMP') && tipo_solicitud == 'Relacion de Dependencia' && oppFromSF.Reingresa_como__c != 'Familiar'){
                prefijosTitular.add('ultimo_recibo_sueldo_');
                prefijosTitular.add('codem_');
                prefijosTitular.add('cuil_');		
            }
    
            if((oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLDIR' || oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLEMP') && tipo_solicitud == 'Monotributista' &&oppFromSF.Reingresa_como__c != 'Familiar'){
                prefijosTitular.add('codem_');
                prefijosTitular.add('monotributo_152_');
                prefijosTitular.add('monotributo_184_');
                prefijosTitular.add('ultimos_pagos_mono_');
            }
    
            for(Integrante__c integrante : oppFromSF.Integrantes__r){
                System.debug('entra al for');
                prefijosIntegrantesMap.put(integrante.Nro_de_documento__c,new List<String>());
                List<String> prefijosIntegrante = new List<String>();
                if(oppFromSF.Segmento_del_Grupo_Familiar__c != null){
                    prefijosIntegrante.add('dni_integrante_'+integrante.Id);
    
                    if(usuario.Profile.Name != 'Front') {
                        if(integrante.Tipo_de_relacion_con_titular__c == 'CO'){
                            prefijosIntegrante.add('cert_matrimonio_'+integrante.Id);
                        }
                    }
                }
    	
                if(oppFromSF.Segmento_del_Grupo_Familiar__c == 'VOLDIR' || oppFromSF.Segmento_del_Grupo_Familiar__c == 'VOLEMP'){
                    System.debug('entra ' + integrante.Tipo_de_relacion_con_titular__c);
                    if(integrante.Tipo_de_relacion_con_titular__c == 'HI'){
                        
                        if(usuario.Profile.Name != 'Front') {
                            prefijosIntegrante.add('cert_nacimiento_integrante_'+integrante.Id);
                        }
                        System.debug('int hijo ' + integrante.Id);
                        if(integrante.Edad__c != null && integrante.Edad__c < 1){
                            prefijosIntegrante.add('historia_clinica_integrante_'+integrante.Id);
                        }
                        
                    }
                }
    
                if(oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLDIR' || oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLEMP'){
                    if(integrante.Integrante_tipo_asociado__c == 'Relación de Dependencia' && integrante.Tipo_de_relacion_con_titular__c == 'CO'){
                        if(integrante.Indicador_de_aporte__c){
                            prefijosIntegrante.add('recibo_sueldo_integrante_'+integrante.Id);
                        }
                    }
                    if(tipo_solicitud == 'Monotributista' || tipo_solicitud == 'Relacion de Dependencia'){
                        if(integrante.Aportes__c == null || integrante.Aportes__c == 0){
                            prefijosIntegrante.add('cert_negativa_integrante_'+integrante.Id);
                        }
                    }
                }
    
                if(oppFromSF.Segmento_del_Grupo_Familiar__c == 'OBLDIR'){
                    //if(tipo_solicitud == 'Monotributista'){
                        //if(integrante.Aportes__c != null && integrante.Aportes__c > 0){
                            //prefijosIntegrante.add('recibo_sueldo_integrante_');
                        //}
                    //}
    
                    if(integrante.Integrante_tipo_asociado__c == 'Monotributista' && integrante.Indicador_de_aporte__c){
                        prefijosIntegrante.add('monotributo_152_integrante_'+integrante.Id);
                        prefijosIntegrante.add('monotributo_184_integrante_'+integrante.Id);
                        prefijosIntegrante.add('monotributo_3pagos_integrante_'+integrante.Id);
                    }
    
                    if(tipo_solicitud != null){
                        if(integrante.Tipo_de_relacion_con_titular__c == 'HI'){
                            prefijosIntegrante.add('cert_nacimiento_integrante_'+integrante.Id);
                            if(integrante.Edad__c != null && integrante.Edad__c < 1){
                                prefijosIntegrante.add('historia_clinica_integrante_'+integrante.Id);
                            }
                            if(integrante.Edad__c != null && (integrante.Edad__c > 21 && integrante.Edad__c <= 25)){
                                prefijosIntegrante.add('cert_alumno_'+integrante.Id);
                            }
    
                        }
    
                    }
                    
    
                }
    
    
                System.debug('pref int ' + prefijosIntegrante);
                prefijosIntegrantesMap.put(integrante.Nro_de_documento__c,prefijosIntegrante);
            }
        }
        

        List<String> contentVersionIds = new List<String>(); 
        List<ContentDocumentLink> links = [
                SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ShareType,
                    ContentDocument.FileType, ContentDocument.FileExtension
                FROM ContentDocumentLink
                WHERE LinkedEntityId =: oppFromSF.Id
        ];

        for(ContentDocumentLink cdl : links) {
            contentVersionIds.add(cdl.ContentDocument.LatestPublishedVersionId);
        }

        List<ContentVersion> docs = [
            SELECT Id, Title, ContentDocumentId
            FROM ContentVersion 
            WHERE Id IN :contentVersionIds 
        ];

        List<String> documentsTitle = new List<String>();
        for(ContentVersion ver : docs){
            documentsTitle.add(ver.Title);
        }       
        String errorsFiles = '';
        System.debug('prefijos ' + prefijosTitular);
        System.debug(docs);
		for(String prefix : prefijosTitular){
			Boolean present = false;
			for(ContentVersion title : docs){
                System.debug(title.title + '   ' + prefix);
				present = present ||  title.Title.contains(prefix + oppFromSF.Id);
				if(title.Title.contains(prefix + oppFromSF.Id)){
					docsToSend.add(title.ContentDocumentId);
				}
				if(oppFromSF.Activar_seleccionar_archivos__c == false && title.Title.contains('Avalian - Solicitud de ingreso y DDJJ completa.pdf') && usuario.Profile.Name != 'Front'){
					docsToSend.add(title.ContentDocumentId);
					present = true;
                    System.debug('Ingresa al error falta documento y es front  1  ' + usuario.profile.Name);
				}

			}
			if(!present){
                System.debug('El primero es el error ::::: ' + usuario.Profile.Name);
				errorsFiles = errorsFiles + 'Falta archivo adjunto: ' + prefix + '\n';
			}
		}

		System.debug('integrantes ' + prefijosIntegrantesMap);

		for(String doc : prefijosIntegrantesMap.keySet()){
			String errorIntegrante = 'Integrante DNI ' + doc + '\n';
			List<String> prefixsIntegrante = prefijosIntegrantesMap.get(doc);
			System.debug(prefixsIntegrante);
			for(String prefix : prefixsIntegrante){
				Boolean present = false;
				for(ContentVersion title : docs){
					System.debug('TUTLETUELE: ' + title.title);
                    System.debug('prefix ' + prefix);
					present = present ||  title.Title.contains(prefix);
                   
					if(title.Title.contains(prefix)){
						docsToSend.add(title.ContentDocumentId);
					}
					if(oppFromSF.Activar_seleccionar_archivos__c == false && title.Title.contains('Avalian - Solicitud de ingreso y DDJJ completa.pdf') && usuario.Profile.Name != 'Front'){
						docsToSend.add(title.ContentDocumentId);
						present = true;
                        System.debug('Ingresa al error falta documento y es front  2  ' + usuario.profile.Name);
					}
				}
                 system.debug('presente ' + present);
				if(!present){
                    System.debug('El primero es el error ::::: ' + usuario.Profile.Name);
					errorIntegrante = errorIntegrante + 'Falta archivo adjunto: ' + prefix + '\n';
				}
			}
            System.debug('error ' + errorIntegrante);
			if(errorIntegrante != 'Integrante DNI ' + doc + '\n'){
				errorsFiles = errorsFiles + errorIntegrante;
			}
		}

        if(errorsFiles != ''){
            return new ResponseFiles(true, errorsFiles, docsToSend);
        }
        else {
            return new ResponseFiles(false, errorsFiles, docsToSend);
        }   
    }

    public static String getRelacionConTitular(String relacion) {
        switch on relacion {
            when 'Hijo/a' {
                return 'HI';
            }
            when 'Conyuge' {
                return 'CO';
            }
            when 'Otro' {
                return 'Otro';
            }
        }
        return null;
    }

    @AuraEnabled
    public static String getProfileName() {
    
    	return perfilUsuario.Name;
    }
    
    @AuraEnabled
    public static Opportunity getOpp(Id IdOpp){
        System.debug('parametro ' + IdOpp);
        Opportunity opp = [
            SELECT Id,Activar_seleccionar_archivos__c,Nro_de_solicitud__c,RecordType.DeveloperName,StageName
            FROM Opportunity
            WHERE Id = :IdOpp
        ];
        System.debug(opp);
    	return opp;
    }

    
    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message) {
            this.hasError = hasError;
            this.message = message;
        }
    }

    public class ResponseFiles {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<Id> files;

        public ResponseFiles(Boolean hasError, String message,List<Id> filesToSend) {
            this.hasError = hasError;
            this.message = message;
            this.files = filesToSend;
        }
    }

}