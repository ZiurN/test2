@isTest
public class WSEfectorGetDetallesPresentacionTest  {
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
			.withBody(WSEfectorGetDetallesPresentacionMock.getFound())
			.addForAddress(WSEfectorGetDetallesPresentacion.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presentaciones/comprobantes/218020757');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSEfectorGetDetallesPresentacionMock.getError())
			.addForAddress(WSEfectorGetDetallesPresentacion.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presentaciones/comprobantes/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfDetallesOfPresentaciones(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSEfectorGetDetallesPresentacion.Response responseToAssert = WSEfectorGetDetallesPresentacion.getEfectorDetallesPresentacion('218020757');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(2, responseToAssert.efectorDetallesPresentacion.data.size());
		System.assertEquals('218020757', responseToAssert.efectorDetallesPresentacion.data[0].pp_pp_id);
		System.assertEquals('772573', responseToAssert.efectorDetallesPresentacion.data[0].cabcp_id);
		System.assertEquals('FACA', responseToAssert.efectorDetallesPresentacion.data[0].tipo);
		System.assertEquals('A-0018-00000301', responseToAssert.efectorDetallesPresentacion.data[0].comprobante);
		System.assertEquals('2018-02-19', responseToAssert.efectorDetallesPresentacion.data[0].fecha_emision);
		System.assertEquals(null, responseToAssert.efectorDetallesPresentacion.data[0].fecha_vencimiento);
		System.assertEquals('333009.69', responseToAssert.efectorDetallesPresentacion.data[0].total);
		System.assertEquals('IF', responseToAssert.efectorDetallesPresentacion.data[0].proceso_contable);
		System.assertEquals('IF', responseToAssert.efectorDetallesPresentacion.data[0].liquidacion);
		System.assertEquals('2018-03-23', responseToAssert.efectorDetallesPresentacion.data[0].fecha_liquidacion);
		System.assertEquals('IF', responseToAssert.efectorDetallesPresentacion.data[0].nota_ajuste);
		System.assertEquals('2018-03-23', responseToAssert.efectorDetallesPresentacion.data[0].fecha_nota_ajuste);
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