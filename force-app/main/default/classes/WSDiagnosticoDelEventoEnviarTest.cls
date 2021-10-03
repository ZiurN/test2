@isTest private class WSDiagnosticoDelEventoEnviarTest {
	static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getResponseError;
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
			.withBody(WSDiagnosticoDelEventoEnviarMock.getFound())
			.addForAddress(WSDiagnosticoDelEventoEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/diagnosticos');
		
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSDiagnosticoDelEventoEnviarMock.getError())
			.addForAddress(WSDiagnosticoDelEventoEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/diagnosticos');		

		body = '{' +
					'"usuario": "CRIOS",' +
					'"fecha": "26/02/2020",' +
					'"diagnostico": "E63.0",' +
					'"tipo_diagnostico": "DEFINITIVO"'+
				'}';
    }

    @IsTest private static void whenTheWSIsConsume_sendTheDiagnosticoDelEventoToSS(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        
        Test.startTest();
        WSDiagnosticoDelEventoEnviar.Response responseToAssert = WSDiagnosticoDelEventoEnviar.enviarDiagnostico('276349', body);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals('Se cargó el diagnóstico.', responseToAssert.result.message);
    }

	@IsTest private static void whenTheWSIsConsume_getErrorMsg(){
        Test.setMock(HttpCalloutMock.class, getResponseError);
        
        Test.startTest();
        WSDiagnosticoDelEventoEnviar.Response responseToAssert = WSDiagnosticoDelEventoEnviar.enviarDiagnostico('276349', body);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assert(responseToAssert.message.contains('El campo fecha es obligatorio.'));
    }
}