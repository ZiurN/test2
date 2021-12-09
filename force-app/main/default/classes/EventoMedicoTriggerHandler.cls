public with sharing class EventoMedicoTriggerHandler extends TriggerHandler {
	List<Evento_medico__c> lNew = (List<Evento_medico__c>) Trigger.new;
	List<Evento_medico__c> lOld = (List<Evento_medico__c>) Trigger.old;
	Map<Id,Evento_medico__c> mNew = (Map<Id,Evento_medico__c>) Trigger.newMap;
	Map<Id,Evento_medico__c> mOld = (Map<Id,Evento_medico__c>) Trigger.oldMap;
	public override void beforeInsert(){
		// Nothing
	}
	public override void beforeUpdate(){
		EventoMedicoTriggerHelper.validateFormaDeEgreso(mNew, mOld);
	}
	public override void beforeDelete(){
		EventoMedicoTriggerHelper.validateDeletion(mOld);
	}
	public override void afterInsert(){
		Map<Id, List<Evento_medico__c>> userIdEMsMap = new Map<Id, List<Evento_medico__c>>();
		for (Evento_medico__c em : lNew) {
			if (userIdEMsMap.containsKey(em.OwnerId)) {
				List<Evento_medico__c> casesFromMap = userIdEMsMap.get(em.OwnerId);
				casesFromMap.add(new Evento_medico__c(Id = em.Id));
				userIdEMsMap.put(em.OwnerId, casesFromMap);
			} else {
				userIdEMsMap.put(em.OwnerId, new List<Evento_medico__c>{new Evento_medico__c(Id = em.Id)});
			}
		}
		if (!userIdEMsMap.isEmpty()) {
			EventoMedicoTriggerHelper.assignDelegacionFromUser(userIdEMsMap);
		}
	}
	public override void afterUpdate(){
		Id[] emsToSendToSS = new List<Id>();
		for(Evento_medico__c em : lNew) {
			Evento_medico__c oldEm = mOld.get(em.Id);
			if(String.isNotBlank(em.Nro_de_Evento_Medico_SS__c)
				&& (em.Forma_de_egreso__c != oldEm.Forma_de_egreso__c
					|| em.Resultado__c != oldEm.Resultado__c
					|| em.Diagnostico__c != oldEm.Diagnostico__c
					|| em.Suspendido__c != oldEM.Suspendido__c)) {
				emsToSendToSS.add(em.Id);
			}
		}
		if(!emsToSendToSS.isEmpty()) {
			EventoMedicoTriggerHelper.sendToSS(emsToSendToSS);
		}
	}
	public override void afterDelete(){
		//Nothing
	}
	public override void afterUndelete(){
		//Nothing
	}
}