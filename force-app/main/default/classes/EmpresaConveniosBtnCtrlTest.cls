@IsTest
private class EmpresaConveniosBtnCtrlTest {
    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSConveniosSucess_returnAListOfConvenios() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        EmpresaConveniosBtnCtrl.Response responseToAssert = EmpresaConveniosBtnCtrl.getConvenios('600011');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals('', responseToAssert.message);
        System.assertEquals(5, responseToAssert.data.convenios.detalles.size());
		System.assertEquals('01/06/2017', responseToAssert.data.convenios.detalles[0].fecha_desde);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].fecha_hasta);
		System.assertEquals('23', responseToAssert.data.convenios.detalles[0].grado);
		System.assertEquals('1', responseToAssert.data.convenios.detalles[0].prioridad);
		System.assertEquals('E600001-S6', responseToAssert.data.convenios.detalles[0].descripcion);
		System.assertEquals('MIGRACION PLANES AS', responseToAssert.data.convenios.detalles[0].sucursal);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].osoc_codigo);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].nombre_agrupacion);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].nombre_agrupacion1);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].nombre_agrupacion2);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].nombre_agrupacion3);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].nombre_agrupacion4);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].categoria_afiliado);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].zona_geografica);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].codigo_afiliado);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].apellido_afiliado);
		System.assertEquals(null, responseToAssert.data.convenios.detalles[0].nombre_afiliado);
		System.assertEquals('F', responseToAssert.data.convenios.detalles[0].permite_plan_mayor);
    }

    @IsTest
    static void whenTheWSIsConsume_GetConveniosErrorResponse() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        EmpresaConveniosBtnCtrl.Response responseToAssert = EmpresaConveniosBtnCtrl.getConvenios('0');
        Test.stopTest();

        System.assertEquals(true,responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar obtener los convenios desde SaludSoft',
                responseToAssert.message);
        System.assertEquals(null,responseToAssert.data);
    }

	@IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSPlanConveniosSucess_returnAListOfPlanConvenios() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundPlanConv);
        Test.startTest();
        EmpresaConveniosBtnCtrl.ResponsePlanConvenios responseToAssert = EmpresaConveniosBtnCtrl.getEmpresaPlanConvenios(2843);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals('',responseToAssert.message);

        System.assertEquals(1, responseToAssert.empresaPlanConvenios.size());
        System.assertEquals('01/07/2017', responseToAssert.empresaPlanConvenios[0].fecha_desde);
		System.assertEquals('30/06/2019', responseToAssert.empresaPlanConvenios[0].fecha_hasta);
		System.assertEquals('SUPERIOR AS300', responseToAssert.empresaPlanConvenios[0].plan_nombre);
    }

    @IsTest
    private static void whenTheWSIsConsume_GetPlanConveniosErrorResponse(){
        Test.setMock(HttpCalloutMock.class, getErrorResponsePlanConv);
        Test.startTest();
        EmpresaConveniosBtnCtrl.ResponsePlanConvenios responseToAssert = EmpresaConveniosBtnCtrl.getEmpresaPlanConvenios(0);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('Hubo un error al intentar obtener los planes del convenio desde SaludSoft', responseToAssert.message);
        System.assertEquals(null, responseToAssert.empresaPlanConvenios);
    }

    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getResponseFoundPlanConv;
    static XHttpCalloutMock getErrorResponsePlanConv;

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

        getResponseFoundPlanConv = new XHttpCalloutMock();
        getResponseFoundPlanConv.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFoundPlanConv.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEmpresaGetPlanConveniosMock.getFound())
                .addForAddress(WSEmpresaGetPlanConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios/planes-permitidos/2843');


        getErrorResponsePlanConv = new XHttpCalloutMock();
        getErrorResponsePlanConv.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponsePlanConv.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSEmpresaGetPlanConveniosMock.getError())
                .addForAddress(WSEmpresaGetPlanConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios/planes-permitidos/0');
    }
}