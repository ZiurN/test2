public class LocalidadTriggerHelper  {

	/*public static void updateLeadWhenLocIsNew(List<Id> localidades){
		
		List<Lead> leadsToUpdateLocId = [
			SELECT Organizador_lookup__c, OwnerId, LocId__c, Provincia__c,
			Localidad__c, Codigo_postal__c, Zona_Geografica__c
			FROM Lead
			WHERE Organizador_lookup__c = null
			AND LocId__c IN :locMapLocId.keySet()			
		];

		List<Lead> leadsToUpdate = [
			SELECT Organizador_lookup__c, OwnerId, LocId__c, Provincia__c,
			Localidad_new__c, Localidad_new__r.Organizador_lookup__c, Zona_Geografica__c,
            Localidad_new__r.Loc_Id__c, Localidad_new__r.ZG_Codigo__c
			FROM Lead
			WHERE Organizador_lookup__c = null
			AND Localidad_new__c IN :localidades
		];

		for(Lead cand : leadsToUpdate){
			cand.LocId__c = cand.Localidad_new__r.Loc_Id__c;
			cand.Zona_Geografica__c = cand.Localidad_new__r.ZG_Codigo__c;
			cand.Organizador_lookup__c = cand.Localidad_new__r.Organizador_lookup__c;
			if(cand.Localidad_new__r.Organizador_lookup__c != null){
				cand.OwnerId = cand.Localidad_new__r.Organizador_lookup__c;
			}
		}


		for(Lead cand : leadsToUpdateLocId){
			Localidad__c loc = locMapLocId.get(cand.LocId__c);
			cand.Provincia__c = loc.Codigo_de_Provincia__c;
			cand.Codigo_postal__c = loc.Codigo_Postal__c;
			cand.Localidad__c = loc.Nombre_de_Localidad__c;
			cand.Zona_Geografica__c = loc.ZG_Codigo__c;
			cand.Organizador_lookup__c = loc.Organizador_lookup__c;
			if(loc.Organizador_lookup__c != null){
				cand.OwnerId = loc.Organizador_lookup__c;
			}
		}

		update leadsToUpdate;
		//update leadsToUpdateLocId;
	}*/
	
    @Future
	public static void updateLeadOrg(List<Id> locIds){
		List<Lead> leadsToUpdate = [
			SELECT Organizador_lookup__c, OwnerId, LocId__c, Provincia__c,RecordTypeId,LeadSource,
			Localidad_new__c, Localidad_new__r.Organizador_lookup__c, Zona_Geografica__c,
            Localidad_new__r.Loc_Id__c, Localidad_new__r.ZG_Codigo__c, Localidad_new__r.Codigo_de_Provincia__c
			FROM Lead
			WHERE Localidad_new__c IN :locIds			
		];

		for(Lead cand : leadsToUpdate){
            cand.LocId__c = cand.Localidad_new__r.Loc_Id__c;
            cand.Provincia__c = cand.Localidad_new__r.Codigo_de_Provincia__c;
			cand.Zona_Geografica__c = cand.Localidad_new__r.ZG_Codigo__c;
			cand.Organizador_lookup__c = cand.Localidad_new__r.Organizador_lookup__c;
			if(cand.RecordTypeId == XappiaHelper.getRecordType('Lead','Individuos').Id){
                    if(cand.LeadSource != '5' && cand.LeadSource != '4' && cand.LeadSource != '15' && cand.LeadSource != '1'){
						if (cand.Localidad_new__c != null &&
						 cand.Localidad_new__r.Organizador_lookup__c != null) {
							cand.OwnerId = cand.Localidad_new__r.Organizador_lookup__c;
						} 
					}
				}
		}

		update leadsToUpdate;
	}

}