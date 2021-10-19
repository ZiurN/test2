@isTest 
private class DiagnosticoDelEventoTriggerTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseError;
	static Diagnostico_del_Evento__c diagnosticoEvento;
    static Diagnostico__c diagnostico;
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
			.withBody(WSDiagnosticoDelEventoEnviarMock.getFound())
			.addForAddress(WSDiagnosticoDelEventoEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/diagnosticos');
		
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSDiagnosticoDelEventoEnviarMock.getError())
			.addForAddress(WSDiagnosticoDelEventoEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/diagnosticos');

		em = new Evento_medico__c();
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		em.Nro_de_Evento_Medico_SS__c = '276349';
		insert em;

		diagnosticoEvento = new Diagnostico_del_Evento__c();
		diagnosticoEvento.Evento_medico__c = em.Id;
	}

	@isTest private static void whenADiagnosticoDelEventoIsInsertedAndEMIsInSS_ItShouldBeSendedToSS() {
        diagnosticoEvento.Fecha__c = Date.newInstance(2020, 2, 26);
        diagnosticoEvento.Tipo__c = 'DEFINITIVO';

		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		insert diagnosticoEvento;
		Test.stopTest();

		diagnosticoEvento = [
			SELECT Error_en_SS__c 
            FROM Diagnostico_del_Evento__c 
            WHERE Id =: diagnosticoEvento.Id
		];

		System.assertEquals(null, diagnosticoEvento.Error_en_SS__c);
	}

    @isTest private static void whenADiagnosticoDelEventoIsInsertedWithoutAllRequiredFields_WSShouldReturnAnErrorOnTheResponse() {
        diagnosticoEvento.Tipo__c = 'DEFINITIVO';

		Test.setMock(HttpCalloutMock.class, getResponseError);
		Test.startTest();
		insert diagnosticoEvento;
		Test.stopTest();

		diagnosticoEvento = [
			SELECT Error_en_SS__c 
            FROM Diagnostico_del_Evento__c 
            WHERE Id =: diagnosticoEvento.Id
		];

        System.assertNotEquals(null, diagnosticoEvento.Error_en_SS__c);
    }
}