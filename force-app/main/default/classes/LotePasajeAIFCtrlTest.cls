@isTest 
private class LotePasajeAIFCtrlTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseError;
	static Lote__c lote;

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
			.withBody(WSLotePasajeAIFMock.getFound())
			.addForAddress(WSLotePasajeAIF.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5406/pasaje-if');
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSLotePasajeAIFMock.getError())
			.addForAddress(WSLotePasajeAIF.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5500/pasaje-if');
		
	}


	@TestSetup
	private static void setup(){
		Test.startTest();
		lote = new Lote__c(Id_lote_SS__c='5406',Estado__c = 'A');
		insert lote;
		Test.stopTest();
	}


	@isTest
	private static void sendLoteToSSAndChageEstadoToFinalizado() {
			lote = [SELECT Id,Estado__c, Id_lote_SS__c FROM Lote__c LIMIT 1];
			Test.setMock(HttpCalloutMock.class,getResponseFound);

			Test.startTest();
			LotePasajeAIFCtrl.Response resp = LotePasajeAIFCtrl.changeToIF(lote.Id_lote_SS__c);
			Test.stopTest();

			lote = [SELECT Estado__c FROM Lote__c WHERE Id = : lote.Id];

			System.assertEquals(false, resp.hasError);
			System.assertEquals('Se realizó correctamente el pasaje If.', resp.message);
			System.assertEquals('F', lote.Estado__c);
			System.assertEquals(1, [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId = :lote.Id]);


	}

	@isTest
	private static void sendLoteToSSWithErrorShouldNotChageEstadoToFinalizado() {
		lote = [SELECT Id,Estado__c, Id_lote_SS__c FROM Lote__c LIMIT 1];
			lote.Id_lote_SS__c = '5500';
			update lote;

			Test.setMock(HttpCalloutMock.class,getResponseError);

			Test.startTest();
			LotePasajeAIFCtrl.Response resp = LotePasajeAIFCtrl.changeToIF(lote.Id_lote_SS__c);
			Test.stopTest();

			lote = [SELECT Estado__c FROM Lote__c WHERE Id = : lote.Id];

			System.assertEquals(true, resp.hasError);
			System.assertEquals('El lote solicitado es inválido.', resp.message);
			System.assertEquals('A', lote.Estado__c);


	}
}