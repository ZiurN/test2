@isTest 
private class WSEfectorGetPdfConveniosTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;


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
			.addForAddress(WSEfectorGetPdfConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/prestadores/123456/convenios');

	}

	@isTest
	private static void getPdfConveniosSuccess() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		WSEfectorGetPdfConvenios.Response resp = WSEfectorGetPdfConvenios.getPdfConvenios('700125');
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals('700125', resp.result.data[0].efe_codigo);
		System.assertEquals('2019-01-01 00:00:00', resp.result.data[0].fecha);
		System.assertEquals('GRUGAMMA_M_20190101.pdf', resp.result.data[0].nombre_arch);
		System.assertEquals(null, resp.result.data[0].modulo);
		System.assertEquals(null, resp.result.data[0].arancel);
		System.assertEquals(null, resp.result.data[0].anexo);
		System.assertEquals('VALORES ENERO 2019', resp.result.data[0].descripcion);
		System.assertEquals('JVBERi0xLjUNCiW1tbW1', resp.result.data[0].base64);

	}

	@isTest
	private static void getPdfConveniosError() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		String msg = 'El prestador solicitado es inválido.';

		Test.startTest();
		WSEfectorGetPdfConvenios.Response resp = WSEfectorGetPdfConvenios.getPdfConvenios('123456');
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals(msg, resp.message);
	}

}