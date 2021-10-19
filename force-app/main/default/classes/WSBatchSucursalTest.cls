@IsTest
public class WSBatchSucursalTest  {
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
			.withBody(WSBatchSucursalMock.getFound())
			.addForAddress(WSBatchSucursal.SERVICE_CONFIG.URL__c + '/v1/salud/batch/sucursales-empresas/10-01-2020?pageSize=1&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSBatchSucursalMock.getError())
			.addForAddress(WSBatchSucursal.SERVICE_CONFIG.URL__c + '/v1/salud/batch/sucursales-empresas/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfSucursals(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSBatchSucursal.Response responseToAssert = WSBatchSucursal.getBatchSucursal('10-01-2020', 1, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(1, responseToAssert.sucursal.data.size());
		System.assertEquals('600001', responseToAssert.sucursal.data[0].empl_empl_id);
		System.assertEquals('A.C.A. ASOC.COOPERATIVAS ARGENTINAS', responseToAssert.sucursal.data[0].nombre);
		System.assertEquals('1', responseToAssert.sucursal.data[0].codigo_suc);
		System.assertEquals('A.C.A. ASOC.COOPERATIVAS ARGEN', responseToAssert.sucursal.data[0].descripcion);
		System.assertEquals('1900-01-01 00:00:00', responseToAssert.sucursal.data[0].fecha_activacion);
		System.assertEquals('A', responseToAssert.sucursal.data[0].estado_sucursal);
		System.assertEquals(null, responseToAssert.sucursal.data[0].email);
		System.assertEquals(null, responseToAssert.sucursal.data[0].observaciones);
		System.assertEquals('F', responseToAssert.sucursal.data[0].es_sujeto_facturacion);
		System.assertEquals('2914/1', responseToAssert.sucursal.data[0].referencia_externa);
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