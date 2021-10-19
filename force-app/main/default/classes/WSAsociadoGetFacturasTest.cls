@IsTest
public class WSAsociadoGetFacturasTest  {
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
			.withBody(WSAsociadoGetFacturasMock.getFound())
			.addForAddress(WSAsociadoGetFacturas.SERVICE_CONFIG.URL__c + '/v1/salud/facturas/446378');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetFacturasMock.getError())
			.addForAddress(WSAsociadoGetFacturas.SERVICE_CONFIG.URL__c + '/v1/salud/facturas/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfFacturasOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetFacturas.Response responseToAssert = WSAsociadoGetFacturas.getAsociadoFacturas('446378');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.debug(responseToAssert.asociadoFacturas.data.size());
		System.assertEquals(12, responseToAssert.asociadoFacturas.data.size());
		System.assertEquals('2019-06-21', responseToAssert.asociadoFacturas.data[0].fecha_factura);
		System.assertEquals('2019-07-10', responseToAssert.asociadoFacturas.data[0].fecha_vto);
		System.assertEquals('10207.72', responseToAssert.asociadoFacturas.data[0].importe);
		System.assertEquals('http://www.extranet.acasalud.com.ar/SF/23433905.pdf', responseToAssert.asociadoFacturas.data[0].link_pdf);
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