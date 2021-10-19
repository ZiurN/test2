@isTest 
private class TelefonoProcessorTest {

	static MasterConfigs__c config;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundTwoPages;
	static XHttpCalloutMock getResponseFoundInitialDataLoad;
	static XHttpCalloutMock getResponseFoundTwoPagesInitialDataLoad;
	static Account asociado;

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
			.withBody(WSBatchTelefonoMock.getFoundAndStop())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/telefonos/' + today + '?pageSize=15&page=2');

		getResponseFoundTwoPages = new XHttpCalloutMock();
		getResponseFoundTwoPages.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundTwoPages.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchTelefonoMock.getFoundAndContinue())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/telefonos/' + today + '?pageSize=15&page=1');	
		getResponseFoundTwoPages.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchTelefonoMock.getFoundAndStop())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/telefonos/' + today + '?pageSize=15&page=2');

		getResponseFoundInitialDataLoad = new XHttpCalloutMock();
		getResponseFoundInitialDataLoad.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundInitialDataLoad.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchTelefonoMock.getFoundAndStop())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/telefonos-m/' + today + '?pageSize=15&page=2');

		getResponseFoundTwoPagesInitialDataLoad = new XHttpCalloutMock();
		getResponseFoundTwoPagesInitialDataLoad.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundTwoPagesInitialDataLoad.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchTelefonoMock.getFoundAndContinue())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/telefonos-m/' + today + '?pageSize=15&page=1');	
		getResponseFoundTwoPagesInitialDataLoad.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchTelefonoMock.getFoundAndStop())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/telefonos-m/' + today + '?pageSize=15&page=2');


		asociado = Build.anAccountCuentapersonal().build();
		asociado.Afi_Id__c = '167755';
		insert asociado;
	}

	static {
		config = Build.aMasterConfigs().build();
		insert config;
	}

	@isTest static void externalsTelefonosCanBeProcessed_InitialDataLoad() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundInitialDataLoad);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new TelefonoProcessor(15, 2, 2, System.now(), true)));
		Test.stopTest();

		Telefono__c[] telefonos = [SELECT TEL_ID__c, Tipo__c, Telefono__c, Cuenta__c, Telefono_principal__c FROM Telefono__c];
		asociado = [SELECT Phone, Tipo_de_Telefono__c FROM Account WHERE Id = :asociado.Id];

		System.assertEquals('3411480105', asociado.Phone);
		System.assertEquals(1, telefonos.size());
		for(Telefono__c tel : telefonos) {
			if(tel.TEL_ID__c == '226244') {
				System.assertEquals('3411480105', tel.Telefono__c);
				System.assertEquals('TEL', tel.Tipo__c);
				System.assertEquals(asociado.Id, tel.Cuenta__c);
				System.assertEquals(true, tel.Telefono_principal__c);
			}
		}
	}

	@isTest static void aSecondBatchOfTelefonosCanBeCalled_InitialDataLoad() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundTwoPagesInitialDataLoad);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new TelefonoProcessor(15, System.now(), true)));
		Test.stopTest();

		Telefono__c[] telefonos = [SELECT TEL_ID__c, Tipo__c, Telefono__c, Telefono_principal__c, Cuenta__c FROM Telefono__c];
		asociado = [SELECT Phone, Tipo_de_Telefono__c FROM Account WHERE Id = :asociado.Id];

		System.assertEquals('3411480105', asociado.Phone);
		System.assertEquals(2, telefonos.size());
		for(Telefono__c tel : telefonos) {
			if(tel.TEL_ID__c == '226245') {
				System.assertEquals('3411480106', tel.Telefono__c);
				System.assertEquals('CEL', tel.Tipo__c);
				System.assertEquals(asociado.Id, tel.Cuenta__c);
				System.assertEquals(false, tel.Telefono_principal__c);
			}

		}
		
	}

	@isTest static void externalsTelefonosCanBeProcessed() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new TelefonoProcessor(15, 2, 2, System.now(), false)));
		Test.stopTest();

		Telefono__c[] telefonos = [SELECT TEL_ID__c, Tipo__c, Telefono__c, Cuenta__c, Telefono_principal__c FROM Telefono__c];
		asociado = [SELECT Phone, Tipo_de_Telefono__c FROM Account WHERE Id = :asociado.Id];

		System.assertEquals('3411480105', asociado.Phone);
		System.assertEquals(1, telefonos.size());
		for(Telefono__c tel : telefonos) {
			if(tel.TEL_ID__c == '226244') {
				System.assertEquals('3411480105', tel.Telefono__c);
				System.assertEquals('TEL', tel.Tipo__c);
				System.assertEquals(asociado.Id, tel.Cuenta__c);
				System.assertEquals(true, tel.Telefono_principal__c);
			}
		}
	}

	@isTest static void aSecondBatchOfTelefonosCanBeCalled() {		
		Test.setMock(HttpCalloutMock.class, getResponseFoundTwoPages);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new TelefonoProcessor(15, System.now())));
		Test.stopTest();

		Telefono__c[] telefonos = [SELECT TEL_ID__c, Tipo__c, Telefono__c, Telefono_principal__c, Cuenta__c FROM Telefono__c];
		asociado = [SELECT Phone, Tipo_de_Telefono__c FROM Account WHERE Id = :asociado.Id];

		System.assertEquals('3411480105', asociado.Phone);
		System.assertEquals(2, telefonos.size());
		for(Telefono__c tel : telefonos) {
			if(tel.TEL_ID__c == '226245') {
				System.assertEquals('3411480106', tel.Telefono__c);
				System.assertEquals('CEL', tel.Tipo__c);
				System.assertEquals(asociado.Id, tel.Cuenta__c);
				System.assertEquals(false, tel.Telefono_principal__c);
			}

		}
		
	}

	@isTest 
	static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		XHttpCalloutMock mock = new XHttpCalloutMock();
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Datetime now = System.now();

		Datetime yesterday = Datetime.now().addDays(-1);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new TelefonoProcessor(15, 2, 2, now, false)));
		Test.stopTest();

		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Telefonos__c);
	}
}