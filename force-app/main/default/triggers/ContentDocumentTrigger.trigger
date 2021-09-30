trigger ContentDocumentTrigger on ContentDocument (
	before insert, before delete
	) { 
	if(Trigger.isBefore) {
		if(Trigger.isDelete) {
			System.debug('entro al before delete del CD');
			ContentDocumentTriggerHelper.avoidDeleteSentOpportunityFiles(Trigger.oldMap);
			ContentDocumentTriggerHelper.avoidDeleteSentSalesCaseFiles(Trigger.oldMap);

			Id[] contentNoteIds = new List<Id>();
			//Cancelacion s3
			//ContentDocument[] contentDocumentsToDeleteFromAWS = new List<ContentDocument>();
			
			for(ContentDocument cd : Trigger.old) {
				if(cd.FileType == 'SNOTE') {
					contentNoteIds.add(cd.Id);
				}
				else {
					//Cancelacion s3
					//contentDocumentsToDeleteFromAWS.add(cd);
				}
			}

			if(!contentNoteIds.isEmpty()) {
				ContentDocumentTriggerHelper.copyTheLastContentNoteToNotaFieldInLead(contentNoteIds);
			}

			//Cancelacion s3
			/*if(!contentDocumentsToDeleteFromAWS.isEmpty()) {
				System.debug('contentDocumentsToDeleteFromAWS');
				ContentDocumentTriggerHelper.avoidDeletionOfSentFiles(contentDocumentsToDeleteFromAWS);
				System.enqueueJob(new ContentDocumentQueueable(contentDocumentsToDeleteFromAWS));
			}	*/	
		}
	}
}