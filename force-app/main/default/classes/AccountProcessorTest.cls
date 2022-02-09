@isTest
public class AccountProcessorTest  {
	private static String today = System.now().format('yyyy-MM-dd').substringBefore(' ');
	private static final String BATCH_AFILIADOS_URL = ConfigUtils.getEndpointsByTipo('batch').get('afiliados').Endpoint__c;
	private static final String BATCH_AFILIADOS_URL_PAGE_1 = BATCH_AFILIADOS_URL +'/' + today + '?pageSize=15&page=1';
	private static final String BATCH_AFILIADOS_URL_PAGE_2 = BATCH_AFILIADOS_URL +'/' + today + '?pageSize=15&page=2';
	private static final String BATCH_AFILIADOS_URL_PAGE_3 = BATCH_AFILIADOS_URL +'/' + today + '?pageSize=3&page=3';
	private static MasterConfigs__c config;
	private static XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
	private static XHttpCalloutMock getErrorResponse  = new XHttpCalloutMock();
	private static XHttpCalloutMock getEmptyListResponse = new XHttpCalloutMock();
	private static XHttpCalloutMock getResponseFoundSecondPageOnly = new XHttpCalloutMock();
	private static XHttpCalloutMock getFoundBajaAccounts = new XHttpCalloutMock();
	private static Account empresa;
	private static Account delegacion;
	private static Account os;
	private static Localidad__c localidad;
	static {
		List<TestUtils.MockSettings> mockSettings = new List<TestUtils.MockSettings>();
		TestUtils.MockSettings mock1info = new TestUtils.MockSettings();
		mock1info.statusCode = 200;
		mock1info.status = 'OK';
		mock1info.url = BATCH_AFILIADOS_URL_PAGE_1;
		mock1info.body = WSBatchAsociadoMock.getFound();
		mockSettings.add(mock1info);
		TestUtils.MockSettings mock2info = new TestUtils.MockSettings();
		mock2info.statusCode = 200;
		mock2info.status = 'OK';
		mock2info.url = BATCH_AFILIADOS_URL_PAGE_2;
		mock2info.body = WSBatchAsociadoMock.getFoundSecondPage();
		mockSettings.add(mock2info);
		TestUtils.setMockResponse(getResponseFound, mockSettings);
		TestUtils.setMockResponse(
			getResponseFoundSecondPageOnly,
			BATCH_AFILIADOS_URL_PAGE_2,
			WSBatchAsociadoMock.getFoundSecondPage());
		TestUtils.setMockResponse(
			getFoundBajaAccounts,
			BATCH_AFILIADOS_URL_PAGE_3,
			WSBatchAsociadoMock.getFoundBajaAccounts());
		config = Build.aMasterConfigs().build();
		insert config;
		empresa = Build.anAccountEmpresa().withCodigoEmpresa('600011').build();
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
		Integer personAccounts = [SELECT Count() FROM Account WHERE RecordType.DeveloperName = 'Cuenta_personal'];
		System.assertEquals(15, personAccounts, 'Deben haber 15 cuentas personales');
		Account acc = [SELECT Id,
						Afi_Id_del_Titular__c,
						Codigo_de_Afiliado__c,
						Envio_de_recibo__c,
						Numero_de_documento__c,
						Fecha_permanencia_desde__c,
						Fecha_permanencia_hasta__c
					FROM Account
					WHERE Afi_Id__c = '180018'];
		System.assertEquals(140980, acc.Afi_Id_del_Titular__c, 'El id del titular no coincide');
		System.assertEquals('69796/36', acc.Codigo_de_Afiliado__c, 'El código de afiliado no coincide');
		System.assertEquals('43713260', acc.Numero_de_documento__c, ' El número de documento no coincide');
		System.assertEquals(Date.newInstance(2020, 7, 1), acc.Fecha_permanencia_desde__c, 'la fecha desde no coincide');
		System.assertEquals(Date.newInstance(2020, 9, 1), acc.Fecha_permanencia_hasta__c, 'la fecha hasta no coincide');
		System.assertEquals('Factura papel', acc.Envio_de_recibo__c, 'El valor no coincide');
	}
	@isTest static void aSecondBatchOfAccountsCanBeCalled() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountProcessor(15, System.now())));
		Test.stopTest();
		Integer personAccounts = [SELECT Count() FROM Account WHERE RecordType.DeveloperName = 'Cuenta_personal'];
		System.assertEquals(25, personAccounts, 'Deben haber 25 cuentas personales');
		System.assertEquals(7, [SELECT Count() FROM Agrupacion__c], 'Debe haber 7 agrupaciones');
		System.assertEquals(96, [SELECT Count() FROM Cuenta_Agrupacion__c], 'Deben haber 96 cuentas de agrupación');
		Batch_log__c[] logs = [SELECT Id, Name, Error__c, Id_registro_error__c FROM Batch_log__c];
		System.assertEquals('Asociados(familiares)', logs[0].Name, 'El nombre del log no coincide');
		System.assertEquals('180017', logs[0].Id_registro_error__c, 'El id del registro de error no coincide');
		System.assert(logs[0].Error__c.contains('609999'), 'El error no contiene el código esperado');
		System.assert(logs[0].Error__c.contains('Codigo_de_empresa__c'), 'El error no contiene el campo esperado');
	}
	@isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);
		Datetime now = System.now();
		Datetime yesterday = Datetime.now().addDays(-1);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountProcessor(15, 2, 2, now)));
		Test.stopTest();
		System.debug(MasterConfigs__c.getOrgDefaults().Asociados__c);
		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Asociados__c, 'Las fechas no coinciden');
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
		System.assertEquals('180018', acc.Afi_Id__c, 'El código de afiliado no coincide');
		System.assertEquals('43713260', acc.Numero_de_documento__c, 'El número de documento no coincide');
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
		System.assertEquals('180018', acc.Afi_Id__c, 'El código de afiliado no coincide');
		System.assertEquals('43713260', acc.Numero_de_documento__c, 'El número de documento no coincide');
	}
	@isTest
	private static void ifAccountChangeToEstadoBThenCloseCFCases() {
		List<Account> accountsToInsert = new List<Account>();
		Account acc1 = Build.anAccountCuentapersonal()
			.withLastName('Test1')
			.withEstado('A')
			.withAfiId('140975')
			.withNroDeDocumento('20173680')
			.build();
		accountsToInsert.add(acc1);
		Account acc2 = Build.anAccountCuentapersonal()
			.withLastName('Test2')
			.withEstado('A')
			.withAfiId('140976')
			.withNroDeDocumento('22725723')
			.build();
		accountsToInsert.add(acc2);
		Account acc3 = Build.anAccountCuentapersonal()
			.withLastName('Test3')
			.withEstado('A')
			.withAfiId('140977')
			.withNroDeDocumento('14666853')
			.build();
		accountsToInsert.add(acc3);
		insert accountsToInsert;
		List<Case> casesToInsert = new List<Case>();
		Case casoFalseamiento1 = Build.aCaseFalseamientoDDJJ().withAccount(acc1).build();
		casesToInsert.add(casoFalseamiento1);
		Case casoFalseamiento2 = Build.aCaseFalseamientoDDJJ().withAccount(acc2).build();
		casesToInsert.add(casoFalseamiento2);
		Case casoFalseamiento3 = Build.aCaseFalseamientoDDJJ().withAccount(acc3).build();
		casesToInsert.add(casoFalseamiento3);
		insert casesToInsert;
		Test.setMock(HttpCalloutMock.class, getFoundBajaAccounts);
		Test.startTest();
		Database.executeBatch(new MasterBatch(new AccountProcessor(3, 3, 3, System.now())));
		Test.stopTest();
		List<Account> updatedAccounts = [SELECT Estado__c FROM Account WHERE Id IN: accountsToInsert];
		System.assertEquals(3, updatedAccounts.size(), 'Deben haber tres cuentas actualizadas');
		for (Account acc : updatedAccounts) {
			System.assertEquals('B', acc.Estado__c, 'La cuenta debe estar dada de baja');
		}
		List<Case> closedCases = [SELECT Status FROM Case WHERE AccountId IN: accountsToInsert];
		System.assertEquals(3, closedCases.size(), 'Deben haber tres casos actualizados');
		for (Case casoDDFF : closedCases) {
			System.assertEquals('Closed', casoDDFF.Status, 'La cuenta debe estar dada de baja');
		}
	}
}