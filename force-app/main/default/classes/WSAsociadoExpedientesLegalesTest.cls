@isTest 
private class WSAsociadoExpedientesLegalesTest {
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
                .withBody(WSAsociadoExpedientesLegalesMock.getFound())
                .addForAddress(WSAsociadoExpedientesLegales.SERVICE_CONFIG.URL__c + '/v1/salud/socio-legal/185415');		

		getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(400)
                .withBody(WSAsociadoExpedientesLegalesMock.getError())
                .addForAddress(WSAsociadoExpedientesLegales.SERVICE_CONFIG.URL__c + '/v1/salud/socio-legal/1234');		
    }

    @IsTest
    private static void whenTheWSIsConsume_autorizarAPRechazada() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        
        Test.startTest();
        WSAsociadoExpedientesLegales.Response responseToAssert = WSAsociadoExpedientesLegales.getExpedientes('185415');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
		//System.assertEquals('**SOCIO EN LEGALES**', responseToAssert.result.data.socio_legal);
    }

	@IsTest
    private static void whenTheWSIsConsume_getErrorMsg() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        
        Test.startTest();
        WSAsociadoExpedientesLegales.Response responseToAssert = WSAsociadoExpedientesLegales.getExpedientes('1234');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('El ID del Afiliado es inválido.', responseToAssert.message);
    }
}