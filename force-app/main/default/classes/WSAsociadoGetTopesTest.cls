@IsTest
public class WSAsociadoGetTopesTest  {
	@IsTest
	private static void whenTheWSIsConsume_GetListOfTopesOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		WSAsociadoGetTopes.Response responseToAssert = WSAsociadoGetTopes.getTopes('140983',Date.valueOf('2019-12-15'));
		Test.stopTest();
		
		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(8, responseToAssert.asociadoTopes.data.size());
		System.assertEquals('ALERGIA TESTIFICACION', responseToAssert.asociadoTopes.data[0].rubro_tope);
		System.assertEquals('TOPE DE 1 POR AÑO', responseToAssert.asociadoTopes.data[0].tope);
		System.assertEquals('CUOTA BASICA', responseToAssert.asociadoTopes.data[0].clausula);
		System.assertEquals('1', responseToAssert.asociadoTopes.data[0].valor_tope);
		System.assertEquals('0', responseToAssert.asociadoTopes.data[0].consumo);
		System.assertEquals('1', responseToAssert.asociadoTopes.data[0].remanente);
		System.assertEquals(null, responseToAssert.asociadoTopes.data[0].valor_red);
		System.assertEquals(null, responseToAssert.asociadoTopes.data[0].remanente_red);
		System.assertEquals(null, responseToAssert.asociadoTopes.data[0].nombre_red);
		System.assertEquals('1500', responseToAssert.asociadoTopes.data[0].tocmpc_id);
		System.assertEquals('M', responseToAssert.asociadoTopes.data[0].tope_id);
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		WSAsociadoGetTopes.Response responseToAssert = WSAsociadoGetTopes.getTopes('140983',Date.valueOf('2019-12-15'));
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('Not Found', responseToAssert.response.getStatus());
		System.assertEquals(null, responseToAssert.asociadoTopes);
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
			.withBody(WSAsociadoGetTopesMock.getFound())
			.addForAddress(WSAsociadoGetTopes.SERVICE_CONFIG.URL__c + '/v1/salud/topes/140983/2019-12-15');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetTopesMock.getError())
			.addForAddress(WSAsociadoGetTopes.SERVICE_CONFIG.URL__c + '/v1/salud/topes/140983/2019-12-15');
	}
}