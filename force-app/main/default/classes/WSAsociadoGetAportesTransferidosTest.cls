@IsTest
public class WSAsociadoGetAportesTransferidosTest  {
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
			.withBody(WSAsociadoGetAportesTransferidosMock.getFound())
			.addForAddress(WSAsociadoGetAportesTransferidos.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-transferidos/70107-14');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetAportesTransferidosMock.getError())
			.addForAddress(WSAsociadoGetAportesTransferidos.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-transferidos/0');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfAportesTransferidosOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetAportesTransferidos.Response responseToAssert = WSAsociadoGetAportesTransferidos.getAsociadoAportesTransferidos('70107-14');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(1, responseToAssert.asociadoAportesTransferidos.data.size());
		System.assertEquals('2002-12-01', responseToAssert.asociadoAportesTransferidos.data[0].periodo);
		System.assertEquals('33533717999', responseToAssert.asociadoAportesTransferidos.data[0].cuit);
		System.assertEquals('600055', responseToAssert.asociadoAportesTransferidos.data[0].empleador);
		System.assertEquals('COOP. AGROP. DE ARMSTRONG LTDA.', responseToAssert.asociadoAportesTransferidos.data[0].nombre_empleador);
		System.assertEquals('640008', responseToAssert.asociadoAportesTransferidos.data[0].cod_ooss);
		System.assertEquals('O.S.P.ACA', responseToAssert.asociadoAportesTransferidos.data[0].nombre_ooss);
		System.assertEquals('MAN', responseToAssert.asociadoAportesTransferidos.data[0].origen_aporte);
		System.assertEquals('504.33', responseToAssert.asociadoAportesTransferidos.data[0].aporte);
		System.assertEquals('0', responseToAssert.asociadoAportesTransferidos.data[0].aporte_reconocido);
		System.assertEquals('0', responseToAssert.asociadoAportesTransferidos.data[0].aporte_derivado);
		System.assertEquals('0', responseToAssert.asociadoAportesTransferidos.data[0].subsidio);
		System.assertEquals('0', responseToAssert.asociadoAportesTransferidos.data[0].secuencia);
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