/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase para testear el trigger de EmailMessage
@date			28/12/2021
------------------------------------------------------------------------------------------------------------------------*/
@isTest
public without sharing class EmailMessageTriggerTest {
	private static Case emailToCaseCase;
	private static List<Id> idList = new List<Id>();
	@TestSetup
	static void makeData() {
		List<ContentVersion> contentVersionsToInsert = new List<ContentVersion>();
		for (Integer i = 0; i < 6; i++) {
			ContentVersion cv = new ContentVersion();
			cv.Title = 'cvInEmail ' + i;
			cv.VersionData = Blob.valueOf('cvInEmail ' + i);
			cv.PathOnClient = '/cvInEmail' + i;
			cv.FirstPublishLocationId = UserInfo.getUserId();
			cv.ContentLocation = 'S';
			cv.Enviado__c = false;
			contentVersionsToInsert.add(cv);
		}
		insert contentVersionsToInsert;
		emailToCaseCase = Build.aCaseFromEmail().build();
		insert emailToCaseCase;
		List<ContentVersion> cvs = [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN :contentVersionsToInsert];
		List<ContentDocumentLink> cDLinksToInsert =  new List<ContentDocumentLink>();
		for (ContentVersion cv: cvs) {
			ContentDocumentLink cDLink = new ContentDocumentLink();
			cDLink.ContentDocumentId = cv.ContentDocumentId;
			cDLink.LinkedEntityId = emailToCaseCase.Id;
			cDLinksToInsert.add(cDLink);
		}
		insert cDLinksToInsert;
	}
	@isTest
	private static void whenSendEmailWithCVInBodyDontCreateNewCDLinks () {
		validateContentDocumentLinksCreated();
		List<ContentVersion> cvs = [SELECT ContentDocumentId FROM ContentVersion];
		String HTMLBody = TestUtils.createHTMLBody(cvs);
		EmailMessage email = new EmailMessage();
		email.ToAddress = 'test@example.com';
		email.ParentId = emailToCaseCase.Id;
		email.HtmlBody = HTMLBody;
		insert email;
		idList.add(email.Id);
		List<ContentDocumentLink> cDLinksToInsert =  new List<ContentDocumentLink>();
		for (ContentVersion cv: cvs) {
			ContentDocumentLink cDLink = new ContentDocumentLink();
			cDLink.ContentDocumentId = cv.ContentDocumentId;
			cDLink.LinkedEntityId = email.Id;
			cDLinksToInsert.add(cDLink);
		}
		insert cDLinksToInsert;
		Test.startTest();
		EmailMessageTriggerHelper.ifEmailHaveFilesDeleteCDLinksIfParentHasTheSame(new List<EmailMessage>{email});
		Test.stopTest();
		validateContentDocumentLinksCreated();
	}
	private static void validateContentDocumentLinksCreated () {
		List<Case> cases = [SELECT Id FROM Case];
		System.assertEquals(1, cases.size(), 'Debe haber solo un caso');
		for (Case caso : cases) {
			idList.add(caso.Id);
			emailToCaseCase = caso;
		}
		idList.add(UserInfo.getUserId());
		List<ContentDocumentLink> cdLinksCreated = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: idList];
		System.assertEquals(12, cdLinksCreated.size(), 'Deben haber doce CDLinks');
		List<ContentDocumentLink> caseCDLinks = new List<ContentDocumentLink>();
		List<ContentDocumentLink> userCDLinks = new List<ContentDocumentLink>();
		List<ContentDocumentLink> otherCDLinks = new List<ContentDocumentLink>();
		for (ContentDocumentLink cdLink : cdLinksCreated) {
			String sObjectType = cdLink.LinkedEntityId.getSObjectType().getDescribe().getName();
			if (sObjectType == 'User') {
				userCDLinks.add(cdLink);
			} else if (sObjectType == 'Case') {
				caseCDLinks.add(cdLink);
			} else {
				otherCDLinks.add(cdLink);
			}
		}
		System.assertEquals(6, userCDLinks.size(), 'Deben haber seis CDLinks para el usuario');
		System.assertEquals(6, caseCDLinks.size(), 'Deben haber doce CDLinks para el caso');
		System.assertEquals(0, otherCDLinks.size(), 'No deben haber CDLinks diferentes a los del caso y el usuario');
	}
}