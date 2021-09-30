@IsTest
public class WSAsociadoGetAportesDeclaradosTest  {
	@IsTest
	private static void whenTheWSIsConsume_GetListOfAportesDeclaradosOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		WSAsociadoGetAportesDeclarados.Response responseToAssert = WSAsociadoGetAportesDeclarados.getAsociadoAportesDeclarados('69799-19');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(14, responseToAssert.asociadoAportesDeclarados.data.size());
		System.assertEquals('2018-12-01', responseToAssert.asociadoAportesDeclarados.data[0].periodo);
		System.assertEquals('30604958640', responseToAssert.asociadoAportesDeclarados.data[0].cuit);
		System.assertEquals('600011', responseToAssert.asociadoAportesDeclarados.data[0].empleador);
		System.assertEquals('ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA', responseToAssert.asociadoAportesDeclarados.data[0].nombre);//
		System.assertEquals('101604', responseToAssert.asociadoAportesDeclarados.data[0].obra_social);
		System.assertEquals('640008', responseToAssert.asociadoAportesDeclarados.data[0].codigo_obra_social);
		System.assertEquals('O.S.P.ACA', responseToAssert.asociadoAportesDeclarados.data[0].nombre_obra_social);
		System.assertEquals('EST', responseToAssert.asociadoAportesDeclarados.data[0].origen_aporte);
		System.assertEquals('0', responseToAssert.asociadoAportesDeclarados.data[0].remuneracion);
		System.assertEquals('3850.52', responseToAssert.asociadoAportesDeclarados.data[0].aporte);
		System.assertEquals(null, responseToAssert.asociadoAportesDeclarados.data[0].aporte_reconocido);
		System.assertEquals('3657.99', responseToAssert.asociadoAportesDeclarados.data[0].aporte_derivado);
		System.assertEquals('0', responseToAssert.asociadoAportesDeclarados.data[0].secuencia);
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		WSAsociadoGetAportesDeclarados.Response responseToAssert = WSAsociadoGetAportesDeclarados.getAsociadoAportesDeclarados('69799-19');
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('Not Found', responseToAssert.response.getStatus());
		System.assertEquals(null, responseToAssert.asociadoAportesDeclarados);
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
			.withBody(WSAsociadoGetAportesDeclaradosMock.getFound())
			.addForAddress(WSAsociadoGetAportesDeclarados.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-declarados/69799-19');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetAportesDeclaradosMock.getError())
			.addForAddress(WSAsociadoGetAportesDeclarados.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-declarados/69799-19');
	}
}