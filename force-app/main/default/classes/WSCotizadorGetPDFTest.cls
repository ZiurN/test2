@IsTest
private class WSCotizadorGetPDFTest  {
	
	static XHttpCalloutMock responseFound;
	static XHttpCalloutMock responseError;

	static{
		responseFound = new XHttpCalloutMock();
        responseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        responseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCotizadorGetPDFMock.getResponseFound())
                .addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/cotizaciones/print/731');


        responseError = new XHttpCalloutMock();
        responseError.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        responseError.buildResponse()
                .withStatus('Invalid data')
                .withStatusCode(404)
                .withBody(WSCotizadorGetPDFMock.getResponseError())
                .addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/cotizaciones/print/1');
	}

	@IsTest
	private static void getBase64WithValidId(){
		Test.setMock(HttpCalloutMock.class, responseFound);

		Test.startTest();
		WSCotizadorGetPDF.Response res = WSCotizadorGetPDF.getPDF('731');
		Test.stopTest();

		System.assertEquals(false, res.hasError);
		System.assertNotEquals(null, res.cotizacion.data.base_64);
	}

	@IsTest
	private static void getBase64WithInValidId(){
		Test.setMock(HttpCalloutMock.class, responseError);

		Test.startTest();
		WSCotizadorGetPDF.Response res = WSCotizadorGetPDF.getPDF('1');
		Test.stopTest();

		System.assertEquals(true, res.hasError);
		System.assertEquals(null, res.cotizacion);
	}

}