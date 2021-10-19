@isTest 
private class WSLotePasajeAIFTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseError;

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
			.withBody(WSLotePasajeAIFMock.getFound())
			.addForAddress(WSLotePasajeAIF.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5406/pasaje-if');
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSLotePasajeAIFMock.getError())
			.addForAddress(WSLotePasajeAIF.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5500/pasaje-if');
		
	}

	@isTest
	private static void shouldSendLoteToSS() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		WSLotePasajeAIF.Response resp = WSLotePasajeAIF.pasajeIF('5406','{"usuario":"CRIOS"}');
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals(null, resp.message);
		System.assertEquals('F',resp.lote.data.lote.estado);
		System.assertEquals(5406,resp.lote.data.lote.lr_id);
	}

	@isTest
	private static void shouldSendLoteToSSAndReceiveError() {
		Test.setMock(HttpCalloutMock.class, getResponseError);
		Test.startTest();
		WSLotePasajeAIF.Response resp = WSLotePasajeAIF.pasajeIF('5500','{"usuario":"CRIOS"}');
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('El lote solicitado es inválido.', resp.message);
		
	}
}