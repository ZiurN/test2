@IsTest
private class WSEfectorMatriculasTest {
    @IsTest
    private static void whenTheWSIsConsume_GetListOfMatriculasFromEfector(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        WSEfectorMatriculas.Response responseToAssert = WSEfectorMatriculas.getEfectorMatriculas(
                '765058');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(1, responseToAssert.matriculas.data.size());

        System.assertEquals('19392/01000000', responseToAssert.matriculas.data[0].matricula);
        System.assertEquals('HMED', responseToAssert.matriculas.data[0].clase_efector);
        System.assertEquals('765058', responseToAssert.matriculas.data[0].codigo);
        System.assertEquals('VIGNAU CARLOS GUSTAVO',
                responseToAssert.matriculas.data[0].nombre);
        System.assertEquals('MEDICOS DIRECTOS', responseToAssert.matriculas.data[0].nombre_clase);
        System.assertEquals('BUENOS AIRES', responseToAssert.matriculas.data[0].nombre_pcia);
        System.assertEquals('B', responseToAssert.matriculas.data[0].pcia_codigo);
        System.assertEquals('P', responseToAssert.matriculas.data[0].tipo_matricula);

    }

    @IsTest
    private static void whenTheWSIsConsume_GetEmptyListOfMatriculas(){
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        WSEfectorMatriculas.Response responseToAssert = WSEfectorMatriculas.getEfectorMatriculas('0');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(0, responseToAssert.matriculas.data.size());
    }

//    @IsTest
//    private static void whenTheWSIsConsume_consumeWSEfectorMatriculas_returnErrorMessage(){
//        Test.setMock(HttpCalloutMock.class, getErrorResponse);
//        Test.startTest();
//        WSEfectorMatriculas.Response responseToAssert = WSEfectorMatriculas.getEfectorMatriculas('');
//        Test.stopTest();
//
//        System.assertEquals(true, responseToAssert.hasError);
//        System.assertEquals(404, responseToAssert.response.getStatusCode());
//        System.assertEquals('Not Found', responseToAssert.response.getStatus());
//        System.assertEquals(null, responseToAssert.matriculas);
//    }

    static XHttpCalloutMock getResponseFound;
//    static XHttpCalloutMock getErrorResponse;
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

//        getErrorResponse = new XHttpCalloutMock();
//        getErrorResponse.buildResponse()
//                .withStatus('OK')
//                .withStatusCode(200)
//                .withBody(WSAuthTokenMock.getTokenSuccess())
//                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
//        getErrorResponse.buildResponse()
//                .withStatus('Not Found')
//                .withStatusCode(404)
//                .withBody(WSEfectorMatriculasMock.getError())
//                .addForAddress(WSEfectorMatriculas.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/matriculas/');
    }
}