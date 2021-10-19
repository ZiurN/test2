@IsTest
private class WSEventoMedicoAnularTest {
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
                .withBody(WSEventoMedicoAnularMock.getFound())
                .addForAddress(WSEventoMedicoAnular.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/249818/anular');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSEventoMedicoAnularMock.getError())
                .addForAddress(WSEventoMedicoAnular.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/0/anular');
    }

    @IsTest
    private static void whenTheWSIsConsume_GetListOfPresupuestosOfPrestador(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        WSEventoMedicoAnular.Response responseToAssert = WSEventoMedicoAnular.anularEM('249818', '{"usuario": "CRIOS"}');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals('249818', responseToAssert.result.data.em_id);
        System.assertEquals('ANULADO', responseToAssert.result.data.estado);

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