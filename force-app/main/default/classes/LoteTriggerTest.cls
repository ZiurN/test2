@isTest 
private class LoteTriggerTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseError;

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
			.withBody(WSLoteEnviarASSMock.getFound())
			.addForAddress(WSLoteEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes');
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSLoteEnviarASSMock.getError())
			.addForAddress(WSLoteEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes');
		
	}

	@isTest
	private static void whenALoteIsCreatedWithValidFields_ItShouldSendToSSAndFillTheCorrespondingFields() {
		Lote__c lote = new Lote__c(Fecha__c = Date.today(),Emision__c='S',Observaciones__c='Sin obs');
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		insert lote;
		Test.stopTest();

		lote = [SELECT Id_lote_SS__c, Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals('5400', lote.Id_lote_SS__c);
		System.assertEquals('A', lote.Estado__c);
	}


	@isTest
	private static void whenALoteIsCreatedWithInvalidFields_ItShouldFailsSendToSSAndFillTheCorrespondingFields() {
		Lote__c lote = new Lote__c(Fecha__c = Date.today().addDays(-5),Emision__c='S',Observaciones__c='Sin obs');
		Test.setMock(HttpCalloutMock.class, getResponseError);

		Test.startTest();
		insert lote;
		Test.stopTest();

		lote = [
			SELECT Id_lote_SS__c, Estado__c, Fallo_en_SS__c, Fecha_de_fallo__c
			FROM Lote__c 
			WHERE Id = :lote.Id
		];

		System.assertEquals(null, lote.Id_lote_SS__c);
		System.assertEquals('A', lote.Estado__c);
		System.assertNotEquals(null, lote.Fallo_en_SS__c);
		System.assertNotEquals(null, lote.Fecha_de_fallo__c);
	}
}