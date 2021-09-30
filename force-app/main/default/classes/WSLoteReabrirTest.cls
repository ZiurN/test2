@isTest 
private class WSLoteReabrirTest {

	static XHttpCalloutMock getResponseSuccess;
	static XHttpCalloutMock getResponseError;

	static {
		getResponseSuccess = new XHttpCalloutMock();
		getResponseSuccess.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseSuccess.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLoteReabrirMock.getFound())
			.addForAddress(WSLoteReabrir.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5397');
		
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('No se pudo reabrir el lote.')
			.withStatusCode(400)
			.withBody(WSLoteReabrirMock.getError())
			.addForAddress(WSLoteReabrir.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5397');
		
	}

	@isTest
	private static void reopenLoteEnSS() {
		
		Test.setMock(HttpCalloutMock.class, getResponseSuccess);
		Test.startTest();
		WSLoteReabrir.Response resp = WSLoteReabrir.reabrirLote('5397','{"accion":"REABRIR","usuario":"CRIOS"}');
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals(null, resp.message);
		System.assertEquals('A',resp.lote.data.lote.estado);
		System.assertEquals(5397,resp.lote.data.lote.lr_id);
		System.assertEquals('38855',resp.lote.data.lote.prei_id);
		System.assertEquals(1,resp.lote.data.lote.procesos.size());
	}

		@isTest
	private static void reopenLoteThatItsAlreadyOpenedEnSS() {
		
		Test.setMock(HttpCalloutMock.class, getResponseError);
		Test.startTest();
		WSLoteReabrir.Response resp = WSLoteReabrir.reabrirLote('5397','{"accion":"REABRIR","usuario":"CRIOS"}');
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('ERROR AL ABRIR LOTE. ERR Reabriendo el lote:. no esta en estado CERRADO', resp.message);
		System.assertEquals(null,resp.lote);

	}
}