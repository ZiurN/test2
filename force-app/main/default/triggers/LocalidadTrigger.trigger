trigger LocalidadTrigger on Localidad__c (after insert, after update)  {
	if(Trigger.isAfter){
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