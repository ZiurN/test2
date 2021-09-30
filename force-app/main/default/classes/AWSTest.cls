@isTest
private with sharing class AWSTest {
	private static XHttpCalloutMock serverMock;
	
	static {
		serverMock = new XHttpCalloutMock();
	}

    @isTest		
	private static void putObjectTest() {
		serverMock.buildResponse()
			.withBody('some body')
			.addForAddress(AWS.url + '0051U0000043d1AQAQ/TEST.TXT');
        Test.setMock(HttpCalloutMock.class, serverMock);

        ContentVersion cv = new ContentVersion();
		cv.VersionData = Blob.valueOf('test 1');
		cv.Title = 'TEST';
		cv.PathOnClient = '/TEST.TXT';
		insert cv;

		// hay que hacer la query para obtener el FileExtension
        cv = [
			SELECT Id, FileExtension, FileType, Title, VersionData,
				ContentDocumentId
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		ContentDocumentLink cdl = [
			SELECT LinkedEntityId 
			FROM ContentDocumentLink 
			WHERE ContentDocumentId = :cv.ContentDocumentId
		];
		
		Test.startTest();
		AWS.Response resp = AWS.putFile(cv, cdl.LinkedEntityId + '/', cdl.LinkedEntityId);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals(200, resp.response.getStatusCode());
		System.assertEquals(AWS.location + cdl.LinkedEntityId + '/TEST.TXT', resp.url);
    }
}