@IsTest
public class WSAsociadoGetDatosAdicionalesTest  {
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
			.withBody(WSAsociadoGetDatosAdicionalesMock.getFound())
			.addForAddress(WSAsociadoGetDatosAdicionales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-adicionales/458495');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDatosAdicionalesMock.getError())
			.addForAddress(WSAsociadoGetDatosAdicionales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-adicionales/0');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfDatosAdicionalesOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetDatosAdicionales.Response responseToAssert = WSAsociadoGetDatosAdicionales.getAsociadoDatosAdicionales('458495');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(4, responseToAssert.asociadoDatosAdicionales.data.size());
		System.assertEquals('SC', responseToAssert.asociadoDatosAdicionales.data[0].codigo);
		System.assertEquals('SOCIO DE COOPERATIVA', responseToAssert.asociadoDatosAdicionales.data[0].nombre);
		System.assertEquals('F', responseToAssert.asociadoDatosAdicionales.data[0].valor);
		System.assertEquals(null, responseToAssert.asociadoDatosAdicionales.data[0].observaciones);
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