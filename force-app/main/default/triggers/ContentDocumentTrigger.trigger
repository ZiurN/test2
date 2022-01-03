trigger ContentDocumentTrigger on ContentDocument (before insert,
													before update,
													before delete,
													after insert,
													after update,
													after delete,
													after undelete) {
	if(!XappiaHelper.isPlatformUser()) {
		new ContentDocumentTriggerHandler().run();
	}
}