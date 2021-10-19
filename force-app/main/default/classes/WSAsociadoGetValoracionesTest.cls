@IsTest
public class WSAsociadoGetValoracionesTest  {
	@IsTest
	private static void whenTheWSIsConsume_GetListOfValoracionesOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		WSAsociadoGetValoraciones.Response responseToAssert = WSAsociadoGetValoraciones.getAsociadoValoraciones('131153', '04-2019');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		
        System.assertEquals(4, responseToAssert.asociadoValoraciones.data.size());

		System.assertEquals('2460.33', responseToAssert.asociadoValoraciones.data[0].Importe);
		System.assertEquals('BAS', responseToAssert.asociadoValoraciones.data[0].Tcc_Codigo);
		System.assertEquals('Cuota Basica', responseToAssert.asociadoValoraciones.data[0].Nombre_Clausula);
		System.assertEquals('1', responseToAssert.asociadoValoraciones.data[0].Cantidad);
		System.assertEquals('1', responseToAssert.asociadoValoraciones.data[0].Coeficiente);
		System.assertEquals('1', responseToAssert.asociadoValoraciones.data[0].Coeficiente_General);
		System.assertEquals('', responseToAssert.asociadoValoraciones.data[0].Cga_codigo);
		System.assertEquals('', responseToAssert.asociadoValoraciones.data[0].Nombre_Cat_Grupal);
		System.assertEquals('PERSONA', responseToAssert.asociadoValoraciones.data[0].Rcg_codigo);
		System.assertEquals('Persona', responseToAssert.asociadoValoraciones.data[0].Nombre_Regla_Adic);
	}
	
	@IsTest
	private static void whenTheWSIsConsume_consumeWSAfiliadoValoraciones_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		WSAsociadoGetValoraciones.Response responseToAssert = WSAsociadoGetValoraciones.getAsociadoValoraciones('131153', '04-2019');
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('Not Found', responseToAssert.response.getStatus());
		System.assertEquals(null, responseToAssert.asociadoValoraciones);
	}

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
			.withBody(WSAsociadoGetValoracionesMock.getFound())
			.addForAddress(WSAsociadoGetValoraciones.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/131153/04-2019');
		
		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetValoracionesMock.getError())
			.addForAddress(WSAsociadoGetValoraciones.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/131153/04-2019');
	}
}