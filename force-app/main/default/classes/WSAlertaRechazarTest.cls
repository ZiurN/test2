@IsTest
private class WSAlertaRechazarTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
    static XHttpCalloutMock getResponseFoundReintegro;

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
                .addForAddress(WSAlertaAutorizar.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/alerta/rechazar/16461114');

        getResponseFoundReintegro = new XHttpCalloutMock();
        getResponseFoundReintegro.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFoundReintegro.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAlertaRechazarMock.getFound())
            .addForAddress(WSAlertaAutorizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/alertas/16461114');

    }

    @IsTest
    private static void whenTheWSIsConsume_AuthorizeAlert() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        WSAlertaRechazar.Response responseToAssert = WSAlertaRechazar.rechazarAlerta('16461114', '{"username": "CRIOS"}');
        Test.stopTest();

        System.debug(responseToAssert);

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
    }


    @IsTest
    private static void whenTheWSIsConsume_RejectAlertFromReintegro() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundReintegro);

        Test.startTest();
        WSAlertaRechazar.Response responseToAssert = WSAlertaRechazar.rechazarAlertaReintegro('16461114', '{"accion":"rechazar","username": "CRIOS","motivo":"test"}');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
    }
}