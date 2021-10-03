@isTest 
private class ClausulasTempProcessorTest {

	static MasterConfigs__c config;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse; 
	static XHttpCalloutMock getEmptyListResponse;
	static XHttpCalloutMock getResponseFoundSecondPageOnly;
	static Account asociado;
	static Account asociado2;
	static Account asociado3;
	static Account asociado4;
	static Diagnostico__c diagnostico;

	static {
		asociado = Build.anAccountCuentapersonal().build();
		asociado.Sexo__c = 'F';
		asociado.Codigo_de_Afiliado__c = '51692/10';
		insert asociado;

		asociado2 = Build.anAccountCuentapersonal().build();
		asociado2.Sexo__c = 'F';
		asociado2.Codigo_de_Afiliado__c = '51773/14';
		insert asociado2;

		diagnostico = new Diagnostico__c();
		diagnostico.Codigo_del_Diagnostico__c = 'Z34';
		insert diagnostico;

		String today = System.now().addDays(-90).format('yyyy-MM-dd').substringBefore(' ');

		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchClausulasTempMock.getFound())
			.addForAddress(WSBatchClausulasTemp.SERVICE_CONFIG.URL__c + '/v1/salud/batch/clausulas-temporarias/' + today + '?pageSize=15&page=1');	
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchClausulasTempMock.getFoundSecondPage())
			.addForAddress(WSBatchClausulasTemp.SERVICE_CONFIG.URL__c + '/v1/salud/batch/clausulas-temporarias/' + today + '?pageSize=15&page=2');

		getResponseFoundSecondPageOnly = new XHttpCalloutMock();
		getResponseFoundSecondPageOnly.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundSecondPageOnly.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchClausulasTempMock.getFoundSecondPage())
			.addForAddress(WSBatchClausulasTemp.SERVICE_CONFIG.URL__c + '/v1/salud/batch/clausulas-temporarias/' + today + '?pageSize=15&page=2');
		
		config = Build.aMasterConfigs().build();
		insert config;
	}

	@isTest static void externalsClausulasTempCanBeProcessed() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new ClausulasTempProcessor(15, 2, 2, System.now())));
		Test.stopTest();
		
		System.assertEquals(2, [SELECT Count() FROM Asignacion_de_clausula_temporaria__c]);

	}

	@isTest static void aSecondBatchOfClausulasTempCanBeCalled() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
        
		Test.startTest();
		Database.executeBatch(new MasterBatch(new ClausulasTempProcessor(15, System.now())));
		Test.stopTest();
		
		System.assertEquals(4, [SELECT Count() FROM Asignacion_de_clausula_temporaria__c]);
		//System.assertEquals(4, [SELECT Count() FROM Monodroga__c]);

	}

	@isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

		Datetime now = System.now();

		Datetime yesterday = Datetime.now().addDays(-1);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new ClausulasTempProcessor(15, 2, 2, now)));
		Test.stopTest();

		System.debug(MasterConfigs__c.getOrgDefaults().Clausulas_Temporales__c);

		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Clausulas_Temporales__c);
	}
}