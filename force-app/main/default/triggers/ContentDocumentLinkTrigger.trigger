trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert,
															before update,
															before delete,
															after insert,
															after update,
															after delete,
															after undelete) {
	if(!XappiaHelper.isPlatformUser()) {
		new ContentDocumentLinkTriggerHandler().run();
	}
}