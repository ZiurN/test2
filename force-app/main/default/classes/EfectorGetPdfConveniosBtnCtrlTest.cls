@isTest 
private class EfectorGetPdfConveniosBtnCtrlTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static Account efector;


	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSEfectorGetPdfConveniosMock.getFound())
			.addForAddress(WSEfectorGetPdfConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/prestadores/700125/convenios');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSEfectorGetPdfConveniosMock.getError())
			.addForAddress(WSEfectorGetPdfConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/prestadores/700125/convenios');

		efector = Build.anAccountEfector().build();
		efector.Codigo_de_efector__c = '700125';
		insert efector;
	}

	@isTest
	private static void getPdfConveniosSuccess() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		EfectorGetPdfConveniosBtnCtrl.Response resp = EfectorGetPdfConveniosBtnCtrl.attachPfdConvenios(efector.Id);
		Test.stopTest();

		ContentDocumentLink[] links = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :efector.Id];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
		System.assertEquals(3, links.size());

	}

	@isTest
	private static void getPdfConveniosError() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		String msg = 'El prestador solicitado es inválido.';

		Test.startTest();
		EfectorGetPdfConveniosBtnCtrl.Response resp = EfectorGetPdfConveniosBtnCtrl.attachPfdConvenios(efector.Id);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals(msg, resp.message);
	}

	@isTest
	private static void whenCodigoDeEfectorIsEmptyShowTheMsg() {
		efector.Codigo_de_efector__c = null;
		update efector;

		Test.startTest();
		EfectorGetPdfConveniosBtnCtrl.Response resp = EfectorGetPdfConveniosBtnCtrl.attachPfdConvenios(efector.Id);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals('El código de efector esta vacío.', resp.message);

	}

	@IsTest
	private static void ifAlreadyExistAnContentVersionWithTheSameTitle_DontInsertThisPdf() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		ContentVersion cv = new ContentVersion();
		cv.Title = 'GGAMMA_20181001.pdf';
		cv.VersionData = Blob.valueOf('GGAMMA_20181001_Test');
		cv.PathOnClient = '/GGAMMA_20181001_Test';
		insert cv;

		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

		ContentDocumentLink link = new ContentDocumentLink();
		link.ContentDocumentId = cv.ContentDocumentId;
		link.LinkedEntityId = efector.Id;
		insert link;

		Test.startTest();
		EfectorGetPdfConveniosBtnCtrl.Response resp = EfectorGetPdfConveniosBtnCtrl.attachPfdConvenios(efector.Id);
		Test.stopTest();

		ContentDocumentLink[] links = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :efector.Id];
		ContentVersion[] versions = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :cv.ContentDocumentId];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
		System.assertEquals(3, links.size());
		System.assertEquals(1, versions.size());

	}

}