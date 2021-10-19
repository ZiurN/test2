@IsTest
public class WSAsociadoGetClausulasPlanTest  {
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
			.withBody(WSAsociadoGetClausulasPlanMock.getFound())
			.addForAddress(WSAsociadoGetClausulasPlan.SERVICE_CONFIG.URL__c + '/v1/salud/clausulas/plan/140983/7');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetClausulasPlanMock.getError())
			.addForAddress(WSAsociadoGetClausulasPlan.SERVICE_CONFIG.URL__c + '/v1/salud/clausulas/plan/140983');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfClausulasPlanOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetClausulasPlan.Response responseToAssert = WSAsociadoGetClausulasPlan.getAsociadoClausulasPlan('140983', '7');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(14, responseToAssert.asociadoClausulasPlan.data.size());
		System.assertEquals('BAS', responseToAssert.asociadoClausulasPlan.data[0].codigo);
		System.assertEquals('CUOTA BASICA', responseToAssert.asociadoClausulasPlan.data[0].nombre);
		System.assertEquals('Base', responseToAssert.asociadoClausulasPlan.data[0].caracteristica);
		System.assertEquals('V', responseToAssert.asociadoClausulasPlan.data[0].contratada);
		System.assertEquals('F', responseToAssert.asociadoClausulasPlan.data[0].informa);
		System.assertEquals('V', responseToAssert.asociadoClausulasPlan.data[0].bonificable);
		System.assertEquals('Permanente', responseToAssert.asociadoClausulasPlan.data[0].permanente);
		System.assertEquals('1900-01-01', responseToAssert.asociadoClausulasPlan.data[0].fecha_vigencia_desde);
		System.assertEquals(null, responseToAssert.asociadoClausulasPlan.data[0].fecha_vigencia_hasta);
		
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