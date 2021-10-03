trigger ContentVersionTrigger on ContentVersion (
	before update, after insert
	) { 
	if(Trigger.isBefore) {
		if(Trigger.isUpdate) {
			System.debug('entro al before update del CV');
			
			Map<Id, String> dataStringByContentDocumentIds = new Map<Id, String>();

			for(ContentVersion cv : Trigger.new) {
				if(cv.FileType == 'SNOTE') {
					System.debug(cv.Title);
					System.debug(cv.VersionData?.toString().replaceAll('<[^>]+>',' ').normalizeSpace());
					String dataString = cv.VersionData?.toString().replaceAll('<[^>]+>',' ').normalizeSpace();
					dataStringByContentDocumentIds.put(cv.ContentDocumentId, dataString);
				}
			}

			System.debug(dataStringByContentDocumentIds);

			if(!dataStringByContentDocumentIds.isEmpty()) {
				ContentVersionTriggerHelper.copyContentNoteToNotaFieldInLead(dataStringByContentDocumentIds);
			}
		}
	}

	if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			System.debug('entro al after insert del CV');
			Map<Id, String> dataStringByContentDocumentIds = new Map<Id, String>();
			Map<Id, ContentVersion> ContentVersionBycontentDocumentId = new Map<Id, ContentVersion>();

			for(ContentVersion cv : Trigger.new) {

				if(cv.FileType == 'SNOTE') {
					System.debug(cv.Title);
					String dataString = cv.VersionData?.toString().replaceAll('<[^>]+>',' ').normalizeSpace();
					dataStringByContentDocumentIds.put(cv.ContentDocumentId, dataString);
				}
				ContentVersionBycontentDocumentId.put(cv.ContentDocumentId, cv);
			}

			System.debug(dataStringByContentDocumentIds);

			if(!dataStringByContentDocumentIds.isEmpty()) {
				ContentVersionTriggerHelper.copyContentNoteToNotaFieldInLead(dataStringByContentDocumentIds);
			}

			Boolean isAsync = System.isBatch() || System.isFuture() || System.isQueueable() || System.isScheduled();
			if(!ContentVersionBycontentDocumentId.isEmpty() && !isAsync) {
				ContentVersionTriggerHelper.avoidUploadANewVersion(ContentVersionBycontentDocumentId);
			}
		}
	}
}