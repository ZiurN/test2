@isTest 
private class WSCaseAutorizarAPRechazadaTest {
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
                .withBody(WSCaseAutorizarAPRechazadaMock.getFound())
                .addForAddress(WSCaseAutorizarAPRechazada.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/rechazadas/1014011025');		

		getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(400)
                .withBody(WSCaseAutorizarAPRechazadaMock.getError())
                .addForAddress(WSCaseAutorizarAPRechazada.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/rechazadas/123');		
    }

    @IsTest
    private static void whenTheWSIsConsume_autorizarAPRechazada() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        
        Test.startTest();
        WSCaseAutorizarAPRechazada.Response responseToAssert = WSCaseAutorizarAPRechazada.autorizarApRechazada(
			'1014011025', '{"usuario": "CRIOS"}'
		);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals('Se autorizó correctamente la AP.', responseToAssert.result.message);
    }

	@IsTest
    private static void whenTheWSIsConsume_getErrorMsg() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        
        Test.startTest();
        WSCaseAutorizarAPRechazada.Response responseToAssert = WSCaseAutorizarAPRechazada.autorizarApRechazada(
			'123', '{"usuario": "CRIOS"}'
		);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('La autorización solicitada es inválida.', responseToAssert.message);
    }
}