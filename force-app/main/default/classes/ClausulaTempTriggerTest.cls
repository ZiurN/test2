@isTest 
private class ClausulaTempTriggerTest {

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
			.withBody(WSClausulaTempEnviarASSMock.getFound())
			.addForAddress(WSClausulaTempEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/clausulas-temporarias/pmi');
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSClausulaTempEnviarASSMock.getError())
			.addForAddress(WSClausulaTempEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/clausulas-temporarias/pmi');
		
	}

	@isTest
	private static void whenAClausulaIsCreatedWithValidFields_ItShouldSendToSSAndFillTheCorrespondingFields() {
        Date today = Date.today();
        Date tomorrow = Date.today().addDays(1);
        Date yesterday = Date.Today().addDays(-1);
		Date fpp = Date.Today().addDays(-2);
        Account acc = Build.anAccount().withLastName('AccountTest').build();
        acc.Codigo_de_Afiliado__c = '123';
        acc.Sexo__c = 'F';
        insert acc;

		Asignacion_de_clausula_temporaria__c clausula = new Asignacion_de_clausula_temporaria__c(
            Fecha_desde__c = today,
            Asociado__c = acc.Id,
			Fecha_FUM__c = yesterday,
			FPP__c = fpp
        );
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		insert clausula;
		Test.stopTest();

		clausula = [SELECT codigo_ACT_SS__c FROM Asignacion_de_clausula_temporaria__c WHERE Id = :clausula.Id];

		System.assertEquals('47518', clausula.codigo_ACT_SS__c);

    }


	@isTest
	private static void whenAClausulaIsCreatedWithInvalidFields_ItShouldFailsSendToSSAndFillTheCorrespondingFields() {
        Date today = Date.today();
        Date tomorrow = Date.today().addDays(1);
        Date yesterday = Date.Today().addDays(-1);
		Date fpp = Date.Today().addDays(-2);
        Account acc = Build.anAccount().withLastName('AccountTest').build();
        acc.Codigo_de_Afiliado__c = '123';
        acc.Sexo__c = 'F';
        insert acc;

		Asignacion_de_clausula_temporaria__c clausula = new Asignacion_de_clausula_temporaria__c(
            Fecha_desde__c = today,
            Asociado__c = acc.Id,
			Fecha_FUM__c = yesterday,
			FPP__c = fpp
		);
		Test.setMock(HttpCalloutMock.class, getResponseError);

		Test.startTest();
		insert clausula;
		Test.stopTest();

		clausula = [
			SELECT codigo_ACT_SS__c, Fallo_en_SS__c, Fecha_de_fallo__c
			FROM Asignacion_de_clausula_temporaria__c 
			WHERE Id = :clausula.Id
		];

		System.assertEquals(null, clausula.codigo_ACT_SS__c);
		System.assertNotEquals(null, clausula.Fallo_en_SS__c);
		System.assertNotEquals(null, clausula.Fecha_de_fallo__c);
	}

	@isTest
	private static void whenUpdateClosedDateOfClausula_ItShouldUpdatesInSS() {
        Date today = Date.today();
        Date tomorrow = Date.today().addDays(1);
        Date yesterday = Date.Today().addDays(-1);
		Date fpp = Date.Today().addDays(-2);
        Account acc = Build.anAccount().withLastName('AccountTest').build();
        acc.Codigo_de_Afiliado__c = '123';
        acc.Sexo__c = 'F';
        insert acc;

		Asignacion_de_clausula_temporaria__c clausula = new Asignacion_de_clausula_temporaria__c(
            Fecha_desde__c = today,
            Asociado__c = acc.Id,
			Fecha_FUM__c = yesterday,
			FPP__c = fpp
        );
		insert clausula;

		clausula.codigo_ACT_SS__c = '47518';
		clausula.Fecha_de_cierre_de_clausula__c = today.addDays(2);
		clausula.Motivo_de_cierre__c = 'cierre';

		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		update clausula;
		Test.stopTest();

		clausula = [SELECT Fallo_en_SS__c FROM Asignacion_de_clausula_temporaria__c WHERE Id = :clausula.Id];

		System.assertEquals(null, clausula.Fallo_en_SS__c);

    }
}