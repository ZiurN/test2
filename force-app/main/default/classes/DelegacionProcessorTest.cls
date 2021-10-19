@isTest
public class DelegacionProcessorTest  {

	static MasterConfigs__c config;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse; 
	static XHttpCalloutMock getEmptyListResponse;
	static XHttpCalloutMock getResponseFoundSecondPageOnly;

	static {
		String today = System.now().format('yyyy-MM-dd').substringBefore(' ');

		Account filial = new Account();
		filial.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		filial.Codigo_de_delegacion__c = '650497';
        filial.Name = 'Filial Test';
        filial.Type = 'Filial';
		insert filial;
		
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchDelegacionMock.getFoundFirstPage())
			.addForAddress(WSBatchDelegacion.SERVICE_CONFIG.URL__c + '/v1/salud/batch/delegaciones/' + today + '?pageSize=1&page=1');	
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchDelegacionMock.getFoundSecondPage())
			.addForAddress(WSBatchDelegacion.SERVICE_CONFIG.URL__c + '/v1/salud/batch/delegaciones/' + today + '?pageSize=1&page=2');

		getResponseFoundSecondPageOnly = new XHttpCalloutMock();
		getResponseFoundSecondPageOnly.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundSecondPageOnly.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchDelegacionMock.getFoundSecondPage())
			.addForAddress(WSBatchDelegacion.SERVICE_CONFIG.URL__c + '/v1/salud/batch/delegaciones/' + today + '?pageSize=1&page=2');
	}

	static {
		config = Build.aMasterConfigs().build();
		insert config;
	}

	@isTest static void externalsAccountsDelegacionesCanBeProcessed() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new DelegacionProcessor(1, 2, 2, System.now())));
		Test.stopTest();

		System.assertEquals(2, [SELECT Count() FROM Account]);
	}

	@isTest static void aSecondBatchOfAccountsDelegacionesCanBeCalled() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
        
		Test.startTest();
		Database.executeBatch(new MasterBatch(new DelegacionProcessor(1, System.now())));
		Test.stopTest();
		
		System.assertEquals(3, [SELECT Count() FROM Account]);
	}

	@isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

		Datetime now = System.now();

		Datetime yesterday = Datetime.now().addDays(-1);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new DelegacionProcessor(1, 2, 2, now)));
		Test.stopTest();

		System.debug(MasterConfigs__c.getOrgDefaults().Delegaciones__c);

		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Delegaciones__c);
	}

}