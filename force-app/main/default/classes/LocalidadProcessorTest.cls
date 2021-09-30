@isTest
public class LocalidadProcessorTest {
    static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmpty;
    static  Localidad__c loc;
    static  Localidad__c loc2;
	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLocalidadMock.getFound())
            .addForAddress(WSLocalidad.SERVICE_CONFIG.URL__c + '/v1/salud/localidades-zonas?filter[fecha_modificacion]=2020-04-06&pageSize=50&page=1');
        getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLocalidadMock.getFound2())
			.addForAddress(WSLocalidad.SERVICE_CONFIG.URL__c + '/v1/salud/localidades-zonas?filter[fecha_modificacion]=2020-04-06&pageSize=50&page=2');

		getEmpty = new XHttpCalloutMock();
		getEmpty.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getEmpty.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLocalidadMock.getEmpty())
			.addForAddress(WSLocalidad.SERVICE_CONFIG.URL__c + '/v1/salud/localidades-zonas?filter[fecha_modificacion]=2020-04-05&pageSize=50&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSLocalidadMock.getError())
            .addForAddress(WSLocalidad.SERVICE_CONFIG.URL__c + '/v1/salud/localidades-zona');
            
        loc = Build.aLocalidad().withLocId('0002').withNombreLocalidad('ACASUSSO').withCodigoPostal('1645ACO').withCodigoProvincia('D').build();
        loc2 = Build.aLocalidad().withLocId('0000').withNombreLocalidad('ACASUSSO').withCodigoPostal('1645ACO').withCodigoProvincia('D').build();
        
    }

    @isTest static void aLocalidadExternalCanBeProcessed(){
        
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
        System.debug(profileList);

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

        Localidad__c locToAssert = [
            SELECT Id, Nombre_de_Localidad__c, Loc_Id__c, ZG_Codigo__c, 
                    Codigo_de_Provincia__c, Codigo_Postal__c, Organizador_lookup__c
            FROM Localidad__c WHERE Id = :loc.Id
        ];
        
        System.assertEquals('CAPITAL FEDERAL', locToAssert.Nombre_de_Localidad__c);
        System.assertEquals('C', locToAssert.Codigo_de_Provincia__c);
        System.assertEquals('ZN_3', locToAssert.ZG_Codigo__c);
        System.assertEquals('3640', locToAssert.Loc_Id__c);
        System.assertEquals('1077CFE', locToAssert.Codigo_Postal__c);
        System.assertEquals(usuario.Id, locToAssert.Organizador_lookup__c);
        
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

        System.assertEquals('ACASUSSO', locToAssert.Nombre_de_Localidad__c);
        
    }

    @isTest static void aSecondBatchOfLocalidadCanBeCalled(){
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
        System.debug(profileList);

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

        
        System.assertEquals('CAPITAL FEDERAL', locToAssert[0].Nombre_de_Localidad__c);
        System.assertEquals('C', locToAssert[0].Codigo_de_Provincia__c);
        System.assertEquals('3690', locToAssert[0].Loc_Id__c);
        System.assertEquals(usuario.Id, locToAssert[0].Organizador_lookup__c);
        System.assertEquals('1139CFE', locToAssert[0].Codigo_Postal__c);
        System.assertEquals('CAPITAL FEDERAL', locToAssert[1].Nombre_de_Localidad__c);
        System.assertEquals('C', locToAssert[1].Codigo_de_Provincia__c);
        System.assertEquals('3651', locToAssert[1].Loc_Id__c);
        System.assertEquals('1088CFE', locToAssert[1].Codigo_Postal__c);
        
    }


    @isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Datetime now = System.now();

		Datetime yesterday = Datetime.now().addDays(-1);

        Test.startTest();
		Database.executeBatch(new MasterBatch(new LocalidadProcessor(50, 1, 470, yesterday, now)));
		Test.stopTest();

		System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Localidades__c);
	}


}