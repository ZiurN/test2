@IsTest
public class WSAsociadoGetCredencialesTest  {
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
			.withBody(WSAsociadoGetCredencialesMock.getFound())
			.addForAddress(WSAsociadoGetCredenciales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/140983');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetCredencialesMock.getError())
			.addForAddress(WSAsociadoGetCredenciales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/0');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfCredencialesOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetCredenciales.Response responseToAssert = WSAsociadoGetCredenciales.getAsociadoCredenciales('140983');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(15, responseToAssert.asociadoCredenciales.data.size());
		System.assertEquals('69799/19', responseToAssert.asociadoCredenciales.data[0].codigo);
		System.assertEquals('14', responseToAssert.asociadoCredenciales.data[0].secuencia);
		System.assertEquals('2017-07-01', responseToAssert.asociadoCredenciales.data[0].fecha_vigencia);
		System.assertEquals('2844-12-01', responseToAssert.asociadoCredenciales.data[0].fecha_vencimiento);
		System.assertEquals(null, responseToAssert.asociadoCredenciales.data[0].fecha_baja);
		System.assertEquals('2017-06-05', responseToAssert.asociadoCredenciales.data[0].fecha_emision);
		System.assertEquals('2017-06-05', responseToAssert.asociadoCredenciales.data[0].fecha_generacion);
		System.assertEquals(null, responseToAssert.asociadoCredenciales.data[0].fecha_anulacion);
		System.assertEquals('2017-06-05', responseToAssert.asociadoCredenciales.data[0].fecha_entregada);
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