@isTest 
private class ContentVersionTriggerTest {
	private static XHttpCalloutMock serverMock;

	static {
		serverMock = new XHttpCalloutMock();
		serverMock.buildResponse()
				.withBody('some body');
	}
	
	@isTest
	private static void copyBodyFromNoteToFieldNotaInLeadBeforeUpdate() {
		Lead cand = Build.aLead().build();
		cand.Phone = '1234567890';
		insert cand;

		ContentNote cn = new ContentNote();
		cn.Title = 'Test';
		cn.Content = Blob.valueOf('contentNote');
		insert cn;

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cn.Id;
		cdl.LinkedEntityId = cand.Id;
		
		Test.startTest();
		insert cdl;
		Test.stopTest();

		cand = [
			SELECT Id, Nota__c, 
				(SELECT Id FROM AttachedContentNotes) 
			FROM Lead WHERE Id = :cand.Id
		];

		System.assertEquals('contentNote', cand.Nota__c);
	}

	@isTest
	private static void copyBodyFromNoteToFieldNotaInLeadAfterInsert() {
		Lead cand = Build.aLead().build();
		cand.Phone = '1234567890';
		insert cand;

		ContentNote cn = new ContentNote();
		cn.Title = 'Test';
		cn.Content = Blob.valueOf('contentNote');
		insert cn;

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cn.Id;
		cdl.LinkedEntityId = cand.Id;
		insert cdl;

		ContentVersion cv = new ContentVersion();
		cv.ContentDocumentId = cn.Id;
		cv.VersionData = Blob.valueOf('nueva version');
		cv.PathOnClient = '/copyBodyFromNoteToFieldNotaInLead.snote';
		
		Test.startTest();
		insert cv;
		Test.stopTest();

		cand = [
			SELECT Id, Nota__c, 
				(SELECT Id FROM AttachedContentNotes) 
			FROM Lead WHERE Id = :cand.Id
		];

		System.assertEquals('nueva version', cand.Nota__c);
	}

	@isTest
	private static void dontUpdateContentVersionOnOpportunityIndividuos() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
		insert opp;

		ContentVersion cv = new ContentVersion();
		cv.Title = 'Test';
		cv.VersionData = Blob.valueOf('testDontUpdateContentVersionOnOpportunityIndividuos');
		cv.PathOnClient = '/testDontUpdateContentVersionOnOpportunityIndividuos';
		insert cv;

		cv = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cv.ContentDocumentId;
		cdl.LinkedEntityId = opp.Id;
		insert cdl;

		ContentVersion cv2 = new ContentVersion();
		cv2.Title = 'Test2';
		cv2.VersionData = Blob.valueOf('testDontUpdateContentVersionOnOpportunityIndividuos2');
		cv2.PathOnClient = '/testDontUpdateContentVersionOnOpportunityIndividuos';
		cv2.ContentDocumentId = cv.ContentDocumentId;
		
		Test.startTest();
		Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest();

		String[] errors = new List<String>();

		System.assertEquals(false, result.isSuccess());
		
		for(Database.Error err : result.getErrors()) {
			errors.add(err.getMessage());
		}

		System.assert(errors.contains('No se permite cargar una nueva version'));
		//System.assertEquals(false, result.isSuccess());
	}

	//Cancelacion s3
	/*@isTest
	private static void sendOpportunityFileToAWS() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
		insert opp;

		ContentVersion cv = new ContentVersion();
		cv.Title = 'TESTAWSTRIGGER';
		cv.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		cv.PathOnClient = '/TESTAWSTRIGGER.TXT';
		insert cv;

		cv = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cv.ContentDocumentId;
		cdl.LinkedEntityId = opp.Id;
		insert cdl;

		cv.Title = 'TESTAWSTRIGGER.TXT';
		
		serverMock.buildResponse()
				.addForAddress(AWS.url + 'solicitudes_sf/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest();

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
		];

		System.assert(!archivos.isEmpty());	
	}*/
}