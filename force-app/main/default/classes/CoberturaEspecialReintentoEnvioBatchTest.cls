@isTest 
private class CoberturaEspecialReintentoEnvioBatchTest {
	
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseError;
	static Cobertura_Especial__c cobertura;
	static Evento_medico__c em;

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
			.withBody(WSCoberturaEspecialEnviarMock.getFound())
			.addForAddress(WSCoberturaEspecialEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/coberturas-especiales');
		
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSCoberturaEspecialEnviarMock.getError())
			.addForAddress(WSCoberturaEspecialEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/coberturas-especiales');
	
	}

	@TestSetup
	private static void setup(){
		Test.setMock(HttpCalloutMock.class, getResponseError);

		em = new Evento_medico__c();
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		em.Nro_de_Evento_Medico_SS__c = '276349';
		insert em;

		Test.startTest();
		cobertura = new Cobertura_Especial__c();
		cobertura.Evento_Medico_de_Seguimiento__c = em.Id;
		cobertura.Fecha_desde__c = Date.today().addDays(-7);
		insert cobertura;
		Test.stopTest();
	}

	@isTest
	private static void whenACoberturaIsCreatedWithInValidFields_ItShouldReSendToSSAndFillTheCorrespondingFields() {
	
		cobertura = [
			SELECT Error_en_SS__c, Fecha_de_error_en_SS__c, Id_externo__c FROM Cobertura_Especial__c LIMIT 1
		];

		System.assertEquals(null, cobertura.Id_externo__c);
		System.assertNotEquals(null, cobertura.Error_en_SS__c);
		System.assertNotEquals(null, cobertura.Fecha_de_error_en_SS__c);
		
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		Database.executeBatch(new CoberturaEspecialReintentoEnvioASSBatch());
		Test.stopTest();

		cobertura = [
			SELECT Error_en_SS__c, Fecha_de_error_en_SS__c, Id_externo__c FROM Cobertura_Especial__c WHERE Id =: cobertura.Id
		];

		System.assertEquals('191769', cobertura.Id_externo__c);
		System.assertEquals(null, cobertura.Error_en_SS__c);
		System.assertEquals(null, cobertura.Fecha_de_error_en_SS__c);
	}
}