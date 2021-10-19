@isTest 
private class WSAsociadoFacturaElectronicaTest {
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
			.withBody(WSAsociadoFacturaElectronicaMock.getFound())
			.addForAddress(WSAsociadoFacturaElectronica.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/477443/factura-electronica');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoFacturaElectronicaMock.getError())
			.addForAddress(WSAsociadoFacturaElectronica.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/477443/factura-electronica');

		body = '{ "adherido": "S" }';
	}

	@isTest
	private static void updateFacturaElectronicaSuccess() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		String msg = 'Se actualizó la información de FE del socio.';

		Test.startTest();
		WSAsociadoFacturaElectronica.Response resp = WSAsociadoFacturaElectronica.updateFacturaElectronica('477443', body);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
	}

	@isTest
	private static void updateFacturaElectronicaError() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		String msg = 'No se pudo actualizar la información de FE del socio. DATO INGRESADO IGUAL AL ACTUAL.';

		Test.startTest();
		WSAsociadoFacturaElectronica.Response resp = WSAsociadoFacturaElectronica.updateFacturaElectronica('477443', body);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals(msg, resp.message);
	}
}