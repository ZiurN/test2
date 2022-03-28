trigger SegmentoTrigger on Segmentos__c (before insert,
										before update,
										before delete,
										after insert,
										after update,
										after delete,
										after undelete) {
	if(!XappiaHelper.isPlatformUser()) {
		new SegmentoTriggerHandler().run();
	}
}