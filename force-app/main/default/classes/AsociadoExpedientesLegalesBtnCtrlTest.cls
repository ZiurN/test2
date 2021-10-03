@isTest 
private class AsociadoExpedientesLegalesBtnCtrlTest {

	static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
	static Account asociado;

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
                .withBody(WSAsociadoExpedientesLegalesMock.getFound())
                .addForAddress(WSAsociadoExpedientesLegales.SERVICE_CONFIG.URL__c + '/v1/salud/socio-legal/185415');		

		getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(400)
                .withBody(WSAsociadoExpedientesLegalesMock.getError())
                .addForAddress(WSAsociadoExpedientesLegales.SERVICE_CONFIG.URL__c + '/v1/salud/socio-legal/185415');		

		asociado = Build.anAccountCuentapersonal().build();
		asociado.Afi_Id__c = '185415';
		insert asociado;    

	}

    @IsTest
    private static void whenClickTheButton_updateCheckExpediente() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        
        Test.startTest();
        AsociadoExpedientesLegalesBtnCtrl.Response resp = AsociadoExpedientesLegalesBtnCtrl.updateCheckExpediente(asociado.Id);
        Test.stopTest();

		asociado = [SELECT Id, Contiene_expediente_legal__c FROM Account WHERE Id =: asociado.Id];

        System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
		System.assertEquals(true, asociado.Contiene_expediente_legal__c);
    }

	@IsTest
    private static void whenClickTheButton_showErrorMsgFromWS() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        
        Test.startTest();
        AsociadoExpedientesLegalesBtnCtrl.Response resp = AsociadoExpedientesLegalesBtnCtrl.updateCheckExpediente(asociado.Id);
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
		System.assertEquals('El ID del Afiliado es inválido.', resp.message);
    }

}