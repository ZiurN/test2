/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase manejadora del desencadenador para el objeto ContentDocumentLink
@date			22/12/2021
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class ContentDocumentLinkTriggerHandler extends TriggerHandler {
	List<ContentDocumentLink> lNew = (List<ContentDocumentLink>) Trigger.new;
	List<ContentDocumentLink> lOld = (List<ContentDocumentLink>) Trigger.old;
	Map<Id,ContentDocumentLink> mNew = (Map<Id,ContentDocumentLink>) Trigger.newMap;
	Map<Id,ContentDocumentLink> mOld = (Map<Id,ContentDocumentLink>) Trigger.oldMap;
	public override void beforeInsert() {
		Boolean isPlatformUser = XappiaHelper.isPlatformUser();
		ContentDocumentLinkTriggerHelper.modifyLinkedEntityForEmailToCaseCases(lNew);
		ContentDocumentLinkTriggerHelper.avoidTwoFilesWithTheSameNameInCaseAndEM(lNew, isPlatformUser);
		if (!isPlatformUser) ContentDocumentLinkTriggerHelper.avoidFilesLargerThan3MbInCaseAndEM(lNew);
	}
	public override void beforeUpdate() {
		// Nothing to do
	}
	public override void beforeDelete() {
		Id[] opportunityContentDocumentIds = new List<Id>();
			Id[] caseContentDocumentIds = new List<Id>();
			for(ContentDocumentLink cdl : lOld) {
				String strObjPrefix = String.isBlank(cdl.LinkedEntityId) ? null : String.valueOf(cdl.LinkedEntityId).substring(0, 3);
				if(strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()) {
					opportunityContentDocumentIds.add(cdl.ContentDocumentId);
				}
				if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()) {
					caseContentDocumentIds.add(cdl.ContentDocumentId);
				}
			}
			if(!opportunityContentDocumentIds.isEmpty()) {
				ContentDocumentLinkTriggerHelper.avoidDeleteSentOpportunityFiles(mOld, opportunityContentDocumentIds);
			}
			if(!caseContentDocumentIds.isEmpty()) {
				ContentDocumentLinkTriggerHelper.avoidDeleteSentCaseFiles(mOld, caseContentDocumentIds);
			}
	}
	public override void afterInsert() {
		ContentDocumentLinkTriggerHelper.modifyParentIdFromCDocumentsForEmailToCaseCases(lNew);
		ContentDocumentLinkTriggerHelper.overwriteOpportunityWithNewFile(lNew);
		ContentDocumentLinkTriggerHelper.deleteDuplicatePlatIntCDLinks (mNew);
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
