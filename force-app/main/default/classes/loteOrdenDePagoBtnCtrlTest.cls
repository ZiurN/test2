@IsTest
public class loteOrdenDePagoBtnCtrlTest {
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
			.withBody(WSLoteOrdenDePagoMock.getFound())
			.addForAddress(WSLoteOrdenDePago.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5381/ordenes-pago');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSLoteOrdenDePagoMock.getError())
			.addForAddress(WSLoteOrdenDePago.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/0/ordenes-pago');
	}
	
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSLoteOrdenDePagoSucess_returnAListOfClausulasPlan(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		loteOrdenDePagoBtnCtrl.Response responseToAssert = loteOrdenDePagoBtnCtrl.getOrdenesDePago('5381');
		Test.stopTest();
		
        System.assert(!responseToAssert.hasError);
        System.assertEquals('', responseToAssert.message);
        System.assertEquals('5381', responseToAssert.ordenesDePago[0].lote);
        System.assertEquals('395011', responseToAssert.ordenesDePago[0].opr_id);
        System.assertEquals('SEEWALD, NERINA ANAHI', responseToAssert.ordenesDePago[0].nombre_destinatario);
        System.assertEquals('REEF---F', responseToAssert.ordenesDePago[0].estado);
        System.assertEquals('INTERFACE', responseToAssert.ordenesDePago[0].nombre_estado);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSLoteOrdenDePagoError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		loteOrdenDePagoBtnCtrl.Response responseToAssert = loteOrdenDePagoBtnCtrl.getOrdenesDePago('0');
		Test.stopTest();
        
		System.assert(responseToAssert.hasError);
		System.assertEquals('El lote solicitado es inválido.', responseToAssert.message);
		System.assertEquals(null, responseToAssert.ordenesDePago);
	}

}