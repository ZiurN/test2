@isTest
private class UtilsTest {
	static User liderBsAsYPampeana;
	static User liderAmba;
	static User liderBsAsCentro;
	static User liderBsAsNorte;
	static User liderCordoba;
	static User liderLitoral;
	static User liderNEA;
	static User liderNOA;
	static User liderNucleo;
	static User liderPatagoniaAnd;
	static User liderPatagoniaAtl;
	static User userFront;
	static User userBack;
	static User userEncargado;
	static User userDoctor;
	static User userDoctor2;
	static Case caso;
	static Alerta__c alert;
	static Account delegacion;
	static {
		String uniqueUserName = 'standarduserRevertirCase' + DateTime.now().getTime() + '@testorg.com';
		Profile pFront = [SELECT Id, Name FROM Profile WHERE Name='Front'];
		Profile pBack = [SELECT Id, Name FROM Profile WHERE Name='Back Administrativo'];
		UserRole roleFilial = [SELECT Id, Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Filial_Casa_central'];
		userFront = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'userFront', ProfileId = pFront.Id, Profile = pFront, UserRole = roleFilial);
		insert userFront;
		userBack = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'userBack', ProfileId = pBack.Id);
		insert userBack;
		UserRole role = [SELECT Id, Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_Buenos_Aires_So_y_Pampeana'];
		liderBsAsYPampeana = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650001',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderBsAsYPampeana', ProfileId = pFront.Id, Profile = pFront, UserRole = role);
		insert liderBsAsYPampeana;
		UserRole roleLiderAmba = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_Amba'];
		liderAmba = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650002',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderAmba', ProfileId = pFront.Id, Profile = pFront,
				UserRoleId = roleLiderAmba.Id, UserRole = roleLiderAmba);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert liderAmba;
		}
		UserRole roleLiderBsAsCentro = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_Buenos_Aires_Centro'];
		liderBsAsCentro = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650003',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderBsAsCentro', ProfileId = pFront.Id, Profile = pFront, UserRole = roleLiderBsAsCentro);
		insert liderBsAsCentro;
		UserRole roleLiderBsAsNorte = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_Buenos_Aires_Norte'];
		liderBsAsNorte = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650004',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderBsAsNorte', ProfileId = pFront.Id, Profile = pFront, UserRole = roleLiderBsAsNorte);
		insert liderBsAsNorte;
		UserRole roleLiderCordoba = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_Cordoba'];
		liderCordoba = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650005',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderCordoba', ProfileId = pFront.Id, Profile = pFront, UserRole = roleLiderCordoba);
		insert liderCordoba;
		UserRole roleLiderLitoral = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_Litoral'];
		liderLitoral = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650006',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderLitoral', ProfileId = pFront.Id, Profile = pFront, UserRole = roleLiderLitoral);
		insert liderLitoral;
		UserRole roleLiderNEA = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_NEA'];
		liderNEA = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650007',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderNEA', ProfileId = pFront.Id, Profile = pFront, UserRole = roleLiderNEA);
		insert liderNEA;
		UserRole roleLiderNOA = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_NOA'];
		liderNOA = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650008',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderNOA', ProfileId = pFront.Id, Profile = pFront, UserRole = roleLiderNOA);
		insert liderNOA;
		UserRole roleLiderNucleo = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_Nucleo'];
		liderNucleo = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650009',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderNucleo', ProfileId = pFront.Id, Profile = pFront, UserRole = roleLiderNucleo);
		insert liderNucleo;
		UserRole roleLiderPatagoniaAnd = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_Patagonia_Andina'];
		liderPatagoniaAnd = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650010',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderPatagoniaAnd', ProfileId = pFront.Id, Profile = pFront, UserRole = roleLiderPatagoniaAnd);
		insert liderPatagoniaAnd;
		UserRole roleLiderPatagoniaAtl = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Lider_Patagonia_Atlantica'];
		liderPatagoniaAtl = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650011',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'liderPatagoniaAtl', ProfileId = pFront.Id, Profile = pFront, UserRole = roleLiderPatagoniaAtl);
		insert liderPatagoniaAtl;
		Profile perfilDoctor = [SELECT Id FROM Profile WHERE Name='Auditor Medico'];
		userDoctor = new User(Alias = 'standt', Email='standarduser@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
			LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
			UserName=uniqueUserName + 'DoctorUtils', ProfileId = perfilDoctor.Id, UserRoleId = role.Id
		);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert userDoctor;
		}
		userDoctor2 = new User(Alias = 'standt', Email='standarduser@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
			LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
			UserName=uniqueUserName + 'Doctor2Utils', ProfileId = perfilDoctor.Id, UserRoleId = role.Id
		);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert userDoctor2;
		}
		UserRole roleEncargado = [SELECT Id,Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Encargado_Filial_Mar_del_Plata'];
		userEncargado = new User(Alias = 'standtEn', Email='standarduser@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
			LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
			UserName=uniqueUserName + 'Encargado_Filial_Mar_del_Plata', ProfileId = pFront.Id, Profile = pFront, UserRoleId = roleEncargado.Id
		);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert userEncargado;
		}
		List<Group> groupMesa = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Mesa_de_ayuda'];
		List<GroupMember> groupMembersMesa = new List<GroupMember> {
			new GroupMember(groupId = groupMesa[0].Id, UserOrGroupId = userDoctor.Id),
			new GroupMember(groupId = groupMesa[0].Id, UserOrGroupId = userDoctor2.Id)
		};
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert groupMembersMesa;
		}
		delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('123456').build();
		insert delegacion;
		caso = new Case();
		insert caso;
		caso.Delegacion__c = delegacion.Id;
		update caso;
	}
	@isTest
	private static void getTypeAndExtensionTest() {
		String png = Utils.getTypeAndExtension('png');
		String jpg = Utils.getTypeAndExtension('jpg');
		String jpeg = Utils.getTypeAndExtension('jpeg');
		String pdf = Utils.getTypeAndExtension('pdf');
		String txt = Utils.getTypeAndExtension('txt');
		String nulo = Utils.getTypeAndExtension(null);
		System.assertEquals(png, 'image/png', 'el formato debe ser png');
		System.assertEquals(jpg, 'image/jpg', 'el formato debe ser jpg');
		System.assertEquals(jpeg, 'image/jpeg', 'el formato debe ser jpeg');
		System.assertEquals(pdf, 'application/pdf', 'el formato debe ser pdf');
		System.assertEquals(txt, 'text/plain', 'el formato debe ser plain');
		System.assertEquals(nulo, null, 'Debe ser nulo');
	}
	@isTest
	private static void translateStateAPToReintegroTest() {
		String generado = Utils.translateStateAPToReintegro('CA-----G');
		String centroAuto = Utils.translateStateAPToReintegro('CA-----A');
		String emitido = Utils.translateStateAPToReintegro('CA-----E');
		String anulado = Utils.translateStateAPToReintegro('CA-----N');
		String nulo = Utils.translateStateAPToReintegro(null);
		System.assertEquals(generado, 'CR-----G', 'EL estado debe ser CR-----G');
		System.assertEquals(centroAuto, 'CR-----A', 'EL estado debe ser CR-----A');
		System.assertEquals(emitido, 'CR-----E', 'EL estado debe ser CR-----E');
		System.assertEquals(anulado, 'CR-----N', 'EL estado debe ser CR-----N');
		System.assertEquals(nulo, null, 'Debe ser nulo');
	}
	@isTest
	private static void translateStateReintegroToAPTest() {
		String generado = Utils.translateStateReintegroToAP('CR-----G');
		String centroAuto = Utils.translateStateReintegroToAP('CR-----A');
		String emitido = Utils.translateStateReintegroToAP('CR-----E');
		String anulado = Utils.translateStateReintegroToAP('CR-----N');
		String nulo = Utils.translateStateReintegroToAP(null);
		System.assertEquals(generado, 'CA-----G', 'EL estado debe ser CR-----G');
		System.assertEquals(centroAuto, 'CA-----A', 'EL estado debe ser CR-----A');
		System.assertEquals(emitido, 'CA-----E', 'EL estado debe ser CR-----E');
		System.assertEquals(anulado, 'CA-----N', 'EL estado debe ser CR-----N');
		System.assertEquals(nulo, null, 'Debe ser nulo');
	}
	@isTest
	private static void translateEstadoCivilTest() {
		String casado = Utils.getEstadoCivilCodFromValue('Casado');
		String concubinato = Utils.getEstadoCivilCodFromValue('Concubinato');
		String divorciado = Utils.getEstadoCivilCodFromValue('Divorciado');
		String separado = Utils.getEstadoCivilCodFromValue('Separado');
		String soltero = Utils.getEstadoCivilCodFromValue('Soltero');
		String viudo = Utils.getEstadoCivilCodFromValue('Viudo');
		String nulo = Utils.getEstadoCivilCodFromValue(null);
		System.assertEquals(casado, 'C', 'El valor debe ser C');
		System.assertEquals(concubinato, 'N', 'El valor debe ser N');
		System.assertEquals(divorciado, 'D', 'El valor debe ser D');
		System.assertEquals(separado, 'P', 'El valor debe ser P');
		System.assertEquals(soltero, 'S', 'El valor debe ser S');
		System.assertEquals(viudo, 'V', 'El valor debe ser V');
		System.assertEquals(nulo, null, 'Debe ser nulo');
	}
	@isTest
	private static void delegacionIncorrectaWhenUserIsNotLider() {
		validarSiPerteneceADelegacion (userFront, false);
	}
	@isTest
	private static void delegacionIncorrectaBsAsYPampeana() {
		validarSiPerteneceADelegacion (liderBsAsYPampeana, false);
	}
	@isTest
	private static void delegacionIncorrectaAmba() {
		validarSiPerteneceADelegacion (liderAmba, false);
	}
	@isTest
	private static void delegacionIncorrectaBsAsCentro() {
		validarSiPerteneceADelegacion (liderBsAsCentro, false);
	}
	@isTest
	private static void delegacionIncorrectaBsAsNorte() {
		validarSiPerteneceADelegacion (liderBsAsNorte, false);
	}
	@isTest
	private static void delegacionIncorrectaCordoba() {
		validarSiPerteneceADelegacion (liderCordoba, false);
	}
	@isTest
	private static void delegacionIncorrectaLitoral() {
		validarSiPerteneceADelegacion (liderLitoral, false);
	}
	@isTest
	private static void delegacionIncorrectaNEA() {
		validarSiPerteneceADelegacion (liderNEA, false);
	}
	@isTest
	private static void delegacionIncorrectaNOA() {
		validarSiPerteneceADelegacion (liderNOA, false);
	}
	@isTest
	private static void delegacionIncorrectaNucleo() {
		validarSiPerteneceADelegacion (liderNucleo, false);
	}
	@isTest
	private static void delegacionIncorrectaPatagoniaAnd() {
		validarSiPerteneceADelegacion (liderPatagoniaAnd, false);
	}
	@isTest
	private static void delegacionIncorrectaPatagoniaAtl() {
		validarSiPerteneceADelegacion (liderPatagoniaAtl, false);
	}
	@isTest
	private static void delegacionCorrectaBsAsYPampeana() {
		asignarDelegacionACaso('650321');
		validarSiPerteneceADelegacion(liderBsAsYPampeana, true);
	}
	@isTest
	private static void delegacionCorrectaAmba() {
		asignarDelegacionACaso('650071');
		validarSiPerteneceADelegacion (liderAmba, true);
	}
	@isTest
	private static void delegacionCorrectaBsAsCentro() {
		asignarDelegacionACaso('650044');
		validarSiPerteneceADelegacion (liderBsAsCentro, true);
	}
	@isTest
	private static void delegacionCorrectaBsAsNorte() {
		asignarDelegacionACaso('650681');
		validarSiPerteneceADelegacion (liderBsAsNorte, true);
	}
	@isTest
	private static void delegacionCorrectaCordoba() {
		asignarDelegacionACaso('650461');
		validarSiPerteneceADelegacion (liderCordoba, true);
	}
	@isTest
	private static void delegacionCorrectaLitoral() {
		asignarDelegacionACaso('650886');
		validarSiPerteneceADelegacion (liderLitoral, true);
	}
	@isTest
	private static void delegacionCorrectaNEA() {
		asignarDelegacionACaso('650949');
		validarSiPerteneceADelegacion (liderNEA, true);
	}
	@isTest
	private static void delegacionCorrectaNOA() {
		asignarDelegacionACaso('650489');
		validarSiPerteneceADelegacion (liderNOA, true);
	}
	@isTest
	private static void delegacionCorrectaNucleo() {
		asignarDelegacionACaso('650989');
		validarSiPerteneceADelegacion (liderNucleo, true);
	}
	@isTest
	private static void delegacionCorrectaPatagoniaAnd() {
		asignarDelegacionACaso('650928');
		validarSiPerteneceADelegacion (liderPatagoniaAnd, true);
	}
	@isTest
	private static void delegacionCorrectaPatagoniaAtl() {
		asignarDelegacionACaso('650809');
		validarSiPerteneceADelegacion (liderPatagoniaAtl, true);
	}
	@isTest
	private static void whenADoctorWantsAuthorizeAnAlertAMAndTheMedicoAsignadoIsEmpty_assingHimself() {
		Case aCase = setCaseToAssignment(XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id, null);
		Boolean isAssinged;
		System.runAs(userDoctor) {
			Test.startTest();
			isAssinged = Utils.autoasignarMedico(alert.Id);
			Test.stopTest();
		}
		aCase = [SELECT Id, Medico_asignado__c FROM Case WHERE Id =: aCase.Id];
		System.assert(isAssinged, 'Se debería haber asignado el médico');
		System.assertEquals(userDoctor.Id, aCase.Medico_asignado__c, 'Se debería haber asignado el médico');
	}
	@isTest
	private static void whenADoctorWantsAuthorizeAnAlertAMAndTheMedicoAsignadoIsEmptyAtReintegro_assingHimself() {
		Case aCase = setCaseToAssignment(XappiaHelper.getRecordType('Case', 'Reintegro').Id, null);
		Account acc = Build.anAccountCuentapersonal().build();
		Boolean isAssinged;
		System.runAs(userDoctor) {
			Test.startTest();
			isAssinged = Utils.autoasignarMedico(alert.Id);
			Test.stopTest();
		}
		aCase = [SELECT Id, Medico_asignado__c FROM Case WHERE Id =: aCase.Id];
		System.assert(isAssinged, 'Se debería haber asignado el médico');
		System.assertEquals(userDoctor.Id, aCase.Medico_asignado__c, 'Se debería haber asignado el médico');
	}
	@isTest
	private static void whenADoctorWantsAuthorizeAnAlertAMAndTheMedicoAsignadoIsNotEmpty_dontAssingHimself() {
		Case aCase = setCaseToAssignment(XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id, userDoctor2.Id);
		Boolean isAssinged;
		System.runAs(userDoctor) {
			Test.startTest();
			isAssinged = Utils.autoasignarMedico(alert.Id);
			Test.stopTest();
		}
		aCase = [SELECT Id, Medico_asignado__c FROM Case WHERE Id =: aCase.Id];
		System.assert(!isAssinged, 'No se debería haber asignado el médico' );
		System.assertNotEquals(userDoctor.Id, aCase.Medico_asignado__c, 'No se debería haber asignado el médico');
	}
	@isTest
	private static void ifTheMailIsInvalidReturnFalse() {
		Test.startTest();
		Boolean isValid = Utils.isAValidEmail('-@-invalid.com');
		Boolean isValid2 = Utils.isAValidEmail('.@invalid-apm.com');
		Test.stopTest();
		System.assert(!isValid, 'El correo debe ser inválido');
		System.assert(!isValid2, 'El correo debe ser inválido');
	}
	@isTest
	private static void ifTheMailIsNullReturnFalse() {
		Test.startTest();
		Boolean isValid = Utils.isAValidEmail(null);
		Test.stopTest();
		System.assert(!isValid, 'El correo debe ser inválido');
	}
	@isTest
	private static void ifTheMailIsValidReturnTrue() {
		Test.startTest();
		Boolean isValid = Utils.isAValidEmail('valid@test.com');
		Test.stopTest();
		System.assert(isValid, 'El correo debe ser válido');
	}
	@isTest
	private static void getAccountsWithFailedUpsertTest() {
		Account[] accs = new List<Account>();
		String[] externalIds = new List<String>();
		for(Integer i = 0; i < 10; i++) {
			Account acc = new Account();
			if(math.mod(i, 2) == 0) {
				acc.LastName = 'AccountWithError';
				acc.Localidad_new__r = new Localidad__c(Loc_Id__c = '1234');
			}
			else {
				acc.LastName = 'Test';
			}
			accs.add(acc);
			externalIds.add(String.valueOf(i));
		}
		Database.UpsertResult[] results = Database.upsert(accs, false);
		Test.startTest();
		Utils.ResponseFailedUpserts res = Utils.getAccountsWithFailedUpsert(results, accs, externalIds);
		Test.stopTest();
		System.assertEquals(5, res.accounts.size(), 'Deben haber cinco cuentas fallidas');
		for(Account acc : res.accounts) {
			System.assertEquals('AccountWithError', acc.LastName, 'La cuenta debe ser AccountWithError');
		}
		System.assertEquals(5, res.externalIds.size(), ' Deben haber cinco external Ids');
		for(Integer i = 0; i < 4; i++) {
			System.assertEquals(String.valueOf(i * 2), res.externalIds[i], 'El External id no coincide');
		}
	}
	@isTest
	private static void whenTheUserIsAdminReturnTrue() {
		Test.startTest();
		Boolean resp = Utils.isLeader();
		Test.stopTest();
		System.assert(resp, 'Debe ser lider');
	}
	@isTest
	private static void whenTheUserIsLeaderOfCellReturnTrue() {
		List<Group> celula1Queue = [SELECT Id,Name FROM Group WHERE type= 'queue' AND DeveloperName = 'Celula_1'];
		if(celula1Queue.isEmpty()) {
			return;
		}
		GroupMember groupMember = new GroupMember(groupId = celula1Queue[0].Id, UserOrGroupId = userBack.Id);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert groupMember;
		}
		GroupMember[] leaders = [SELECT Id, UserOrGroupId, Group.DeveloperName
									FROM GroupMember
									WHERE Group.DeveloperName = 'Celula_1' AND UserOrGroupId =: userBack.Id];
		Boolean resp;
		System.runAs(userBack) {
			Test.startTest();
			resp = Utils.isLeader();
			Test.stopTest();
		}
		System.assert(resp, 'Debe ser lider');
	}
	@isTest
	private static void whenTheUserhasRoleLeaderReturnTrue() {
		Boolean resp;
		System.runAs(liderAmba) {
			Test.startTest();
			resp = Utils.isLeader();
			Test.stopTest();
		}
		System.assert(resp, 'Debe ser lider');
	}
	@isTest
	private static void whenTheUserIsNotLeaderReturnFalse() {
		Boolean resp;
		System.runAs(userFront) {
			Test.startTest();
			resp = Utils.isLeader();
			Test.stopTest();
		}
		System.assert(!resp, 'No debe ser lider');
	}
	@isTest
	private static void getStringAlphanumericOnlyTest() {
		String text = 'notificación - al (asociado)';
		Test.startTest();
		String resp = Utils.getStringAlphanumericOnly(text);
		Test.stopTest();
		System.assertEquals('notificacin al asociado', resp, 'Los valores de texto no coinciden');
	}
	@isTest
	private static void ifUserIsEncargadoReturnTrue() {
		Boolean resp;
		System.runAs(userEncargado) {
			Test.startTest();
			resp = Utils.isEncargado();
			Test.stopTest();
		}
		System.assert(resp, 'Debe ser encargado');
	}
	/** Utils */
	private static void validarSiPerteneceADelegacion (User userToCheck, Boolean debePertenecer) {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];
		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, userToCheck);
		Test.stopTest();
		if (debePertenecer) {
			System.assert(pertenece, 'EL usuario debe pertenecer a la delegación');
		} else {
			System.assert(!pertenece, 'EL usuario no debe pertenecer a la delegación');
		}
	}
	private static void asignarDelegacionACaso (String numeroDelegacion) {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion(numeroDelegacion).build();
		insert delegacionCorrecta;
		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;
	}
	private static Case setCaseToAssignment (String rTId, String medicoId) {
		Boolean esReintegro = rTId == XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.Nivel_de_derivacion__c = 'Nivel 2';
		aCase.RecordTypeId = rTId;
		if (String.isNotBlank(medicoId)){
			aCase.Medico_asignado__c = medicoId;
		}
		insert aCase;
		String prestId;
		if (esReintegro) {
			Prestacion_de_reintegro__c prest = new Prestacion_de_reintegro__c();
			prest.Caso__c = aCase.Id;
			insert prest;
			prestId = prest.Id;
		} else {
			Prestacion__c prest = new Prestacion__c();
			prest.Ap__c = aCase.Id;
			insert prest;
			prestId = prest.Id;
		}
		alert = new Alerta__c();
		if (esReintegro) {
			alert.Prestacion_de_reintegro__c = prestId;
		} else {
			alert.Prestacion__c = prestId;
		}
		alert.Funcion__c = 'AM';
		alert.Estado__c = 'C1-----A';
		insert alert;
		return aCase;
	}
}