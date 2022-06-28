@isTest
private with sharing class AWSTest {
	private static XHttpCalloutMock serverMock = new XHttpCalloutMock();
	@isTest
	private static void putObjectTest() {
		ContentVersion cv = new ContentVersion();
		cv.VersionData = Blob.valueOf('test 1');
		cv.Title = 'TEST';
		cv.PathOnClient = '/TEST.TXT';
		insert cv;
		cv = [SELECT Id,
				FileExtension,
				FileType,
				Title,
				VersionData,
				ContentDocumentId
			FROM ContentVersion
			WHERE Id = :cv.Id];
		ContentDocumentLink cdl = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :cv.ContentDocumentId];
		serverMock.buildResponse()
			.withBody('some body')
			.addForAddress(AWS.url + cdl.LinkedEntityId + '/TEST.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);
		System.debug(cdl.LinkedEntityId);
		Test.startTest();
		AWS.Response resp = AWS.putFile(cv, cdl.LinkedEntityId + '/', cdl.LinkedEntityId);
		Test.stopTest();
		System.assertEquals(false, resp.hasError, 'No debe haber ningún error');
		System.assertEquals(200, resp.response.getStatusCode(), 'El código deber ser 200');
		System.assertEquals(AWS.location + cdl.LinkedEntityId + '/TEST.TXT', resp.url, 'La URL no coincide');
	}
}