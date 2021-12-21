trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert, after insert,	before delete) {
	if(Trigger.isBefore) {
		if(Trigger.isInsert) {
			ContentDocumentLinkTriggerHelper.modifyLinkedEntityForEmailToCaseCases(Trigger.new);
			ContentDocumentLinkTriggerHelper.avoidTwoFilesWithTheSameNameInCaseAndEM(Trigger.new);
			ContentDocumentLinkTriggerHelper.avoidFilesLargerThan3MbInCaseAndEM(Trigger.new);
		}
		if(Trigger.isDelete) {
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
		if(Trigger.isInsert) {
			ContentDocumentLinkTriggerHelper.modifyParentIdFromCDocumentsForEmailToCaseCases(Trigger.new);
			ContentDocumentLinkTriggerHelper.overwriteOpportunityWithNewFile(Trigger.new);
		}
	}
}
