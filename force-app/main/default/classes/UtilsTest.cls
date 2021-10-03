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
	static User userDoctor;
	static User userDoctor2;
	static Case caso;
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
		
		System.assertEquals(png, 'image/png');
		System.assertEquals(jpg, 'image/jpg');
		System.assertEquals(jpeg, 'image/jpeg');
		System.assertEquals(pdf, 'application/pdf');
		System.assertEquals(txt, 'text/plain');
		System.assertEquals(nulo, null);
	}

	@isTest
	private static void translateStateAPToReintegroTest() {

		String generado = Utils.translateStateAPToReintegro('CA-----G');
		String centroAuto = Utils.translateStateAPToReintegro('CA-----A');
		String emitido = Utils.translateStateAPToReintegro('CA-----E');
		String anulado = Utils.translateStateAPToReintegro('CA-----N');
		String nulo = Utils.translateStateAPToReintegro(null);
		
		System.assertEquals(generado, 'CR-----G');
		System.assertEquals(centroAuto, 'CR-----A');
		System.assertEquals(emitido, 'CR-----E');
		System.assertEquals(anulado, 'CR-----N');
		System.assertEquals(nulo, null);
	}

	@isTest
	private static void translateStateReintegroToAPTest() {

		String generado = Utils.translateStateReintegroToAP('CR-----G');
		String centroAuto = Utils.translateStateReintegroToAP('CR-----A');
		String emitido = Utils.translateStateReintegroToAP('CR-----E');
		String anulado = Utils.translateStateReintegroToAP('CR-----N');
		String nulo = Utils.translateStateReintegroToAP(null);
		
		System.assertEquals(generado, 'CA-----G');
		System.assertEquals(centroAuto, 'CA-----A');
		System.assertEquals(emitido, 'CA-----E');
		System.assertEquals(anulado, 'CA-----N');
		System.assertEquals(nulo, null);
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
		
		System.assertEquals(casado, 'C');
		System.assertEquals(concubinato, 'N');
		System.assertEquals(divorciado, 'D');
		System.assertEquals(separado, 'P');
		System.assertEquals(soltero, 'S');
		System.assertEquals(viudo, 'V');
		System.assertEquals(nulo, null);
	}

	@isTest
	private static void delegacionIncorrectaWhenUserIsNotLider() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, userFront);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaBsAsYPampeana() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderBsAsYPampeana);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaAmba() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderAmba);
		Test.stopTest();

		System.assert(!pertenece);

	}

	@isTest
	private static void delegacionIncorrectaBsAsCentro() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderBsAsCentro);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaBsAsNorte() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderBsAsNorte);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaCordoba() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderCordoba);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaLitoral() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderLitoral);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaNEA() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderNEA);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaNOA() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderNOA);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaNucleo() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderNucleo);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaPatagoniaAnd() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderPatagoniaAnd);
		Test.stopTest();

		System.assert(!pertenece);
	}

	@isTest
	private static void delegacionIncorrectaPatagoniaAtl() {
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderPatagoniaAtl);
		Test.stopTest();

		System.assert(!pertenece);
	}
//------------------------------------------------------------------------------------------
	@isTest
	private static void delegacionCorrectaBsAsYPampeana() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650321').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;

		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderBsAsYPampeana);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void delegacionCorrectaAmba() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650071').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;

		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderAmba);
		Test.stopTest();

		System.assert(pertenece);

	}

	@isTest
	private static void delegacionCorrectaBsAsCentro() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650044').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;

		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderBsAsCentro);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void delegacionCorrectaBsAsNorte() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650681').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;

		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderBsAsNorte);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void delegacionCorrectaCordoba() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650461').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;

		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderCordoba);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void delegacionCorrectaLitoral() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650886').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;

		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderLitoral);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void delegacionCorrectaNEA() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650949').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;
		
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderNEA);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void delegacionCorrectaNOA() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650489').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;
		
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderNOA);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void delegacionCorrectaNucleo() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650989').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;
		
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderNucleo);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void delegacionCorrectaPatagoniaAnd() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650928').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;
		
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderPatagoniaAnd);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void delegacionCorrectaPatagoniaAtl() {
		Account delegacionCorrecta = Build.anAccountDelegacion().withCodigoDeDelegacion('650809').build();
		insert delegacionCorrecta;

		caso.Delegacion__c = delegacionCorrecta.Id;
		update caso;
		
		Case casoQuery = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id = :caso.Id];

		Test.startTest();
		Boolean pertenece = Utils.perteneceALaDelegacionCorrecta(casoQuery, liderPatagoniaAtl);
		Test.stopTest();

		System.assert(pertenece);
	}

	@isTest
	private static void whenADoctorWantsAuthorizeAnAlertAMAndTheMedicoAsignadoIsEmpty_assingHimself() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;

		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.Nivel_de_derivacion__c = 'Nivel 2';
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Ap__c = aCase.Id;
		insert prest;

		Alerta__c alert = new Alerta__c();
		alert.Prestacion__c = prest.Id;
		alert.Funcion__c = 'AM';
		alert.Estado__c = 'C1-----A';
		insert alert;
		
		Boolean isAssinged;
		System.runAs(userDoctor) {

			Test.startTest();
			isAssinged = Utils.autoasignarMedico(alert.Id);
			Test.stopTest();
		}

		aCase = [SELECT Id, Medico_asignado__c FROM Case WHERE Id =: aCase.Id];

		System.assert(isAssinged);
		System.assertEquals(userDoctor.Id, aCase.Medico_asignado__c);
	}

	@isTest
	private static void whenADoctorWantsAuthorizeAnAlertAMAndTheMedicoAsignadoIsEmptyAtReintegro_assingHimself() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;

		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.Nivel_de_derivacion__c = 'Nivel 2';
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert aCase;

		Prestacion_de_reintegro__c prest = new Prestacion_de_reintegro__c();
		prest.Caso__c = aCase.Id;
		insert prest;

		Alerta__c alert = new Alerta__c();
		alert.Prestacion_de_reintegro__c = prest.Id;
		alert.Funcion__c = 'AM';
		alert.Estado__c = 'C1-----A';
		insert alert;
		
		Boolean isAssinged;
		System.runAs(userDoctor) {

			Test.startTest();
			isAssinged = Utils.autoasignarMedico(alert.Id);
			Test.stopTest();
		}

		aCase = [SELECT Id, Medico_asignado__c FROM Case WHERE Id =: aCase.Id];

		System.assert(isAssinged);
		System.assertEquals(userDoctor.Id, aCase.Medico_asignado__c);
	}

	@isTest
	private static void whenADoctorWantsAuthorizeAnAlertAMAndTheMedicoAsignadoIsNotEmpty_dontAssingHimself() {
		Case aCase = new Case();
		aCase.Nivel_de_derivacion__c = 'Nivel 2';
		aCase.Medico_asignado__c = userDoctor2.Id;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Ap__c = aCase.Id;
		insert prest;

		Alerta__c alert = new Alerta__c();
		alert.Prestacion__c = prest.Id;
		alert.Funcion__c = 'AM';
		alert.Estado__c = 'C1-----A';
		insert alert;
		
		Boolean isAssinged;
		System.runAs(userDoctor) {
			Test.startTest();
			isAssinged = Utils.autoasignarMedico(alert.Id);
			Test.stopTest();
		}

		aCase = [SELECT Id, Medico_asignado__c FROM Case WHERE Id =: aCase.Id];

		System.assert(!isAssinged);
		System.assertNotEquals(userDoctor.Id, aCase.Medico_asignado__c);
	}

	@isTest
	private static void ifTheMailIsInvalidReturnFalse() {
		Test.startTest();
		Boolean isValid = Utils.isAValidEmail('-@-invalid.com');
		Boolean isValid2 = Utils.isAValidEmail('.@invalid-apm.com');
		Test.stopTest();

		System.assert(!isValid);
		System.assert(!isValid2);
	}

	@isTest
	private static void ifTheMailIsNullReturnFalse() {
		Test.startTest();
		Boolean isValid = Utils.isAValidEmail(null);
		Test.stopTest();

		System.assert(!isValid);
	}

	@isTest
	private static void ifTheMailIsValidReturnTrue() {
		Test.startTest();
		Boolean isValid = Utils.isAValidEmail('valid@test.com');
		Test.stopTest();

		System.assert(isValid);
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

		System.assertEquals(5, res.accounts.size());
		for(Account acc : res.accounts) {
			System.assertEquals('AccountWithError', acc.LastName);
		}

		System.assertEquals(5, res.externalIds.size());
		for(Integer i = 0; i < 4; i++) {
			System.assertEquals(String.valueOf(i * 2), res.externalIds[i]);
		}

	}

	@isTest
	private static void whenTheUserIsAdminReturnTrue() {
		Test.startTest();
		Boolean resp = Utils.isLeader();
		Test.stopTest();

		System.assert(resp);

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

		GroupMember[] leaders = [
			SELECT Id, UserOrGroupId, Group.DeveloperName 
			FROM GroupMember 
			WHERE Group.DeveloperName = 'Celula_1' AND UserOrGroupId =: userBack.Id
		];
		System.debug(leaders);

		Boolean resp;

		System.runAs(userBack) {
			Test.startTest();
			resp = Utils.isLeader();
			Test.stopTest();
		}

		System.assert(resp);

	}

	@isTest
	private static void whenTheUserhasRoleLeaderReturnTrue() {
		Boolean resp;

		System.runAs(liderAmba) {
			Test.startTest();
			resp = Utils.isLeader();
			Test.stopTest();
		}

		System.assert(resp);

	}

	@isTest
	private static void whenTheUserIsNotLeaderReturnFalse() {
		Boolean resp;

		System.runAs(userFront) {
			Test.startTest();
			resp = CaseAPRevertirOrdenCtrl.isLeader();
			Test.stopTest();
		}

		System.assert(!resp);

	}

	@isTest
	private static void getStringAlphanumericOnlyTest() {
		String text = 'notificación - al (asociado)';

		Test.startTest();
		String resp = Utils.getStringAlphanumericOnly(text);
		Test.stopTest();

		System.assertEquals('notificacin - al (asociado)', resp);

	}
}