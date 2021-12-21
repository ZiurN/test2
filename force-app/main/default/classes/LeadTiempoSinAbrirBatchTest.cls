@isTest
private class LeadTiempoSinAbrirBatchTest {
	static User u;

    static  {
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		u = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p.Id,
				TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName,UserRole = role);
		insert u;


    }
    static testmethod void testLeadTiempoSinAbrirBatch() {
		List<Lead> leadPrevs = new List<Lead>();
	    for (Integer i=0;i<10;i++) {
			Lead theLead = Build.aLead()
			.withLocalidad('Ciudadela')
			.withCodigoPostal('1702')
			.build();
			theLead.Phone = '1144445555';
			theLead.Organizador_lookup__c = UserInfo.getUserId();
			theLead.OwnerId = UserInfo.getUserId();
			leadPrevs.add(theLead);
        }


		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1702')
			.withCodigoProvincia('B')
			.withOrganizador(UserInfo.getUserId())
			.build();
		System.runAs(u){
			insert loc;
			insert leadPrevs;
		}

		Lead[] leads = [SELECT Id FROM Lead];

		for(Integer i = 0; i < 2; i++){
			Datetime yesterday = Datetime.now().addDays(-1);
			leads[i].Fecha_modificacion_usuario__c = yesterday;
			//Test.setCreatedDate(leads[i].Id, yesterday);
		}

		for(Integer i = 2; i < 4; i++){
			Datetime yesterday = Datetime.now().addDays(-2);
			leads[i].Fecha_modificacion_usuario__c = yesterday;
			//Test.setCreatedDate(leads[i].Id, yesterday);
		}

		for(Integer i = 4; i < 6; i++){
			Datetime yesterday = Datetime.now().addDays(-3);
			leads[i].Fecha_modificacion_usuario__c = yesterday;
			//Test.setCreatedDate(leads[i].Id, yesterday);
		}

		for(Integer i = 6; i < 8; i++){
			Datetime yesterday = Datetime.now().addDays(-4);
			leads[i].Fecha_modificacion_usuario__c = yesterday;
			//Test.setCreatedDate(leads[i].Id, yesterday);
		}

		for(Integer i = 8; i < 10; i++){
			Datetime yesterday = Datetime.now().addDays(-5);
			leads[i].Fecha_modificacion_usuario__c = yesterday;
			//Test.setCreatedDate(leads[i].Id, yesterday);
		}
		update leads;
		
        Test.startTest();
        LeadTiempoSinAbrirBatch batch = new LeadTiempoSinAbrirBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();

        System.assertEquals(2, [select count() from Lead where Tiempo_sin_abrir__c = '24 horas']);
        System.assertEquals(2, [select count() from Lead where Tiempo_sin_abrir__c = '48 horas']);
        System.assertEquals(2, [select count() from Lead where Tiempo_sin_abrir__c = '72 horas']);
        System.assertEquals(2, [select count() from Lead where Tiempo_sin_abrir__c = '96 horas']);
		System.assertEquals(2, [select count() from Lead where Tiempo_sin_abrir__c = 'Mas de 96 Horas']);
		
    }
    
}