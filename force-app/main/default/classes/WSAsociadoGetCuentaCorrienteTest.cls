@IsTest
public class WSAsociadoGetCuentaCorrienteTest  {
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
			.withBody(WSAsociadoGetCuentaCorrienteMock.getFound())
			.addForAddress(WSAsociadoGetCuentaCorriente.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/473981');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetCuentaCorrienteMock.getError())
			.addForAddress(WSAsociadoGetCuentaCorriente.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/0');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfCuentaCorrienteOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetCuentaCorriente.Response responseToAssert = WSAsociadoGetCuentaCorriente.getAsociadoCuentaCorriente('473981');
		Test.stopTest();

		System.debug('*****responseToAssert*****: ' + responseToAssert);
		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		//System.assertEquals(1, responseToAssert.asociadoCuentaCorriente.data.detallesAfi.size());
		System.assertEquals('10/05/2019', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].comprobante);
		System.assertEquals('23162069', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].id);
		System.assertEquals('1', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].cuota);
		System.assertEquals('130.86', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].importe);
		System.assertEquals('B', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].letra);
		System.assertEquals('51', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].movimiento);
		System.assertEquals('01566119', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].numero);
		System.assertEquals('130.86', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].saldo);
		System.assertEquals('0022', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].sucursal);
		System.assertEquals('FA', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].tipo);
		System.assertEquals('10/06/2019', responseToAssert.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[0].vencimiento);
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