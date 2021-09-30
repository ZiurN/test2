@isTest 
private class WSCaseTestReintegroTest {
	static XHttpCalloutMock getResponseFoundPres;
	static XHttpCalloutMock getResponseFoundMed;
	static XHttpCalloutMock getErrorResponse;
	static String bodyPres;
	static String bodyMed;

	static {
		getResponseFoundPres = new XHttpCalloutMock();
		getResponseFoundPres.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundPres.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSCaseTestReintegroMock.getFoundPres())
			.addForAddress(WSCaseTestReintegro.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/test');

		getResponseFoundMed = new XHttpCalloutMock();
		getResponseFoundMed.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundMed.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSCaseTestReintegroMock.getFoundMed())
			.addForAddress(WSCaseTestReintegro.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/test');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSCaseTestReintegroMock.getError())
			.addForAddress(WSCaseTestReintegro.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/test');

		bodyPres = 
			'{' +
				'"contexto": "A",' +
				'"codigo_afiliado": "46940/16",' +
				'"prestacion": "02146003"' +
			'}';
		bodyMed = 
			'{' +
				'"contexto": "A",' +
				'"codigo_afiliado": "46940/16",' +
				'"medicamento": "48896"' +
			'}';				
	}
	
	@IsTest
	private static void whenTheWSIsConsume_getResponseWithMedicamentoData(){
		Test.setMock(HttpCalloutMock.class, getResponseFoundMed);
		
		Test.startTest();
		WSCaseTestReintegro.Response responseToAssert = WSCaseTestReintegro.testReintegro(bodyMed);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals('48896', responseToAssert.result.data.medicamento);
		System.assertEquals('66441.35', responseToAssert.result.data.precio_vta);
		System.assertEquals('53153.08', responseToAssert.result.data.precio_vta_20);
		System.assertEquals('40', responseToAssert.result.data.porc_cob);
		System.assertEquals('21261.23', responseToAssert.result.data.total);

	}

	@IsTest
	private static void whenTheWSIsConsume_getResponseWithPrestacionData(){
		Test.setMock(HttpCalloutMock.class, getResponseFoundPres);
		
		Test.startTest();
		WSCaseTestReintegro.Response responseToAssert = WSCaseTestReintegro.testReintegro(bodyPres);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals('02146003', responseToAssert.result.data.prestacion);
		System.assertEquals('257', responseToAssert.result.data.honorario);
		System.assertEquals('257', responseToAssert.result.data.gastos);
		System.assertEquals('100.66', responseToAssert.result.data.copago);
		System.assertEquals('413.34', responseToAssert.result.data.total);

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