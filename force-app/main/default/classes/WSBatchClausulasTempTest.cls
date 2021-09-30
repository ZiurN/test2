@isTest 
private class WSBatchClausulasTempTest {
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
			.withBody(WSBatchClausulasTempMock.getFound())
			.addForAddress(WSBatchClausulasTemp.SERVICE_CONFIG.URL__c + '/v1/salud/batch/clausulas-temporarias/2019-01-01?pageSize=15&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSBatchClausulasTempMock.getError())
			.addForAddress(WSBatchClausulasTemp.SERVICE_CONFIG.URL__c + '/v1/salud/batch/clausulas-temporarias/');
	}

	@IsTest
	private static void whenTheWSIsConsume_GetListOfClausulasTemporales() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSBatchClausulasTemp.Response responseToAssert = WSBatchClausulasTemp.getBatchClausulasTemp('2019-01-01', 15, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(2, responseToAssert.result.data.size());
		
		System.assertEquals('1', responseToAssert.result.data[0].rn);
		System.assertEquals('51692/10', responseToAssert.result.data[0].codigo);
		System.assertEquals('PMI_MADRE', responseToAssert.result.data[0].tacta_codigo);
		System.assertEquals('2020-05-01 00:00:00', responseToAssert.result.data[0].fecha_vigencia_desde);
		System.assertEquals('2020-11-30 00:00:00', responseToAssert.result.data[0].fecha_vigencia_hasta);
		System.assertEquals('Z34', responseToAssert.result.data[0].diag_codigo);
		System.assertEquals(null, responseToAssert.result.data[0].observaciones);
		System.assertEquals('2020-05-01 00:00:00', responseToAssert.result.data[0].fecha_fum);
		System.assertEquals('2020-05-31 00:00:00', responseToAssert.result.data[0].fecha_pp);
		System.assertEquals('48574', responseToAssert.result.data[0].acta_id);
		
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
}