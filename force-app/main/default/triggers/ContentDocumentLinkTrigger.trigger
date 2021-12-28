trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert,
															before update,
															before delete,
															after insert,
															after update,
															after delete,
															after undelete) {
	if(!XappiaHelper.isPlatformUser()) {
		new ContentDocumentLinkTriggerHandler().run();
	} else if (XappiaHelper.isPlatformUser()
			&& !XappiaHelper.eventFired
			&& Trigger.isAfter
			&& Trigger.isInsert) {
		Set<String> LinkedEntitiesIds = new Set<String>();
		for (ContentDocumentLink cdLink : Trigger.new) {
			String sobjectType = cDLink.LinkedEntityId.getSObjectType().getDescribe().getName();
			if (sobjectType == 'EmailMessage') {
				LinkedEntitiesIds.add(cdLink.LinkedEntityId);
			}
		}
		if (!LinkedEntitiesIds.isEmpty()) {
			ContentDocumentLinkTriggerHelper.fireCDLinksInsertedEvent(LinkedEntitiesIds);
			XappiaHelper.eventFired = true;
		}
	}
}