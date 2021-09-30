@IsTest
public class WSAsociadoGetEmpleosTest  {
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
			.withBody(WSAsociadoGetEmpleosMock.getFound())
			.addForAddress(WSAsociadoGetEmpleos.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/empleos/458495');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetEmpleosMock.getError())
			.addForAddress(WSAsociadoGetEmpleos.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/empleos/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfEmpleosOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetEmpleos.Response responseToAssert = WSAsociadoGetEmpleos.getAsociadoEmpleos('458495');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(2, responseToAssert.asociadoEmpleos.data.size());
		System.assertEquals('2016-08-01', responseToAssert.asociadoEmpleos.data[0].fecha_inicio);
		System.assertEquals(null, responseToAssert.asociadoEmpleos.data[0].fecha_fin);
		System.assertEquals('600011', responseToAssert.asociadoEmpleos.data[0].codigo);
		System.assertEquals('ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA', responseToAssert.asociadoEmpleos.data[0].descripcion);
		
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