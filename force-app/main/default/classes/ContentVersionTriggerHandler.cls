/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase manejadora del desencadenador para el objeto ContentVersion
@date			23/12/2021
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class ContentVersionTriggerHandler extends TriggerHandler {
	List<ContentVersion> lNew = (List<ContentVersion>) Trigger.new;
	List<ContentVersion> lOld = (List<ContentVersion>) Trigger.old;
	Map<Id,ContentVersion> mNew = (Map<Id,ContentVersion>) Trigger.newMap;
	Map<Id,ContentVersion> mOld = (Map<Id,ContentVersion>) Trigger.oldMap;
	public override void beforeInsert() {
		// Nothing to do
	}
	public override void beforeUpdate() {
		Map<Id, String> dataStringByContentDocumentIds = new Map<Id, String>();
		for(ContentVersion cv : lNew) {
			if(cv.FileType == 'SNOTE') {
				String dataString = cv.VersionData?.toString().replaceAll('<[^>]+>',' ').normalizeSpace();
				dataStringByContentDocumentIds.put(cv.ContentDocumentId, dataString);
			}
		}
		if(!dataStringByContentDocumentIds.isEmpty()) {
			ContentVersionTriggerHelper.copyContentNoteToNotaFieldInLead(dataStringByContentDocumentIds);
		}
	}
	public override void beforeDelete() {
		// Nothing to do
	}
	public override void afterInsert() {
		Map<Id, String> dataStringByContentDocumentIds = new Map<Id, String>();
		Map<Id, ContentVersion> ContentVersionBycontentDocumentId = new Map<Id, ContentVersion>();
		for(ContentVersion cv : lNew) {
			if(cv.FileType == 'SNOTE') {
				String dataString = cv.VersionData?.toString().replaceAll('<[^>]+>',' ').normalizeSpace();
				dataStringByContentDocumentIds.put(cv.ContentDocumentId, dataString);
			}
			ContentVersionBycontentDocumentId.put(cv.ContentDocumentId, cv);
		}
		if(!dataStringByContentDocumentIds.isEmpty()) {
			ContentVersionTriggerHelper.copyContentNoteToNotaFieldInLead(dataStringByContentDocumentIds);
		}
		Boolean isAsync = System.isBatch() || System.isFuture() || System.isQueueable() || System.isScheduled();
		if(!ContentVersionBycontentDocumentId.isEmpty() && !isAsync) {
			ContentVersionTriggerHelper.avoidUploadANewVersion(ContentVersionBycontentDocumentId);
		}
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

