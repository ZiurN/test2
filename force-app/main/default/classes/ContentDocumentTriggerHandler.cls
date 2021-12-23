public with sharing class ContentDocumentTriggerHandler extends TriggerHandler {
	List<ContentDocument> lNew = (List<ContentDocument>) Trigger.new;
	List<ContentDocument> lOld = (List<ContentDocument>) Trigger.old;
	Map<Id,ContentDocument> mNew = (Map<Id,ContentDocument>) Trigger.newMap;
	Map<Id,ContentDocument> mOld = (Map<Id,ContentDocument>) Trigger.oldMap;
	public override void beforeInsert() {
		// Nothing to do
	}
	public override void beforeUpdate() {
		// Nothing to do
	}
	public override void beforeDelete() {
		ContentDocumentTriggerHelper.avoidDeleteSentOpportunityFiles(mOld);
		ContentDocumentTriggerHelper.avoidDeleteSentSalesCaseFiles(mOld);
		Id[] contentNoteIds = new List<Id>();
		ContentDocument[] contentDocumentsToDeleteFromAWS = new List<ContentDocument>();
		for(ContentDocument cd : lOld) {
			if(cd.FileType == 'SNOTE') {
				contentNoteIds.add(cd.Id);
			}
			else {
				contentDocumentsToDeleteFromAWS.add(cd);
			}
		}
		if(!contentNoteIds.isEmpty()) {
			ContentDocumentTriggerHelper.copyTheLastContentNoteToNotaFieldInLead(contentNoteIds);
		}
	}
	public override void afterInsert() {
		// Nothing to do
	}
	public override void afterUpdate() {
		// Nothing to do
	}
	public override void afterDelete() {
		// Nothing to do
	}
	public override void afterUndelete() {
		// Nothing to do
	}
}
