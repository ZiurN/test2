trigger ContentDocumentLinkTrigger on ContentDocumentLink (
	before insert, after insert, 
	before delete
	) { 
	if(Trigger.isBefore) {
		if(Trigger.isInsert) {
			System.DEBUG('BEFORE INSERT');
			ContentDocumentLinkTriggerHelper.avoidTwoFilesWithTheSameNameInCaseAndEM(Trigger.new);
			ContentDocumentLinkTriggerHelper.avoidFilesLargerThan3MbInCaseAndEM(Trigger.new); 
		}

		if(Trigger.isDelete) {
			System.DEBUG('BEFORE DELETE');
			Id[] opportunityContentDocumentIds = new List<Id>();
			Id[] caseContentDocumentIds = new List<Id>();

			for(ContentDocumentLink cdl : Trigger.old) {
				String strObjPrefix = String.isBlank(cdl.LinkedEntityId) ? null : String.valueOf(cdl.LinkedEntityId).substring(0, 3);

				if(strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()) {					
					opportunityContentDocumentIds.add(cdl.ContentDocumentId);
				}
				if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()) {					
					caseContentDocumentIds.add(cdl.ContentDocumentId);
				}
				
			}

			if(!opportunityContentDocumentIds.isEmpty()) {
				ContentDocumentLinkTriggerHelper.avoidDeleteSentOpportunityFiles(Trigger.oldMap, opportunityContentDocumentIds);
			}
			
			if(!caseContentDocumentIds.isEmpty()) {
				ContentDocumentLinkTriggerHelper.avoidDeleteSentCaseFiles(Trigger.oldMap, caseContentDocumentIds);
			}

		}
	}

	if(Trigger.isAfter){
		if(Trigger.isInsert){
			ContentDocumentLinkTriggerHelper.overwriteOpportunityWithNewFile(Trigger.new);
		}
	}

	//Cancelacion s3
	/*if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			Id[] contentDocumentLinksToSendToAWS = new List<Id>();
			Boolean isAsync = System.isBatch() || System.isFuture() || System.isQueueable() || System.isScheduled();

			for(ContentDocumentLink cdl : Trigger.new) {
				Id linked = cdl.LinkedEntityId;
				String objeto = String.valueOf(linked.getSobjectType());
				if(cdl.ContentDocument.FileType != 'SNOTE' && objeto != 'User') {
					contentDocumentLinksToSendToAWS.add(cdl.Id);
				}
			}
            
            System.debug('****isAsync: ' + isAsync);
			if(!contentDocumentLinksToSendToAWS.isEmpty() && !isAsync) {
				ContentDocumentLinkTriggerHelper.sendToAWSFuture(contentDocumentLinksToSendToAWS);
			}
		}
	}*/
}