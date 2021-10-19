@isTest
public class AccountEmpresaProcessorTest  {

	static MasterConfigs__c config;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundSecondPage;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmptyListResponse;
	static Account agencia;

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
			.withBody(WSBatchEmpresaMock.getFound())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/empresas/' + today + '?pageSize=15&page=2');

		getResponseFoundSecondPage = new XHttpCalloutMock();
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchEmpresaMock.getFoundAndContinue())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/empresas/' + today + '?pageSize=15&page=1');	
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchEmpresaMock.getFound())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/empresas/' + today + '?pageSize=15&page=2');
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchSucursalMock.getFound())
			.addForAddress(WSBatchSucursal.SERVICE_CONFIG.URL__c + '/v1/salud/batch/sucursales-empresas/' + today + '?pageSize=15&page=1');	
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchSucursalMock.getFoundSecondPage())
			.addForAddress(WSBatchSucursal.SERVICE_CONFIG.URL__c + '/v1/salud/batch/sucursales-empresas/' + today + '?pageSize=15&page=2');

		agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('650098').build();
		insert agencia;
	}

	static {
		config = Build.aMasterConfigs().build();
		insert config;
	}

	@isTest static void externalsAccountsCanBeProcessed() {
		XHttpCalloutMock mock = new XHttpCalloutMock();

		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountEmpresaProcessor(15, 2, 2, System.now())));
		Test.stopTest();

		System.assertEquals(1, [SELECT Count() FROM Account WHERE RecordType.DeveloperName = 'Empresa']);
	}

	@isTest static void aSecondBatchOfAccountsCanBeCalled() {

		XHttpCalloutMock mock = new XHttpCalloutMock();
		
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPage);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountEmpresaProcessor(15, System.now())));
		Test.stopTest();

		System.assertEquals(2, [SELECT Count() FROM Account WHERE RecordType.DeveloperName = 'Empresa']);
        System.assertEquals(2, [SELECT Count() FROM Sucursal__c WHERE Empresa__r.Codigo_de_empresa__c = '600001']);// + 1 manager
		//System.assertEquals(1, [SELECT Count() FROM Dependiente__c]);
	}

	@isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {


		XHttpCalloutMock mock = new XHttpCalloutMock();

		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Datetime now = System.now();

		Datetime yesterday = Datetime.now().addDays(-1);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountEmpresaProcessor(15, 2, 2, now)));
		Test.stopTest();

		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Empresas__c);
	}

}