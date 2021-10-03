@IsTest
public class LoteOrdenReintegroBtnCtrlTest  {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmptyListResponse;

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
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSLoteOrdenReintegroMock.getError())
			.addForAddress(WSLoteOrdenReintegro.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/0/ordenes-reintegros');
	}

	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSLoteOrdenReintegroSucess_returnAListOfOrdenesReintegros(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		LoteOrdenReintegroBtnCtrl.Response responseToAssert = LoteOrdenReintegroBtnCtrl.getOrdenReintegro('5381');
		Test.stopTest();

        System.assertEquals('', responseToAssert.message);
        System.assertEquals('5381', responseToAssert.lote[0].lr_id);
		System.assertEquals('229937/39', responseToAssert.lote[0].codigo);
		System.assertEquals('QUIROGA SEEWALD NERINA', responseToAssert.lote[0].afi_nom);
		System.assertEquals('651075', responseToAssert.lote[0].orei_id);
		System.assertEquals('395011', responseToAssert.lote[0].orden_pago);
		System.assertEquals('CR-----E', responseToAssert.lote[0].estado);
		System.assertEquals('ORDEN EMITIDA', responseToAssert.lote[0].nombre_estado);
		System.assertEquals('0', responseToAssert.lote[0].importe);
		System.assertEquals('SEEWALD, NERINA ANAHI', responseToAssert.lote[0].nombre_destinatario);
		System.assertEquals('REEF---C', responseToAssert.lote[0].est_financiero);
		System.assertEquals('CONTABILIZADO', responseToAssert.lote[0].estado_financiero);
		System.assertEquals(1, responseToAssert.lote[0].reintegros.size());
	}

	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSLoteOrdenReintegroError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);

		Test.startTest();
		LoteOrdenReintegroBtnCtrl.Response responseToAssert = LoteOrdenReintegroBtnCtrl.getOrdenReintegro('5381');
		Test.stopTest();

		System.assertEquals('El lote solicitado es inválido.', responseToAssert.message);
		System.assertEquals(null, responseToAssert.lote);
	}

}