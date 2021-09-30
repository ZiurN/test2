@IsTest
private class WSEmpresaConveniosTest {
    @IsTest
    static void whenTheWSIsConsume_GetListOfConveniosFromEmpresa() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        WSEmpresaConvenios.Response responseToAssert = WSEmpresaConvenios.getConvenios('600011');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(5, responseToAssert.convenios.data.convenios.detalles.size());
		System.assertEquals('01/06/2017', responseToAssert.convenios.data.convenios.detalles[0].fecha_desde);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].fecha_hasta);
		System.assertEquals('23', responseToAssert.convenios.data.convenios.detalles[0].grado);
		System.assertEquals('1', responseToAssert.convenios.data.convenios.detalles[0].prioridad);
		System.assertEquals('E600001-S6', responseToAssert.convenios.data.convenios.detalles[0].descripcion);
		System.assertEquals('MIGRACION PLANES AS', responseToAssert.convenios.data.convenios.detalles[0].sucursal);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].osoc_codigo);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].nombre_agrupacion);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].nombre_agrupacion1);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].nombre_agrupacion2);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].nombre_agrupacion3);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].nombre_agrupacion4);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].categoria_afiliado);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].zona_geografica);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].codigo_afiliado);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].apellido_afiliado);
		System.assertEquals(null, responseToAssert.convenios.data.convenios.detalles[0].nombre_afiliado);
		System.assertEquals('F', responseToAssert.convenios.data.convenios.detalles[0].permite_plan_mayor);
    }

    @IsTest
    private static void whenTheWSIsConsume_consumeWSEmpresa_returnErrorMessage(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        WSEmpresaConvenios.Response responseToAssert = WSEmpresaConvenios.getConvenios('0');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
        System.assertEquals('Not Found', responseToAssert.response.getStatus());
        System.assertEquals(null, responseToAssert.convenios);
    }

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
                .withBody(WSEmpresaConveniosMock.getFound())
                .addForAddress(WSEmpresaConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios/600011');


        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSEmpresaConveniosMock.getError())
                .addForAddress(WSEmpresaConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios/0');
    }
}