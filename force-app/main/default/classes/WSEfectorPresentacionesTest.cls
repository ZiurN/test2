@IsTest
private class WSEfectorPresentacionesTest {
    @IsTest
    private static void whenTheWSIsConsume_GetListOfPresentacionesFromEfector(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        WSEfectorPresentaciones.Response responseToAssert = WSEfectorPresentaciones.getEfectorPresentaciones('700084');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(5, responseToAssert.presentaciones.data.size());

        System.assertEquals('219010600', responseToAssert.presentaciones.data[0].pp_id);
        System.assertEquals('2018-12-16', responseToAssert.presentaciones.data[0].periodo);
        System.assertEquals('CIBIC', responseToAssert.presentaciones.data[0].nombre_prestador);
        System.assertEquals('700084',
                responseToAssert.presentaciones.data[0].prestador);
        System.assertEquals('ROSARIO', responseToAssert.presentaciones.data[0].localidad);
        System.assertEquals('2019-01-09', responseToAssert.presentaciones.data[0].fecha_recepcion);
        System.assertEquals('2019-02-08', responseToAssert.presentaciones.data[0].fecha_vencimiento);
        System.assertEquals('821979.01', responseToAssert.presentaciones.data[0].total);
        System.assertEquals('GRABACION', responseToAssert.presentaciones.data[0].estado);

    }

    @IsTest
    private static void whenTheWSIsConsume_GetEmptyListOfPresentaciones(){
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        WSEfectorPresentaciones.Response responseToAssert = WSEfectorPresentaciones.getEfectorPresentaciones('0');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(0, responseToAssert.presentaciones.data.size());
    }

    @IsTest
    private static void whenTheWSIsConsume_consumeWSEfectorPresentaciones_returnErrorMessage(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        WSEfectorPresentaciones.Response responseToAssert = WSEfectorPresentaciones.getEfectorPresentaciones('');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
        System.assertEquals('Not Found', responseToAssert.response.getStatus());
        System.assertEquals(null, responseToAssert.presentaciones);
    }

    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
    static XHttpCalloutMock getEmptyResponse;

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
                .withBody(WSEfectorPresentacionesMock.getFound())
                .addForAddress(WSEfectorPresentaciones.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presentaciones/700084');

        getEmptyResponse = new XHttpCalloutMock();
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEfectorPresentacionesMock.getEmpty())
                .addForAddress(WSEfectorPresentaciones.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presentaciones/0');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSEfectorPresentacionesMock.getError())
                .addForAddress(WSEfectorPresentaciones.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presentaciones/');
    }
}