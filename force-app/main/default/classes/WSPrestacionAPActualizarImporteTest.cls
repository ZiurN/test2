@isTest 
private class WSPrestacionAPActualizarImporteTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static String body;

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
			.withBody(WSPrestacionAPActualizarImporteMock.getFound())
			.addForAddress(WSPrestacionAPActualizarImporte.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/prestacion/74042009/importe');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSPrestacionAPActualizarImporteMock.getError())
			.addForAddress(WSPrestacionAPActualizarImporte.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/prestacion/74042009/importe');

		body = '{' +
					'"importe_plan": 187.50,' +
					'"importe_conv": 200.75,' +
					'"importe_socio": 250.50' +
				'}';
	}
	
	@IsTest
	private static void whenTheWSIsConsume_getPrestaciones(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSPrestacionAPActualizarImporte.Response responseToAssert = WSPrestacionAPActualizarImporte.updateImporte('74042009', body);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals('1014009728', responseToAssert.result.data[0].apr_id);
		System.assertEquals('Ambulatorio', responseToAssert.result.data[0].contexto);
		System.assertEquals('1', responseToAssert.result.data[0].cantidad);
		System.assertEquals('707008150', responseToAssert.result.data[0].prestacion);
		System.assertEquals('0', responseToAssert.result.data[0].importe_cargo_al_socio_sys);
		System.assertEquals('250.5', responseToAssert.result.data[0].importe_cargo_al_socio_aud);
		
	}

	@IsTest
	private static void whenTheWSIsConsume_GetTokenErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);

		Test.startTest();
		WSAuthToken.Response responseToAssert = WSAuthToken.getToken();
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('404 not found', responseToAssert.response.getStatus());
		System.assertEquals(null, responseToAssert.token);
	}
}