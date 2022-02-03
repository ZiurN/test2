@isTest
private class OpportunityTriggerTest {
	private static Profile agenteDeVentasProfile = [SELECT Id FROM Profile WHERE Name='Agente de Ventas'];
	private static Profile fromProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Front' LIMIT 1];
	private static List<String> roleDevNames = new List<String>{'Comercial_AMBA', 'Org_AMBA', 'Comercial_CS'};
	private static List<UserRole> roles = [SELECT Id, Name, DeveloperName FROM UserRole WHERE DeveloperName IN: roleDevNames];
	private static User comercialAMBAUser = Build.anUser()
		.withUserName('comercialAMBAUser' + DateTime.now().getTime() + '@testorg.com')
		.withProfile(agenteDeVentasProfile)
		.withAlias('AMBAUser')
		.build();
	private static User orgAMBAUser = Build.anUser()
		.withUserName('orgAMBAUser' + DateTime.now().getTime() + '@testorg.com')
		.withProfile(agenteDeVentasProfile)
		.withAlias('orgUser')
		.build();
	private static User comercialCSUser = Build.anUser()
		.withUserName('comercialCSUser' + DateTime.now().getTime() + '@testorg.com')
		.withProfile(agenteDeVentasProfile)
		.withAlias('CSUser')
		.build();
	private static User userFront = Build.anUser()
		.withUserName('userFront' + DateTime.now().getTime() + '@testorg.com')
		.withProfile(agenteDeVentasProfile)
		.withAlias('Front')
		.build();
	private static List<User> usersToInsert = new List<User>();
	private static Map<String, String> paramsMap;
	static {
		for (userRole role : roles) {
			if (role.DeveloperName == 'Comercial_AMBA') {
				comercialAMBAUser.UserRoleId = role.Id;
				usersToInsert.add(comercialAMBAUser);
				userFront.UserRoleId = role.Id;
				usersToInsert.add(userFront);
			} else if (role.DeveloperName == 'Org_AMBA') {
				orgAMBAUser.UserRoleId = role.Id;
				usersToInsert.add(orgAMBAUser);
			} else if (role.DeveloperName == 'Comercial_CS') {
				comercialCSUser.UserRoleId = role.Id;
				usersToInsert.add(comercialCSUser);
			}
		}
		System.runAs(new User(Id=UserInfo.getUserId())){
			insert usersToInsert;
		}
		paramsMap = new Map<String, String>();
	}
	@isTest
	private static void addAccountToOpportunityWithRecordTypeIndividualCorporativo () {
		Account acc = Build.anAccount().build();
		insert acc;
		Opportunity opp = Build.anOpportunityCorporativo()
			.withTipodeSolicitud('REINGRESO')
			.withAccount(acc.Id)
			.build();
		insert opp;
		Opportunity oportunidadIndividualCorporativa = Build.anOpportunityIndividualCorporativo()
			.withTipodeSolicitud('REINGRESO')
			.withNumeroDocumento('78945612')
			.withOportunidadCorporativa(opp.Id)
			.build();
		Test.startTest();
		insert oportunidadIndividualCorporativa;
		Test.stopTest();
		Opportunity opportunityToAssert = getOpportunityById(oportunidadIndividualCorporativa.Id);
		System.assertEquals(opp.AccountId, opportunityToAssert.AccountId, 'La cuenta de las oportunidades debe ser la misma');
	}
	@isTest
	private static void AccCreationWhenOpportunityWithRecordTypeIndividualCorporativoStageNameChangedToClosedWin () {
		Opportunity opp = Build.anOpportunityCorporativo()
			.withTipodeSolicitud('REINGRESO')
			.build();
		insert opp;
		Opportunity oportunidadIndividualCorporativa = Build.anOpportunityIndividualCorporativo()
			.withTipodeSolicitud('REINGRESO')
			.withName('Opp test')
			.withCloseDate(Date.today())
			.withStageName('En Edición')
			.withOportunidadCorporativa(opp.Id)
			.withNombreINDCORP('Nombre prueba')
			.withApellidoINDCORP('Apellido prueba')
			.withFechaNacimiento(Date.newInstance(1980, 2, 17))
			.withTipoDocumento('DNI')
			.withNumeroDocumento('38079225')
			.withCUIL('20380792258')
			.withEstadoCivil('D')
			.withSexo('F')
			.withTipodeSolicitud('ALTA')
			.build();
		insert oportunidadIndividualCorporativa;
		Test.startTest();
			oportunidadIndividualCorporativa.Nro_de_asociado__c = '123456';
			oportunidadIndividualCorporativa.StageName = 'Cerrada ganada';
		update oportunidadIndividualCorporativa;
		Test.stopTest();
		paramsMap.put('Numero_de_documento__c', String.valueOf(oportunidadIndividualCorporativa.Numero_de_documento__c));
		List<Account> accountsToAssert = getAccountsByParams(paramsMap);
		System.assertEquals(1, accountsToAssert.size(), 'Debe haber solo una cuenta');
		Account accountToAssert = accountsToAssert[0];
		System.assertEquals(oportunidadIndividualCorporativa.Nombre_INDCORP__c,
							accountToAssert.FirstName,
							'El nombre de la cuenta no coincide con el de la oportunidad');
		System.assertEquals(oportunidadIndividualCorporativa.Apellido_INDCOR__c,
							accountToAssert.LastName,
							'El apellido de la cuenta no coincide con el de la oportunidad');
		System.assertEquals(oportunidadIndividualCorporativa.Fecha_de_Nacimiento__c,
							accountToAssert.PersonBirthdate,
							'La fecha de nacimiento de la cuenta no coincide con la de la oportunidad');
		System.assertEquals(oportunidadIndividualCorporativa.Tipo_de_Documento__c,
							accountToAssert.Tipo_de_documento__c,
							'El tipo de documento de la cuenta no coincide con el de la oportunidad');
		System.assertEquals(oportunidadIndividualCorporativa.Numero_de_documento__c,
							accountToAssert.Numero_de_documento__c,
							'El número de documento de la cuenta no coincide con el de la oportunidad');
		System.assertEquals(oportunidadIndividualCorporativa.CUIT__c,
							accountToAssert.CUIT__c,
							'El CUIL de la cuenta no coincide con el de la oportunidad');
		System.assertEquals(oportunidadIndividualCorporativa.Estado_Civil__c,
							accountToAssert.Estado_civil__c,
							'El Estado civil de la cuenta no coincide con el de la oportunidad');
		System.assertEquals(oportunidadIndividualCorporativa.Sexo__c,
							accountToAssert.Sexo__c,
							'El sexp de la cuenta no coincide con el de la oportunidad');
	}
	@IsTest
	static void GrupoFamiliarCreationWhenOpportunityWithRecordTypeIndividuosStageNameChangesToClosedWin (){
		XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		TestUtils.setAuthToken(getResponseFound);
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Account acc = setTestAccount()
			.withType('TIT')
			.withCodigoDeAfiliado('69782')
			.build();
		insert acc;
		Opportunity opp = Build.anOpportunityIndividuos()
			.withAccount(acc.Id)
			.withTipodeSolicitud('REINGRESO')
			.withName('Opp test')
			.withCloseDate(Date.today())
			.withNumeroAsociado('123123')
			.withStageName('En Edición')
			.withCodigoPostal('1234')
			.build();
		insert opp;
		List<Account> obrasSocialesToInsert = new List<Account>();
		Account accObraSocial = Build.anAccountObrasocial().build();
		obrasSocialesToInsert.add(accObraSocial);
		Account accObraSocialAnterior = Build.anAccountObrasocial().build();
		obrasSocialesToInsert.add(accObraSocialAnterior);
		insert obrasSocialesToInsert;
		Integrante__c integrante = Build.anIntegrante()
			.withApellido('Apellido integrante')
			.withNombre('Nombre integrante')
			.withOpportunity(opp.Id)
			.withFechaNacimiento(Date.newInstance(1999, 4, 30))
			.withTipoDocumento('DNI')
			.withNroDocumento('14657')
			.withCUIT('20380792258')
			.withSexo('M')
			.withEstadoCivil('C')
			.withCoberturaAnterior(accObraSocialAnterior.Id)
			.withObraSocialActual(accObraSocial.Id)
			.withIndicadorDeAporte(true)
			.withAportes(Double.valueOf(1000.50))
			.withTipoDeRelacionConTitular('HI')
			.withNacionalidad('054')
			.withDiscapacidad('No')
			.withMail('ej@test.com')
			.build();
		insert integrante;
		Test.startTest();
		opp.StageName = 'Cerrada ganada';
		opp.Nro_de_solicitud__c = '12345678';
		update opp;
		Test.stopTest();
		paramsMap.put('LastName', 'Apellido integrante');
		List<Account> accsToAssert = getAccountsByParams(paramsMap);
		System.assertEquals(1, accsToAssert.size(), 'Solo debe haber una cuenta');
		Account accToAssert = accsToAssert[0];
		Grupo_Familiar__c grupoFamiliarToAssert = [SELECT Id,
														Integrante__c,
														Relacion_con_el_titular__c,
														Titular_del_Grupo_Familiar__c,
														Nro_de_socio_del_titular__c
													FROM Grupo_Familiar__c
													WHERE Integrante__c = :accToAssert.Id];
		System.assertEquals(integrante.Apellido__c, accToAssert.LastName, 'El apellido no coincide');
		System.assertEquals(integrante.Nombre__c, accToAssert.FirstName, 'El nombre no coincide');
		System.assertEquals(acc.Phone, accToAssert.Phone, 'El teléfono no coincide');
		System.assertEquals(integrante.Correo_electronico__c, accToAssert.Correo_electronico__c, 'El correo no coincide');
		System.assertEquals(integrante.CUIT_Sin_guiones__c, accToAssert.CUIT__c, 'El CUIL no coincide');
		System.assertEquals(integrante.Tipo_de_relacion_con_titular__c, accToAssert.Parentesco__c, 'El parentesco no coincide');
		System.assertEquals(integrante.Tipo_de_relacion_con_titular__c, grupoFamiliarToAssert.Relacion_con_el_titular__c, 'El parentesco no coincide');
		System.assertEquals(acc.Id, grupoFamiliarToAssert.Titular_del_Grupo_Familiar__c, 'La cuenta no coincide');
		System.assertEquals(acc.Codigo_de_Afiliado__c, grupoFamiliarToAssert.Nro_de_socio_del_titular__c, 'El Código de Afiliado no coincide');
	}
	@IsTest
	static void whenStageNamePassToEnTramitacion_WithOutCotizacionElegida_getError () {
		Account acc = setTestAccount().build();
		insert acc;
		Opportunity opp = setTestOppIndividuos(acc.Id).build();
		insert opp;
		opp.StageName = 'En tramitación';
		Test.startTest();
		Database.SaveResult result = Database.update(opp, false);
		Test.stopTest();
		validateDMLError(result, 'Cotizacion_elegida__c', 'Este campo debe estar completo');
	}
	@IsTest
	static void whenStageNamePassToEnTramitacion_WithOutCotizacionElegida_WihtMedioCobroTarjeta_getError () {
		Account acc = setTestAccount().build();
		insert acc;
		Opportunity opp = setTestOppIndividuos(acc.Id)
			.withEstadoCivil('C')
			.withMedioCobro('Tarjeta')
			.build();
		insert opp;
		opp.StageName = 'En tramitación';
		Test.startTest();
		Database.SaveResult result = Database.update(opp, false);
		Test.stopTest();
		validateDMLError(result, 'Cotizacion_elegida__c', 'Este campo debe estar completo');
	}
	@IsTest
	static void whenStageNamePassToEnTramitacion_WithOutCotizacionElegida_WihtMedioCobroCBU_getError () {
		Account acc = setTestAccount().build();
		insert acc;
		Opportunity opp = setTestOppIndividuos(acc.Id)
			.withEstadoCivil('C')
			.withMedioCobro('CBU')
			.withCBUParaCobroCuota('20123456786')
			.withTipoCBU('CBUFR')
			.withCuilDelCBU('20123456786')
			.build();
		insert opp;
		opp.StageName = 'En tramitación';
		Test.startTest();
		Database.SaveResult result = Database.update(opp, false);
		Test.stopTest();
		validateDMLError(result, 'Cotizacion_elegida__c', 'Este campo debe estar completo');
	}
	@IsTest
	static void whenEstadoSolicitudChangedToTransformadaAndNroAsociadoIsComplete_ActivateTheAcc () {
		List<Account> accsToInsert = new List<Account>();
		Account acc = setTestAccount().build();
		accsToInsert.add(acc);
		Account os = Build.anAccountObrasocial().withCodigoDeOS('74123').build();
		accsToInsert.add(os);
		Account agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('50123').build();
		accsToInsert.add(agencia);
		insert accsToInsert;
		Opportunity testOpp = setTestOppIndividuos(acc.Id)
			.withStageName('Contactado')
			.withNroDeSolicitud('12345678')
			.withCloseDate(Date.today().addDays(15))
			.withNacionalidad('054')
			.withSexo('M')
			.withObraSocialTitutar(os.Id)
			.withFechaNacimiento(Date.today())
			.withCUIL('20342223339')
			.withAgencia(agencia.Id)
			.withActividadProfesionTitular('COM')
			.withEstadoCivil('S')
			.withSegmentoGrupoFamiliar('VOLDIR')
			.build();
		insert testOpp;
		Cotizacion__c cotizacion = new Cotizacion__c();
		cotizacion.Oportunidad__c = testOpp.Id;
		cotizacion.CP__c = '7102';
		insert cotizacion;
		testOpp.StageName = 'Cotizado';
		update testOpp;
		Test.startTest();
		testOpp.StageName = 'Cerrada ganada';
		testOpp.Cotizacion_elegida__c = cotizacion.Id;
		testOpp.Nro_de_asociado__c= '123456';
		testOpp.Estado_de_solicitud__c = 'Transformada';
		testOpp.CloseDate = Date.today();
		testOpp.Cambio_Manual__c = false;
		update testOpp;
		Test.stopTest();
		paramsMap.put('Id', String.valueOf(acc.Id));
		List<Account> accsToAssert = getAccountsByParams(paramsMap);
		System.assertEquals(1, accsToAssert.size(), 'Solo debe haber una cuenta');
		Account accToAssert = accsToAssert[0];
		System.assertEquals(testOpp.Nro_de_asociado__c, accToAssert.Codigo_de_Afiliado__c, 'Los códigos no coinciden');
		System.assertEquals(testOpp.Sexo__c, accToAssert.Sexo__c, 'El sexo no coincide');
		System.assertEquals(os.Id, accToAssert.Obra_social__c, 'La obra social no coincide');
		System.assertEquals(testOpp.Fecha_de_Nacimiento__c, accToAssert.PersonBirthdate, 'Las fechas no coinciden');
		System.assertEquals(testOpp.CUIT__c, accToAssert.CUIT__c, 'El CUIL no coincide');
		System.assertEquals(agencia.Id, accToAssert.Delegacion__c, 'La agencia no coincide');
		System.assertEquals(testOpp.Estado_Civil__c, accToAssert.Estado_civil__c, 'El estado civil no coincide');
		System.assertEquals(testOpp.Segmento_del_Grupo_Familiar__c, accToAssert.Segmento_de_grupo_familiar__c, 'El segmento no coincide');
		Opportunity oppQuery = [SELECT Cambio_Manual__c FROM Opportunity WHERE Id =: testOpp.Id];
		System.assert(oppQuery.Cambio_Manual__c, 'El campo debe estar marcado como verdadero');
	}
	@IsTest
	static void copyDataFromAccountToOpportunity () {
		List<Account> accsToInsert = new List<Account>();
		Account os = Build.anAccountObrasocial().withCodigoDeOS('74123').build();
		accsToInsert.add(os);
		Account agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('50123').build();
		accsToInsert.add(agencia);
		insert accsToInsert;
		Account acc = setTestAccount(os.Id, agencia.Id).build();
		insert acc;
		Opportunity opp = setTestOppIndividuos(acc.Id)
			.withStageName('Contactado')
			.withSexo('M')
			.build();
		Test.startTest();
		insert opp;
		Test.stopTest();
		Opportunity oppFromQuery = getOpportunityById(opp.Id);
		System.assertEquals(acc.Numero_de_documento__c, oppFromQuery.Numero_de_documento__c, 'El número de documento no coincide');
		System.assertEquals(acc.PersonEmail, oppFromQuery.Correo_Electronico__c, 'El correo no coincide');
		System.assertEquals(acc.Tipo_de_documento__c, oppFromQuery.Tipo_de_Documento__c, 'El tipo de documento no coincide');
		System.assertEquals(os.Id, oppFromQuery.Obra_social_del_titular__c, 'La obra social no es la misma');
		System.assertEquals(acc.Sexo__c, oppFromQuery.Sexo__c, 'El sexo no coindice');
		System.assertEquals(acc.Phone, oppFromQuery.Telefono__c, 'El télefono no coincide');
		System.assertEquals(acc.PersonBirthdate, oppFromQuery.Fecha_de_Nacimiento__c, 'La fecha de nacimiento no coincide');
		System.assertEquals(acc.CUIT__c, oppFromQuery.CUIT__c, 'El CUIL no coincide');
		System.assertEquals(agencia.Id, oppFromQuery.Agencia__c, 'La agencia no es la misma');
		System.assertEquals(acc.Estado_civil__c, oppFromQuery.Estado_Civil__c, 'El estado civil no coincide');
	}
	@IsTest
	static void canAssignLocIfUserIsInRoleHierarchy () {
		Opportunity opp = setRoleHierarchyTestData(true);
		Database.SaveResult result;
		System.runAs(comercialAMBAUser){
			Test.startTest();
			result = Database.insert(opp);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debieron haber errores al insertar la oportunidad');
		System.assertEquals(1, [SELECT COUNT() FROM Opportunity], 'Debe habe una oportunidad nueva');
	}
	@IsTest
	static void cantAssignLocIfUserIsNotInRoleHierarchy () {
		Opportunity opp = setRoleHierarchyTestData(true);
		Database.SaveResult result;
		System.runAs(comercialCSUser){
			Test.startTest();
			result = Database.insert(opp, false);
			Test.stopTest();
		}
		validateDMLError(result, 'Localidad_new__c', System.Label.OppTrigger_Error_NoPuedeCambiarLoc);
	}
	@IsTest
	static void cantChangeOwnerIfUserIsNotInRoleHierarchy () {
		Opportunity opp = setRoleHierarchyTestData(false);
		Database.SaveResult result;
		System.runAs(comercialCSUser) {
			insert opp;
			Test.startTest();
			opp.OwnerId = orgAMBAUser.Id;
			result = Database.update(opp, false);
			Test.stopTest();
		}
		opp = getOpportunityById(opp.Id);
		System.assertEquals(comercialCSUser.Id, opp.OwnerId, 'El usuario dueño no debio cambiar');
		validateDMLError(result, System.Label.OppTrigger_Error_CannotDerivateOpp);
	}
	@IsTest
	static void canChangeOwnerIfUserIsInRoleHierarchy () {
		Opportunity opp = setRoleHierarchyTestData(false);
		Database.SaveResult result;
		System.runAs(orgAMBAUser){
			insert opp;
			Test.startTest();
			opp.OwnerId = comercialAMBAUser.Id;
			result = Database.update(opp, false);
			Test.stopTest();
		}
		opp = getOpportunityById(opp.Id);
		System.assertEquals(comercialAMBAUser.Id, opp.OwnerId, 'El dueño de la oportunidad debio cambiar');
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
	@IsTest
	private static void testEstadoDDJJValidations () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(comercialAMBAUser){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			update opp;
			Test.startTest();
			opp.Nombre_INDCORP__c = 'Cambio';
			result = Database.update(opp, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
	@IsTest
	private static void testEstadoDDJJValidations_Front () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(userFront){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			update opp;
			Test.startTest();
			opp.Nombre_INDCORP__c = 'Cambio';
			result = Database.update(opp, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
	@IsTest
	private static void testEstadoDDJJValidations_Comercial_Solicitud_Completa () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(comercialAMBAUser){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'PEDIDO ESTUDIO';
			update opp;
			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			result = Database.update(opp, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
   @IsTest
	private static void testEstadoDDJJValidations_Comercial_Solicitud_Incompleta () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(comercialAMBAUser){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Incompleta';
			opp.Subestado_de_DDJJ__c = 'NUEVA';
			update opp;
			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			result = Database.update(opp, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
	@IsTest
	private static void testEstadoDDJJValidations_Comercial_Error () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(comercialAMBAUser){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Incompleta';
			opp.Subestado_de_DDJJ__c = 'FIRMA O.S.';
			update opp;
			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'TRASPASO';
			result = Database.update(opp, false);
			Test.stopTest();
		}
		validateDMLError(result, 'Subestado_de_DDJJ__c', System.Label.OppTrigger_Error_SubEstadoTranspasoError);
	}
	@IsTest
	private static void testEstadoDDJJValidations_ORG_SubEstadoDDJJ_DePEDIDOESTUDIO_AAUDITORIA () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(orgAMBAUser){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'PEDIDO ESTUDIO';
			update opp;
			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			result = Database.update(opp, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
	@IsTest
	private static void testEstadoDDJJValidations_ORG_SubEstadoDDJJ_DeFIRMAOS_ATRASPASO () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(orgAMBAUser){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'FIRMA O.S.';
			update opp;
			Test.startTest();
			opp.Nombre_INDCORP__c = 'ALGO';
			opp.Subestado_de_DDJJ__c = 'TRASPASO';
			result = Database.update(opp,false);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
	@IsTest
	private static void testEstadoDDJJValidations_ORG_SubEstadoDDJJ_DeNUEVA_AAUDITORIA () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(orgAMBAUser){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'NUEVA';
			update opp;
			Test.startTest();
			opp.Nombre_INDCORP__c = 'Algo';
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			result = Database.update(opp,false);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
	@IsTest
	private static void testEstadoDDJJValidations_ORG_Error_SubEstadoDDJJPrevioInvalido () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(orgAMBAUser){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'FIRMA O.S.';
			update opp;
			Test.startTest();
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			result = Database.update(opp,false);
			Test.stopTest();
		}
		validateDMLError(result, 'Subestado_de_DDJJ__c', System.Label.OppTrigger_Error_SubEstadoTranspasoError);
	}
	@IsTest
	private static void testEstadoDDJJValidations_ORG_NombreINDCORP_AALGO () {
		Account acc = setTestAccount().build();
		insert acc;
		Database.SaveResult result;
		System.runAs(orgAMBAUser){
			Opportunity opp = setTestOppIndividuosDDJJ(acc.Id).build();
			insert opp;
			opp.Estado_de_solicitud__c = 'Completa';
			opp.Subestado_de_DDJJ__c = 'AUDITORIA';
			update opp;
			Test.startTest();
			opp.Nombre_INDCORP__c = 'ALGO';
			result = Database.update(opp,false);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
	@IsTest
	static void delegacion_assignItFromUserTest () {
		Account delegacion = Build.anAccountDelegacion()
			.withCodigoDeDelegacion('661089')
			.build();
		insert  delegacion;
		User usuario = setDelegacionTestUser(delegacion.Codigo_de_delegacion__c);
		insert usuario;
		Opportunity opp = Build.anOpportunityIndividuos()
			.withTipodeSolicitud('REINGRESO')
			.withStageName('Contactado')
			.withOwner(usuario)
			.build();
		Test.startTest();
		insert opp;
		Test.stopTest();
		Opportunity oppToAssert = getOpportunityById(opp.Id);
		System.assertEquals(delegacion.Codigo_de_delegacion__c,
							oppToAssert.Delegacion__r.Codigo_de_delegacion__c,
							'El código de la delegación no coincide');
	}
	@IsTest
	static void delegacion_ifItDoesNotExistInUserDoNotGiveError () {
		User usuario = setDelegacionTestUser('123456');
		insert usuario;
		Opportunity opp = Build.anOpportunityCorporativo()
			.withTipodeSolicitud('REINGRESO')
			.build();
		System.runAs(usuario) {
			Test.startTest();
			insert opp;
			Test.stopTest();
		}
		Opportunity oppToAssert = getOpportunityById(opp.Id);
		System.assertEquals(null, oppToAssert.Delegacion__r.Codigo_de_delegacion__c, 'La delegación debe ser nula');
	}
	@IsTest
	static void delegacion_ifItIsNullInUserDoNotGiveError () {
		List<Group> groupList = [SELECT Id,Name FROM Group WHERE type= 'queue'];
		User usuario = setDelegacionTestUser(null);
		insert usuario;
		GroupMember groupMember = new GroupMember( groupId = groupList[0].Id);
		Opportunity opp = Build.anOpportunityCorporativo()
			.withTipodeSolicitud('REINGRESO')
			.build();
		System.runAs(usuario) {
			Test.startTest();
			insert opp;
			Test.stopTest();
		}
		Opportunity oppToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Opportunity WHERE Id =: opp.Id];
		System.assertEquals(null, oppToAssert.Delegacion__r.Codigo_de_delegacion__c, 'La delegación debe ser nula');
	}
	@isTest
	private static void notaAceptacion_ifAceptadoPorElAsociadoIsTrueAnd_TryToSaveWithoutFileShouldReturnError () {
		Opportunity opp = setAceptacionFileTestsData();
		Database.SaveResult result;
		Test.startTest();
		opp.Aceptado_por_el_asociado__c = true;
		result = Database.update(opp, false);
		Test.stopTest();
		validateDMLError(result, System.Label.OppTrigger_Error_SinArchivoAceptacion);
	}
	@isTest
	private static void notaAceptacion_ifAceptadoPorElAsociadoIsTrueAnd_TryToSaveWithFileWithOtherNameShouldReturnError() {
		Opportunity opp = setAceptacionFileTestsData('Archivo X');
		Database.SaveResult result;
		Test.startTest();
		opp.Aceptado_por_el_asociado__c = true;
		result = Database.update(opp, false);
		Test.stopTest();
		validateDMLError(result, System.Label.OppTrigger_Error_SinArchivoAceptacion);
	}
	@isTest
	private static void notaAceptacion_ifAceptadoPorElAsociadoIsTrueAnd_TryToSaveWithFileShouldNotReturnError() {
		Opportunity opp = setAceptacionFileTestsData('Nota de Aceptacion');
		Database.SaveResult result;
		Test.startTest();
		opp.Aceptado_por_el_asociado__c = true;
		result = Database.update(opp, false);
		Test.stopTest();
		System.debug(result);
		System.assert(result.isSuccess(), 'No debio ocurrir ningún error');
	}
	@isTest
	private static void whenOpportunitysDNIIsChanged_changesDNIInAccount() {
		Account acc = Build.anAccountCuentapersonal()
			.withNroDeDocumento('30123123')
			.build();
		insert acc;
		Opportunity opp = Build.anOpportunityIndividuos()
			.withAccount(acc.Id)
			.withTipodeSolicitud('REINGRESO')
			.build();
		insert opp;
		Test.startTest();
		opp.Numero_de_documento__c = '30222333';
		update opp;
		Test.stopTest();
		acc = [SELECT Id, Numero_de_documento__c FROM Account WHERE Id = :acc.Id];
		System.assertEquals(opp.Numero_de_documento__c, acc.Numero_de_documento__c, 'El número de documento no coincide');
	}
	@isTest
	private static void whenOpportunityLocalidadChangesChangeTheOrganizadorAndOwnerInOpp() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Opportunity opp = Build.anOpportunityIndividuos()
			.withAccount(acc.Id)
			.withTipodeSolicitud('REINGRESO')
			.build();
		insert opp;
		Localidad__c loc = new Localidad__c();
		loc.Organizador_lookup__c = UserInfo.getUserId();
		insert loc;
		Test.startTest();
		opp.Localidad_new__c = loc.Id;
		update opp;
		Test.stopTest();
		opp = [SELECT Id, Organizador_lookup__c, OwnerId FROM Opportunity WHERE Id = :opp.Id];
		System.assertEquals(loc.Organizador_lookup__c, opp.Organizador_lookup__c, 'La localidad no coincide');
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
			.withTipodeSolicitud('REINGRESO')
			.build();
		Test.StartTest();
		insert opp;
		Test.StopTest();
		Opportunity oppUpdated = getOpportunityById(opp.Id);
		System.assertEquals(UserInfo.getUserId(), oppUpdated.Organizador_lookup__c, 'El organizador no es el mismo');
	}
	/** Utils */
	private static Opportunity getOpportunityById (Id oppId) {
		return [SELECT Id,
					Name,
					AccountId,
					Numero_de_documento__c,
					Tipo_de_Documento__c,
					Obra_social_del_titular__c,
					Nacionalidad__c,
					Sexo__c,
					Fecha_de_Nacimiento__c,
					CUIT__c,
					ActividadProfesion_del_titular__c,
					Agencia__c,
					Estado_Civil__c,
					Telefono__c,
					Correo_Electronico__c,
					OwnerId,
					Delegacion__r.Codigo_de_delegacion__c,
					Organizador_lookup__c
				FROM Opportunity
				WHERE Id = :oppId];
	}
	private static List<Account> getAccountsByParams (Map<String, String> paramMap) {
		String initialQuery = 'SELECT Id, ' +
									'FirstName, ' +
									'LastName, ' +
									'PersonBirthdate, ' +
									'Tipo_de_documento__c, ' +
									'Numero_de_documento__c, ' +
									'CUIT__c, ' +
									'Estado_civil__c, ' +
									'Sexo__c, ' +
									'Phone, ' +
									'Correo_electronico__c, ' +
									'Parentesco__c, ' +
									'Codigo_de_Afiliado__c, ' +
									'Obra_social__c, ' +
									'Delegacion__c, ' +
									'Actividad_codigo__c, ' +
									'Actividad_nombre__c, ' +
									'Estado__c, ' +
									'Segmento_de_grupo_familiar__c ' +
								'FROM Account ';
		if (!paramMap.isEmpty()) {
			initialQuery += 'WHERE ';
			for (String param : paramMap.keySet()) {
				initialQuery += param + ' = \'' + paramMap.get(param) + '\' ';
			}
		}
		String query = initialQuery;
		List<Account> accountsToReturn = new List<Account>();
		Database.QueryLocatorIterator iterator = Database.getQueryLocator(query).iterator();
		while(iterator .hasNext()){
			Account accRow =(Account) iterator.next();
			accountsToReturn.add(accRow);
		}
		return accountsToReturn;
	}
	private static Build.AccountBuilder setTestAccount () {
		Build.AccountBuilder builder = Build.anAccountCuentapersonal()
			.withLastName('Apellido test')
			.withEmail('correo@test.com')
			.withPrefijo('011')
			.withPhone('44444444');
		return builder;
	}
	private static Build.AccountBuilder setTestAccount (Id osId, Id agenciaId) {
		Build.AccountBuilder builder = setTestAccount()
			.withSexo('M')
			.withObraSocial(osId)
			.withFechaNacimiento(Date.today().addYears(-30))
			.withCuit('20342223339')
			.withDelegacionId(agenciaId)
			.withActividadCodigo('COM')
			.withActividadNombre('Comerciante')
			.withEstadoCivil('S')
			.withPersonEmail('ej@test.com')
			.withType('TIT')
			.withTipoDocumento('DNI')
			.withNroDeDocumento('34111222');
		return builder;
	}
	private static Build.OpportunityBuilder setTestOppIndividuos (Id accId) {
		Build.OpportunityBuilder builder = Build.anOpportunityIndividuos()
			.withTipodeSolicitud('REINGRESO')
			.withName('Opp test')
			.withCloseDate(Date.today())
			.withStageName('En Edición')
			.withAccount(accId);
		return builder;
	}
	private static Build.OpportunityBuilder setTestOppIndividuosDDJJ (Id accId) {
		Build.OpportunityBuilder builder = Build.anOpportunityIndividuos()
			.withTipodeSolicitud('REINGRESO')
			.withStageName('En Edición')
			.withAccount(accId)
			.withMedioCobro('CBU')
			.withCBUParaCobroCuota('20123456786')
			.withTipoCBU('CBUFR')
			.withCuilDelCBU('20123456786');
		return builder;
	}
	private static void validateDMLError (Database.SaveResult result, String field, String errorMessage) {
		System.assert(!result.isSuccess(), 'Debio haber un error al actualizar la oportunidad');
		System.assertEquals(1, result.getErrors().size(), 'Debe haber un solo mensaje de error');
		System.assertEquals(1, result.getErrors()[0].getFields().size(), 'Debe haber un solo campo con error');
		System.assertEquals(field, result.getErrors()[0].getFields()[0], 'El campo no es el esperado');
		System.assertEquals(errorMessage, result.getErrors().get(0).getMessage(), 'El mensaje no indica el error');
	}
	private static void validateDMLError (Database.SaveResult result, String errorMessage) {
		System.assert(!result.isSuccess(), 'Debio haber un error al actualizar la oportunidad');
		System.assertEquals(1, result.getErrors().size(), 'Debe haber un solo mensaje de error');
		System.assertEquals(0, result.getErrors()[0].getFields().size(), 'No deben haber errores asociados a algún campo');
		System.assertEquals(errorMessage, result.getErrors().get(0).getMessage(), 'El mensaje no indica el error');
	}
	private static Opportunity setRoleHierarchyTestData (Boolean withLocalidad) {
		Localidad__c loc;
		if (withLocalidad) {
			loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1884')
			.withCodigoProvincia('S')
			.withOrganizador(orgAMBAUser.Id)
			.build();
			insert loc;
		}
		List<Account> accsToInsert = new List<Account>();
		Account os = Build.anAccountObrasocial().withCodigoDeOS('74123').build();
		accsToInsert.add(os);
		Account agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('50123').build();
		accsToInsert.add(agencia);
		insert accsToInsert;
		Account acc = setTestAccount(os.Id, agencia.Id).build();
		insert acc;
		Opportunity opp = setTestOppIndividuos(acc.Id)
			.withStageName('Contactado')
			.withSexo('M')
			.withLocalidadNew(withLocalidad ? loc.Id: null)
			.build();
		return opp;
	}
	private static User setDelegacionTestUser (String codigoDelegacion) {
		User usuario = Build.anUser()
			.withUserName('usertotestassignDelegacionFromUser' + DateTime.now().getTime() + '@testorg.com')
			.withProfile(fromProfile)
			.withAlias('user1')
			.withCodigoDelegacion(codigoDelegacion)
			.build();
		return usuario;
	}
	private static Opportunity setAceptacionFileTestsData () {
		Account cuenta = build.anAccount()
			.withAfiIddelTitular(182701)
			.withCodigodeAfiliado('70332/34')
			.withLastName('Testing182701')
			.withEstado('A')
			.build();
		insert cuenta;
		Opportunity opp = Build.anOpportunityIndividuos()
			.withName('TEST')
			.withStageName('Contactado')
			.withCloseDate(Date.newInstance(2020, 01, 05))
			.withAccount(cuenta.Id)
			.withTipodeSolicitud('REINGRESO')
			.build();
		insert opp;
		return opp;
	}
	private static Opportunity setAceptacionFileTestsData (String fileName) {
		Opportunity opp = setAceptacionFileTestsData();
		ContentVersion cv = new ContentVersion();
		cv.Title =  fileName;
		cv.VersionData = Blob.valueOf('document');
		cv.PathOnClient = '/document';
		insert cv;
		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
		ContentDocumentLink contentlink = new ContentDocumentLink();
		contentlink.LinkedEntityId= opp.id;
		contentlink.Visibility = 'AllUsers';
		contentlink.ContentDocumentId = cv.ContentDocumentId;
		insert contentlink;
		return opp;
	}
}