@IsTest
private class WSEmpresaConveniosPorAporteTest {
    @IsTest
    private static void whenTheWSIsConsume_GetListOfConveniosPorAporteFromEmpresa(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        WSEmpresaConveniosPorAporte.Response responseToAssert = WSEmpresaConveniosPorAporte.getConveniosAportes('600011');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(1, responseToAssert.conveniosPorAporte.data.size());

        System.assertEquals('147', responseToAssert.conveniosPorAporte.data[0].id);
        System.assertEquals('SIN DEFINIR', responseToAssert.conveniosPorAporte.data[0].obra_social);
        System.assertEquals(null, responseToAssert.conveniosPorAporte.data[0].grupo_empresa);
        System.assertEquals('ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA',
                responseToAssert.conveniosPorAporte.data[0].empresa);
        System.assertEquals(null, responseToAssert.conveniosPorAporte.data[0].codigo_afiliado);
        System.assertEquals(null, responseToAssert.conveniosPorAporte.data[0].importe);
        System.assertEquals('105', responseToAssert.conveniosPorAporte.data[0].grado);


    }

    @IsTest
    private static void whenTheWSIsConsume_GetEmptyListOfConvenios(){
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        WSEmpresaConveniosPorAporte.Response responseToAssert = WSEmpresaConveniosPorAporte.getConveniosAportes('0');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(0, responseToAssert.conveniosPorAporte.data.size());
    }

    @IsTest
    private static void whenTheWSIsConsume_consumeWSEmpresaConveniosPorAporte_returnErrorMessage(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        WSEmpresaConveniosPorAporte.Response responseToAssert = WSEmpresaConveniosPorAporte.getConveniosAportes('asdf');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(500, responseToAssert.response.getStatusCode());
        System.assertEquals('Not Found', responseToAssert.response.getStatus());
        System.assertEquals(null, responseToAssert.conveniosPorAporte);
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
                .withBody(WSEmpresaConveniosPorAporteMock.getFound())
                .addForAddress(WSEmpresaConveniosPorAporte.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios-aportes?filter[codigo_empresa]=600011');

        getEmptyResponse = new XHttpCalloutMock();
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEmpresaConveniosPorAporteMock.getEmpty())
                .addForAddress(WSEmpresaConveniosPorAporte.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios-aportes?filter[codigo_empresa]=0');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(500)
                .withBody(WSEmpresaConveniosPorAporteMock.getError())
                .addForAddress(WSEmpresaConveniosPorAporte.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios-aportes?filter[codigo_empresa]=asdf');
    }
}