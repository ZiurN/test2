@isTest 
private class WSCoberturaEspecialEnviarTest {

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
                .withBody(WSCoberturaEspecialEnviarMock.getFound())
                .addForAddress(WSCoberturaEspecialEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/coberturas-especiales');		

		getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(400)
                .withBody(WSCoberturaEspecialEnviarMock.getError())
                .addForAddress(WSCoberturaEspecialEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/coberturas-especiales');		

		body = '{' +
					'"fecha_desde": "2020-04-01",' +
					'"efector_codigo": "753415",' +
					'"nom_prestacion": "02170101",' +
					'"tipo_copago": "P",' +
					'"incluye_excluye": "I",' +
					'"prioridad": "1",' +
					'"valor": "0",' +
					'"tope_mensual": "1",' +
					'"tope_anual": "10",' +
					'"usuario": "CRIOS"' +
				'}';
    }

    @IsTest
    private static void whenTheWSIsConsume_sendTheCoberturaToSS(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        
        Test.startTest();
        WSCoberturaEspecialEnviar.Response responseToAssert = WSCoberturaEspecialEnviar.enviarCobertura('276349', body);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals('Se cargó correctamente la cobertura especial.', responseToAssert.result.message);
    }

	@IsTest
    private static void whenTheWSIsConsume_getErrorMsg(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        
        Test.startTest();
        WSCoberturaEspecialEnviar.Response responseToAssert = WSCoberturaEspecialEnviar.enviarCobertura('276349', body);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('ERROR AL CARGAR COBERTURA. Hay solapamiento de rangos:', responseToAssert.message);
    }
}