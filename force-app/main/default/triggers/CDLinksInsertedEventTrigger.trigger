trigger CDLinksInsertedEventTrigger on CDLinks_Inserted__e (after insert) {
	Set<String> linkedEntitiesIds = new Set<String>();
	for (CDLinks_Inserted__e event : Trigger.New) {
		linkedEntitiesIds.add(event.Linked_Entity__c);
	}
	if (!linkedEntitiesIds.isEmpty()) {
		ContentDocumentLinkTriggerHelper.processAfterInsertEvent(LinkedEntitiesIds);
	}
}