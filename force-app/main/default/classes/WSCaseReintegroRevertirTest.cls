@IsTest
public class WSCaseReintegroRevertirTest  {

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
                .withBody(WSCaseReintegroRevertirMock.getFound())
                .addForAddress(WSCaseAPRevertir.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/553276');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(500)
                .withBody(WSCaseReintegroRevertirMock.getError())
                .addForAddress(WSCaseAPRevertir.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/553276');

    }

    @IsTest
    public static void revertValidReintegro() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        
		Case reintegro = new Case(Codigo_reintegro_SS__c = '553276');
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;

        Test.startTest();
        WSCaseReintegroRevertir.Response response = WSCaseReintegroRevertir.revertirReintegro(reintegro.Codigo_reintegro_SS__c,'{"username":"CRIOS"}');
        Test.stopTest();

        System.assertEquals(false, response.hasError);
        System.assertEquals(null, response.message);
		System.assertEquals('CR-----G', response.result.data.reintegro[0].vda_drv_estado);

    }

    @IsTest
    public static void revertInvalidReintegro() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        
		Case reintegro = new Case(Codigo_reintegro_SS__c = '553276');
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;

        Test.startTest();
        WSCaseReintegroRevertir.Response response = WSCaseReintegroRevertir.revertirReintegro(reintegro.Codigo_reintegro_SS__c,'{"username":"CRIOS"}');
        Test.stopTest();

        System.assertEquals(true, response.hasError);
        System.assertEquals(null, response.result);


    }
}