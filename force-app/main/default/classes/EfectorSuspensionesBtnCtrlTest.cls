@IsTest
private class EfectorSuspensionesBtnCtrlTest {
    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSEfectorSuspensionesSucess_returnAListOfSuspensiones() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        EfectorSuspensionesBtnCtrl.Response responseToAssert = EfectorSuspensionesBtnCtrl.getSuspensionesEfector('700047');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(6,responseToAssert.suspensiones.size());
    }



    @IsTest
    static void whenTheWSIsConsume_GetSuspensionesEfectorEmptyResponse() {
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        EfectorSuspensionesBtnCtrl.Response responseToAssert = EfectorSuspensionesBtnCtrl.getSuspensionesEfector('0');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(0,responseToAssert.suspensiones.size());
    }

    @IsTest
    static void whenTheWSIsConsume_GetSuspensionesErrorResponse() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        EfectorSuspensionesBtnCtrl.Response responseToAssert = EfectorSuspensionesBtnCtrl.getSuspensionesEfector('');
        Test.stopTest();

        System.assertEquals(true,responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar obtener las suspensiones del efector desde SaludSoft',
                responseToAssert.message);
        System.assertEquals(null,responseToAssert.suspensiones);
    }


    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getEmptyResponse;
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
                .withBody(WSEfectorSuspensionesMock.getFound())
                .addForAddress(WSEfectorSuspensiones.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/suspensiones/700047');

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
                .addForAddress(WSEfectorSuspensiones.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/suspensiones/0');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSEfectorSuspensionesMock.getError())
                .addForAddress(WSEfectorSuspensiones.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/suspensiones/');
    }
}