@isTest
public class AccountProcessorTest  {

	static MasterConfigs__c config;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse; 
	static XHttpCalloutMock getEmptyListResponse;
	static XHttpCalloutMock getResponseFoundSecondPageOnly;
	static Account empresa;
	static Account delegacion;
	static Account os;
	static Localidad__c localidad;

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
			.withBody(WSBatchAsociadoMock.getFound())
			.addForAddress(WSBatchAsociado.SERVICE_CONFIG.URL__c + '/v1/salud/batch/afiliados/' + today + '?pageSize=15&page=1');	
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchAsociadoMock.getFoundSecondPage())
			.addForAddress(WSBatchAsociado.SERVICE_CONFIG.URL__c + '/v1/salud/batch/afiliados/' + today + '?pageSize=15&page=2');

		getResponseFoundSecondPageOnly = new XHttpCalloutMock();
		getResponseFoundSecondPageOnly.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundSecondPageOnly.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchAsociadoMock.getFoundSecondPage())
			.addForAddress(WSBatchAsociado.SERVICE_CONFIG.URL__c + '/v1/salud/batch/afiliados/' + today + '?pageSize=15&page=2');
		
		config = Build.aMasterConfigs().build();
		insert config;

		empresa = Build.anAccountEmpresa().build();
		empresa.Codigo_de_empresa__c = '600011';
		insert empresa;

		delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('650098').build();
		insert delegacion;

		os = Build.anAccountObrasocial().withCodigoDeOS('640008').build();
		insert os;
		
		localidad = Build.aLocalidad().withLocId('1200').build();
		insert localidad;
		
	}

	@isTest static void externalsAccountsCanBeProcessed() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountProcessor(15, 2, 2, System.now())));
		Test.stopTest();

		// Los 10 del mock + 5 titulares creados para poder asociarlos a los familiares
		System.assertEquals(15, [SELECT Count() FROM Account WHERE RecordType.DeveloperName = 'Cuenta_personal']);
		
		Account acc = [
			SELECT Id, Afi_Id_del_Titular__c, Codigo_de_Afiliado__c, Envio_de_recibo__c, Numero_de_documento__c,
				Fecha_permanencia_desde__c, Fecha_permanencia_hasta__c
			FROM Account 
			WHERE Afi_Id__c = '180018'
		];
		
		System.assertEquals(140980, acc.Afi_Id_del_Titular__c);
		System.assertEquals('69796/36', acc.Codigo_de_Afiliado__c);
		System.assertEquals('43713260', acc.Numero_de_documento__c);
		//System.assertEquals('DNI|43713260', acc.Tipo_y_numero_de_documento__c);
		System.assertEquals(Date.newInstance(2020, 7, 1), acc.Fecha_permanencia_desde__c);
		System.assertEquals(Date.newInstance(2020, 9, 1), acc.Fecha_permanencia_hasta__c);
		System.assertEquals('Factura papel', acc.Envio_de_recibo__c);
	}

	@isTest static void aSecondBatchOfAccountsCanBeCalled() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
        
		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountProcessor(15, System.now())));
		Test.stopTest();
		
        // Los 24 del mock(son 25, pero 1 falla para crear el log) + 1 titular creado para poder asociarlo al familiar
		System.assertEquals(25, [SELECT Count() FROM Account WHERE RecordType.DeveloperName = 'Cuenta_personal']);
		System.assertEquals(7, [SELECT Count() FROM Agrupacion__c]);
		System.assertEquals(96, [SELECT Count() FROM Cuenta_Agrupacion__c]);

		Batch_log__c[] logs = [SELECT Id, Name, Error__c, Id_registro_error__c FROM Batch_log__c];
		
		System.assertEquals('Asociados(familiares)', logs[0].Name);
		System.assertEquals('180017', logs[0].Id_registro_error__c);
		System.assert(logs[0].Error__c.contains('609999'));
		System.assert(logs[0].Error__c.contains('Codigo_de_empresa__c'));

		
	}

	@isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

		Datetime now = System.now();

		Datetime yesterday = Datetime.now().addDays(-1);

		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountProcessor(15, 2, 2, now)));
		Test.stopTest();

		System.debug(MasterConfigs__c.getOrgDefaults().Asociados__c);

		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Asociados__c);
	}

	@isTest static void ifAnAfiliadoHasTheDNIDiferent_DoTheUpsertByAfiIdAndUpdateTheDNI() {
		Account acc = new Account();
		acc.LastName = 'Test';
		acc.Afi_Id__c = '180018';
		acc.Numero_de_documento__c = '043713260';
		insert acc;

		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountProcessor(15, 2, 2, System.now())));
		Test.stopTest();

		acc = [SELECT Afi_Id__c, Numero_de_documento__c FROM Account WHERE Id = :acc.Id];

		System.assertEquals('180018', acc.Afi_Id__c);
		System.assertEquals('43713260', acc.Numero_de_documento__c);
	}

	@isTest static void ifAnAfiliadoHasTheAfiIdEmptyInSF_DoTheUpsertByDNIAndUpdateTheAfiId() {
		Account acc = new Account();
		acc.LastName = 'Test';
		acc.Numero_de_documento__c = '43713260';
		insert acc;

		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountProcessor(15, 2, 2, System.now())));
		Test.stopTest();

		acc = [SELECT Afi_Id__c, Numero_de_documento__c FROM Account WHERE Id = :acc.Id];

		System.assertEquals('180018', acc.Afi_Id__c);
		System.assertEquals('43713260', acc.Numero_de_documento__c);
	}

}