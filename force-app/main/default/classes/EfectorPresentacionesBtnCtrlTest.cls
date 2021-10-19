@IsTest
private class EfectorPresentacionesBtnCtrlTest {
    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSEfectorPresentacionesSucess_returnAListOfPresentaciones() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        EfectorPresentacionesBtnCtrl.Response responseToAssert = EfectorPresentacionesBtnCtrl.getPresentacionesEfector('700084');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(5,responseToAssert.presentaciones.size());
    }

    @IsTest
    static void whenTheWSIsConsume_GetPresentacionesErrorResponse() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        EfectorPresentacionesBtnCtrl.Response responseToAssert = EfectorPresentacionesBtnCtrl.getPresentacionesEfector('');
        Test.stopTest();

        System.assertEquals(true,responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar obtener las presentaciones del efector desde SaludSoft',
                responseToAssert.message);
        System.assertEquals(null,responseToAssert.presentaciones);
    }

    @IsTest
    static void whenTheWSIsConsume_GetPresentacionesEfectorEmptyResponse() {
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        EfectorPresentacionesBtnCtrl.Response responseToAssert = EfectorPresentacionesBtnCtrl.getPresentacionesEfector('0');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(0,responseToAssert.presentaciones.size());
    }

	@IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSEfectorDetallesSucess_returnAListOfDetalles() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundDetalles);
        Test.startTest();
        EfectorPresentacionesBtnCtrl.ResponseDetalles responseToAssert = EfectorPresentacionesBtnCtrl.getEfectorDetallesPresentacion('218020757');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(2,responseToAssert.detallesPresentacion.size());
    }

    @IsTest
    static void whenTheWSIsConsume_GetDetallesPresentacionesErrorResponse() {
        Test.setMock(HttpCalloutMock.class, getErrorResponseDetalles);
        Test.startTest();
        EfectorPresentacionesBtnCtrl.ResponseDetalles responseToAssert = EfectorPresentacionesBtnCtrl.getEfectorDetallesPresentacion('0');
        Test.stopTest();

        System.assertEquals(true,responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar obtener los comprobantes de la presentación desde SaludSoft',
                responseToAssert.message);
        System.assertEquals(null,responseToAssert.detallesPresentacion);
    }

    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
    static XHttpCalloutMock getEmptyResponse;
    static XHttpCalloutMock getResponseFoundDetalles;
    static XHttpCalloutMock getErrorResponseDetalles;

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

		getResponseFoundDetalles = new XHttpCalloutMock();
		getResponseFoundDetalles.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundDetalles.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSEfectorGetDetallesPresentacionMock.getFound())
			.addForAddress(WSEfectorGetDetallesPresentacion.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presentaciones/comprobantes/218020757');
		
		getErrorResponseDetalles = new XHttpCalloutMock();
		getErrorResponseDetalles.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseDetalles.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSEfectorGetDetallesPresentacionMock.getError())
			.addForAddress(WSEfectorGetDetallesPresentacion.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presentaciones/comprobantes/');
    }
}