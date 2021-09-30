@isTest
public class AccountEfectorProcessorTest  {

	static MasterConfigs__c config;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundSecondPage;
	static XHttpCalloutMock getErrorResponse; 

	static {
		String today = System.now().format('yyyy-MM-dd');


		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchEfectorMock.getFound())
			.addForAddress(WSBatchEfector.SERVICE_CONFIG.URL__c + '/v1/salud/batch/efectores/' + today + '?pageSize=15&page=1');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getFound2())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700050');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getFound())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700047');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getEmpty())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700616');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getEmpty())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700076');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getEmpty())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700711');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSBatchConsultoriosMock.getFound())
				.addForAddress(WSBatchConsultorios.SERVICE_CONFIG.URL__c + '/v1/salud/batch/consultorios/' + today + '?pageSize=100&page=1');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSBatchConvenioMock.getFoundSecondPage())
				.addForAddress(WSBatchConvenio.SERVICE_CONFIG.URL__c + '/v1/salud/batch/convenios-prestadores/' + today + '?pageSize=100&page=1');

		getResponseFoundSecondPage = new XHttpCalloutMock();
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchEfectorMock.getFoundAndContinue())
			.addForAddress(WSBatchEfector.SERVICE_CONFIG.URL__c + '/v1/salud/batch/efectores/' + today + '?pageSize=15&page=1');	
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchEfectorMock.getFound())
			.addForAddress(WSBatchEfector.SERVICE_CONFIG.URL__c + '/v1/salud/batch/efectores/' + today + '?pageSize=15&page=2');
		getResponseFoundSecondPage.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getEmpty())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700050');
		getResponseFoundSecondPage.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getFound())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700047');
		getResponseFoundSecondPage.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getEmpty())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700711');
		getResponseFoundSecondPage.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getEmpty())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700076');
		getResponseFoundSecondPage.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSEfectorConveniosMock.getEmpty())
				.addForAddress(WSEfectorConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/convenios/700084');
		getResponseFoundSecondPage.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSBatchConsultoriosMock.getFound())
				.addForAddress(WSBatchConsultorios.SERVICE_CONFIG.URL__c + '/v1/salud/batch/consultorios/' + today + '?pageSize=100&page=1');
		getResponseFoundSecondPage.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSBatchConvenioMock.getFoundSecondPage())
				.addForAddress(WSBatchConvenio.SERVICE_CONFIG.URL__c + '/v1/salud/batch/convenios-prestadores/' + today + '?pageSize=100&page=2');
		getResponseFoundSecondPage.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSBatchConvenioMock.getFound())
				.addForAddress(WSBatchConvenio.SERVICE_CONFIG.URL__c + '/v1/salud/batch/convenios-prestadores/' + today + '?pageSize=100&page=1');

		Account acc = new Account(
				RecordTypeId = XappiaHelper.getRecordType('Account', 'Efector').Id,
				Codigo_de_efector__c = '700711',
				Name = 'Efector1',
				Es_Prestador__c = true
		);
		Account acc2 = new Account(
				RecordTypeId = XappiaHelper.getRecordType('Account', 'Efector').Id,
				Codigo_de_efector__c = '700047',
				Name = 'Efector1',
				Es_Prestador__c = true
		);
//		ContentVersion contVer = new ContentVersion();
//		contVer.PathOnClient = '/700047_M_20181001.pdf';
//		contVer.origin = 'H';
//		contVer.Title = '700047_M_20181001.pdf';
//		Blob pdfBody;
//		pdfBody = Blob.valueOf('Test data');
//		contVer.VersionData = pdfBody;
//		insert contVer;
		insert  acc;insert  acc2;
//		ContentVersion newCont = [
//				SELECT ContentDocumentId
//				FROM ContentVersion
//				WHERE Id = :contVer.Id
//		];
//		ContentDocumentLink contLink = new ContentDocumentLink();
//		contLink.ContentDocumentId = newCont.ContentDocumentId;
//		contLink.LinkedEntityId =acc2.Id;
//		contLink.ShareType = 'V';
//		insert contLink;

	}

	static {
		config = Build.aMasterConfigs().build();
		insert config;
	}

	@isTest static void externalsAccountsEfectorCanBeProcessed() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);


		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountEfectorProcessor(15, 1, 1, System.now(),new List<String>())));

		Database.executeBatch(new MasterBatch(new AccountEfectorProcessor(15, 1, 1, System.now(),new List<String>())));
		Test.stopTest();

		System.assertEquals(5, [SELECT Count() FROM Account]);
		Id accountId = [SELECT Id FROM Account WHERE Codigo_de_efector__c = '700047'].Id;
		//System.assertEquals(4, [SELECT Count() FROM ContentVersion]);
		//System.assertEquals(4, [SELECT Count() FROM ContentDocumentLink WHERE LinkedEntityId = :accountId]);
		System.assertEquals(3, [SELECT Count() FROM Consultorio__c]);
		System.assertEquals(1, [SELECT Count() FROM Convenio__c]);

	}

	@isTest static void aSecondBatchOfAccountsCanBeCalled() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPage);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountEfectorProcessor(15, System.now())));
		Test.stopTest();

		System.assertEquals(6, [SELECT Count() FROM Account]);
		Id accountId = [SELECT Id FROM Account WHERE Codigo_de_efector__c = '700047'].Id;
		System.assertEquals(2, [SELECT Count() FROM Convenio__c]);
		//System.assertEquals(4, [SELECT Count() FROM ContentVersion]);
		//System.assertEquals(4, [SELECT Count() FROM ContentDocumentLink WHERE LinkedEntityId = :accountId]);
		System.assertEquals(3, [SELECT Count() FROM Consultorio__c]);

	}

	@isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Datetime now = System.now();

		Datetime yesterday = Datetime.now().addDays(-1);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountEfectorProcessor(15, now)));
		Test.stopTest();

		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Efectores__c);
	}

}