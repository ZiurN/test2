trigger LocalidadTrigger on Localidad__c (after insert, after update)  {

	if(Trigger.isAfter){
		if(Trigger.isInsert){
			Set<String> cpSet = new Set<String>();
			Set<String> provinciaSet = new Set<String>();
			Map<String,Localidad__c> locMap = new Map<String,Localidad__c>();
			Map<String,Localidad__c> locMapLocId = new Map<String,Localidad__c>();
			for(Localidad__c loc : Trigger.new){
				locMap.put(loc.Codigo_Postal__c + '*-' + loc.Codigo_de_Provincia__c,loc);
				locMapLocId.put(loc.Loc_Id__c,loc);
				cpSet.add(loc.Codigo_Postal__c);
				provinciaSet.add(loc.Codigo_de_Provincia__c);
				
			}
			//LocalidadTriggerHelper.updateLeadWhenLocIsNew(locMapLocId,locMap,cpSet,provinciaSet);
		}

		if(Trigger.isUpdate){
			List<Id> locMap = new List<Id>();
			for(Localidad__c loc : Trigger.new){
				if(loc.Organizador_lookup__c != Trigger.oldMap.get(loc.Id).Organizador_lookup__c){
					locMap.add(loc.Id);
				}
			}
			LocalidadTriggerHelper.updateLeadOrg(locMap);
			
		}
	}
}