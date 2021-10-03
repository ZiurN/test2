@IsTest
private class EmpresaConveniosPorAportesBtnCtrlTest {
    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSConveniosPorAporteSucess_returnAListOfConvenios() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        EmpresaConveniosPorAportesBtnCtrl.Response responseToAssert = EmpresaConveniosPorAportesBtnCtrl.getConveniosPorAporte('600011');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(1,responseToAssert.convenios.size());
    }

    @IsTest
    static void whenTheWSIsConsume_GetConveniosPorAportesErrorResponse() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        EmpresaConveniosPorAportesBtnCtrl.Response responseToAssert = EmpresaConveniosPorAportesBtnCtrl.getConveniosPorAporte('asdf');
        Test.stopTest();

        System.assertEquals(true,responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar obtener los convenios por aporte desde SaludSoft',
                            responseToAssert.message);
        System.assertEquals(null,responseToAssert.convenios);
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
                .withBody(WSEmpresaConveniosPorAporteMock.getFound())
                .addForAddress(WSEmpresaConveniosPorAporte.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios-aportes?filter[codigo_empresa]=600011');

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