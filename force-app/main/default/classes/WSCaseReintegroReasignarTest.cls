@isTest 
private class WSCaseReintegroReasignarTest {

	static XHttpCalloutMock getSuccessResponse;
	static XHttpCalloutMock getErrorResponse;

	static{
	    getSuccessResponse = new XHttpCalloutMock();
        getSuccessResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getSuccessResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseReintegroReasignarMock.getFound())
                .addForAddress(WSCaseReintegroReasignar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/553276');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(500)
                .withBody(WSCaseReintegroReasignarMock.getError())
                .addForAddress(WSCaseReintegroReasignar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/123');

	}

	@isTest
	private static void reasignarLoteReintegroConExito() {
		Test.setMock(HttpCalloutMock.class, getSuccessResponse);
		String body = '{'+
							'"accion": "REASIGNAR",'+
							'"numero_lote": "999999",'+
							'"usuario": "CRIOS"'+
						'}';
		Test.startTest();
		WSCaseReintegroReasignar.Response resp = WSCaseReintegroReasignar.reasignarReintegro('553276',body);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals(553276, resp.result.data.id_reintegro);
	}

	@isTest
	private static void reasignarLoteReintegroInexistente() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		String body = '{'+
							'"accion": "REASIGNAR",'+
							'"numero_lote": "999999",'+
							'"usuario": "CRIOS"'+
						'}';
		Test.startTest();
		WSCaseReintegroReasignar.Response resp = WSCaseReintegroReasignar.reasignarReintegro('123',body);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('El reintegro solicitado es inválido.', resp.message);
	}

	@isTest
	private static void reasignarLoteReintegroSinCodigoDeReintegro() {
		Test.startTest();
		WSCaseReintegroReasignar.Response resp = WSCaseReintegroReasignar.reasignarReintegro(null, '');
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('No se puede reasignar el lote porque el reintegro no fue enviado a SS.', resp.message);
	}
}