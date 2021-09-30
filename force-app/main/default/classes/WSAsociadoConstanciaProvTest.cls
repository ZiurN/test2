@IsTest
private class WSAsociadoConstanciaProvTest  {

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
                .withBody(WSAsociadoConstanciaProvMock.getFound())
                .addForAddress(WSAsociadoConstanciaProv.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/constancia-provisoria/202637-15');


        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Invalid data')
                .withStatusCode(404)
                .withBody(WSAsociadoConstanciaProvMock.getError())
                .addForAddress(WSAsociadoConstanciaProv.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/constancia-provisoria/0000-00');
    }

	@IsTest
	private static void whenWSIsConsumed_ShouldReturnAPDFLink(){
		Test.setMock(HttpCalloutMock.class,getResponseFound);

		Test.startTest();
		WSAsociadoConstanciaProv.Response resp = WSAsociadoConstanciaProv.getConstancia('202637-15');
		Test.stopTest();
	
		System.assertEquals(false,resp.hasError);
		System.assertEquals(200, resp.response.getStatusCode());
		System.assertEquals('http://www.extranet.acasalud.com.ar/SF/CREDENCIAL_PROVISORIA_202637.pdf', resp.constancia.data.link);
	}

	@IsTest
	private static void whenWSIsConsumedWithInvalidCode_ShouldReturnAnError(){
		Test.setMock(HttpCalloutMock.class,getErrorResponse);

		Test.startTest();
		WSAsociadoConstanciaProv.Response resp = WSAsociadoConstanciaProv.getConstancia('0000-00');
		Test.stopTest();
	
		System.assertEquals(true,resp.hasError);
		System.assertEquals(404, resp.response.getStatusCode());
	}
}