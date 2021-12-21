@isTest
public class LocalidadProcessorTest {
	private static String LOCALIDADES_ZONAS_URL = ConfigUtils.getEndpointsByTipo('localidades-zonas').get('localidades-zonas').Endpoint__c;
	private static String LOCALIDADES_ZONAS_URL_TAIL1 = '?filter[fecha_modificacion]=2020-04-06&pageSize=50&page=';
	private static String LOCALIDADES_ZONAS_URL_TAIL2 = '?filter[fecha_modificacion]=2020-04-05&pageSize=50&page=1';
    private static XHttpCalloutMock getResponseFound;
	private static XHttpCalloutMock getErrorResponse;
	private static XHttpCalloutMock getEmpty;
    private static Localidad__c loc;
    private static Localidad__c loc2;
	static {
		List<TestUtils.MockSettings> settingsList = new List<TestUtils.MockSettings>();
		TestUtils.mockSettings endpoint1 = new TestUtils.MockSettings();
		endpoint1.statusCode = 200;
		endpoint1.status = 'OK';
		endpoint1.body = XappiaHelper.getStaticResource('mockLocalidadOk').body.toString();
		endpoint1.url = LOCALIDADES_ZONAS_URL + LOCALIDADES_ZONAS_URL_TAIL1 + '1';
		settingsList.add(endpoint1);
		TestUtils.mockSettings endpoint2 = new TestUtils.MockSettings();
		endpoint2.statusCode = 200;
		endpoint2.status = 'OK';
		endpoint2.body = XappiaHelper.getStaticResource('mockLocalidadOk2').body.toString();
		endpoint2.url = LOCALIDADES_ZONAS_URL + LOCALIDADES_ZONAS_URL_TAIL1 + '2';
		settingsList.add(endpoint2);
		getResponseFound = new XHttpCalloutMock();
		TestUtils.setMockResponse(getResponseFound, settingsList);
		getEmpty = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getEmpty,
			LOCALIDADES_ZONAS_URL + LOCALIDADES_ZONAS_URL_TAIL2,
			XappiaHelper.getStaticResource('mockLocalidadEmpty').body.toString()
		);
		getErrorResponse = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			false,
			getErrorResponse,
			LOCALIDADES_ZONAS_URL,
			XappiaHelper.getStaticResource('mockLocalidadError').body.toString()
		);
        loc = Build.aLocalidad().withLocId('0002').withNombreLocalidad('CAPITAL FEDERAL').withCodigoPostal('1645ACO').withCodigoProvincia('D').build();
        loc2 = Build.aLocalidad().withLocId('0000').withNombreLocalidad('CAPITAL FEDERAL').withCodigoPostal('1645ACO').withCodigoProvincia('D').build();
    }
    @isTest static void aLocalidadExternalCanBeProcessed(){
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
        User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com',
                CommunityNickname = 'USERTEST', User_ID_en_SS__c = 'USERTEST'
        );
        insert usuario;
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Datetime fecha = Datetime.newInstanceGmt(2020, 04, 06, 06, 00, 00);
        loc.Loc_Id__c = '3640';
        insert loc;
        Test.startTest();
		Database.executeBatch(new MasterBatch(new LocalidadProcessor(50, 1, 1, fecha, Datetime.now())));
        Test.stopTest();
        Localidad__c locToAssert = [SELECT Id, Nombre_de_Localidad__c, Loc_Id__c, ZG_Codigo__c,
											Codigo_de_Provincia__c, Codigo_Postal__c, Organizador_lookup__c
									FROM Localidad__c WHERE Id = :loc.Id];
        System.assertEquals('CAPITAL FEDERAL', locToAssert.Nombre_de_Localidad__c, 'La localidad no es la esperada');
        System.assertEquals('C', locToAssert.Codigo_de_Provincia__c, 'El código de la provincia no coincide');
        System.assertEquals('ZN_3', locToAssert.ZG_Codigo__c, 'El código postal no coincide');
        System.assertEquals('3640', locToAssert.Loc_Id__c, 'El Id de la localidad no es la esperada');
        System.assertEquals('1077CFE', locToAssert.Codigo_Postal__c, 'El código postal no corresponde');
        System.assertEquals(usuario.Id, locToAssert.Organizador_lookup__c, 'El Id del usuario no coincide');
    }
    @isTest static void aLocalidadExternalCantBeProcessed(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Datetime fecha = Datetime.newInstanceGmt(2020, 04, 06, 06, 00, 00);
        loc.Loc_Id__c = '0001';
        insert loc;
        Test.startTest();
		Database.executeBatch(new MasterBatch(new LocalidadProcessor(50, 1, 1, fecha, Datetime.now())));
        Test.stopTest();
        Localidad__c locToAssert = [SELECT Id, Nombre_de_Localidad__c, Loc_Id__c, Codigo_de_Provincia__c, Codigo_Postal__c
                                     FROM Localidad__c WHERE Id = :loc.Id];
        System.assertEquals('CAPITAL FEDERAL', locToAssert.Nombre_de_Localidad__c,  'La localidad no es la esperada');
    }
    @isTest static void aSecondBatchOfLocalidadCanBeCalled(){
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
        User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com',
                CommunityNickname = 'USERTEST2', User_ID_en_SS__c = 'USERTEST2'
        );
        insert usuario;
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Datetime fecha = Datetime.newInstanceGmt(2020, 04, 06, 06, 00, 00);
        loc.Loc_Id__c = '3690';
        loc2.Loc_Id__c = '3651';
        insert loc;
        insert loc2;
        List<Id> ids = new List<Id> ();
        ids.add(loc.Id);
        ids.add(loc2.Id);
        Test.startTest();
		Database.executeBatch(new MasterBatch(new LocalidadProcessor(50, 1, 470, fecha, Datetime.now())));
        Test.stopTest();
        List<Localidad__c> locToAssert = [SELECT Id, Nombre_de_Localidad__c, Loc_Id__c, Codigo_de_Provincia__c, Codigo_Postal__c, Organizador_lookup__c
                                     		FROM Localidad__c WHERE Id IN :ids];
        System.assertEquals('CAPITAL FEDERAL', locToAssert[0].Nombre_de_Localidad__c, 'La localidad no es la esperada');
        System.assertEquals('C', locToAssert[0].Codigo_de_Provincia__c, 'El codigo de provincia no es el esperado');
        System.assertEquals('3690', locToAssert[0].Loc_Id__c, 'El Id de la localidad no es el esperado');
        System.assertEquals(usuario.Id, locToAssert[0].Organizador_lookup__c, 'El usuario no coincide');
        System.assertEquals('1139CFE', locToAssert[0].Codigo_Postal__c, 'El código postal no es el esperado');
        System.assertEquals('CAPITAL FEDERAL', locToAssert[1].Nombre_de_Localidad__c, 'La localidad no es la esperada');
        System.assertEquals('C', locToAssert[1].Codigo_de_Provincia__c, 'El codigo de provincia no es el esperado');
        System.assertEquals('3651', locToAssert[1].Loc_Id__c, 'El Id de la localidad no es el esperado');
        System.assertEquals('1088CFE', locToAssert[1].Codigo_Postal__c, 'El código postal no es el esperado');
    }
    @isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Datetime now = System.now();
		Datetime yesterday = Datetime.now().addDays(-1);
        Test.startTest();
		Database.executeBatch(new MasterBatch(new LocalidadProcessor(50, 1, 470, yesterday, now)));
		Test.stopTest();
		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Localidades__c, 'La localidad no es la esperada');
	}
}