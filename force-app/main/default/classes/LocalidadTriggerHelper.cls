public without sharing class LocalidadTriggerHelper {
	private static String individuosRTId = XappiaHelper.getRecordType('Lead','Individuos').Id;
	public static void updateLeadOrg(List<Id> locIds){
		List<Lead> leadsToUpdate = [SELECT Organizador_lookup__c, OwnerId, LocId__c, Provincia__c,RecordTypeId,LeadSource,
										Localidad_new__c, Localidad_new__r.Organizador_lookup__c, Zona_Geografica__c,
										Localidad_new__r.Loc_Id__c, Localidad_new__r.ZG_Codigo__c, Localidad_new__r.Codigo_de_Provincia__c
									FROM Lead
									WHERE Localidad_new__c IN :locIds];
		for(Lead cand : leadsToUpdate){
            cand.LocId__c = cand.Localidad_new__r.Loc_Id__c;
            cand.Provincia__c = cand.Localidad_new__r.Codigo_de_Provincia__c;
			cand.Zona_Geografica__c = cand.Localidad_new__r.ZG_Codigo__c;
			cand.Organizador_lookup__c = cand.Localidad_new__r.Organizador_lookup__c;
			Boolean leadSourceValid = cand.LeadSource != '5' && cand.LeadSource != '4' && cand.LeadSource != '15' && cand.LeadSource != '1';
			if (cand.RecordTypeId == individuosRTId
					&& leadSourceValid
					&& cand.Localidad_new__c != null
					&& cand.Localidad_new__r.Organizador_lookup__c != null) {
				cand.OwnerId = cand.Localidad_new__r.Organizador_lookup__c;
			}
		}
		Database.update(leadsToUpdate);
	}
}