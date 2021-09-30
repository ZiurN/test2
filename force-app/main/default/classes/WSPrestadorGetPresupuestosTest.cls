@IsTest
public class WSPrestadorGetPresupuestosTest  {
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
			.withBody(WSPrestadorGetPresupuestosMock.getFound())
			.addForAddress(WSPrestadorGetPresupuestos.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presupuestos/700076');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSPrestadorGetPresupuestosMock.getError())
			.addForAddress(WSPrestadorGetPresupuestos.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presupuestos/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfPresupuestosOfPrestador(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSPrestadorGetPresupuestos.Response responseToAssert = WSPrestadorGetPresupuestos.getPrestadorPresupuesto(700076);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(3, responseToAssert.prestadorPresupuestos.data.size());
		System.assertEquals('2019-01-31', responseToAssert.prestadorPresupuestos.data[0].fecha);
		System.assertEquals('700076_p_20190131.pdf', responseToAssert.prestadorPresupuestos.data[0].nombre_arch);
		System.assertEquals('Presup. Discectomia y Artrodesis Instrumentada af 39573-10', responseToAssert.prestadorPresupuestos.data[0].descripcion);
		System.assertEquals('https://acaiasnew.acasalud.com.ar/dd_convenios/700076_p_20190131.pdf', responseToAssert.prestadorPresupuestos.data[0].p_link);
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