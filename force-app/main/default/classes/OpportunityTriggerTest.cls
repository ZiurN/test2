@isTest 
private class OpportunityTriggerTest {

	static XHttpCalloutMock getResponseFound;
	static User u3;
	static User u4;
	static User u5;
	static User userFront;
    
	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');


			
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

        String uniqueUserName6 = 'orgFRONT' + DateTime.now().getTime() + '@testorg.com';
       	UserRole role5 = [SELECT Id,Name FROM UserRole WHERE DeveloperName = 'Comercial_AMBA'];

        userFront = new User(Alias = 'standt6', Email='standarduserOrgCS@testorg.com',
				EmailEncodingKey='UTF-8', LastName='FrontTest', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p2.Id,
				TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName6,UserRoleId = role5.Id);
        
		System.runAs(new User(Id=UserInfo.getUserId())){
			insert u3;
			insert u4;
			insert u5;
            insert userFront;
		}
	}

	@isTest
	private static void addAccountToOpportunityWithRecordTypeIndividualCorporativo() {
		Account acc = Build.anAccount().build();
		insert acc;
		Opportunity opp = Build.anOpportunity().build();
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Corporativo').Id;
		opp.AccountId = acc.Id;
		insert opp;
		Opportunity oportunidadIndividualCorporativa = Build.anOpportunity().build();
		oportunidadIndividualCorporativa.Tipo_de_Solicitud__c = 'REINGRESO';
		oportunidadIndividualCorporativa.RecordTypeId = XappiaHelper.getRecordType(
			'Opportunity', 'Individual_Corporativo').Id;
		oportunidadIndividualCorporativa.Numero_de_documento__c = '78945612';
		oportunidadIndividualCorporativa.Oportunidad_Corporativa__c = opp.Id;

		Test.startTest();
		insert oportunidadIndividualCorporativa;
		Test.stopTest();

		Opportunity opportunityToAssert = [
			SELECT AccountId 
			FROM Opportunity 
			WHERE Id = :oportunidadIndividualCorporativa.Id
		];
		System.assertEquals(opp.AccountId, opportunityToAssert.AccountId);
	}

	//@IsTest
	//private static void getNroAsociadoForIntegrantesWhenOpportunityChangesToClosedWin(){
		//Test.setMock(HttpCalloutMock.class, getResponseFound);

		//Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		//acc.Phone = '2643972015';
		//acc.Correo_electronico__c = 'correo@test.com';
		//acc.Prefijo__c = '011';
		//acc.Type = 'Titular';
		//insert acc;

        //Account accObraSocial = new Account(RecordTypeId = XappiaHelper.getRecordType('Account', 'Obra_social').Id);
		//accObraSocial.Name = 'Test ObraSocial';
		//insert accObraSocial;

		//Account accObraSocialAnterior = new Account(RecordTypeId = XappiaHelper.getRecordType('Account', 'Obra_social').Id);
		//accObraSocialAnterior.Name = 'Test ObraSocial';
		//insert accObraSocialAnterior;

		//Opportunity testOpp = new Opportunity();
		//testOpp.AccountId = acc.Id;
		//testOpp.Name = 'opp test';
		//testOpp.StageName = 'Contrato Generado';
		//testOpp.CloseDate = Date.today();
		//insert testOpp;

		//Integrante__c int1 = new Integrante__c(
            //Apellido__c = 'Apellido integrante',
			//Nombre__c = 'Nombre integrante',
			//Oportunidad__c = testOpp.Id,
			//Fecha_de_Nacimiento__c = Date.newInstance(1999, 4, 30),
			//Tipo_de_Documento__c = 'DNI',
			//Nro_de_documento__c = '14657',
			//CUIT_Sin_guiones__c = '20380792258',
			//Sexo__c = 'M',
			//Cobertura_anterior__c = accObraSocialAnterior.Id,
			//Estado_Civil__c = 'C',
			//Obra_social_actual__c = accObraSocial.Id,
			//Aportes__c = 1000.50,
			//Tipo_de_relacion_con_titular__c = 'Hijo/a',
            //Nacionalidad__c = '054',
            //Discapacitado__c = 'No',
			//Correo_electronico__c = 'ej@test.com'
		//);
		//insert int1;

		//Integrante__c int2 = new Integrante__c(
        	//Apellido__c = 'Apellido integrante2',
			//Nombre__c = 'Nombre integrante2',
			//Oportunidad__c = testOpp.Id,
			//Fecha_de_Nacimiento__c = Date.newInstance(1999, 4, 30),
			//Tipo_de_Documento__c = 'DNI',
			//Nro_de_documento__c = '14658',
			//CUIT_Sin_guiones__c = '20380792258',
			//Sexo__c = 'M',
			//Cobertura_anterior__c = accObraSocialAnterior.Id,
			//Estado_Civil__c = 'C',
			//Obra_social_actual__c = accObraSocial.Id,
			//Aportes__c = 1000.50,
			//Tipo_de_relacion_con_titular__c = 'Hijo/a',
            //Nacionalidad__c = '054',
            //Discapacitado__c = 'No',
			//Correo_electronico__c = 'ej2@test.com'
		//);
		//insert int2;

		//Test.startTest();
		//testOpp.StageName = 'Cerrada ganada';
		//testOpp.Nro_de_asociado__c = '123456/12';
		////testOpp.Nro_de_precarga__c = '123456';
		//testOpp.Nro_de_solicitud__c = '12345678';
		//testOpp.Cambio_Manual__c = false;
		//update testOpp;
		//Test.stopTest();

		//Integrante__c updatedInteg = [SELECT Id,Nro_de_asociado__c FROM Integrante__c WHERE Id = :int1.Id];
		//Integrante__c updatedInteg2 = [SELECT Id,Nro_de_asociado__c FROM Integrante__c WHERE Id = :int2.Id];

		//System.assertEquals('599997/01',updatedInteg.Nro_de_asociado__c);
		//System.assertEquals('599998/01',updatedInteg2.Nro_de_asociado__c);

	//}

	@isTest
	private static void AccCreationWhenOpportunityWithRecordTypeIndividualCorporativoStageNameChangedToClosedWin() {
		Opportunity opp = Build.anOpportunity().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Corporativo').Id;
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		insert opp;
		Opportunity oportunidadIndividualCorporativa = Build.anOpportunity().build();
		oportunidadIndividualCorporativa.RecordTypeId = XappiaHelper.getRecordType(
			'Opportunity', 'Individual_Corporativo').Id;
		oportunidadIndividualCorporativa.Tipo_de_Solicitud__c = 'REINGRESO';
		oportunidadIndividualCorporativa.Name = 'Opp test';
		oportunidadIndividualCorporativa.CloseDate = Date.today();
		oportunidadIndividualCorporativa.StageName = 'En Edición';
		oportunidadIndividualCorporativa.Oportunidad_Corporativa__c = opp.Id;
		oportunidadIndividualCorporativa.Nombre_INDCORP__c= 'Nombre prueba';
		oportunidadIndividualCorporativa.Apellido_INDCOR__c = 'Apellido prueba';
		oportunidadIndividualCorporativa.Fecha_de_Nacimiento__c = Date.newInstance(1980, 2, 17);
		oportunidadIndividualCorporativa.Tipo_de_Documento__c = 'DNI';
		oportunidadIndividualCorporativa.Numero_de_documento__c = '38079225';
		oportunidadIndividualCorporativa.CUIT__c = '20380792258';
		oportunidadIndividualCorporativa.Estado_Civil__c = 'D';
		oportunidadIndividualCorporativa.Sexo__c = 'F';
		oportunidadIndividualCorporativa.Tipo_de_Solicitud__c = 'ALTA';
		insert oportunidadIndividualCorporativa;


		Test.startTest();
		oportunidadIndividualCorporativa.Nro_de_asociado__c = '123456';
		oportunidadIndividualCorporativa.StageName = 'Cerrada ganada';
		update oportunidadIndividualCorporativa;
		Test.stopTest();

		Opportunity oportunidad = [
			SELECT Id, Name, AccountId,Numero_de_documento__c
			FROM Opportunity
			WHERE Name = 'Opp test'
		];

		Account accountToAssert = [
			SELECT  Id, FirstName, LastName, PersonBirthdate, Tipo_de_documento__c, Numero_de_documento__c, CUIT__c, Estado_civil__c, Sexo__c
			FROM Account 
			WHERE Numero_de_documento__c = :oportunidad.Numero_de_documento__c
		];

		Date dateForAssert = Date.newInstance(1980, 2, 17);

		System.assertEquals('Nombre prueba', accountToAssert.FirstName);
		System.assertEquals('Apellido prueba', accountToAssert.LastName);
		System.assertEquals(dateForAssert, accountToAssert.PersonBirthdate);
		System.assertEquals('DNI', accountToAssert.Tipo_de_documento__c);
		System.assertEquals('38079225', accountToAssert.Numero_de_documento__c);
		System.assertEquals('20380792258', accountToAssert.CUIT__c);
		System.assertEquals('D', accountToAssert.Estado_civil__c);
		System.assertEquals('F', accountToAssert.Sexo__c);

	}

	@IsTest
	static void GrupoFamiliarCreationWhenOpportunityWithRecordTypeIndividuosStageNameChangesToClosedWin(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Type = 'TIT';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		acc.Codigo_de_Afiliado__c = '69782';
		insert acc;

		Opportunity opp = Build.anOpportunity().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.Name = 'Opp test';
		opp.CloseDate = Date.today();
		opp.Nro_de_asociado__c = '123123';
		opp.StageName = 'En Edición';
		opp.Codigo_Postal__c = '1234';
		opp.AccountId = acc.Id;
		insert opp;

		Account accObraSocial = new Account(RecordTypeId = XappiaHelper.getRecordType('Account', 'Obra_social').Id);
		accObraSocial.Name = 'Test ObraSocial';
		insert accObraSocial;

		Account accObraSocialAnterior = new Account(RecordTypeId = XappiaHelper.getRecordType('Account', 'Obra_social').Id);
		accObraSocialAnterior.Name = 'Test ObraSocial';
		insert accObraSocialAnterior;

		Integrante__c integrante = new Integrante__c(
			Apellido__c = 'Apellido integrante',
			Nombre__c = 'Nombre integrante',
			Oportunidad__c = opp.Id,
			Fecha_de_Nacimiento__c = Date.newInstance(1999, 4, 30),
			Tipo_de_Documento__c = 'DNI',
			Nro_de_documento__c = '14657',
			CUIT_Sin_guiones__c = '20380792258',
			Sexo__c = 'M',
			Cobertura_anterior__c = accObraSocialAnterior.Id,
			Estado_Civil__c = 'C',
			Obra_social_actual__c = accObraSocial.Id,
			Indicador_de_aporte__c = true,
			Aportes__c = 1000.50,
			Tipo_de_relacion_con_titular__c = 'HI',
            Nacionalidad__c = '054',
            Discapacitado__c = 'No',
			Correo_electronico__c = 'ej@test.com'
		);
		insert integrante;

		Test.startTest();
		opp.StageName = 'Cerrada ganada';
		//opp.Nro_de_precarga__c = '123456';
		opp.Nro_de_solicitud__c = '12345678';
		update opp;
		Test.stopTest();

		Account accToAssert = [
			SELECT  Id, LastName, FirstName, Phone, Correo_electronico__c, CUIT__c, Parentesco__c
			FROM Account 
			WHERE LastName = 'Apellido integrante'
		];

		Grupo_Familiar__c grupoFamiliarToAssert = [
			SELECT Id, Integrante__c, Relacion_con_el_titular__c, Titular_del_Grupo_Familiar__c, Nro_de_socio_del_titular__c
			FROM Grupo_Familiar__c
			WHERE Integrante__c = :accToAssert.Id
		];

		System.assertEquals('Apellido integrante', accToAssert.LastName);
		System.assertEquals('Nombre integrante', accToAssert.FirstName);
		System.assertEquals('2643972015', accToAssert.Phone);
		System.assertEquals('ej@test.com', accToAssert.Correo_electronico__c);
		System.assertEquals('20380792258', accToAssert.CUIT__c);
		System.assertEquals('HI', accToAssert.Parentesco__c);
		System.assertEquals('HI', grupoFamiliarToAssert.Relacion_con_el_titular__c);
		System.assertEquals(acc.Id, grupoFamiliarToAssert.Titular_del_Grupo_Familiar__c);
		System.assertEquals('69782', grupoFamiliarToAssert.Nro_de_socio_del_titular__c);

		Id rt = acc.RecordTypeId;
		List<Account> listAcc = [SELECT Id, Titular__c, Name, CUIT__c  FROM Account WHERE RecordTypeId =: rt];
		System.debug('****listAccCant: ' + listAcc.size());
		System.debug('****listAcc: ' + listAcc);
	}

	@IsTest
	static void whenStageNamePassToEnTramitacion_ShowErrorFields() {
		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;

		Opportunity opp = Build.anOpportunity().build();
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.Name = 'Opp test';
		opp.CloseDate = Date.today();
		opp.StageName = 'En Edición';
		opp.AccountId = acc.Id;
		insert opp;
		opp.StageName = 'En tramitación';

		Test.startTest();
		Database.SaveResult result = Database.update(opp, false); 
		Test.stopTest();

		System.debug(result);
	}

	@IsTest
	static void whenStageNamePassToEnTramitacion_ShowErrorsInSomeFields() {
		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;

		Opportunity opp = Build.anOpportunity().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.Name = 'Opp test';
		opp.CloseDate = Date.today();
		opp.StageName = 'En Edición';
		opp.AccountId = acc.Id;
		opp.Estado_Civil__c = 'C';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.Medio_de_cobro__c = 'Tarjeta';
		insert opp;
		opp.StageName = 'En tramitación';

		Test.startTest();
		Database.SaveResult result = Database.update(opp, false); 
		Test.stopTest();

		System.debug(result);
	}

	@IsTest
	static void whenStageNamePassToEnTramitacion_ShowErrorInFieldNroCBUParaCobroDeCuota() {
		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;

		Opportunity opp = Build.anOpportunity().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		//opp.Name = 'Opp test';
		//opp.CloseDate = Date.today();
		opp.StageName = 'En Edición';
		opp.AccountId = acc.Id;
		opp.Medio_de_cobro__c = 'CBU';
		opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
		opp.Tipo_CBU__c = 'CBUFR';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.CUIL_del_CBU__c = '20123456786';
		insert opp;
		opp.StageName = 'En tramitación';

		Test.startTest();
		Database.SaveResult result = Database.update(opp, false); 
		Test.stopTest();

		System.debug(result);
	}

	@IsTest
	static void whenEstadoSolicitudChangedToTransformadaAndNroAsociadoIsComplete_ActivateTheAcc() {
		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;

		Account os = Build.anAccountObrasocial().withCodigoDeOS('74123').build();
		insert os;

		Account agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('50123').build();
		insert agencia;

		Opportunity testOpp = Build.anOpportunityIndividuos().build();
		testOpp.AccountId = acc.Id;
		testOpp.Name = 'opp test';
		testOpp.Tipo_de_solicitud__c = 'REINGRESO';
		testOpp.StageName = 'Contactado';
		//testOpp.Nro_de_precarga__c = '123123';
		testOpp.Nro_de_solicitud__c = '12345678';
		testOpp.CloseDate = Date.today().addDays(15);
		//testOpp.Cambio_Manual__c = false;
		testOpp.Nacionalidad__c = '054';
		testOpp.Sexo__c = 'M';
		testOpp.Telefono__c='4226505185';
		testOpp.Obra_social_del_titular__c = os.Id;
		testOpp.Fecha_de_Nacimiento__c = Date.today();
		testOpp.CUIT__c = '20342223339';
		testOpp.Agencia__c = agencia.Id;
		testOpp.ActividadProfesion_del_titular__c = 'COM';
		testOpp.Estado_Civil__c = 'S';
		testOpp.Segmento_del_Grupo_Familiar__c = 'VOLDIR';

		//acc.Codigo_pais__c = opp.Nacionalidad__c;
		//acc.Sexo__c = opp.Sexo__c == 'M' ? 'M' : opp.Sexo__c == 'F' ? 'F' : null;
		//acc.Obra_social__c = opp.Obra_social_del_titular__c;
		//acc.PersonBirthdate = opp.Fecha_de_Nacimiento__c;
		//acc.CUIT__c = opp.CUIT__c;
		//acc.Delegacion__c = opp.Agencia__c;
		//Map<String, String> fieldProfesion = XappiaHelper.getPicklistLabelAndValues('Opportunity', 'ActividadProfesion_del_titular__c');
		//acc.Actividad_codigo__c = opp.ActividadProfesion_del_titular__c;
		//acc.Actividad_nombre__c = fieldProfesion.get(opp.ActividadProfesion_del_titular__c);
		//acc.Estado_civil__c = seleccionarEstadoCivil(opp.Estado_Civil__c);

		insert testOpp;

		Cotizacion__c cotizacion = new Cotizacion__c();
		cotizacion.Oportunidad__c = testOpp.Id;
		cotizacion.CP__c = '7102';
		insert cotizacion;

		testOpp.StageName = 'Cotizado';
		update testOpp;

		Test.startTest();
		testOpp.StageName = 'Cerrada ganada';// 'En tramitación'
		testOpp.Cotizacion_elegida__c = cotizacion.Id;
		testOpp.Nro_de_asociado__c= '123456';
		testOpp.Estado_de_solicitud__c = 'Transformada';
		testOpp.CloseDate = Date.today();
		testOpp.Cambio_Manual__c = false;
		update testOpp;
		Test.stopTest();

		Account accFromQuery = [
			SELECT Codigo_de_Afiliado__c, Sexo__c, Obra_social__c, PersonBirthdate, CUIT__c, Delegacion__c,
				Actividad_codigo__c, Actividad_nombre__c, Estado_civil__c, Estado__c, Segmento_de_grupo_familiar__c
			FROM Account
			WHERE Id =: acc.Id
		];
		System.assertEquals('123456', accFromQuery.Codigo_de_Afiliado__c);
		//System.assertEquals('054', accFromQuery.Codigo_pais__c);
		System.assertEquals('M', accFromQuery.Sexo__c);
		System.assertEquals(os.Id, accFromQuery.Obra_social__c);
		System.assertEquals(Date.today(), accFromQuery.PersonBirthdate);
		System.assertEquals('20342223339', accFromQuery.CUIT__c);
		System.assertEquals(agencia.Id, accFromQuery.Delegacion__c);
		//System.assertEquals('COM', accFromQuery.Actividad_codigo__c);
		//System.assertEquals('Comerciante', accFromQuery.Actividad_nombre__c);
		System.assertEquals('S', accFromQuery.Estado_civil__c);
		//System.assertEquals('A', accFromQuery.Estado__c);
		System.assertEquals('VOLDIR', accFromQuery.Segmento_de_grupo_familiar__c);
		Opportunity oppQuery = [SELECT Cambio_Manual__c FROM Opportunity WHERE Id =: testOpp.Id];
		System.assertEquals(true, oppQuery.Cambio_Manual__c);
	}

	@IsTest
	static void copyPasteDataFromAccountToOpportunity() {
		Account os = Build.anAccountObrasocial().withCodigoDeOS('74123').build();
		insert os;

		Account agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('50123').build();
		insert agencia;

		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		//acc.Codigo_pais__c = '054';
		acc.Sexo__c = 'M';
		acc.Obra_social__c = os.Id;
		acc.PersonBirthdate = Date.today().addYears(-30);
		acc.CUIT__c = '20342223339';
		acc.Delegacion__c = agencia.Id;
		acc.Actividad_codigo__c = 'COM';
		acc.Actividad_nombre__c = 'Comerciante';
		acc.Estado_civil__c = 'S';
		acc.PersonEmail = 'ej@test.com';
		acc.Type = 'TIT';
		//----------------------------
		acc.Tipo_de_documento__c = 'DNI';
		acc.Numero_de_documento__c = '34111222';


		insert acc;

		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.StageName = 'Contactado';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.AccountId = acc.Id;
		opp.Sexo__c = 'M';

		Test.startTest();
		insert opp;
		Test.stopTest();

		Opportunity oppFromQuery = [
			SELECT Id, Tipo_de_Documento__c, Obra_social_del_titular__c, Nacionalidad__c, Sexo__c, Fecha_de_Nacimiento__c,
				CUIT__c, Agencia__c, ActividadProfesion_del_titular__c, Estado_Civil__c, Telefono__c, Correo_Electronico__c,
				Numero_de_documento__c
			FROM Opportunity
			WHERE Id =: opp.Id
		];

		System.assertEquals('34111222', oppFromQuery.Numero_de_documento__c);
		System.assertEquals('ej@test.com', oppFromQuery.Correo_Electronico__c);
		System.debug('oppFromQuery' + oppFromQuery);
		System.assertEquals('DNI', oppFromQuery.Tipo_de_Documento__c);
		System.assertEquals(os.Id, oppFromQuery.Obra_social_del_titular__c);
		//System.assertEquals('054', oppFromQuery.Nacionalidad__c);
		System.assertEquals('M', oppFromQuery.Sexo__c);
		System.assertEquals('2643972015', oppFromQuery.Telefono__c);
		System.assertEquals(acc.PersonBirthdate, oppFromQuery.Fecha_de_Nacimiento__c);
		System.assertEquals('20342223339', oppFromQuery.CUIT__c);
		System.assertEquals(agencia.Id, oppFromQuery.Agencia__c);
		//System.assertEquals('DNI', oppFromQuery.ActividadProfesion_del_titular__c);
		System.assertEquals('S', oppFromQuery.Estado_Civil__c);

	}

	@IsTest
	static void canAssignLocIfUserIsInRoleHierarchy() {
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1884')
			.withCodigoProvincia('S')
			.withOrganizador(u4.Id)
			.build();
		insert loc;
		Account os = Build.anAccountObrasocial().withCodigoDeOS('74123').build();
		insert os;

		Account agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('50123').build();
		insert agencia;

		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		//acc.Codigo_pais__c = '054';
		acc.Sexo__c = 'M';
		acc.Obra_social__c = os.Id;
		acc.PersonBirthdate = Date.today().addYears(-30);
		acc.CUIT__c = '20342223339';
		acc.Delegacion__c = agencia.Id;
		acc.Actividad_codigo__c = 'COM';
		acc.Actividad_nombre__c = 'Comerciante';
		acc.Estado_civil__c = 'S';
		acc.PersonEmail = 'ej@test.com';
		acc.Type = 'TIT';
		//----------------------------
		acc.Tipo_de_documento__c = 'DNI';
		acc.Numero_de_documento__c = '34111222';


		insert acc;

		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.StageName = 'Contactado';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.Localidad_new__c = loc.Id;
		opp.AccountId = acc.Id;

		System.runAs(u3){
			Test.startTest();
			insert opp;
			Test.stopTest();
		}

		System.assertEquals(1, [SELECT COUNT() FROM Opportunity]);

	}

	@IsTest
	static void cantAssignLocIfUserIsNotInRoleHierarchy() {
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1884')
			.withCodigoProvincia('S')
			.withOrganizador(u4.Id)
			.build();
		insert loc;
		Account os = Build.anAccountObrasocial().withCodigoDeOS('74123').build();
		insert os;

		Account agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('50123').build();
		insert agencia;

		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		//acc.Codigo_pais__c = '054';
		acc.Sexo__c = 'M';
		acc.Obra_social__c = os.Id;
		acc.PersonBirthdate = Date.today().addYears(-30);
		acc.CUIT__c = '20342223339';
		acc.Delegacion__c = agencia.Id;
		acc.Actividad_codigo__c = 'COM';
		acc.Actividad_nombre__c = 'Comerciante';
		acc.Estado_civil__c = 'S';
		acc.PersonEmail = 'ej@test.com';
		acc.Type = 'TIT';
		//----------------------------
		acc.Tipo_de_documento__c = 'DNI';
		acc.Numero_de_documento__c = '34111222';


		insert acc;

		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.StageName = 'Contactado';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.Localidad_new__c = loc.Id;
		opp.AccountId = acc.Id;

		System.runAs(u5){
			Test.startTest();
			Database.SaveResult res = Database.insert(opp,false);
			Test.stopTest();
		}

		System.assertEquals(0, [SELECT COUNT() FROM Opportunity]);


	}

	@IsTest
	static void cantChangeOwnerIfUserIsNotInRoleHierarchy() {

		Account os = Build.anAccountObrasocial().withCodigoDeOS('74123').build();
		insert os;

		Account agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('50123').build();
		insert agencia;

		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		//acc.Codigo_pais__c = '054';
		acc.Sexo__c = 'M';
		acc.Obra_social__c = os.Id;
		acc.PersonBirthdate = Date.today().addYears(-30);
		acc.CUIT__c = '20342223339';
		acc.Delegacion__c = agencia.Id;
		acc.Actividad_codigo__c = 'COM';
		acc.Actividad_nombre__c = 'Comerciante';
		acc.Estado_civil__c = 'S';
		acc.PersonEmail = 'ej@test.com';
		acc.Type = 'TIT';
		//----------------------------
		acc.Tipo_de_documento__c = 'DNI';
		acc.Numero_de_documento__c = '34111222';


		insert acc;

		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.StageName = 'Contactado';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.AccountId = acc.Id;
		Database.SaveResult res;
		System.runAs(u5){
			insert opp;
			Test.startTest();
			opp.OwnerId = u4.Id;
			res = Database.update(opp,false);
			Test.stopTest();
		}
		opp = [
			SELECT Id, OwnerId
			FROM Opportunity
			WHERE Id = :opp.Id
		];
		System.assertEquals(u5.Id, opp.OwnerId);


	}

		@IsTest
	static void canChangeOwnerIfUserIsInRoleHierarchy() {

		Account os = Build.anAccountObrasocial().withCodigoDeOS('74123').build();
		insert os;

		Account agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('50123').build();
		insert agencia;

		Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		//acc.Codigo_pais__c = '054';
		acc.Sexo__c = 'M';
		acc.Obra_social__c = os.Id;
		acc.PersonBirthdate = Date.today().addYears(-30);
		acc.CUIT__c = '20342223339';
		acc.Delegacion__c = agencia.Id;
		acc.Actividad_codigo__c = 'COM';
		acc.Actividad_nombre__c = 'Comerciante';
		acc.Estado_civil__c = 'S';
		acc.PersonEmail = 'ej@test.com';
		acc.Type = 'TIT';
		//----------------------------
		acc.Tipo_de_documento__c = 'DNI';
		acc.Numero_de_documento__c = '34111222';


		insert acc;

		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.StageName = 'Contactado';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.AccountId = acc.Id;
		Database.SaveResult res;
		System.runAs(u4){
			insert opp;
			Test.startTest();
			opp.OwnerId = u3.Id;
			res = Database.update(opp,false);
			Test.stopTest();
		}
		opp = [
			SELECT Id, OwnerId
			FROM Opportunity
			WHERE Id = :opp.Id
		];
		System.debug(res);
		System.assertEquals(u3.Id, opp.OwnerId);


	}

	@IsTest
	private static void testEstadoDDJJValidations(){
				Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u3){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			update opp;

			Test.startTest();
			opp.Nombre_INDCORP__c = 'Cambio';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(true, res.isSuccess());
	}

    @IsTest
	private static void testEstadoDDJJValidationsWithFrontProfile(){
				Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(userFront){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			update opp;

			Test.startTest();
			opp.Nombre_INDCORP__c = 'Cambio';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(true, res.isSuccess());
	}

	@IsTest
	private static void testEstadoDDJJValidationsComercial(){
				Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u3){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			opp.CUIL_del_CBU__c = '20123456786';
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'PEDIDO ESTUDIO';
			update opp;

			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			res = Database.update(opp,false);
			Test.stopTest();
		}
        System.assertEquals(true, res.isSuccess());


    }

   @IsTest
	private static void testEstadoDDJJValidationsComercial2(){
        Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u3){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Incompleta';
			opp.Subestado_de_DDJJ__c = 'NUEVA';
			update opp;

			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(true, res.isSuccess());
	}

	   @IsTest
	private static void testEstadoDDJJValidationsComercial3(){
        Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u3){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Incompleta';
			opp.Subestado_de_DDJJ__c = 'NUEVA';
			update opp;

			Test.startTest();
			opp.Nombre_INDCORP__c = 'AUDITORIA';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(true, res.isSuccess());
	}

    @IsTest
	private static void testEstadoDDJJValidationsComercialError(){
        Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u3){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Incompleta';
			opp.Subestado_de_DDJJ__c = 'FIRMA O.S.';
			update opp;

			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'TRASPASO';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(false, res.isSuccess());
	}

    @IsTest
	private static void testEstadoDDJJValidationsORG(){
				Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u4){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'PEDIDO ESTUDIO';
			update opp;

			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(true, res.isSuccess());
	}

    @IsTest
	private static void testEstadoDDJJValidationsORG2(){
        Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u4){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'FIRMA O.S.';
			update opp;

			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'TRASPASO';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(true, res.isSuccess());
	}

    @IsTest
	private static void testEstadoDDJJValidationsORG3(){
        Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u4){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'NUEVA';
			update opp;

			Test.startTest();
            opp.Nombre_INDCORP__c = 'Algo';
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(true, res.isSuccess());
	}

    @IsTest
	private static void testEstadoDDJJValidationsORGError(){
        Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u4){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'FIRMA O.S.';
			update opp;

			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(false, res.isSuccess());
	}

     @IsTest
	private static void testEstadoDDJJValidationsORGErrorChangeMoreFields(){
        Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u4){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'FIRMA O.S.';
			update opp;

			Test.startTest();
            opp.Nombre_INDCORP__c = 'ALGO';
			opp.Subestado_de_DDJJ__c = 'TRASPASO';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(true, res.isSuccess());
	}

     @IsTest
	private static void testEstadoDDJJValidationsORGError2(){
        Account acc = Build.anAccountCuentapersonal().withLastName('Apellido test').build();
		acc.Phone = '2643972015';
		acc.Correo_electronico__c = 'correo@test.com';
		acc.Prefijo__c = '011';
		insert acc;
		Database.SaveResult res;

		System.runAs(u4){
			Opportunity opp = Build.anOpportunity().build();
			opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
			//opp.Name = 'Opp test';
			//opp.CloseDate = Date.today();
			opp.StageName = 'En Edición';
			opp.AccountId = acc.Id;
			opp.Medio_de_cobro__c = 'CBU';
			opp.Nro_CBU_para_cobro_de_cuota__c = '20123456786';
			opp.Tipo_CBU__c = 'CBUFR';
			opp.CUIL_del_CBU__c = '20123456786';
			opp.Tipo_de_Solicitud__c = 'REINGRESO';
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			update opp;

			Test.startTest();
			opp.Nombre_INDCORP__c = 'ALGO';
			res = Database.update(opp,false);
			Test.stopTest();
		}

		System.assertEquals(true, res.isSuccess());
	}

	@IsTest
    static void assignDelegacionFromUserTest() {
//        Account delegacion = Build.anAccountDelegacion().build();
        Account delegacion = new Account();
        delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
        delegacion.Name = 'Test';
        delegacion.Codigo_de_delegacion__c = '661089';
        insert  delegacion;

        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Front'];
        System.debug(profileList);

        User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
        );
        usuario.Codigo_delegacion__c = delegacion.Codigo_de_delegacion__c;
        insert usuario;

		User usuario2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser2@xappia.com'
        );
        usuario2.Codigo_delegacion__c = delegacion.Codigo_de_delegacion__c;
        insert usuario2;

		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		opp.StageName = 'Contactado';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.OwnerId = usuario.Id;
		List<Opportunity> oportunidades = new List<Opportunity> {opp};

        Test.startTest();
		insert oportunidades;
        Test.stopTest();

        List<Opportunity> oportunidadesToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Opportunity WHERE Id =: oportunidades];
        for(Opportunity oportunidadToAssert : oportunidadesToAssert) {
			System.assertEquals('661089', oportunidadToAssert.Delegacion__r.Codigo_de_delegacion__c);
		}
    }

	@IsTest
    static void ifTheDelegacionDoesNotExistInUserDoNotGiveError() {

        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Front'];
        System.debug(profileList);

        User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
        );
        usuario.Codigo_delegacion__c = '123456';
        insert usuario;

		Opportunity opp = Build.anOpportunityCorporativo().build();
		opp.Tipo_de_Solicitud__c = 'REINGRESO';

        System.runAs(usuario) {
            Test.startTest();
            insert opp;
            Test.stopTest();
        }

        Opportunity oppToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Opportunity WHERE Id =: opp.Id];
        System.assertEquals(null, oppToAssert.Delegacion__r.Codigo_de_delegacion__c);
    }

    @IsTest
    static void ifTheDelegacionIsNullInUserDoNotGiveError() {
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Front'];

        List<Group> groupList = [SELECT Id,Name FROM Group WHERE type= 'queue'];

        User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',profileId=profileList[0].Id, 
                UserName='usertotestassignDelegacionFromUser@xappia.com'
        );
        insert usuario;

        GroupMember groupMember = new GroupMember( groupId = groupList[0].Id);

        Opportunity opp = Build.anOpportunityCorporativo().build();
		opp.Tipo_de_Solicitud__c = 'REINGRESO';

		System.runAs(usuario) {
            Test.startTest();
            insert opp;
            Test.stopTest();
        }

        Opportunity oppToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Opportunity WHERE Id =: opp.Id];
        System.assertEquals(null, oppToAssert.Delegacion__r.Codigo_de_delegacion__c);
	}

	@isTest
	private static void whenAOpportunityWithAceptadoPorElAsociadoTryToSaveWithoutFileShouldReturnError() {
		Account cuenta = build.anAccount()
                                    .withAfiIddelTitular(182701)
                                    .withCodigodeAfiliado('70332/34')
									.withLastName('Testing182701')
                                    .build();
        cuenta.Estado__c = 'A';

        insert cuenta;
		Opportunity opp = Build.anOpportunityIndividuos()
							.withName('TEST')
							.withStageName('Contactado')
							.withCloseDate(Date.newInstance(2020, 01, 05))
							.withAccount(cuenta.Id)
						.build();
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		insert opp;

		User actualUser = [SELECT Id, Profile.Name FROM User WHERE Profile.Name = 'Front' LIMIT 1];
		Database.SaveResult res;
		Test.startTest();
		opp.Aceptado_por_el_asociado__c = true;
		res = Database.update(opp, false);
		Test.stopTest();

		System.assertEquals(false, res.isSuccess(), 'No esta validando que tenga el adjunto');
	}

	@isTest
	private static void whenAOpportunityWithAceptadoPorElAsociadoTryToSaveWithFileWithOtherNameShouldReturnError() {
		Account cuenta = build.anAccount()
                                    .withAfiIddelTitular(182701)
                                    .withCodigodeAfiliado('70332/34')
									.withLastName('Testing182701')
                                    .build();
		cuenta.Estado__c = 'A';

		ContentVersion cv = new ContentVersion();
		cv.Title =  'Archivo x';
		cv.VersionData = Blob.valueOf('document');
		cv.PathOnClient = '/document';
        insert cv;
		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        insert cuenta;
		Opportunity opp = Build.anOpportunityIndividuos()
							.withName('TEST')
							.withStageName('Contactado')
							.withCloseDate(Date.newInstance(2020, 01, 05))
							.withAccount(cuenta.Id)
						.build();
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		insert opp;

		ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId= opp.id;
		contentlink.Visibility = 'AllUsers'; 
        contentlink.ContentDocumentId = cv.ContentDocumentId;
		insert contentlink;

		User actualUser = [SELECT Id, Profile.Name FROM User WHERE Profile.Name = 'Front' LIMIT 1];
		Database.SaveResult res;
		Test.startTest();
		opp.Aceptado_por_el_asociado__c = true;
		res = Database.update(opp, false);
		Test.stopTest();
		System.assertEquals(false, res.isSuccess(), 'No se esta ejecutando la validacion');
	}

	@isTest
	private static void whenAOpportunityWithAceptadoPorElAsociadoTryToSaveWithFileShouldNotReturnError() {
		Account cuenta = build.anAccount()
                                    .withAfiIddelTitular(182701)
                                    .withCodigodeAfiliado('70332/34')
									.withLastName('Testing182701')
                                    .build();
		cuenta.Estado__c = 'A';

		ContentVersion cv = new ContentVersion();
		cv.Title =  'Nota de Aceptacion';
		cv.VersionData = Blob.valueOf('document');
		cv.PathOnClient = '/document';
        insert cv;
		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        insert cuenta;
		Opportunity opp = Build.anOpportunityIndividuos()
							.withName('TEST')
							.withStageName('Contactado')
							.withCloseDate(Date.newInstance(2020, 01, 05))
							.withAccount(cuenta.Id)
						.build();
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		insert opp;

		ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId= opp.id;
		contentlink.Visibility = 'AllUsers';
        contentlink.ContentDocumentId = cv.ContentDocumentId;
		insert contentlink;


		User actualUser = [SELECT Id, Profile.Name FROM User WHERE Profile.Name = 'Front' LIMIT 1];
		Database.SaveResult res;
		Test.startTest();
		opp.Aceptado_por_el_asociado__c = true;
		res = Database.update(opp, false);
		Test.stopTest();

		System.assertEquals(true, res.isSuccess(), 'No se esta guardando el check');
	}

	@isTest
	private static void whenOpportunitysDNIIsChanged_changesDNIInAccount() {
		Account acc = Build.anAccountCuentapersonal().build();
		acc.Numero_de_documento__c = '30123123';
		insert acc;

		Opportunity opp = Build.anOpportunityIndividuos()
							.withAccount(acc.Id)
							.build();
		opp.Tipo_de_Solicitud__c = 'REINGRESO';

		insert opp;

		Test.startTest();
		opp.Numero_de_documento__c = '30222333';
		update opp;
		Test.stopTest();

		acc = [SELECT Id, Numero_de_documento__c FROM Account WHERE Id = :acc.Id];

		System.assertEquals(opp.Numero_de_documento__c, acc.Numero_de_documento__c);
	}

	@isTest
	private static void whenOpportunitysLocalidadChangesChangeTheOrganizadorAndOwnerInOpp() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;

		Opportunity opp = Build.anOpportunityIndividuos()
							.withAccount(acc.Id)
							.build();
		opp.Tipo_de_Solicitud__c = 'REINGRESO';

		insert opp;

		Localidad__c loc = new Localidad__c();
		loc.Organizador_lookup__c = UserInfo.getUserId();
		insert loc;

		Test.startTest();
		opp.Localidad_new__c = loc.Id;
		update opp;
		Test.stopTest();

		opp = [SELECT Id, Organizador_lookup__c, OwnerId FROM Opportunity WHERE Id = :opp.Id];

		System.assertEquals(loc.Organizador_lookup__c, opp.Organizador_lookup__c);
		//System.assertEquals(loc.Organizador_lookup__c, opp.OwnerId);
	}

	@isTest
	public static void whenCreateAnOppMustMapTheOrganizadorOfTheAccount(){

		Localidad__c loc = new Localidad__c();
		loc.Organizador_lookup__c = UserInfo.getUserId();
		insert loc;

		Account acc = Build.anAccountCuentapersonal().build();
		acc.Localidad_new__c = loc.Id;
		insert acc;

		Opportunity opp = Build.anOpportunityIndividuos()
							.withAccount(acc.Id)
							.build();
							opp.Tipo_de_Solicitud__c = 'REINGRESO';

		Test.StartTest();
		insert opp;
		Test.StopTest();

		Opportunity oppUpdated = [
			SELECT Id, Organizador_lookup__c
			FROM Opportunity
			WHERE Id = :opp.Id
		];
		System.assertEquals(UserInfo.getUserId(),oppUpdated.Organizador_lookup__c);
	}
}