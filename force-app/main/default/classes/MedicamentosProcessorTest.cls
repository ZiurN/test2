@isTest 
private class MedicamentosProcessorTest {

	static MasterConfigs__c config;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse; 
	static XHttpCalloutMock getEmptyListResponse;
	static XHttpCalloutMock getResponseFoundSecondPageOnly;

	static {
		String today = System.now().format('yyyy-MM-dd').substringBefore(' ');

		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchMedicamentosMock.getFound())
			.addForAddress(WSBatchMedicamentos.SERVICE_CONFIG.URL__c + '/v1/salud/batch/medicamentos/' + today + '?pageSize=15&page=1');	
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchMedicamentosMock.getFoundSecondPage())
			.addForAddress(WSBatchMedicamentos.SERVICE_CONFIG.URL__c + '/v1/salud/batch/medicamentos/' + today + '?pageSize=15&page=2');

		getResponseFoundSecondPageOnly = new XHttpCalloutMock();
		getResponseFoundSecondPageOnly.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundSecondPageOnly.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchMedicamentosMock.getFoundSecondPage())
			.addForAddress(WSBatchMedicamentos.SERVICE_CONFIG.URL__c + '/v1/salud/batch/medicamentos/' + today + '?pageSize=15&page=2');
		
		config = Build.aMasterConfigs().build();
		insert config;
	}

	@isTest static void externalsMedicamentosCanBeProcessed() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new MedicamentosProcessor(15, 2, 2, System.now())));
		Test.stopTest();

		System.assertEquals(2, [SELECT Count() FROM Medicamento__c]);
		System.assertEquals(2, [SELECT Count() FROM Monodroga__c]);
	}

	@isTest static void aSecondBatchOfMedicamentosCanBeCalled() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
        
		Test.startTest();
		Database.executeBatch(new MasterBatch(new MedicamentosProcessor(15, System.now())));
		Test.stopTest();
		
		System.assertEquals(4, [SELECT Count() FROM Medicamento__c]);
		System.assertEquals(4, [SELECT Count() FROM Monodroga__c]);

	}

	@isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

		Datetime now = System.now();

		Datetime yesterday = Datetime.now().addDays(-1);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new MedicamentosProcessor(15, 2, 2, now)));
		Test.stopTest();

		System.debug(MasterConfigs__c.getOrgDefaults().Medicamentos__c);

		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Medicamentos__c);
	}

}