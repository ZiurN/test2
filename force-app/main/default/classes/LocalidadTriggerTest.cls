@isTest 
private class LocalidadTriggerTest {

	static User userTest;

	static{
		String uniqueUserName2 = 'organizador' + DateTime.now().getTime() + '@testorg.com';

		Profile p = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		userTest = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p.Id,
				TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName2,UserRole = role);
		insert userTest;
	}

	@isTest
	private static void updateLeadOrganizadorWhenLocalidadIsUpdated() {

        Localidad__c loc = Build.aLocalidad()
			.withCodigoPostal('1884')
			.withCodigoProvincia('B')
			.withLocId('123')
			.withNombreLocalidad('Berazategui')
			.withOrganizador(UserInfo.getUserId())
			.build();

		insert loc;
        
		Lead cand = Build.aLead().withLocId('123').build();
		cand.Phone = '1144445555';
        cand.Localidad_new__c = loc.Id;
		insert cand;

		Test.startTest();
		loc.Organizador_lookup__c = userTest.Id;
		update loc;
		Test.stopTest();

		Lead updatedLead = [
			SELECT Organizador_lookup__c, OwnerId,Provincia__c,Codigo_postal__c,
				Localidad__c,LocId__c,Zona_Geografica__c
			FROM Lead
			WHERE Id = :cand.Id
		];
		System.assertEquals(userTest.Id, updatedLead.Organizador_lookup__c);
		System.assertEquals(userTest.Id, updatedLead.OwnerId);
		System.assertEquals(loc.Codigo_de_Provincia__c, updatedLead.Provincia__c);
		System.assertEquals(loc.ZG_Codigo__c, updatedLead.Zona_Geografica__c);
		System.assertEquals(loc.Loc_Id__c, updatedLead.LocId__c);
	}


	/*@isTest
	private static void updateLeadOrganizadorWhenLocalidadIsNew() {

		Lead cand = Build.aLead().withLocId('123').build();
		cand.Phone = '1144445555';
		insert cand;
		System.debug(cand.Organizador_lookup__c);

		Localidad__c loc = Build.aLocalidad()
			.withCodigoPostal('1884')
			.withCodigoProvincia('B')
			.withLocId('123')
			.withNombreLocalidad('Berazategui')
			.withOrganizador(UserInfo.getUserId())
			.build();
		
		Test.startTest();
		insert loc;
		Test.stopTest();
		
		Lead updatedLead = [
			SELECT Organizador_lookup__c, OwnerId,Provincia__c,Codigo_postal__c,
				Localidad__c,LocId__c,Zona_Geografica__c
			FROM Lead
			WHERE Id = :cand.Id
		];
		System.assertEquals(UserInfo.getUserId(),updatedLead.Organizador_lookup__c);
		System.assertEquals(UserInfo.getUserId(),updatedLead.OwnerId);
		System.assertEquals(loc.Codigo_de_Provincia__c, updatedLead.Provincia__c);
		System.assertEquals(loc.Nombre_de_Localidad__c, updatedLead.Localidad__c);
		System.assertEquals(loc.Codigo_Postal__c, updatedLead.Codigo_postal__c);
		System.assertEquals(loc.ZG_Codigo__c, updatedLead.Zona_Geografica__c);
		System.assertEquals(loc.Loc_Id__c, updatedLead.LocId__c);

	}

		@isTest
	private static void updateLeadOrganizadorWhenLocalidadIsNewByProvAndCP() {

		Lead cand = Build.aLead().withCodigoPostal('1884').build();
		cand.Provincia__c = 'B';
		cand.Phone = '1144445555';
		insert cand;
		System.debug(cand.Organizador_lookup__c);

		Localidad__c loc = Build.aLocalidad()
			.withCodigoPostal('1884')
			.withCodigoProvincia('B')
			.withLocId('123')
			.withNombreLocalidad('Berazategui')
			.withOrganizador(UserInfo.getUserId())
			.build();
		
		Test.startTest();
		insert loc;
		Test.stopTest();
		
		Lead updatedLead = [
			SELECT Organizador_lookup__c, OwnerId,Provincia__c,Codigo_postal__c,
				Localidad__c,LocId__c,Zona_Geografica__c
			FROM Lead
			WHERE Id = :cand.Id
		];
		System.assertEquals(UserInfo.getUserId(),updatedLead.Organizador_lookup__c);
		System.assertEquals(UserInfo.getUserId(),updatedLead.OwnerId);
		System.assertEquals(loc.Codigo_de_Provincia__c, updatedLead.Provincia__c);
		System.assertEquals(loc.Nombre_de_Localidad__c, updatedLead.Localidad__c);
		System.assertEquals(loc.Codigo_Postal__c, updatedLead.Codigo_postal__c);
		System.assertEquals(loc.ZG_Codigo__c, updatedLead.Zona_Geografica__c);
		System.assertEquals(loc.Loc_Id__c, updatedLead.LocId__c);

	}*/
}