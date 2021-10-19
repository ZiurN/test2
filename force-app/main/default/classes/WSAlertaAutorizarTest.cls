@IsTest
public with sharing class WSAlertaAutorizarTest {
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
                .withBody(WSCasoEnviarASSMock.getFound())
                .addForAddress(WSAlertaAutorizar.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/alerta/autorizar/16461118');

    }

    @IsTest
    private static void whenTheWSIsConsume_AuthorizeAlert() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        WSAlertaAutorizar.Response responseToAssert = WSAlertaAutorizar.autorizarAlerta('16461118', '{"username": "CRIOS"}');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
    }
}