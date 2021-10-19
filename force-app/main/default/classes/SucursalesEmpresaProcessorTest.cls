@isTest
public class SucursalesEmpresaProcessorTest  {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundSecondPage;
	static XHttpCalloutMock getErrorResponse; 
	static XHttpCalloutMock getEmptyListResponse;


	static {
		String today = System.now().format('yyyy-MM-dd');
		//List<Account> prestadorList = new List<Account>{
		Account empresa = new Account( 
			RecordTypeId = XappiaHelper.getRecordType('Account', 'Empresa').Id,
			Codigo_de_empresa__c = '600001',
			Name = 'Empresa'
		);

		insert empresa;

		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchSucursalMock.getFoundSecondPage())
			.addForAddress(WSBatchSucursal.SERVICE_CONFIG.URL__c + '/v1/salud/batch/sucursales-empresas/' + today + '?pageSize=1&page=2');

		getResponseFoundSecondPage = new XHttpCalloutMock();
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchSucursalMock.getFound())
			.addForAddress(WSBatchSucursal.SERVICE_CONFIG.URL__c + '/v1/salud/batch/sucursales-empresas/' + today + '?pageSize=1&page=1');	
		getResponseFoundSecondPage.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchSucursalMock.getFoundSecondPage())
			.addForAddress(WSBatchSucursal.SERVICE_CONFIG.URL__c + '/v1/salud/batch/sucursales-empresas/' + today + '?pageSize=1&page=2');	
	}

	@isTest static void externalsSucursalesCanBeProcessed() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new SucursalesEmpresaProcessor(1, 2, 2, System.now())));
		Test.stopTest();

		System.assertEquals(1, [SELECT Count() FROM Sucursal__c WHERE Empresa__r.Codigo_de_empresa__c = '600001']);
	}

	@isTest static void aSecondBatchOfSucursalesCanBeCalled() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPage);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new SucursalesEmpresaProcessor(1, System.now())));
		Test.stopTest();

		System.assertEquals(2, [SELECT Count() FROM Sucursal__c WHERE Empresa__r.Codigo_de_empresa__c = '600001']);

	}

}