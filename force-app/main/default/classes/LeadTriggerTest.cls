@isTest 
private class LeadTriggerTest {
	static User u;
	static User u2;
	static User u3;
	static User u4;
	static User u5;

	static {
		
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		String uniqueUserName2 = 'organizador' + DateTime.now().getTime() + '@testorg.com';

		Profile p = [SELECT Id FROM Profile WHERE Name='Administrador del sistema' OR Name = 'System Administrator'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		u = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p.Id,
				TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName,UserRole = role);
		insert u;
		u2 = new User(Alias = 'standt2', Email='standardorg@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p.Id,
				TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName2,UserRole = role);
		insert u2;

				String uniqueUserName3 = 'comercial' + DateTime.now().getTime() + '@testorg.com';

		Profile p2 = [SELECT Id FROM Profile WHERE Name='Agente de Ventas'];
		UserRole role2 = [SELECT Id,Name FROM UserRole WHERE DeveloperName = 'Comercial_AMBA'];
		u3 = new User(Alias = 'standt3', Email='standarduserComercial@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p2.Id,
				TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName3,UserRoleId = role2.Id);
		String uniqueUserName4 = 'orgAMBA' + DateTime.now().getTime() + '@testorg.com';
		UserRole role3 = [SELECT Id,Name FROM UserRole WHERE DeveloperName = 'Org_AMBA'];
		u4 = new User(Alias = 'standt4', Email='standarduserOrgAMBA@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p2.Id,
				TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName4,UserRoleId = role3.Id);

		String uniqueUserName5 = 'orgCS' + DateTime.now().getTime() + '@testorg.com';
		UserRole role4 = [SELECT Id,Name FROM UserRole WHERE DeveloperName = 'Comercial_CS'];
		u5 = new User(Alias = 'standt5', Email='standarduserOrgCS@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p2.Id,
				TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName5,UserRoleId = role4.Id);

		System.runAs(new User(Id=UserInfo.getUserId())){
			insert u3;
			insert u4;
			insert u5;
		}

	}

	@isTest
	private static void fillFieldsInLeadWhenLocalidadAndCodigoPostalAreFilledTest() {
		Lead candidato = Build.aLead()
			.withLocalidad('Ciudadela')
			.withCodigoPostal('1702')
			.build();
		candidato.LeadSource = '2';
		candidato.Phone = '1144445555';
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1702')
			.withCodigoProvincia('B')
			.withOrganizador(UserInfo.getUserId())
			.build();


		System.debug(u.UserRole.Name);
		System.runAs(u) {
			Test.startTest();
			insert loc;
			candidato.Localidad_new__c = loc.Id;
			insert candidato;
			Test.stopTest();
		}

		List<Lead> leadsList = [SELECT LocId__c, OwnerId, Organizador_lookup__c, Provincia__c FROM Lead];
		System.assertEquals('B', leadsList[0].Provincia__c);
		System.assertEquals(UserInfo.getUserId(), leadsList[0].Organizador_lookup__c);
		System.assertEquals(UserInfo.getUserId(), leadsList[0].OwnerId);
	}

	@isTest
	private static void fillFieldsInLeadWhenlocIdIsFilledTest() {
		Lead candidato = Build.aLead()
			.withLocId('123')
			.build();
		candidato.Phone = '1144445555';
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1702')
			.withCodigoProvincia('B')
			.withOrganizador(UserInfo.getUserId())
			.build();
		
		System.runAs(u) {
			Test.startTest();
			insert loc;
			insert candidato;
			Test.stopTest();
		}

		List<Lead> leadsList = [
			SELECT LocId__c, Codigo_postal__c, OwnerId, Organizador_lookup__c, Provincia__c, Localidad_new__c 
			FROM Lead];

		System.assertEquals(loc.Id, leadsList[0].Localidad_new__c);
		System.assertEquals('1702', leadsList[0].Codigo_postal__c);
		System.assertEquals('B', leadsList[0].Provincia__c);
		System.assertEquals(UserInfo.getUserId(), leadsList[0].Organizador_lookup__c);
		System.assertEquals(UserInfo.getUserId(), leadsList[0].OwnerId);
	}

	@isTest
	private static void accAndOppCreationWhenLeadStatusChangedToContactado(){
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1702')
			.withCodigoProvincia('B')
			.withOrganizador(UserInfo.getUserId())
			.build();
			insert loc;
		Account delegacion = new Account(
				Name = 'asdfafas',
				Codigo_de_delegacion__c = '52',
				RecordTypeId = XappiaHelper.getRecordType('Account','Delegacion').Id);
		insert delegacion;
		Account agencia = new Account(
				Name = 'Test',
				Codigo_de_delegacion__c = '42',
				RecordTypeId = XappiaHelper.getRecordType('Account','Delegacion').Id);
		agencia.Type = 'Agencia';
		agencia.Delegacion__c = delegacion.Id;
		insert agencia;
		Lead candidato = Build.aLead()
				.withLocId('123')
				.withTipoDocumento('DNI')
				.withNumeroDocumento('12345678')
				.withCorreoElectronico('test@gmail.com')
				.withGCLID('test')
				.withLeadSource('3')
				.withAgencia(agencia.Id)
				.build();
		candidato.Localidad_new__c = loc.Id;
		candidato.Phone = '1144445555';
		candidato.Canal_de_contacto_Asesor_con_cliente__c = 'Mail';
		candidato.Status = 'Nuevo';
		candidato.RecordTypeId = XappiaHelper.getRecordType('Lead', 'Individuos').Id;
		

		Test.startTest();
		insert candidato;
		candidato.Status = 'Contactado - Interesado';
		update candidato;
		Test.stopTest();

		Account[] createdAccounts = [
				SELECT Id, Name,Estado__c,Tipo_de_documento__c,Numero_de_documento__c,Phone,Correo_electronico__c
				FROM Account
				WHERE RecordTypeId = :XappiaHelper.getRecordType('Account','Cuenta_personal').Id];
		Opportunity[] createdOpportunities = [
			SELECT Id, Provincia__c, GCLID__c, LeadSource, Agencia__c, Codigo_Postal__c,Localidad_new__c,Telefono__c
			FROM Opportunity
			];

		System.assertEquals(1, createdAccounts.size());
		System.assertEquals(1, createdOpportunities.size());

		Lead updatedLead = [SELECT Id,IsConverted FROM Lead WHERE Id = :candidato.Id];
		System.assertEquals(true,updatedLead.IsConverted);

		System.assertEquals(candidato.LastName,createdAccounts[0].Name);
		System.assertEquals(candidato.Tipo_de_Documento__c, createdAccounts[0].Tipo_de_documento__c);
		//System.assertEquals(candidato.Nro_de_Documento__c, Decimal.valueOf(createdAccounts[0].Numero_de_documento__c));
		System.assertEquals(candidato.Email, createdAccounts[0].Correo_electronico__c);
		System.assertEquals(candidato.Phone, createdAccounts[0].Phone);

		//System.assertEquals(candidato.Provincia__c, createdOpportunities[0].Provincia__c);
		System.assertEquals(candidato.GCLID__c, createdOpportunities[0].GCLID__c);
		System.assertEquals(candidato.LeadSource, createdOpportunities[0].LeadSource);
		System.assertEquals(candidato.Agencia__c, createdOpportunities[0].Agencia__c);
		System.assertEquals(candidato.Localidad_new__c,createdOpportunities[0].Localidad_new__c);
		System.assertEquals(candidato.Phone,createdOpportunities[0].Telefono__c);

	}

	@IsTest
	private static void getOrganizadorUsingCPAndProvLeadCorp(){
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1884')
			.withCodigoProvincia('S')
			.withOrganizador(u2.Id)
			.build();
		insert loc;
		Lead cand = Build.aLead().withCodigoPostal('1884').build();
		cand.Provincia__c = 'S';
		cand.LeadSource = '0';
		cand.RecordTypeId = XappiaHelper.getRecordType('Lead','Corporativo').Id;
		cand.Localidad_new__c = loc.Id;
		cand.Phone = '1234567890';
		Test.startTest();
		insert cand;
		Test.stopTest();
		Lead updatedCand = [SELECT Organizador_lookup__c,OwnerId,Localidad_new__c FROM Lead WHERE Id = :cand.Id];
		System.assertEquals(u2.Id,updatedCand.Organizador_lookup__c);
		//System.assertEquals(u2.Id,updatedCand.OwnerId);
		System.assertEquals(loc.Id,updatedCand.Localidad_new__c);
	}

	//Cambio la logica. Rever quien se asocia como propietario del lead en corporativo
	@IsTest
	private static void getOrganizadorUsingLocId(){
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1077CFE')
			.withCodigoProvincia('B')
			.withOrganizador(u2.Id)
			.build();
		loc.ZG_Codigo__c = 'ZN_3';
		insert loc;
		Lead cand = Build.aLead().withCodigoPostal('1884').build();
		cand.LocId__c = '123';
		cand.LeadSource = '3';
		cand.Phone = '1234567890';
		cand.RecordTypeId = XappiaHelper.getRecordType('Lead','Corporativo').Id;
		Test.startTest();
		insert cand;
		Test.stopTest();
		Lead updatedCand = [SELECT Organizador_lookup__c,OwnerId,Localidad_new__c,Provincia__c,Zona_Geografica__c,Codigo_postal__c FROM Lead WHERE Id = :cand.Id];
		System.assertEquals(u2.Id,updatedCand.Organizador_lookup__c);
		UserRole role = [SELECT Id,Name FROM UserRole WHERE DeveloperName = 'Jefe_Canal_Empresa'];
		User[] jefe_canal_empresa = [
			SELECT Id
			FROM User
			WHERE UserRoleId = :role.Id
		];
		if(!jefe_canal_empresa.isEmpty()){
			System.assertEquals(jefe_canal_empresa[0].Id, updatedCand.OwnerId);
		}
		System.assertEquals(loc.Id,updatedCand.Localidad_new__c);
		System.assertEquals('B',updatedCand.Provincia__c);
		System.assertEquals('ZN_3',updatedCand.Zona_Geografica__c);
		System.assertEquals('1077CFE',updatedCand.Codigo_postal__c);
	}

	@IsTest
	private static void canChangeLocIfUserIsInRoleHierarchy(){
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1884')
			.withCodigoProvincia('S')
			.withOrganizador(u4.Id)
			.build();
		insert loc;
		Localidad__c loc2 = Build.aLocalidad()
			.withLocId('1234')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1884')
			.withCodigoProvincia('S')
			.withOrganizador(u4.Id)
			.build();
		insert loc2;
		Lead cand = Build.aLead().withCodigoPostal('1884').build();
		cand.Provincia__c = 'S';
		cand.LeadSource = '0';
		cand.RecordTypeId = XappiaHelper.getRecordType('Lead','Individuos').Id;
		cand.Localidad_new__c = loc2.Id;
		cand.Phone = '1234567890';
		insert cand;
		System.runAs(u4){		

			Test.startTest();
			cand.Localidad_new__c = loc.Id;
			cand.Motivo_de_No_interes__c = 'Otros';
			cand.Otro_motivo_de_no_interes__c = 'test';
			cand.Status = 'Contactado - No Interesado';
			cand.Canal_de_contacto_Asesor_con_cliente__c = 'Telefono';
			update cand;
			Test.stopTest();
		}
		System.assertEquals(loc.Id,cand.Localidad_new__c);
	}

	@IsTest
	private static void canChangeOwnerIfUserIsInRoleHierarchy(){
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1884')
			.withCodigoProvincia('S')
			.withOrganizador(u4.Id)
			.build();
		insert loc;
		Lead cand = Build.aLead().withCodigoPostal('1884').build();
		cand.Provincia__c = 'S';
		cand.LeadSource = '0';
		cand.RecordTypeId = XappiaHelper.getRecordType('Lead','Individuos').Id;
		cand.Localidad_new__c = loc.Id;
		cand.Phone = '1234567890';
		System.runAs(u4){		
			insert cand;
			Test.startTest();
			cand.OwnerId = u3.Id;
			cand.Motivo_de_No_interes__c = 'Otros';
			cand.Otro_motivo_de_no_interes__c = 'test';
			cand.Status = 'Contactado - No Interesado';
			cand.Canal_de_contacto_Asesor_con_cliente__c = 'Telefono';
			update cand;
			Test.stopTest();
		}
		System.assertEquals(u3.Id, cand.OwnerId);
	}

	@IsTest
	private static void cantChangeOwnerIfUserIsNotInRoleHierarchy(){
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1884')
			.withCodigoProvincia('S')
			.withOrganizador(u4.Id)
			.build();
		insert loc;
		Lead cand = Build.aLead().withCodigoPostal('1884').build();
		cand.Provincia__c = 'S';
		cand.LeadSource = '0';
		cand.RecordTypeId = XappiaHelper.getRecordType('Lead','Individuos').Id;
		cand.Localidad_new__c = loc.Id;
		cand.Phone = '1234567890';
		Database.SaveResult res;
		System.debug(u5.Id);
		System.runAs(u4){		
			insert cand;
			Test.startTest();
			cand.OwnerId = u5.Id;
			cand.Motivo_de_No_interes__c = 'Otros';
			cand.Otro_motivo_de_no_interes__c = 'test';
			cand.Status = 'Contactado - No Interesado';
			cand.Canal_de_contacto_Asesor_con_cliente__c = 'Telefono';
			res = Database.update(cand,false);
			Test.stopTest();
		}
		cand = [SELECT Id, OwnerId FROM Lead WHERE Id = :cand.Id];
		System.assertEquals(false, res.isSuccess());
		System.assertEquals(u4.Id, cand.OwnerId);
	}

	@isTest
	private static void whenStatusIsInteresadoAndMovilFieldIsComplete_CopyThatFieldInPhoneInOppAndAcc() {
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1702')
			.withCodigoProvincia('B')
			.withOrganizador(UserInfo.getUserId())
			.build();
			insert loc;
		Account delegacion = new Account(
				Name = 'asdfafas',
				Codigo_de_delegacion__c = '52',
				RecordTypeId = XappiaHelper.getRecordType('Account','Delegacion').Id);
		insert delegacion;
		Account agencia = new Account(
				Name = 'Test',
				Codigo_de_delegacion__c = '42',
				RecordTypeId = XappiaHelper.getRecordType('Account','Delegacion').Id);
		agencia.Type = 'Agencia';
		agencia.Delegacion__c = delegacion.Id;
		insert agencia;
		Lead candidato = Build.aLead()
				.withLocId('123')
				.withTipoDocumento('DNI')
				.withNumeroDocumento('12345678')
				.withCorreoElectronico('test@gmail.com')
				.withGCLID('test')
				.withLeadSource('3')
				.withAgencia(agencia.Id)
				.build();
		candidato.Localidad_new__c = loc.Id;
		candidato.MobilePhone = '1144445555';
		candidato.Phone = null;
		candidato.Canal_de_contacto_Asesor_con_cliente__c = 'Mail';
		candidato.Status = 'Nuevo';
		candidato.RecordTypeId = XappiaHelper.getRecordType('Lead', 'Individuos').Id;
		insert candidato;

		Test.startTest();
		candidato.Status = 'Contactado - Interesado';
		update candidato;
		Test.stopTest();

		Account acc = [SELECT Id, Phone, Tipo_de_Telefono__c FROM Account WHERE RecordType.DeveloperName = 'Cuenta_personal'];
		System.assertEquals(candidato.MobilePhone, acc.Phone);
		System.assertEquals('CEL', acc.Tipo_de_Telefono__c);
		
		Opportunity opp = [SELECT Id, Telefono__c, Tipo_de_Telefono__c FROM Opportunity];
		System.assertEquals(candidato.MobilePhone, opp.Telefono__c);
		System.assertEquals('CEL', opp.Tipo_de_Telefono__c);

	}
}