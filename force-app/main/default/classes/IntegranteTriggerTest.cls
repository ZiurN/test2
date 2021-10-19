@isTest 
private class IntegranteTriggerTest {
	static Account acc;
	static Opportunity opp;

	static {
		acc = Build.anAccountCuentapersonal().build();
		insert acc;

		Account os = Build.anAccountObrasocial().withCodigodeOS('99880').build();
		insert os;

		opp = Build.anOpportunityIndividuos().build();
		opp.AccountId = acc.Id;
		opp.Obra_social_del_titular__c = os.Id;
		opp.Cobertura_anterior__c = os.Id;
		insert opp;
	}

	@isTest
	private static void fillContactInformationFromPersonAccountTest() {
		
		Localidad__c localidad = new Localidad__c();
		localidad.Codigo_Postal__c = '1702';
		insert localidad;

		Localidad__c localidad2 = new Localidad__c();
		localidad2.Codigo_Postal__c = '1234';
		insert localidad2;

		List<Account> accList = new List<Account>{
			Build.anAccountCuentapersonal()
				//.withPhone('1144556677')
				//--------------------------------------------------
				.withEmail('ejemplo@test.com') // Hace falta porque el process de integrante lo pisa con este valor
				//--------------------------------------------------
				.withPrefijo('011')
				.build(),
			Build.anAccountCuentapersonal()
				//.withPhone('1111112222')
				//---------------------------------------------------
				.withEmail('ejemplo2@test.com')
				//---------------------------------------------------
				.withPrefijo('253')
				.build()
		};
		//accList[0].Localidad_new__c = localidad.Id;
		//accList[1].Localidad_new__c = localidad2.Id;
		insert accList;


		Opportunity opp = Build.anOpportunity()
			.withStageName('Contactado')
			//---------------------------------------------------
			.withCodigoPostal('1702')
			//----------------------------------------------------
			.build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.AccountId = accList[0].Id;
		insert opp;

		opp.Telefono__c = '1144556677';
		opp.Correo_Electronico__c = 'ejemplo@test.com';
		opp.Localidad_new__c = localidad.Id;
		update opp;

		System.debug(localidad);
		System.debug(opp);
		Opportunity oppQ = [SELECT Telefono__c, Correo_Electronico__c, AccountId, Localidad_new__c, Localidad_new__r.Codigo_Postal__c FROM Opportunity WHERE Id =: opp.Id];
		System.debug(oppQ);
		System.debug(oppQ.Correo_Electronico__c);

		Opportunity opp2 = Build.anOpportunity()
			.withStageName('Contactado')
			//-----------------------------------------------------
			.withCodigoPostal('1234')
			//-----------------------------------------------------
			.build();
		opp2.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp2.AccountId = accList[1].Id;
		insert opp2;

		opp2.Telefono__c = '1111112222';
		opp2.Correo_Electronico__c = 'ejemplo2@test.com';
		opp2.Localidad_new__c = localidad2.Id;
		update opp2;

		Integrante__c integrante = Build.anIntegrante().withSexo('M').withNroDocumento('24123123')
			.withTipoDeRelacionConTitular('Hijo/a').withTipoDocumento('DNI').withNacionalidad('054')
			.withDiscapacidad('No').withIndicadorDeAporte(true).withNombre('Fulanito')
			.withApellido('Test').withCUIT('20541231235').withFechaNacimiento(Date.today().addYears(-10)).withAportes(1234)
			.withEstadoCivil('S')
			.build();
		integrante.Oportunidad__c = opp.Id;
		Integrante__c integrante2 = Build.anIntegrante().withSexo('M').withNroDocumento('24123124')
			.withTipoDeRelacionConTitular('Hijo/a').withTipoDocumento('DNI').withNacionalidad('054')
			.withDiscapacidad('No').withIndicadorDeAporte(true).withNombre('Fulanito')
			.withApellido('Test').withCUIT('20541231235').withFechaNacimiento(Date.today().addYears(-10)).withAportes(1234)
			.withEstadoCivil('S')
			.build();
		integrante2.Oportunidad__c = opp.Id;
		Integrante__c integrante3 = Build.anIntegrante().withSexo('M').withNroDocumento('24123125')
			.withTipoDeRelacionConTitular('Hijo/a').withTipoDocumento('DNI').withNacionalidad('054')
			.withDiscapacidad('No').withIndicadorDeAporte(true).withNombre('Fulanito')
			.withApellido('Test').withCUIT('20541231235').withFechaNacimiento(Date.today().addYears(-10)).withAportes(1234)
			.withEstadoCivil('S')
			.build();
		integrante3.Oportunidad__c = opp2.Id;
		List<Integrante__c> integrantes = new List<Integrante__c>{integrante, integrante2, integrante3};

		Test.startTest();
		insert integrantes;
		Test.stopTest();

		List<Integrante__c> integrantesToAssert = [SELECT Prefijo__c, Telfono__c, Correo_electronico__c, Codigo_Postal__c
			FROM Integrante__c];
		System.assertEquals('1144556677', integrantesToAssert[0].Telfono__c);
		System.assertEquals('ejemplo@test.com', integrantesToAssert[0].Correo_electronico__c);
		System.assertEquals('1702', integrantesToAssert[0].Codigo_Postal__c);
		System.assertEquals(011, integrantesToAssert[0].Prefijo__c);
		System.assertEquals('1144556677', integrantesToAssert[1].Telfono__c);
		System.assertEquals('ejemplo@test.com', integrantesToAssert[1].Correo_electronico__c);
		System.assertEquals('1702', integrantesToAssert[1].Codigo_Postal__c);
		System.assertEquals(011, integrantesToAssert[1].Prefijo__c);
		System.assertEquals('1111112222', integrantesToAssert[2].Telfono__c);
		System.assertEquals('ejemplo2@test.com', integrantesToAssert[2].Correo_electronico__c);
		System.assertEquals('1234', integrantesToAssert[2].Codigo_Postal__c);
		System.assertEquals(253, integrantesToAssert[2].Prefijo__c);
	}

	@isTest
	public static void validateFields() {
		//Account acc = Build.anAccountCuentapersonal().build();
		//insert acc;

		//Opportunity opp = Build.anOpportunityIndividuos().build();
		//opp.AccountId = acc.Id;
		//insert opp;

		Integrante__c integrante = new Integrante__c();
		integrante.Oportunidad__c = opp.Id;

		Test.startTest();
		Database.SaveResult result = Database.insert(integrante, false);
		Test.stopTest();
		
		System.assert(!result.isSuccess());
	}

	@isTest
	public static void validateFieldsWhenSegmentoIsOBL() { 
		opp.Segmento_del_Grupo_Familiar__c = 'OBLDIR';
		update opp;

		Integrante__c integrante = new Integrante__c();
		integrante.Oportunidad__c = opp.Id;
		integrante.Indicador_de_aporte__c = true;

		Test.startTest();
		Database.SaveResult result = Database.insert(integrante, false);
		Test.stopTest();
		
		System.assert(!result.isSuccess());
	}

	@isTest
	public static void validateFieldsWhenSegmentoIsVOL() {
		opp.Segmento_del_Grupo_Familiar__c = 'VOLDIR';
		update opp;

		Integrante__c integrante = new Integrante__c();
		integrante.Oportunidad__c = opp.Id;

		Test.startTest();
		Database.SaveResult result = Database.insert(integrante, false);
		Test.stopTest();
		
		System.assert(!result.isSuccess());
	}

	@isTest
	private static void validateAccountUpdate(){
		Localidad__c localidad = new Localidad__c();
		localidad.Codigo_Postal__c = '1702';
		insert localidad;

		Localidad__c localidad2 = new Localidad__c();
		localidad2.Codigo_Postal__c = '1234';
		insert localidad2;

		Account integranteAcc = Build.anAccountCuentapersonal()
				//.withPhone('1144556677')
				//--------------------------------------------------
				.withEmail('ejemplo@test.com') // Hace falta porque el process de integrante lo pisa con este valor
				//--------------------------------------------------
				.withPrefijo('011')
				.build();
		integranteAcc.Numero_de_documento__c = '24123123';

		
		insert integranteAcc;


		Opportunity opp = Build.anOpportunity()
			.withStageName('Contactado')
			//---------------------------------------------------
			.withCodigoPostal('1702')
			//----------------------------------------------------
			.build();
		//opp.Segmento_del_Grupo_Familiar__c = 'VOLDIR';
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.AccountId = integranteAcc.Id;
		insert opp;

		opp.Telefono__c = '1144556677';
		opp.Correo_Electronico__c = 'ejemplo@test.com';
		opp.Localidad_new__c = localidad.Id;
		update opp;


		Integrante__c integrante = Build.anIntegrante().withSexo('M').withNroDocumento('24123123')
			.withTipoDeRelacionConTitular('Hijo/a').withTipoDocumento('DNI').withNacionalidad('054')
			.withDiscapacidad('No').withIndicadorDeAporte(true).withNombre('Fulanito')
			.withApellido('Test').withCUIT('20541231235').withFechaNacimiento(Date.today().addYears(-10)).withAportes(1234)
			.withEstadoCivil('S')
			.build();
		integrante.Oportunidad__c = opp.Id;

		insert integrante;

		Test.startTest();
		integrante.Nro_de_asociado__c = '123';
		update integrante;
		Test.stopTest();

		integranteAcc = [SELECT Id, Codigo_de_Afiliado__c FROM Account WHERE Id = :integranteAcc.Id];

		System.assertEquals(integranteAcc.Codigo_de_Afiliado__c, integrante.Nro_de_asociado__c);
	}
}