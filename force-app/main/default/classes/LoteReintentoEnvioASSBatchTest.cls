@isTest 
private class LoteReintentoEnvioASSBatchTest {
	
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

	@TestSetup
	private static void setup(){
		Test.setMock(HttpCalloutMock.class, getResponseError);
		Test.startTest();
		lote = new Lote__c(Fecha__c = Date.today(),Emision__c='S',Observaciones__c='Sin obs');
		insert lote;
		Test.stopTest();
	}

	@isTest
	private static void whenALoteIsCreatedWithInValidFields_ItShouldReSendToSSAndFillTheCorrespondingFields() {
	
		lote = [SELECT Id_lote_SS__c, Estado__c, Fecha_de_fallo__c, Fallo_en_SS__c FROM Lote__c LIMIT 1];

		System.assertEquals(null, lote.Id_lote_SS__c);
		System.assertEquals('A', lote.Estado__c);
		System.assertNotEquals(null,lote.Fecha_de_fallo__c);
		System.assertNotEquals(null,lote.Fallo_en_SS__c);
		
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		
		Database.executeBatch(new LoteReintentoEnvioASSBatch());
		
		Test.stopTest();


		lote = [SELECT Id_lote_SS__c, Estado__c, Fecha_de_fallo__c, Fallo_en_SS__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals('5400', lote.Id_lote_SS__c);
		System.assertEquals('A', lote.Estado__c);
		System.assertEquals(null,lote.Fecha_de_fallo__c);
		System.assertEquals(null,lote.Fallo_en_SS__c);

	}
}