trigger EventoMedicoTrigger on Evento_medico__c (before insert,
												before update,
												before delete,
												after insert,
												after update,
												after delete,
												after undelete) {
	if(!XappiaHelper.isIntegracionSSUser()) {
		new EventoMedicoTriggerHandler().run();
	}
}