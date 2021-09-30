@IsTest
public class WSEfectorConveniosTest  {

    @IsTest
    static void whenTheWSIsConsume_GetListOfConvenios() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        WSEfectorConvenios.Response responseToAssert = WSEfectorConvenios.getConvenios('700047');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        
    }

    @IsTest
    private static void whenTheWSIsConsume_consumeWSEfector_returnEmptyMessage(){
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        WSEfectorConvenios.Response responseToAssert = WSEfectorConvenios.getConvenios('123');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals(0, responseToAssert.convenios.data.size());
    }

	@IsTest
    private static void whenTheWSIsConsume_consumeWSEfector_returnErrorMessage(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        WSEfectorConvenios.Response responseToAssert = WSEfectorConvenios.getConvenios('');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
        System.assertEquals('Not Found', responseToAssert.response.getStatus());
        System.assertEquals(null, responseToAssert.convenios);
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
                .withBody(WSEfectorConveniosMock.getFound())
                .addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700047');


        getEmptyResponse = new XHttpCalloutMock();
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEfectorConveniosMock.getEmpty())
                .addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/123');

		getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSEfectorConveniosMock.getError())
                .addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/');
    }

}