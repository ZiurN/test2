@IsTest
private class WSBatchConsultoriosTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
    static XHttpCalloutMock getEmpty;

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
                .withBody(WSBatchConsultoriosMock.getFound())
                .addForAddress(WSBatchConsultorios.SERVICE_CONFIG.URL__c + '/v1/salud/batch/consultorios/07-01-2020?pageSize=100&page=1');

        getEmpty = new XHttpCalloutMock();
        getEmpty.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getEmpty.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSBatchConsultoriosMock.getEmpty())
                .addForAddress(WSBatchConsultorios.SERVICE_CONFIG.URL__c + '/v1/salud/batch/consultorios/12-12-2019?pageSize=100&page=1');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSBatchConsultoriosMock.getError())
                .addForAddress(WSBatchConsultorios.SERVICE_CONFIG.URL__c + '/v1/salud/batch/consultorios/?pageSize=100&page=1');
    }

    @IsTest
    private static void whenTheWSIsConsume_GetListOfConsultorios(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        WSBatchConsultorios.Response responseToAssert = WSBatchConsultorios.getBatchConsultorios('07-01-2020', 100, 1);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals(3, responseToAssert.consultorios.data.size());



    }

    @IsTest
    private static void whenTheWSIsConsume_GetTokenErrorResponse(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        WSAuthToken.Response responseToAssert = WSAuthToken.getToken();
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
        System.assertEquals('404 not found', responseToAssert.response.getStatus());
        System.assertEquals(null, responseToAssert.token);
    }




    @IsTest
    private static void whenTheWSIsConsume_GetEmpty(){
        Test.setMock(HttpCalloutMock.class, getEmpty);

        Test.startTest();
        WSBatchConsultorios.Response responseToAssert = WSBatchConsultorios.getBatchConsultorios('12-12-2019', 100, 1);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals(0, responseToAssert.consultorios.data.size());

    }
}