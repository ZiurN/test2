@IsTest
private class AlertaRechazarBtnCtrlTest {

    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getResponseFoundNoEM;
    static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getErrorMessageWsResponse;
	
	static XHttpCalloutMock getResponseFoundReintegro;
	static XHttpCalloutMock getResponseFoundNoEMReintegro;

	static User userFront;
	static User userMesa;
	static CaseTeamRole caseRole;
	static Profile perfilFront;
	static Profile perfilMesa;

    static {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String uniqueUserName = 'standarduserRechAlert' + DateTime.now().getTime() + '@testorg.com';
			UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
			
			perfilFront = [SELECT Id FROM Profile WHERE Name='Front'];
			userFront = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName + 'FrontAutAlert', ProfileId = perfilFront.Id, UserRoleId = role.Id);
			insert userFront;

			perfilMesa = [SELECT Id FROM Profile WHERE Name='Mesa de ayuda'];
			userMesa = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'MesaAutAlert', ProfileId = perfilMesa.Id, UserRoleId = role.Id);
			insert userMesa;

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
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAlertaRechazarMock.getFound())
                .addForAddress(WSAlertaRechazar.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/alerta/rechazar/16461901');

        getResponseFoundNoEM = new XHttpCalloutMock();
        getResponseFoundNoEM.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFoundNoEM.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAlertaRechazarMock.getFound2())
                .addForAddress(WSAlertaRechazar.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/alerta/rechazar/16461630');

		
		getResponseFoundNoEMReintegro = new XHttpCalloutMock();
		getResponseFoundNoEMReintegro.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundNoEMReintegro.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAlertaRechazarMock.getFound2())
				.addForAddress(WSAlertaRechazar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/alertas/16461630');

		getResponseFoundReintegro = new XHttpCalloutMock();
		getResponseFoundReintegro.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundReintegro.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAlertaReintegroMock.getFound())
				.addForAddress(WSAlertaReintegroAutorizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/alertas/16461901');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSAlertaRechazarMock.getError())
                .addForAddress(WSAlertaRechazar.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/alerta/rechazar/');

        getErrorMessageWsResponse = new XHttpCalloutMock();
        getErrorMessageWsResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorMessageWsResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSAlertaRechazarMock.getError())
                .addForAddress(WSAlertaRechazar.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/alerta/rechazar/1234');
    }

    @IsTest
    public static void whenTheBtnIsClickedInTheView_consumeWSAAlertaAutorizar_returnACorrectResponse() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '276059', Estado__c = 'En Auditoria',Fecha_y_hora_fin_ems__c = Date.today().addDays(2));
        insert em;
        Segmentos__c seg = new Segmentos__c(Semid__c = '305873', Estado__c = 'En auditoria', Evento_Medico__c = em.Id,Fecha_Inicio_real__c = Date.today().addDays(-2),Fecha_Fin_real__c = Date.today().addDays(3));
        insert seg;
        Case caso = new Case(Nro_AP__c = '1014010186', Evento_Medico__c = em.Id,Fecha__c = Date.today());
		insert caso;
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042509', Ap__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461901', Prestacion__c = pres.Id, Evento_Medico__c = em.Id);
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

        Test.startTest();
        AlertaRechazarBtnCtrl.Response responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
        Test.stopTest();

        Alerta__c alertSOQL = [
                SELECT Estado__c, Resolucion_de_alerta_auditor__c, Fecha_resolucion_de_Alerta__c, Prestacion__r.Estado__c
                FROM Alerta__c
                WHERE idalerta__c =: alerta.idalerta__c
        ];
        Evento_medico__c emSOQL = [
                SELECT Estado__c,
                    (
                        SELECT Semid__c, Estado__c FROM Segmentos__r
                    ),
					(
						SELECT Nivel_de_derivacion__c FROM Casos__r
					)
                FROM Evento_medico__c
                WHERE Id =: em.Id
        ];

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals('Rechazado', emSOQL.Estado__c);
        System.assertEquals('Rechazado', emSOQL.Segmentos__r[0].Estado__c);
		System.assertEquals('Nivel 3', emSOQL.Casos__r[0].Nivel_de_derivacion__c);
        System.assertEquals('C1EA-RAA', alertSOQL.Prestacion__r.Estado__c);
        System.assertEquals('C1EA-RAA', alertSOQL.Estado__c);
        System.assertEquals(Date.valueOf('2020-03-02'), alertSOQL.Fecha_resolucion_de_Alerta__c);
    }

    @IsTest
    public static void whenTheBtnIsClickedInTheView_consumeWSAAlertaAutorizaNoEM_returnACorrectResponse(){
        Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);

        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275998', Estado__c = 'En Auditoria');
        insert em;
        Segmentos__c seg = new Segmentos__c(Semid__c = '305822', Estado__c = 'En auditoria', Evento_Medico__c = em.Id);
        insert seg;
		Case caso = new Case(Nro_AP__c = '1014010140');
		insert caso;
        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042491', Ap__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461630', Prestacion__c = pres.Id);
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

        Test.startTest();
        AlertaRechazarBtnCtrl.Response responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
        Test.stopTest();

        Alerta__c alertSOQL = [
                SELECT Estado__c, Resolucion_de_alerta_auditor__c, Fecha_resolucion_de_Alerta__c, Prestacion__r.Estado__c,
					Prestacion__r.Ap__r.Nivel_de_derivacion__c
                FROM Alerta__c
                WHERE idalerta__c =: alerta.idalerta__c
        ];

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals('C1EA-RAA', alertSOQL.Prestacion__r.Estado__c);
		System.assertEquals('Nivel 3', alertSOQL.Prestacion__r.Ap__r.Nivel_de_derivacion__c);
        System.assertEquals('C1EA-RAA', alertSOQL.Estado__c);
        System.assertEquals(Date.valueOf('2020-02-28'), alertSOQL.Fecha_resolucion_de_Alerta__c);
    }

    @IsTest
    public static void whenTheBtnIsClickedFromAnAlertWithExternalIdEmpty_returnErrorMessage(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);

        Test.startTest();
        AlertaRechazarBtnCtrl.Response responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(null);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals('El id externo está vacío', responseToAssert.message);
    }

    @IsTest
    public static void whenTheWsHaveSomeError_returnErrorMessageFromWs(){
        Test.setMock(HttpCalloutMock.class, getErrorMessageWsResponse);

        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275998', Estado__c = 'En Auditoria');
        insert em;

        Segmentos__c seg = new Segmentos__c(Semid__c = '305822', Estado__c = 'En auditoria', Evento_Medico__c = em.Id);
        insert seg;

		Case caso = new Case(Nro_AP__c = '1014010140');
		insert caso;

        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042491', Ap__c = caso.Id);
        insert pres;

        Alerta__c alerta = new Alerta__c(idalerta__c = '1234', Prestacion__c = pres.Id, Evento_Medico__c = em.Id);
		alerta.Prestacion_de_Reintegro__c = null;
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

        Test.startTest();
        AlertaRechazarBtnCtrl.Response responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta('1234');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals('La alerta solicitada es inválida.', responseToAssert.message);
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
		insert caso;
        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_FRONT');
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(usuario){
			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('No se permite rechazar alerta Front', responseToAssert.message);
    }

	@IsTest
    public static void ifTheProfileIsNotBackShowCorrectError() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);

		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.OwnerId = userFront.Id;
		insert caso;
        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_BACK');
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(userFront){
			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('No se permite rechazar alerta Back', responseToAssert.message);
    }

	@IsTest
    public static void ifTheProfileIsNotAMShowCorrectError() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);

		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.OwnerId = userFront.Id;
		insert caso;
        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'AM');
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(userFront){
			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('No se permite rechazar alerta AM', responseToAssert.message);
    }

	@IsTest
    public static void ifTheProfileIsNotComprasTecnicasShowCorrectError() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);

		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.OwnerId = userFront.Id;
		insert caso;
        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'CPRAS_TECNI');
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(userFront){
			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('No se permite rechazar alerta de Compras Tecnicas', responseToAssert.message);
    }

	@IsTest
    public static void ifTheProfileIsNotDiscapacidadShowCorrectError() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);

		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.OwnerId = userFront.Id;
		insert caso;
        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_DISCA');
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(userFront){
			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('No se permite rechazar alerta de Discapacidad', responseToAssert.message);
    }

	@IsTest
    public static void ifTheProfileIsNotDiscapacidadInterdisciplinariohowCorrectError() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);

		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.OwnerId = userFront.Id;
		insert caso;
        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_ID');
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(userFront){
			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('No se permite rechazar alerta ID', responseToAssert.message);
    }
	
	@IsTest
    public static void ifTheProfileIsNotPresupuestohowCorrectError() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);

		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.OwnerId = userFront.Id;
		insert caso;
        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Funcion__c = 'FCION_PRESU');
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(userFront){
			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('No se permite rechazar alerta de Presupuesto', responseToAssert.message);
    }

	@IsTest
    public static void whenTryToRefuseAnAlertWithAHigherNivelDeAuditoria_showTheCorrectError() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundNoEM);

		Case caso = new Case(Nro_AP__c = '1014010152'); 
		insert caso;
        Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
        insert pres;
		Alerta__c alertaMenorNivelSinAutorizar = new Alerta__c(Prestacion__c = pres.Id, Nivel_de_auditoria__c = 120,
			Estado__c = 'C1-----A');
		insert alertaMenorNivelSinAutorizar;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id, Nivel_de_auditoria__c = 200);
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;
		
		Test.startTest();
		AlertaRechazarBtnCtrl.Response responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
		Test.stopTest();
		

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('No se puede rechazar porque hay una alerta, con un nivel de auditoría menor, sin resolver aún',
			responseToAssert.message);
    }

	@isTest
	private static void validateMotivoDeRechazo() {
		Case caso = new Case(Nro_AP__c = '1014010152');
		caso.Nivel_de_derivacion__c = 'Nivel 1';
		insert caso;

		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
		insert pres;

		Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
		insert alerta;

		Test.startTest();
		AlertaRechazarBtnCtrl.Response responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
		Test.stopTest();
	
		System.assertEquals('Debe completar el campo "Motivo de Rechazo"', responseToAssert.message);
	}		

	@isTest
	private static void validateUserWhenNoBelongsToFrontQueueAndCaseIsNivel1() {
		//userMesa.ProfileId = perfilFront.Id;
		//update userMesa;
		
		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(userMesa) {
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			//caso.OwnerId = userMesa.Id;
			caso.Nivel_de_derivacion__c = 'Nivel 1';
			insert caso;

			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;

			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
			insert alerta;

			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Front', responseToAssert.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToMesaQueueAndCaseIsNivel2() {
		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(userFront) {
		
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.Nivel_de_derivacion__c = 'Nivel 2';
			insert caso;

			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;

			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
			insert alerta;

			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Mesa de Ayuda', responseToAssert.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToTeamCaseAndCaseIsNivel3() {
		AlertaRechazarBtnCtrl.Response responseToAssert;
		System.runAs(userFront) {

			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.OwnerId = userFront.Id;
			caso.Nivel_de_derivacion__c = 'Nivel 3';
			insert caso;

			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;

			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
			insert alerta;

			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece al equipo del caso', responseToAssert.message);
	}

	@isTest
	private static void whenADoctorWantsRefuseAnAlertAMAndTheMedicoAsignadoIsEmpty_assingHimself() {
		String uniqueUserName = 'standarduserRechazarAlerta' + DateTime.now().getTime() + '@testorg.com';
		Profile perfilDoctor = [SELECT Id FROM Profile WHERE Name='Auditor Medico'];
		User userDoctor = new User(Alias = 'standt', Email='standarduser@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
			LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
			UserName=uniqueUserName + 'DoctorUtils', ProfileId = perfilDoctor.Id
		);
		//System.runAs(new User(Id = UserInfo.getUserId())) {
			insert userDoctor;
		//}

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
		
		AlertaRechazarBtnCtrl.Response resp;
		System.runAs(userDoctor) {

			Test.startTest();
			resp = AlertaRechazarBtnCtrl.autoasignarMedico(alert.Id);
			Test.stopTest();
		}

		aCase = [SELECT Id, Medico_asignado__c FROM Case WHERE Id =: aCase.Id];

		//System.assert(isAssinged);
		System.assertEquals(userDoctor.Id, aCase.Medico_asignado__c);
	}

	@isTest
	private static void whenACaseDoesntHaveAResponsableAndAnUserWantsToRefuseABackAlert_ShowTheErrorMsg() {
		AlertaRechazarBtnCtrl.Response responseToAssert;
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
			alerta.Motivo_de_rechazo__c = 'test';
			insert alerta;

			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

		System.assertEquals(
			'Solo se pueden rechazar alertas Back si hay un responsable asignado al caso', 
			responseToAssert.message
		);
	}

	@isTest
	private static void whenACaseDoesntHaveAResponsableAndAnUserWantsToRefuseAComprasTecnicasAlert_ShowTheErrorMsg() {
		AlertaRechazarBtnCtrl.Response responseToAssert;
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
			alerta.Motivo_de_rechazo__c = 'test';
			insert alerta;

			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

		System.assertEquals(
			'Solo se pueden rechazar alertas de Compras Tecnicas si hay un responsable asignado al caso', 
			responseToAssert.message
		);
	}

	@isTest
	private static void whenACaseDoesntHaveAResponsableAndAnUserWantsToRefuseADiscaAlert_ShowTheErrorMsg() {
		AlertaRechazarBtnCtrl.Response responseToAssert;
		Profile[] discaProfile = [SELECT Id FROM Profile WHERE Name = 'Discapacidad'];

		System.debug('##backProfile: ' + discaProfile);

		if(!discaProfile.isEmpty()) {
			userFront.ProfileId = discaProfile[0].Id;
			update userFront;
		}
		else {
			return;
		}

		System.debug('##userFront.ProfileId: ' + userFront.ProfileId);

		System.runAs(userFront) {
		
			Case caso = new Case(Nro_AP__c = '1014010152');
			caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Expedientes_legales').Id;
			caso.Nivel_de_derivacion__c = 'Nivel 2';
			insert caso;

			Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			insert pres;

			Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			alerta.Funcion__c = 'FCION_DISCA';
			alerta.Motivo_de_rechazo__c = 'test';
			insert alerta;

			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

		System.assertEquals(
			'Solo se pueden rechazar alertas de Discapacidad si hay un responsable asignado al caso', 
			responseToAssert.message
		);
	}

	@isTest
	private static void whenACaseDoesntHaveAResponsableAndAnUserWantsToRefuseADiscaIDAlert_ShowTheErrorMsg() {
		AlertaRechazarBtnCtrl.Response responseToAssert;
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
			alerta.Motivo_de_rechazo__c = 'test';
			insert alerta;

			Test.startTest();
			responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			Test.stopTest();
		}

		System.assertEquals(
			'Solo se pueden rechazar alertas ID si hay un responsable asignado al caso', 
			responseToAssert.message
		);
	}

	
	@IsTest
    public static void whenTheBtnIsClickedInTheView_consumeWSAAlertaAutorizar_returnACorrectResponse_VersionPrestacionDeReintegro() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundReintegro);

        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '276059', Estado__c = 'En Auditoria',Fecha_y_hora_fin_ems__c = Date.today().addDays(2));
        insert em;
        Segmentos__c seg = new Segmentos__c(Semid__c = '305873', Estado__c = 'En auditoria', Evento_Medico__c = em.Id,Fecha_Inicio_real__c = Date.today().addDays(-2),Fecha_Fin_real__c = Date.today().addDays(3));
        insert seg;
        Case caso = new Case(Nro_AP__c = '1014010186', Evento_Medico__c = em.Id,Fecha__c = Date.today());
		insert caso;
		Prestacion_de_reintegro__c pres = new Prestacion_de_reintegro__c(Id_Externo__c = '74042509', Caso__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461901', Prestacion_de_reintegro__c = pres.Id, Evento_Medico__c = em.Id);
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

        Test.startTest();
        AlertaRechazarBtnCtrl.Response responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
        Test.stopTest();

        Alerta__c alertSOQL = [
                SELECT Estado__c, Resolucion_de_alerta_auditor__c, Fecha_resolucion_de_Alerta__c, Prestacion_de_reintegro__r.Estado__c
                FROM Alerta__c
                WHERE idalerta__c =: alerta.idalerta__c
        ];

        System.assertEquals('C1EA-RAP', alertSOQL.Prestacion_de_reintegro__r.Estado__c);
        System.assertEquals('C1EA-RAP', alertSOQL.Estado__c);
        System.assertEquals(Date.valueOf('2021-08-31'), alertSOQL.Fecha_resolucion_de_Alerta__c);
    }
	
	/*@IsTest
    public static void whenTheBtnIsClickedInTheView_consumeWSAAlertaAutorizaNoEM_returnACorrectResponse_VersionPrestacionDeReintegro(){
        Test.setMock(HttpCalloutMock.class, getResponseFoundNoEMReintegro);


        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275998', Estado__c = 'En Auditoria');
        insert em;
        Segmentos__c seg = new Segmentos__c(Semid__c = '305822', Estado__c = 'En auditoria', Evento_Medico__c = em.Id);
        insert seg;
		Case caso = new Case(Nro_AP__c = '1014010140');
		insert caso;
        Prestacion_de_reintegro__c pres = new Prestacion_de_reintegro__c(Id_Externo__c = '74042491', Caso__c = caso.Id);
        insert pres;
        Alerta__c alerta = new Alerta__c(idalerta__c = '16461630', Prestacion_de_reintegro__c = pres.Id);
		alerta.Motivo_de_rechazo__c = 'Pasaron Cosas';
        insert alerta;

        Test.startTest();
        AlertaRechazarBtnCtrl.Response responseToAssert = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
        Test.stopTest();

        Alerta__c alertSOQL = [
                SELECT Estado__c, Resolucion_de_alerta_auditor__c, Fecha_resolucion_de_Alerta__c, Prestacion_de_reintegro__r.Estado__c,
					Prestacion_de_reintegro__r.Caso__r.Nivel_de_derivacion__c
                FROM Alerta__c
                WHERE idalerta__c =: alerta.idalerta__c
        ];

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals('C1EA-RAA', alertSOQL.Prestacion_de_reintegro__r.Estado__c);
		System.assertEquals('Nivel 3', alertSOQL.Prestacion_de_reintegro__r.Caso__r.Nivel_de_derivacion__c);
        System.assertEquals('C1EA-RAA', alertSOQL.Estado__c);
        System.assertEquals(Date.valueOf('2020-02-28'), alertSOQL.Fecha_resolucion_de_Alerta__c);
    }*/

	// SE ELIMINO LA VALIDACION
	//@isTest
	//private static void whenAFrontUserNotBelongsToDelegacion_showTheErrorMsg() {
		//Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('123456').build();
		//insert delegacion;
		//Case caso = new Case(Nro_AP__c = '1014010152');
		//caso.OwnerId = userFront.Id;
		//caso.Nivel_de_derivacion__c = 'Nivel 1';
		//insert caso;

		//caso.Delegacion__c = delegacion.Id;
		//update caso;

		//AlertaRechazarBtnCtrl.Response resp;
		//System.runAs(userFront) {


			//Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042503', Ap__c = caso.Id);
			//insert pres;

			//Alerta__c alerta = new Alerta__c(idalerta__c = '16461790', Prestacion__c = pres.Id);
			//alerta.Motivo_de_rechazo__c = 'adasd';
			//insert alerta;

			//Test.startTest();
			//resp = AlertaRechazarBtnCtrl.rechazarAlerta(alerta.idalerta__c);
			//Test.stopTest();
		//}

		//System.assertEquals('El usuario puede modificar casos de su delegación solamente', resp.message);
	//}
}