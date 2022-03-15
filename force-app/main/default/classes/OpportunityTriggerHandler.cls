/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase manejadora del desencadenador para el objeto Opportunity
@date			15/12/2021
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class OpportunityTriggerHandler extends TriggerHandler {
	List<Opportunity> lNew = (List<Opportunity>) Trigger.new;
	List<Opportunity> lOld = (List<Opportunity>) Trigger.old;
	Map<Id,Opportunity> mNew = (Map<Id,Opportunity>) Trigger.newMap;
	Map<Id,Opportunity> mOld = (Map<Id,Opportunity>) Trigger.oldMap;
	/** Tipos de Registro */
	String recordTypeIdIndividuos = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
    String recordTypeIdIndividalCorp = XappiaHelper.getRecordType('Opportunity', 'Individual_Corporativo').Id;
    String recordTypeIdCorporativo = XappiaHelper.getRecordType('Opportunity', 'Corporativo').Id;
	/** Variables */
	Id rolEjecutivoId;
	public override void beforeInsert() {
		rolEjecutivoId = [SELECT Id FROM UserRole WHERE DeveloperName = 'Ejecutivo_de_cuenta_corporativo' LIMIT 1].Id;
		Id perfilFrontId = XappiaHelper.getProfileIdByName('Front');
		Map<String, List<Opportunity>> oppsIndividualCorporativaListByOppCorporativaId = new Map<String, List<Opportunity>>();
		List<Opportunity> oppsToUpdate = new List<Opportunity>();
		Map<String, Id> idsOppAccMap = new Map<String, Id>();
		Map<String, Id> idsOppAccFromLeadMap = new Map<String, Id>();
		List<Opportunity> oppsToUpdateToLead = new List<Opportunity>();
		List<Opportunity> oppsLocChanged = new List<Opportunity>();
		List<Opportunity> oppsToCheckReingreso = new List<Opportunity>();
		for (Opportunity oportunidad : lNew) {
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
				if (oppsIndividualCorporativaListByOppCorporativaId.keySet().contains(oportunidad.Oportunidad_Corporativa__c)) {
					oppsIndividualCorporativaListByOppCorporativaId.get(oportunidad.Oportunidad_Corporativa__c).add(oportunidad);
				} else {
					oppsIndividualCorporativaListByOppCorporativaId.put(oportunidad.Oportunidad_Corporativa__c, new List<Opportunity>{oportunidad});
				}
			}
			Boolean shouldMapOrgFromAcc = (oportunidad.Tipo_de_Solicitud__c != null ?
				oportunidad.Tipo_de_Solicitud__c.contains('REINGR') : false ) && UserInfo.getProfileId() != perfilFrontId;
			Boolean shouldMapIfAltaFromClosed = (oportunidad.Tipo_de_Solicitud__c != null ?
			oportunidad.Tipo_de_Solicitud__c.contains('ALTA') : false ) && UserInfo.getProfileId() != perfilFrontId && oportunidad.Account.Codigo_de_Afiliado__c == null;
			Boolean shouldMapOrgFromAccIfIndCoorp = UserInfo.getProfileId() != perfilFrontId && oportunidad.RecordTypeId == recordTypeIdIndividalCorp;
			if (shouldMapOrgFromAcc || shouldMapOrgFromAccIfIndCoorp || shouldMapIfAltaFromClosed) {
				idsOppAccMap.put(oportunidad.Id, oportunidad.AccountId);
				oppsToUpdate.add(oportunidad);
			}
		}
		if (!oppsIndividualCorporativaListByOppCorporativaId.isEmpty()) {
			OpportunityTriggerHelper.addAccountToOpportunityWithRecordTypeIndividualCorporativo(oppsIndividualCorporativaListByOppCorporativaId);
		}
		if (!idsOppAccMap.isEmpty()) {
			OpportunityTriggerHelper.copyDataFromAccountToOpportunity(oppsToUpdate, idsOppAccMap);
		}
		if (!oppsLocChanged.isEmpty()) {
			OpportunityTriggerHelper.validateRoleInLoc(oppsLocChanged);
		}
		if (!oppsToCheckReingreso.isEmpty()) {
			OpportunityTriggerHelper.checkReintegroIndCorp(oppsToCheckReingreso);
		}
	}
	public override void beforeUpdate() {
		rolEjecutivoId = [SELECT Id FROM UserRole WHERE DeveloperName = 'Ejecutivo_de_cuenta_corporativo' LIMIT 1].Id;
		OpportunityTriggerHelper.checkIfIsAcceptedByAsociado(lNew);
		List<Opportunity> oppsToSetImporte = new List<Opportunity>();
		List<Id> oppsToUpdate = new List<Id>();
		List<Opportunity> oppsValidateRol = new List<Opportunity>();
		List<Opportunity> oppsLocChanged = new List<Opportunity>();
		List<Opportunity> oppsOwnerChanged = new List<Opportunity>();
		List<Opportunity> oppsWithDNIChanged = new List<Opportunity>();
		Map<Opportunity, Id> localidadIdsByOpp = new Map<Opportunity, Id>();
		for(Opportunity opp : lNew) {
			Opportunity oldOpp = mOld.get(opp.Id);
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
			if(opp.Cotizacion_elegida__c != mOld.get(opp.Id).Cotizacion_elegida__c){
				oppsToSetImporte.add(opp);
			}
			if(opp.OwnerId != mOld.get(opp.Id).OwnerId){
				oppsOwnerChanged.add(opp);
			}
			if(opp.StageName == 'Cerrada ganada'
				&& opp.StageName != mOld.get(opp.Id).StageName) {
				oppsToUpdate.add(opp.Id);
			}
			if(opp.Numero_de_documento__c != oldOpp.Numero_de_documento__c
				&& String.isNotBlank(opp.AccountId)
				&& opp.RecordTypeId == recordTypeIdIndividuos) {
				oppsWithDNIChanged.add(opp);
			}
		}
		if(!oppsToSetImporte.isEmpty()) {
			OpportunityTriggerHelper.setImporteToOpps(oppsToSetImporte);
		}
		if(!oppsValidateRol.isEmpty()) {
			OpportunityTriggerHelper.validateRoleInLoc(oppsValidateRol);
		}
		if(!oppsOwnerChanged.isEmpty()) {
			OpportunityTriggerHelper.checkNewOwner(oppsOwnerChanged);
		}
		if(!oppsWithDNIChanged.isEmpty()) {
			OpportunityTriggerHelper.updateDNIInAccount(oppsWithDNIChanged);
		}
		if(!oppsLocChanged.isEmpty()) {
			OpportunityTriggerHelper.changeOganizadorInOpp(localidadIdsByOpp);
		}
	}
	public override void beforeDelete() {
		//Nothing
	}
	public override void afterInsert() {
		Map<Id, List<Opportunity>> opportunitiesByUserId = new Map<Id, List<Opportunity>>();
		for (Opportunity opp : lNew) {
			if (!opportunitiesByUserId.containsKey(opp.OwnerId)) {
				opportunitiesByUserId.put(opp.OwnerId, new List<Opportunity>());
			}
			opportunitiesByUserId.get(opp.OwnerId).add(new Opportunity(Id = opp.Id));
		}
		if (!opportunitiesByUserId.isEmpty()) {
			OpportunityTriggerHelper.assignDelegacionFromUser(opportunitiesByUserId);
		}
	}
	public override void afterUpdate() {
		List<Opportunity> oppsToActivateThePersonAccountList = new List<Opportunity>();
		List<Opportunity> oppsToUpdateRTIndvCorp = new List<Opportunity>();
		List<Id> oppsToUpdateRTIndividuos = new List<Id>();
		OpportunityTriggerHelper.validateSubestadoDDJJ(lNew, mOld);
		for(Opportunity opp : lNew){
			if(opp.StageName == 'Cerrada ganada'
				&& opp.StageName != mOld.get(opp.Id).StageName){
				if(opp.RecordTypeId == recordTypeIdIndividalCorp && opp.Tipo_de_Solicitud__c == 'ALTA'){
					oppsToUpdateRTIndvCorp.add(opp);
				}else if (opp.RecordTypeId == recordTypeIdIndividalCorp && opp.Tipo_de_Solicitud__c != 'ALTA') {
					oppsToUpdateRTIndividuos.add(opp.Id);
					oppsToActivateThePersonAccountList.add(opp);
				}
				else if(opp.RecordTypeId == recordTypeIdIndividuos){
					oppsToUpdateRTIndividuos.add(opp.Id);
				}
			}
			if(opp.RecordTypeId == recordTypeIdIndividuos
				&& opp.Estado_de_solicitud__c == 'Transformada'
				&& String.isNotBlank(opp.Nro_de_asociado__c)
				&& String.isNotBlank(opp.AccountId)) {
				oppsToActivateThePersonAccountList.add(opp);
			}
		}
		if(!oppsToUpdateRTIndvCorp.isEmpty()) {
			OpportunityTriggerHelper.createAccWhenOpportunityIndividualCorporativoChangedToClosedWin(oppsToUpdateRTIndvCorp);
		}
		if(!oppsToUpdateRTIndividuos.isEmpty()){
			OpportunityTriggerHelper.createGrupoFamiliarWhenOpportunityIndividuosChangedToClosedWin(oppsToUpdateRTIndividuos,null);
		}
		if(!oppsToActivateThePersonAccountList.isEmpty()) {
			OpportunityTriggerHelper.activatePersonAccounts(oppsToActivateThePersonAccountList);
		}
	}
	public override void afterDelete() {
		//Nothing
	}
	public override void afterUndelete() {
		//Nothing
	}
}