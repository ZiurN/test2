@IsTest
public class WSLoteOrdenReintegroTest {
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
			.withBody(WSLoteOrdenReintegroMock.getFound())
			.addForAddress(WSLoteOrdenReintegro.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5381/ordenes-reintegros');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSLoteOrdenReintegroMock.getError())
			.addForAddress(WSLoteOrdenReintegro.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/');
	}

	@IsTest
	private static void whenTheWSIsConsume_GetListOfOrdenOfReintegros() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		WSLoteOrdenReintegro.Response responseToAssert = WSLoteOrdenReintegro.getOrdenReintegro('5381');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(2, responseToAssert.lote.data.size());
		System.assertEquals('5381', responseToAssert.lote.data[0].lr_id);
		System.assertEquals('229937/39', responseToAssert.lote.data[0].codigo);
		System.assertEquals('QUIROGA SEEWALD NERINA', responseToAssert.lote.data[0].afi_nom);
		System.assertEquals('651075', responseToAssert.lote.data[0].orei_id);
		System.assertEquals('395011', responseToAssert.lote.data[0].orden_pago);
		System.assertEquals('CR-----E', responseToAssert.lote.data[0].estado);
		System.assertEquals('ORDEN EMITIDA', responseToAssert.lote.data[0].nombre_estado);
		System.assertEquals('0', responseToAssert.lote.data[0].importe);
		System.assertEquals('SEEWALD, NERINA ANAHI', responseToAssert.lote.data[0].nombre_destinatario);
		System.assertEquals('REEF---C', responseToAssert.lote.data[0].est_financiero);
		System.assertEquals('CONTABILIZADO', responseToAssert.lote.data[0].estado_financiero);
		System.assertEquals(1, responseToAssert.lote.data[0].reintegros.size());
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