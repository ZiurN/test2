@IsTest
private class AsociadoConstanciaProvCtrlTest  {

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
	private static void whenConstanciaProvisoriaIsRequested_ShouldAttachPDF(){
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Case caso = new Case();
		insert caso;

		Test.startTest();
		AsociadoConstanciaProvCtrl.Response resp = AsociadoConstanciaProvCtrl.getConstanciaProvisoria(caso.Id,'202637-15');
		Test.stopTest();

		ContentDocumentLink[] link = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id];

		System.assertEquals(resp.hasError, false);
		System.assertEquals(1, link.size());
	}

	@IsTest
	private static void whenConstanciaProvisoriaIsRequestedWithIncorrectData_ShouldNotAttachPDF(){
		Test.setMock(HttpCalloutMock.class,getErrorResponse);
		Case caso = new Case();
		insert caso;

		Test.startTest();
		AsociadoConstanciaProvCtrl.Response resp = AsociadoConstanciaProvCtrl.getConstanciaProvisoria(caso.Id,'0000-00');
		Test.stopTest();

		ContentDocumentLink[] link = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id];

		System.assertEquals(resp.hasError, true);
		System.assertEquals(0, link.size());
	}
}