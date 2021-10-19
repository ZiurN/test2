@isTest
public class WSLoteOrdenDePagoTest {
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
			.withBody(WSLoteOrdenDePagoMock.getFound())
			.addForAddress(WSLoteOrdenDePago.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5381/ordenes-pago');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSLoteOrdenDePagoMock.getError())
			.addForAddress(WSLoteOrdenDePago.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/0/ordenes-pago');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfLoteOrdenDePago(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSLoteOrdenDePago.Response responseToAssert = WSLoteOrdenDePago.getOrdenesDePago('5381');
		Test.stopTest();

        System.assert(!responseToAssert.hasError);
        System.assertEquals('5381', responseToAssert.loteOrdenDePago.data[0].lote);
        System.assertEquals('395011', responseToAssert.loteOrdenDePago.data[0].opr_id);
        System.assertEquals('SEEWALD, NERINA ANAHI', responseToAssert.loteOrdenDePago.data[0].nombre_destinatario);
        System.assertEquals('REEF---F', responseToAssert.loteOrdenDePago.data[0].estado);
        System.assertEquals('INTERFACE', responseToAssert.loteOrdenDePago.data[0].nombre_estado);
		
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