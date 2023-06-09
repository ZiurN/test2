@IsTest
private class AlertaAutorizarBtnCtrlTest {
	public static final String ALERTA_AUTORIZAR_URL = ConfigUtils.getEndpointsByTipo('autorizaciones').get('alerta/autorizar').Endpoint__c;
	public static final String REINTEGROS_ALERTAS_URL = ConfigUtils.getEndpointsByTipo('reintegros').get('alertas').Endpoint__c;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundNoEM;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getResponseFoundReintegro;
	static XHttpCalloutMock getErrorResponseReintegro;
	static XHttpCalloutMock getErrorMessageWsResponse;
	static User userFront;
	static User userMesa;
	static User userDisca;
	static CaseTeamRole caseRole;
	static Profile perfilFront;
	static Profile perfilMesa;
	static Profile perfilDisca;
	static {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			for (Profile p : [SELECT Id, Name FROM Profile
								WHERE Name = 'Mesa de ayuda'
									OR Name = 'Front'
									OR Name = 'Discapacidad']) {
				if (p.Name == 'Mesa de ayuda') perfilMesa = p;
				else if (p.Name == 'Front') perfilFront = p;
				else if (p.Name == 'Discapacidad') perfilDisca = p;
			}
			String uniqueUserName = 'standarduserAutAlert' + DateTime.now().getTime() + '@testorg.com';
			UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
			userFront = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName + 'FrontAutAlert', ProfileId = perfilFront.Id, UserRoleId = role.Id);
			insert userFront;
			userMesa = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'MesaAutAlert', ProfileId = perfilMesa.Id, UserRoleId = role.Id);
			insert userMesa;
			userDisca = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'Disca', ProfileId = perfilDisca.Id, UserRoleId = role.Id);
			insert userDisca;
			List<Group> groupFront = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Front'];
			GroupMember groupMemberF = new GroupMember(groupId = groupFront[0].Id, UserOrGroupId = userFront.Id);
			insert groupMemberF;
			List<Group> groupMesa = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Mesa_de_ayuda'];
			GroupMember groupMemberM = new GroupMember(groupId = groupMesa[0].Id, UserOrGroupId = userMesa.Id);
			insert groupMemberM;
			caseRole = new CaseTeamRole();
			caseRole.Name = 'Cel Test';
			caseRole.AccessLevel = 'Edit';
			insert caseRole;
		}
		getResponseFound = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseFound,
			ALERTA_AUTORIZAR_URL + '/16461690',
			WSAlertaAutorizarRespMock.getFound(),
			200,
			'OK'
		);
		getResponseFoundNoEM = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseFoundNoEM,
			ALERTA_AUTORIZAR_URL + '/16461790',
			WSAlertaAutorizarRespMock.getFound2(),
			200,
			'OK'
		);
		getErrorResponse = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getErrorResponse,
			ALERTA_AUTORIZAR_URL + '/',
			WSAlertaAutorizarRespMock.getError(),
			404,
			'Not Found'
		);
		getErrorMessageWsResponse = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getErrorMessageWsResponse,
			ALERTA_AUTORIZAR_URL + '/1234',
			WSAlertaAutorizarRespMock.getError(),
			404,
			'Not Found'
		);
		getResponseFoundReintegro = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseFoundReintegro,
			REINTEGROS_ALERTAS_URL + '/16461901',
			WSAlertaReintegroMock.getFound(),
			200,
			'OK'
		);
		getErrorResponseReintegro = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getErrorResponseReintegro,
			REINTEGROS_ALERTAS_URL + '/16461630',
			WSAlertaRechazarMock.getError(),
			404,
			'Error'
		);
	}
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAAlertaAutorizar_returnACorrectResponse() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '276013', Estado__c = 'En Auditoria');
		insert em;
		Segmentos__c seg = new Segmentos__c(Semid__c = '305822', Estado__c = 'En auditoria', Evento_Medico__c = em.Id);
		insert seg;
		Case caso = new Case(Nro_AP__c = '1014010147', Evento_Medico__c = em.Id);
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		caso.Correo_asociado__c = 'ej@test.com';
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042498', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461690', Prestacion__c = pres.Id, Evento_Medico__c = em.Id);
		insert alerta;
		Test.startTest();
		AlertaAutorizarBtnCtrl.Response responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
		Test.stopTest();
		Alerta__c alertSOQL = getAlerts(alerta.idalerta__c);
		Evento_medico__c emSOQL = [SELECT Estado__c,
										(SELECT Semid__c,
											Estado__c
										FROM Segmentos__r),
										(SELECT Nivel_de_derivacion__c
										FROM Casos__r)
									FROM Evento_medico__c
									WHERE Id =: em.Id];
		System.assertEquals('Autorizado', emSOQL.Estado__c, 'El Estado debe ser Autorizado');
		System.assertEquals('Autorizado', emSOQL.Segmentos__r[0].Estado__c, 'El Estado debe ser Autorizado');
		System.assertEquals('Nivel 3', emSOQL.Casos__r[0].Nivel_de_derivacion__c, 'El nivel de derivación debe ser 3');
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('C1EA--AA', alertSOQL.Prestacion__r.Estado__c, 'El estado de la prestación debe ser C1EA--AA');
		System.assertEquals('C1EA--AA', alertSOQL.Estado__c, 'El estado de la alerat debe ser C1EA--AA');
		System.assertEquals(Date.valueOf('2020-02-29'), alertSOQL.Fecha_resolucion_de_Alerta__c, 'Las fechas no coinciden');
	}
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAAlertaAutorizarNoEM_returnACorrectResponse() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);
		Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '276013', Estado__c = 'En Auditoria');
		insert em;
		Segmentos__c seg = new Segmentos__c(Semid__c = '305822', Estado__c = 'En auditoria', Evento_Medico__c = em.Id);
		insert seg;
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		caso.Correo_asociado__c = 'ej@test.com';
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
		insert alerta;
		Test.startTest();
		AlertaAutorizarBtnCtrl.Response responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
		Test.stopTest();
		Alerta__c alertSOQL = getAlerts(alerta.idalerta__c);
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('C1EA--AA', alertSOQL.Prestacion__r.Estado__c, 'El estado de la prestación debe ser C1EA--AA');
		System.assertEquals('Nivel 3', alertSOQL.Prestacion__r.Ap__r.Nivel_de_derivacion__c, 'El nivel de derivación debe ser 3');
		System.assertEquals('C1EA--AA', alertSOQL.Estado__c, 'El estado de la alerta debe esr C1EA--AA');
		System.assertEquals(Date.valueOf('2020-02-29'), alertSOQL.Fecha_resolucion_de_Alerta__c, 'Las fechas no coinciden');
	}
	@IsTest
	public static void whenTheBtnIsClickedFromAnAlertWithExternalIdEmpty_returnErrorMessage() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		AlertaAutorizarBtnCtrl.Response responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(null);
		Test.stopTest();
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_NoId);
	}
	@IsTest
	public static void whenTheWsHaveSomeError_returnErrorMessageFromWs() {
		Test.setMock(HttpCalloutMock.class, getErrorMessageWsResponse);
		Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '276013', Estado__c = 'En Auditoria');
		insert em;
		Segmentos__c seg = new Segmentos__c(Semid__c = '305822', Estado__c = 'En auditoria', Evento_Medico__c = em.Id);
		insert seg;
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042384', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '1234', Prestacion__c = pres.Id, Evento_Medico__c = em.Id);
		insert alerta;
		Test.startTest();
		AlertaAutorizarBtnCtrl.Response responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta('1234');
		Test.stopTest();
		validateErrorMessage(responseToAssert, 'La alerta solicitada es inválida.');
	}
	@IsTest
	public static void ifTheProfileIsNotFrontShowCorrectError() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name='Discapacidad'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName, ProfileId = p.Id, UserRole = role);
		insert usuario;
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_FRONT');
		insert alerta;
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs(usuario){
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_AlertFront);
	}
	@IsTest
	public static void ifTheProfileIsNotBackShowCorrectError() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs(userFront){
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_BACK');
		insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_AlertBack);
	}
	@IsTest
	public static void ifTheProfileIsNotAMShowCorrectError() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		caso.OwnerId = userFront.Id;
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'AM');
		insert alerta;
		System.runAs(userFront) {
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_AlertAM);
	}
	@IsTest
	public static void ifTheProfileIsNotComprasTecnicasShowCorrectError() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs(userFront){
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'CPRAS_TECNI');
		insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_CPRAS_TECNI);
	}
	@IsTest
	public static void ifTheProfileIsNotDiscapacidadShowCorrectError() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs(userFront) {
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_DISCA');
		insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_AlertDiscapacidad);
	}
	@IsTest
	public static void ifTheProfileIsNotDiscapacidadInterdisciplinariohowCorrectError() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs(userFront) {
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_ID');
		insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_AlertID);
	}
	@IsTest
	public static void ifTheProfileIsNotPresupuestohowCorrectError() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs(userFront) {
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_PRESU');
		insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_AlertPresupuesto);
	}
	@IsTest
	public static void whenTryToAuthorizeAnAlertWithAHigherNivelDeAuditoria_showTheCorrectError() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;
		Alerta__c alertaMenorNivelSinAutorizar = new Alerta__c(Prestacion__c = pres.Id, Nivel_de_auditoria__c = 120,
			Estado__c = 'C1-----A'); //C1EA--AA
		insert alertaMenorNivelSinAutorizar;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Nivel_de_auditoria__c = 200);
		insert alerta;
		Test.startTest();
		AlertaAutorizarBtnCtrl.Response responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
		Test.stopTest();
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_AuditoriaMenor);
	}
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAAlertaReintegroAutorizar_returnACorrectResponse() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundReintegro);
		Case reintegro = new Case(Codigo_reintegro_SS__c = '553276');
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;
		Prestacion_de_reintegro__c pres = new Prestacion_de_reintegro__c(Id_Externo__c = '74042509', Caso__c = reintegro.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461901', Prestacion_de_reintegro__c = pres.Id);
		insert alerta;
		Test.startTest();
		AlertaAutorizarBtnCtrl.Response responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
		Test.stopTest();
		Alerta__c alertSOQL = getAlerts(alerta.idalerta__c);
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('C1EA-RAP', alertSOQL.Prestacion_de_reintegro__r.Estado__c, 'El estado de la prestación debe ser C1EA-RAP');
		System.assertEquals('C1EA-RAP', alertSOQL.Estado__c, 'El estado de la alerta debe ser C1EA-RAP');
		System.assertEquals(Date.valueOf('2021-08-31'), alertSOQL.Fecha_resolucion_de_Alerta__c, 'Las fechas no coinciden');
	}
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAAlertaReintegroAutorizar_returnAnErrorResponse() {
		Test.setMock(HttpCalloutMock.class, getErrorResponseReintegro);
		Case reintegro = new Case(Codigo_reintegro_SS__c = '553276');
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;
		Prestacion_de_reintegro__c pres = new Prestacion_de_reintegro__c(Id_Externo__c = '74042491', Caso__c = reintegro.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461630', Prestacion_de_reintegro__c = pres.Id);
		insert alerta;
		Test.startTest();
		AlertaAutorizarBtnCtrl.Response responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
		Test.stopTest();
		validateErrorMessage(responseToAssert, 'La alerta solicitada es inválida.');
	}
	@isTest
	private static void validateUserWhenNoBelongsToFrontQueueAndCaseIsNivel1() {
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs(userMesa) {
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.Nivel_de_derivacion__c = 'Nivel 1';
			insert caso;
			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;
			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_UsuarioNoFront);
	}
	@isTest
	private static void validateUserWhenNoBelongsToMesaQueueAndCaseIsNivel2() {
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs(userFront) {
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.Nivel_de_derivacion__c = 'Nivel 2';
			insert caso;
			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;
			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_UsuarioNoMesaAyuda);
	}
	@isTest
	private static void validateUserWhenNoBelongsToTeamCaseAndCaseIsNivel3() {
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs(userFront) {
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.OwnerId = userFront.Id;
			caso.Nivel_de_derivacion__c = 'Nivel 3';
			insert caso;
			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;
			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_UsuarioNoEquipoCaso);
	}
	@isTest
	private static void whenADoctorWantsAuthorizeAnAlertAMAndTheMedicoAsignadoIsEmpty_assingHimself() {
		String uniqueUserName = 'standarduserAutorizarAlerta' + DateTime.now().getTime() + '@testorg.com';
		Profile perfilDoctor = [SELECT Id FROM Profile WHERE Name='Auditor Medico'];
		User userDoctor = new User(Alias = 'standt', Email='standarduser@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
			LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
			UserName=uniqueUserName + 'DoctorUtils', ProfileId = perfilDoctor.Id
		);
		insert userDoctor;
		List<Group> groupMesa = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Mesa_de_ayuda'];
		GroupMember groupMemberMesa = new GroupMember(groupId = groupMesa[0].Id, UserOrGroupId = userDoctor.Id);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert groupMemberMesa;
		}
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
		AlertaAutorizarBtnCtrl.Response resp;
		System.runAs(userDoctor) {
			Test.startTest();
			resp = AlertaAutorizarBtnCtrl.autoasignarMedico(alert.Id);
			Test.stopTest();
		}
		aCase = [SELECT Id, Medico_asignado__c FROM Case WHERE Id =: aCase.Id];
		System.assertEquals(userDoctor.Id, aCase.Medico_asignado__c, 'El médico asignado al caso debe ser el médico de prueba');
	}
	@isTest
	private static void whenACaseDoesntHaveAResponsableAndAnUserWantsToAuthorizeABackAlert_ShowTheErrorMsg() {
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		Profile[] backProfile = [SELECT Id FROM Profile WHERE Name = 'Back Administrativo'];
		if(!backProfile.isEmpty()) {
			userFront.ProfileId = backProfile[0].Id;
			update userFront;
		}
		else {
			return;
		}
		System.runAs(userFront) {
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.Nivel_de_derivacion__c = 'Nivel 2';
			insert caso;
			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;
			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			alerta.Funcion__c = 'FCION_BACK';
			insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_AuthBackIfResponsableAsignado);
	}
	@isTest
	private static void whenACaseDoesntHaveAResponsableAndAnUserWantsToAuthorizeAComprasTecnicasAlert_ShowTheErrorMsg() {
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		Profile[] comprasProfile = [SELECT Id FROM Profile WHERE Name = 'Compras Tecnicas'];
		if(!comprasProfile.isEmpty()) {
			userFront.ProfileId = comprasProfile[0].Id;
			update userFront;
		}
		else {
			return;
		}
		System.runAs(userFront) {
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.Nivel_de_derivacion__c = 'Nivel 2';
			insert caso;
			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;
			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			alerta.Funcion__c = 'CPRAS_TECNI';
			insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_NoAuth_CPRAS_TECNI_Responsable);
	}
	@isTest
	private static void whenACaseDoesntHaveAResponsableAndAnUserWantsToAuthorizeADiscaAlert_ShowTheErrorMsg() {
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		Profile[] discaProfile = [SELECT Id FROM Profile WHERE Name = 'Discapacidad'];
		if(!discaProfile.isEmpty()) {
			userFront.ProfileId = discaProfile[0].Id;
			update userFront;
		}
		else {
			return;
		}
		System.runAs(userFront) {
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.Nivel_de_derivacion__c = 'Nivel 2';
			insert caso;
			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;
			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			alerta.Funcion__c = 'FCION_DISCA';
			insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_AuthDiscapacidadIfResponsableAsignado);
	}
	@isTest
	private static void whenACaseDoesntHaveAResponsableAndAnUserWantsToAuthorizeADiscaIDAlert_ShowTheErrorMsg() {
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		Profile[] discaIDProfile = [SELECT Id FROM Profile WHERE Name = 'Discapacidad Interdisciplinario'];
		if(!discaIDProfile.isEmpty()) {
			userFront.ProfileId = discaIDProfile[0].Id;
			update userFront;
		}
		else {
			return;
		}
		System.runAs(userFront) {
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.Nivel_de_derivacion__c = 'Nivel 2';
			insert caso;
			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;
			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			alerta.Funcion__c = 'FCION_ID';
			insert alerta;
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		validateErrorMessage(responseToAssert, System.Label.Alerta_AuthIDIfResponsableAsignado);
	}
	@isTest
	private static void ifUserIsDiscaId_shouldSendAlertAndWorkJustFine () {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '276013', Estado__c = 'En Auditoria');
		insert em;
		Segmentos__c seg = new Segmentos__c(Semid__c = '305822', Estado__c = 'En auditoria', Evento_Medico__c = em.Id);
		insert seg;
		Case caso = new Case(Nro_AP__c = '1014010147', Evento_Medico__c = em.Id, Responsable_de_presupuesto__c = userDisca.Id);
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
		caso.Correo_asociado__c = 'ej@test.com';
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042498', Ap__c = caso.Id);
		insert pres;
		Alerta__c alerta = new Alerta__c(idalerta__c = '16461690', Prestacion__c = pres.Id, Evento_Medico__c = em.Id, Funcion__c = 'CPRAS_TECNI');
		insert alerta;
		AlertaAutorizarBtnCtrl.Response responseToAssert;
		System.runAs (userDisca) {
			Test.startTest();
			responseToAssert = AlertaAutorizarBtnCtrl.autorizarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}
		Alerta__c alertSOQL = getAlerts(alerta.idalerta__c);
		Evento_medico__c emSOQL = [SELECT Estado__c,
										(SELECT Semid__c,
											Estado__c
										FROM Segmentos__r),
										(SELECT Nivel_de_derivacion__c
										FROM Casos__r)
									FROM Evento_medico__c
									WHERE Id =: em.Id];
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals(responseToAssert.message, 'Ok', 'El mensaje debe ser Ok');
		System.assertEquals('Autorizado', emSOQL.Estado__c, 'El Estado debe ser Autorizado');
		System.assertEquals('Autorizado', emSOQL.Segmentos__r[0].Estado__c, 'El Estado debe ser Autorizado');
		System.assertEquals('Nivel 3', emSOQL.Casos__r[0].Nivel_de_derivacion__c, 'El nivel de derivación debe ser 3');
		System.assertEquals('C1EA--AA', alertSOQL.Prestacion__r.Estado__c, 'El estado de la prestación debe ser C1EA--AA');
		System.assertEquals('C1EA--AA', alertSOQL.Estado__c, 'El estado de la alerat debe ser C1EA--AA');
		System.assertEquals(Date.valueOf('2020-02-29'), alertSOQL.Fecha_resolucion_de_Alerta__c, 'Las fechas no coinciden');
	}
	/** Utils */
	private static void validateErrorMessage (AlertaAutorizarBtnCtrl.Response responseToAssert, String expectedErrorMessage) {
		System.assert(responseToAssert.hasError, 'Debe haber ocurrido un error');
		System.assertEquals(expectedErrorMessage, responseToAssert.message, 'El mensaje no indica el error');
	}
	private static Alerta__c getAlerts (String alertId) {
		return [SELECT Estado__c,
					Resolucion_de_alerta_auditor__c,
					Fecha_resolucion_de_Alerta__c,
					Prestacion_de_reintegro__r.Estado__c,
					Prestacion__r.Ap__r.Nivel_de_derivacion__c,
					Prestacion__r.Estado__c
				FROM Alerta__c
				WHERE idalerta__c =: alertId];
	}
}