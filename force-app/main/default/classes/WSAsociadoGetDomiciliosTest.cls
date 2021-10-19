@IsTest
public class WSAsociadoGetDomiciliosTest  {
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
			.withBody(WSAsociadoGetDomiciliosMock.getFound())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/domicilios/191670');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDomiciliosMock.getError())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/domicilios/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfDomiciliosOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetDomicilios.Response responseToAssert = WSAsociadoGetDomicilios.getAsociadoDomicilios('191670');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(1, responseToAssert.asociadoDomicilios.data.size());
		System.assertEquals('COM', responseToAssert.asociadoDomicilios.data[0].tipo_domicilio);
		System.assertEquals('ZONA RURAL', responseToAssert.asociadoDomicilios.data[0].calle);
		System.assertEquals(null, responseToAssert.asociadoDomicilios.data[0].piso);
		System.assertEquals(null, responseToAssert.asociadoDomicilios.data[0].dpto);
		System.assertEquals(null, responseToAssert.asociadoDomicilios.data[0].numero);
		System.assertEquals('2743ARY', responseToAssert.asociadoDomicilios.data[0].codigo_postal);
		System.assertEquals('ARROYO DULCE', responseToAssert.asociadoDomicilios.data[0].localidad);
		System.assertEquals('BUENOS AIRES', responseToAssert.asociadoDomicilios.data[0].provincia);
		System.assertEquals('ARGENTINA', responseToAssert.asociadoDomicilios.data[0].pais);
		System.assertEquals('TEL', responseToAssert.asociadoDomicilios.data[0].telefonos[0].tipo_telefono);
		System.assertEquals('02395-454173', responseToAssert.asociadoDomicilios.data[0].telefonos[0].numero);
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