/**
 * Created by xappia on 10/2/20.
 */

@IsTest
private class WSCaseAPRevertirTest {

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
                .withBody(WSCasoEnviarASSMock.getFound())
                .addForAddress(WSCaseAPRevertir.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/centro-autorizador/revertir/1014009821');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(500)
                .withBody(WSCaseAPRevertirMock.getError())
                .addForAddress(WSCaseAPRevertir.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/centro-autorizador/revertir/1014009821');

    }

    @IsTest
    static void revertValidAP() {
        Case ap = new Case(Nro_AP__c = '1014009821');
        Test.setMock(HttpCalloutMock.class,getResponseFound);
        Test.startTest();
        WSCaseAPRevertir.Response response = WSCaseAPRevertir.revertirCaso(ap.Nro_AP__c,'{"username":"CRIOS"}');
        Test.stopTest();

        System.assertEquals(false,response.hasError);
        System.assertEquals('Ok',response.message);


    }

    @IsTest
    static void revertInvalidAP() {
        Case ap = new Case(Nro_AP__c = '1014009821');
        Test.setMock(HttpCalloutMock.class,getErrorResponse);
        Test.startTest();
        WSCaseAPRevertir.Response response = WSCaseAPRevertir.revertirCaso(ap.Nro_AP__c,'{"username":"CRIOS"}');
        Test.stopTest();

        System.assertEquals(true,response.hasError);
        System.assertEquals(null,response.caseRes);


    }
}