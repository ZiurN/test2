@isTest
private class WSAsociadoScoreTest {
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
			.withBody(WSAsociadoScoreMock.getFound())
			.addForAddress(WSAsociadoScore.SERVICE_CONFIG.URL__c + '/v1/salud/score/202637-15');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoScoreMock.getError())
            .addForAddress(WSAsociadoScore.SERVICE_CONFIG.URL__c + '/v1/salud/score/0');
    }

    @IsTest
	private static void whenTheWSIsConsume_getResponse(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Account acc = Build.anAccount().build();
        acc.Codigo_de_Afiliado__c = '202637/15';
        insert acc;

		Test.startTest();
		WSAsociadoScore.Response responseToAssert = WSAsociadoScore.enviarCuenta(acc.Codigo_de_Afiliado__c);
        Test.stopTest();
        
        System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals('-886034.17', responseToAssert.result.data.indice_rentabilidad);
		System.assertEquals('ROJO', responseToAssert.result.data.color);
    }


    @IsTest
	private static void whenTheWSIsConsume_getError(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Account acc = Build.anAccount().build();
        acc.Codigo_de_Afiliado__c = '0';
        insert acc;

		Test.startTest();
		WSAsociadoScore.Response responseToAssert = WSAsociadoScore.enviarCuenta(acc.Codigo_de_Afiliado__c);
        Test.stopTest();
        
        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
    }

}