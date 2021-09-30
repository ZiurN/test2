@isTest 
private class WSLoteContabilizarTest {

	static XHttpCalloutMock getResponseSuccessCont;
	static XHttpCalloutMock getResponseSuccessAnul;
	static XHttpCalloutMock getResponseError;

	static {
		getResponseSuccessCont = new XHttpCalloutMock();
		getResponseSuccessCont.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseSuccessCont.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLoteContabilizarMock.getFoundContabilizar())
			.addForAddress(WSLoteContabilizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5402/contabilizacion');
		
		getResponseSuccessAnul = new XHttpCalloutMock();
		getResponseSuccessAnul.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseSuccessAnul.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLoteContabilizarMock.getFoundAnular())
			.addForAddress(WSLoteContabilizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5402/contabilizacion');
		
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('No se pudo contabilizar el lote.')
			.withStatusCode(400)
			.withBody(WSLoteContabilizarMock.getError())
			.addForAddress(WSLoteContabilizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5407/contabilizacion');
		
	}

	@isTest
	private static void contabilizarLoteEnSS() {
		
		Test.setMock(HttpCalloutMock.class, getResponseSuccessCont);
		Test.startTest();
		WSLoteContabilizar.Response resp = WSLoteContabilizar.contabilizacion('5402','{"accion":"CONTABILIZAR","usuario":"CRIOS"}');
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals(null, resp.message);
		System.assertEquals('O',resp.lote.data.lote.estado);
		System.assertEquals(5402,resp.lote.data.lote.lr_id);
		System.assertEquals('38863',resp.lote.data.lote.prei_id);
		System.assertEquals(1,resp.lote.data.lote.procesos.size());
	}

	@isTest
	private static void anularContabilizacionLoteEnSS() {
		
		Test.setMock(HttpCalloutMock.class, getResponseSuccessAnul);
		Test.startTest();
		WSLoteContabilizar.Response resp = WSLoteContabilizar.contabilizacion('5402','{"accion":"ANULAR","usuario":"CRIOS"}');
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals(null, resp.message);
		System.assertEquals('C',resp.lote.data.lote.estado);
		System.assertEquals(5402,resp.lote.data.lote.lr_id);
		System.assertEquals('38866',resp.lote.data.lote.prei_id);
		System.assertEquals(1,resp.lote.data.lote.procesos.size());
	}

	@isTest
	private static void contabilizacionFallaEnSS() {
		
		Test.setMock(HttpCalloutMock.class, getResponseError);
		Test.startTest();
		WSLoteContabilizar.Response resp = WSLoteContabilizar.contabilizacion('5407','{"accion":"CONTABILIZAR","usuario":"CRIOS"}');
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('ERROR AL CONTABILIZAR LOTE. no esta en estado CERRADO', resp.message);
		System.assertEquals(null,resp.lote);

	}




}