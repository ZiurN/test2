@isTest 
private class WSAlertaReintegroAutorizarTest {
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
                .withBody(WSAlertaRechazarMock.getFound())
                .addForAddress(WSAlertaAutorizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/alertas/16464709');

		getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(404)
                .withBody(WSAlertaRechazarMock.getError())
                .addForAddress(WSAlertaAutorizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/alertas/164aass4709');

    }

    @IsTest
    private static void whenTheWSIsConsume_AuthorizeAlert() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);

		String body = '{"alerta_id": "16464709","usuario": "CRIOS"}';

        Test.startTest();
        WSAlertaReintegroAutorizar.Response responseToAssert = WSAlertaReintegroAutorizar.autorizarAlertaReintegro('16464709',body);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
    }

	@IsTest
    private static void whenTheWSIsConsume_getErrorMsg() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);

		String body = '{"alerta_id": "164aass4709","usuario": "CRIOS"}';

        Test.startTest();
        WSAlertaReintegroAutorizar.Response responseToAssert = WSAlertaReintegroAutorizar.autorizarAlertaReintegro('164aass4709',body);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('La alerta solicitada es inválida.', responseToAssert.message);
    }
}