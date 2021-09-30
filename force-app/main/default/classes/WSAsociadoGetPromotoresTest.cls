@IsTest
public class WSAsociadoGetPromotoresTest  {
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
			.withBody(WSAsociadoGetPromotoresMock.getFound())
			.addForAddress(WSAsociadoGetPromotores.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/promotores/140978');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetPromotoresMock.getError())
			.addForAddress(WSAsociadoGetPromotores.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/promotores/0');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfPromotoresOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetPromotores.Response responseToAssert = WSAsociadoGetPromotores.getAsociadoPromotores('140978');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(1, responseToAssert.asociadoPromotores.data.size());
		System.assertEquals('2002-09-01', responseToAssert.asociadoPromotores.data[0].fecha_inicio);
		System.assertEquals(null, responseToAssert.asociadoPromotores.data[0].fecha_fin);
		System.assertEquals('USUARIO', responseToAssert.asociadoPromotores.data[0].usuario);
		System.assertEquals('USUARIO', responseToAssert.asociadoPromotores.data[0].apellidos);
		System.assertEquals('USUARIO', responseToAssert.asociadoPromotores.data[0].nombres);
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