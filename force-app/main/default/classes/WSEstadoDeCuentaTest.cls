@isTest
private class WSEstadoDeCuentaTest {
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
			.withBody(WSEstadoDeCuentaMock.getFound())
			.addForAddress(WSEstadoDeCuenta.SERVICE_CONFIG.URL__c + '/v1/salud/semaforo/458495');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSEstadoDeCuentaMock.getError())
            .addForAddress(WSEstadoDeCuenta.SERVICE_CONFIG.URL__c + '/v1/salud/semaforo/0');
    }

    @IsTest
	private static void whenTheWSIsConsume_getResponse(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Account acc = Build.anAccount().build();
        acc.Afi_Id__C  = '458495';
        insert acc;

		Test.startTest();
		WSEstadoDeCuenta.Response responseToAssert = WSEstadoDeCuenta.getEstado(acc.Afi_Id__C );
        Test.stopTest();
        
        System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals('VERDE', responseToAssert.result.data.estado_cuenta);
    }


    @IsTest
	private static void whenTheWSIsConsume_getError(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Account acc = Build.anAccount().build();
        acc.Afi_Id__C = '0';
        insert acc;

        Test.startTest();
		WSEstadoDeCuenta.Response responseToAssert = WSEstadoDeCuenta.getEstado(acc.Afi_Id__C );
        Test.stopTest();
        
        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
    }

}