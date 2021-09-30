@IsTest
private class WSCaseValoracionTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorDateResponse;
    static XHttpCalloutMock getErrorAfiResponse;

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
                .withBody(WSCaseValoracionMock.getFound())
                .addForAddress(WSCaseValoracion.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/458495/04-2019');
        
        getErrorDateResponse = new XHttpCalloutMock();
        getErrorDateResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorDateResponse.buildResponse()
                .withStatus('404 Not Found')
                .withStatusCode(404)
                .withBody(WSCaseValoracionMock.getErrorInvalidDate())
                .addForAddress(WSCaseValoracion.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/458495/04-19');

        getErrorAfiResponse = new XHttpCalloutMock();
        getErrorAfiResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorAfiResponse.buildResponse()
                .withStatus('404 Not Found')
                .withStatusCode(404)
                .withBody(WSCaseValoracionMock.getErrorInvalidAfi())
                .addForAddress(WSCaseValoracion.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/123/04-2019');

    }

    @IsTest
    private static void getValoracionFromAValidAfiliado() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        WSCaseValoracion.Response resp = WSCaseValoracion.getValoracion('458495','04-2019');
        Test.stopTest();

        System.assertEquals(false,resp.hasError);
        System.assertEquals(null,resp.message);
        System.assertEquals('10000',resp.result.data[0].importe);	

    }
    
    @IsTest
    private static void getValoracionUsingAnInvalidAfiliado() {
        Test.setMock(HttpCalloutMock.class, getErrorAfiResponse);
        Test.startTest();
        WSCaseValoracion.Response resp = WSCaseValoracion.getValoracion('123','04-2019');
        Test.stopTest();

        System.assertEquals(true,resp.hasError);
        System.assertEquals('El ID del Afiliado es inválido.',resp.message);
        System.assertEquals(null,resp.result);	

    }
    
    @IsTest
    private static void getValoracionUsingAnInvalidDate() {
        Test.setMock(HttpCalloutMock.class, getErrorDateResponse);
        Test.startTest();
        WSCaseValoracion.Response resp = WSCaseValoracion.getValoracion('123','04-19');
        Test.stopTest();
        
        System.assertEquals(true,resp.hasError);
        System.assertEquals(null,resp.result);	
        
    }


}