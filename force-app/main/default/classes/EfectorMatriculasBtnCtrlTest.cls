@IsTest
private class EfectorMatriculasBtnCtrlTest {
    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSEfectorMatriculasSucess_returnAListOfMatriculas() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        EfectorMatriculasBtnCtrl.Response responseToAssert = EfectorMatriculasBtnCtrl.getMatriculasEfector(
                '765058');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(1,responseToAssert.matriculas.size());
    }

    @IsTest
    static void whenTheWSIsConsume_GetMatriculasErrorResponse() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        EfectorMatriculasBtnCtrl.Response responseToAssert = EfectorMatriculasBtnCtrl.getMatriculasEfector('0');
        Test.stopTest();

        System.assertEquals(true,responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar obtener las matriculas del efector desde SaludSoft',
                responseToAssert.message);
        System.assertEquals(null,responseToAssert.matriculas);
    }

    @IsTest
    static void whenTheWSIsConsume_GetMatriculasEfectorEmptyResponse() {
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        EfectorMatriculasBtnCtrl.Response responseToAssert = EfectorMatriculasBtnCtrl.getMatriculasEfector('0');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(0,responseToAssert.matriculas.size());
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
                .withBody(WSEfectorMatriculasMock.getFound())
                .addForAddress(WSEfectorMatriculas.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/matriculas?' +
                'filter[codigo]=765058');

        getEmptyResponse = new XHttpCalloutMock();
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEfectorMatriculasMock.getEmpty())
                .addForAddress(WSEfectorMatriculas.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/matriculas?filter[codigo]=0');


        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSEfectorMatriculasMock.getError())
                .addForAddress(WSEfectorMatriculas.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/matriculas/');
    }
}