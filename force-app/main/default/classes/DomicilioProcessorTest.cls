@isTest 
private class DomicilioProcessorTest {

	static MasterConfigs__c config;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundTwoPages;
	static Account asociado;
	static Account asociado2;
	static Localidad__c localidad;
	static Localidad__c localidad2;

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
			.withBody(WSBatchDomicilioMock.getFoundAndStop())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/domicilios/' + today + '?pageSize=15&page=2');

		getResponseFoundTwoPages = new XHttpCalloutMock();
		getResponseFoundTwoPages.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundTwoPages.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchDomicilioMock.getFoundAndContinue())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/domicilios/' + today + '?pageSize=15&page=1');	
		getResponseFoundTwoPages.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchDomicilioMock.getFoundAndStop())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/domicilios/' + today + '?pageSize=15&page=2');

		asociado = Build.anAccountCuentapersonal().build();
		asociado.Afi_Id__c = '131784';
		insert asociado;

		asociado2 = Build.anAccountCuentapersonal().build();
		asociado2.Afi_Id__c = '131811';
		insert asociado2;

		localidad = new Localidad__c();
		localidad.Loc_Id__c = '10055';
		insert localidad;

		localidad2 = new Localidad__c();
		localidad2.Loc_Id__c = '3032';
		insert localidad2;
		
		config = Build.aMasterConfigs().build();
		insert config;
	}

	@isTest static void externalsDomiciliosCanBeProcessed() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new DomicilioProcessor(15, 2, 2, System.now())));
		Test.stopTest();

		Domicilio__c[] domicilios = [
			SELECT DOM_ID__c, Calle__c, Numero__c, Piso__c, DPTO__c, Tipo_de_domicilio__c, Cuenta__c, Localidad__c
			FROM Domicilio__c
		];

		System.assertEquals(2, domicilios.size());
		for(Domicilio__c domicilio : domicilios) {
			if(domicilio.DOM_ID__c == '352276') {
				System.assertEquals('MIGUEL CANE', domicilio.Calle__c);
				System.assertEquals(406, domicilio.Numero__c);
				System.assertEquals('PB', domicilio.Piso__c);
				System.assertEquals('A', domicilio.DPTO__c);
				System.assertEquals('COM', domicilio.Tipo_de_domicilio__c);
				System.assertEquals(asociado.Id, domicilio.Cuenta__c);
				System.assertEquals(localidad.Id, domicilio.Localidad__c);
			}
		}
	}

	@isTest static void aSecondBatchOfDomiciliosCanBeCalled() {		
		Test.setMock(HttpCalloutMock.class, getResponseFoundTwoPages);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new DomicilioProcessor(15, System.now())));
		Test.stopTest();

		Domicilio__c[] domicilios = [
			SELECT DOM_ID__c, Calle__c, Numero__c, Piso__c, DPTO__c, Tipo_de_domicilio__c, Cuenta__c, Localidad__c
			FROM Domicilio__c
		];
		Batch_log__c[] logs = [SELECT Id_registro_error__c, Error__c FROM Batch_log__c];

		// 4 en el mock, pero 1 falla
		System.assertEquals(3, domicilios.size());
		for(Domicilio__c domicilio : domicilios) {
			if(domicilio.DOM_ID__c == '352276') {
				System.assertEquals('MIGUEL CANE', domicilio.Calle__c);
				System.assertEquals(406, domicilio.Numero__c);
				System.assertEquals('PB', domicilio.Piso__c);
				System.assertEquals('A', domicilio.DPTO__c);
				System.assertEquals('COM', domicilio.Tipo_de_domicilio__c);
				System.assertEquals(asociado.Id, domicilio.Cuenta__c);
				System.assertEquals(localidad.Id, domicilio.Localidad__c);
			}
		}
		// domicilio que falla
		System.assertEquals('72241', logs[0].Id_registro_error__c); 
		System.debug(logs[0].Error__c);
		
	}

	@isTest 
	static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		XHttpCalloutMock mock = new XHttpCalloutMock();
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Datetime now = System.now();

		Datetime yesterday = Datetime.now().addDays(-1);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new DomicilioProcessor(15, 2, 2, now)));
		Test.stopTest();

		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Domicilios__c);
	}
}