@IsTest
private class WSEfectorSuspensionesTest {
    @IsTest
    static void whenTheWSIsConsume_GetListOfSuspensionesFromEfector() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        WSEfectorSuspensiones.Response responseToAssert = WSEfectorSuspensiones.getEfectorSuspensiones('700047');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(6, responseToAssert.suspensiones.data.size());

        System.assertEquals('2014-07-10 00:00:00', responseToAssert.suspensiones.data[0].fecha_inicio);
        System.assertEquals('2000-01-01 00:00:00', responseToAssert.suspensiones.data[0].fecha_finalizacion);
        System.assertEquals('Chicos, la pxma presentación de AMR se pasa sin fotocopiar.Solo etiqueta en la hoja' +
                ' de resumen.Cualquier duda coordinen con' +
                ' Lili Araujo.Muchas graciasMaría Daniela Mazondo',
                responseToAssert.suspensiones.data[0].motivo);
        System.assertEquals(null,
                responseToAssert.suspensiones.data[0].observaciones);


    }

    @IsTest
    private static void whenTheWSIsConsume_GetEmptyListOfSuspensiones(){
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        WSEfectorSuspensiones.Response responseToAssert = WSEfectorSuspensiones.getEfectorSuspensiones('0');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(0, responseToAssert.suspensiones.data.size());
    }

    static XHttpCalloutMock getResponseFound;
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
                .withBody(WSEfectorSuspensionesMock.getFound())
                .addForAddress(WSEfectorPresentaciones.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/suspensiones/700047');

        getEmptyResponse = new XHttpCalloutMock();
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEfectorSuspensionesMock.getEmpty())
                .addForAddress(WSEfectorPresentaciones.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/suspensiones/0');

    }
}