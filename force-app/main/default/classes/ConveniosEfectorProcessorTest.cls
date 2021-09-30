@isTest
public class ConveniosEfectorProcessorTest  {

	//static MasterConfigs__c config;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundSecondPage;
	static XHttpCalloutMock getErrorResponse; 
	static XHttpCalloutMock getEmptyListResponse;


	static {
		String today = System.now().format('yyyy-MM-dd');
		List<Account> prestadorList = new List<Account>{
			new Account( 
				RecordTypeId = XappiaHelper.getRecordType('Account', 'Efector').Id,
				Codigo_de_efector__c = '700711',
				Name = 'Efector1',
				Es_Prestador__c = true
			),
			new Account( 
				RecordTypeId = XappiaHelper.getRecordType('Account', 'Efector').Id,
				Codigo_de_efector__c = '700047',
				Name = 'Efector2',
				Es_Prestador__c = true
			)
		};
		insert prestadorList;

		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchConvenioMock.getFoundSecondPage())
			.addForAddress(WSBatchConvenio.SERVICE_CONFIG.URL__c + '/v1/salud/batch/convenios-prestadores/' + today + '?pageSize=1&page=2');

		getResponseFoundSecondPage = new XHttpCalloutMock();
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchConvenioMock.getFound())
			.addForAddress(WSBatchConvenio.SERVICE_CONFIG.URL__c + '/v1/salud/batch/convenios-prestadores/' + today + '?pageSize=1&page=1');	
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchConvenioMock.getFoundSecondPage())
			.addForAddress(WSBatchConvenio.SERVICE_CONFIG.URL__c + '/v1/salud/batch/convenios-prestadores/' + today + '?pageSize=1&page=2');	
	}

	//static {
		//config = Build.aMasterConfigs().build();
		//insert config;
	//}

	@isTest static void externalsAccountsCanBeProcessed() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new ConveniosEfectorProcessor(1, 2, 2, System.now(), new Set<String>())));
		Test.stopTest();

		System.assertEquals(1, [SELECT Count() FROM Convenio__c]);
	}

	@isTest static void aSecondBatchOfAccountsCanBeCalled() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPage);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new ConveniosEfectorProcessor(1, System.now())));
		Test.stopTest();

		System.assertEquals(2, [SELECT Count() FROM Convenio__c]);

	}

	//@isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		//Test.setMock(HttpCalloutMock.class, getResponseFound);

		//Datetime now = System.now();

		//Datetime yesterday = Datetime.now().addDays(-1);

		//Test.startTest();
		//Database.executeBatch(new MasterBatch(new AccountProcessor(15, yesterday, now)));
		//Test.stopTest();

		//System.debug(MasterConfigs__c.getOrgDefaults().Asociados__c);

		//System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Asociados__c);
	//}

}