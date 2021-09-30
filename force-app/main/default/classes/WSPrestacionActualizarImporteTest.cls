@isTest
public class WSPrestacionActualizarImporteTest {
    static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static String body;

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
			.withBody(WSPrestacionActualizarImporteMock.getFound())
			.addForAddress(WSPrestacionActualizarImporte.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/' + 553277 + '/prestaciones/' + 74043157 + '/importe');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSPrestacionActualizarImporteMock.getError())
			.addForAddress(WSPrestacionActualizarImporte.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/' + 553277 + '/prestaciones/' + 74043157 + '/importe');

		body = '{' +
					'"importe_reintegro": 1000,' +
					'"importe_socio": 500,' +
				'}';
	}
	
	@IsTest
	private static void whenTheWSIsConsume_getPrestaciones(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSPrestacionActualizarImporte.Response responseToAssert = WSPrestacionActualizarImporte.sendImporteToSS(body, '553277', '74043157');
		Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals('74043157', responseToAssert.prestacion.data[0].pca_id);
		System.assertEquals('Ambulatorio', responseToAssert.prestacion.data[0].contexto);
		System.assertEquals('1', responseToAssert.prestacion.data[0].cantidad);
		System.assertEquals('02170101', responseToAssert.prestacion.data[0].prestacion);
		System.assertEquals('500', responseToAssert.prestacion.data[0].importe_cargo_al_socio_aud);
		System.assertEquals('1000', responseToAssert.prestacion.data[0].importe_rein_aud);
		
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