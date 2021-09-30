@isTest 
private class WSNotaDeAuditoriaEnviarASSTest {

	@isTest
	private static void enviarNotaDeAuditoriaASS() {
		// setup
		Case caso = new Case();
		insert caso;

		Tipo_nota_de_auditoria__c tnda = new Tipo_nota_de_auditoria__c(Codigo_tipoNA__c = 'UnCodigo');
		insert tnda;

		Nota_de_Auditoria__c nda = new Nota_de_Auditoria__c(Tipo_nota_de_auditoria__c = tnda.Id,
															APr_Id__c = caso.Id,
															Nota__c = 'Una nota');
		nda.RecordTypeId = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Service').Id;
		insert nda;

		String mockResponseBody = '{' +
									  '"error": false,' +
									  '"data": {"id_nota": "562866"},' +
									  '"httpCode": 200,' +
									  '"message": "Se cargó satisfactoriamente la nota de auditor.",' +
									  '"meta": {' +
										'"allowed_includes": [],' +
										'"default_includes": []' +
									  '}' +
									'}';
		XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		mock.buildResponse()
			.withStatusCode(200)
			.withBody(mockResponseBody)
			.addForAddress(WSNotaDeAuditoriaEnviarASS.SERVICE_CONFIG.URL__c  + '/v1/salud/notas-auditor');

		Test.setMock(HttpCalloutMock.class, mock);

		// Test
        Test.startTest();
        WSNotaDeAuditoriaEnviarASS.SSWSResult rb = WSNotaDeAuditoriaEnviarASS.enviar(nda);
        Test.stopTest();

		System.assert(!rb.hasError);
		System.assertEquals(200, rb.responseBody.httpCode);
		System.assertEquals('Se cargó satisfactoriamente la nota de auditor.', rb.responseBody.message);

		Nota_de_Auditoria__c ndaQuery = [SELECT Id_Externo__c FROM Nota_de_Auditoria__c WHERE Id =: nda.Id];
		System.assertEquals('562866', ndaQuery.Id_Externo__c);
	}
}