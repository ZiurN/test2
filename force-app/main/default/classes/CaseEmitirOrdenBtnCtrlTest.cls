@isTest 
private class CaseEmitirOrdenBtnCtrlTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static User usuarioFront;
	static User usuarioMesa;
	static CaseTeamRole caseRole;
	//static Case caso;
	static Case casoSeguimiento;
	static Prestacion__c prestacion;
	static Prestacion__c prestacion2;
	static Alerta__c alerta1;
	static Alerta__c alerta2;
	static Alerta__c alerta3;

    static {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String uniqueUserName = 'standarduserAnularCase' + DateTime.now().getTime() + '@testorg.com';
			Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
			UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
			usuarioFront = new User(Alias = 'standt', Email='standarduser@testorg.com',
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
					LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
					UserName=uniqueUserName + 'Front', ProfileId = pFront.Id, UserRoleId = role.Id);
			insert usuarioFront;

			Profile pMesa = [SELECT Id FROM Profile WHERE Name='Mesa de ayuda'];
			usuarioMesa = new User(Alias = 'standt', Email='standarduser@testorg.com',
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
					LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
					UserName=uniqueUserName + 'Mesa', ProfileId = pMesa.Id, UserRole = role);
			insert usuarioMesa;

			List<Group> groupFront = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Front'];
			GroupMember groupMemberF = new GroupMember(groupId = groupFront[0].Id, UserOrGroupId = usuarioFront.Id);
			insert groupMemberF;

			List<Group> groupMesa = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Mesa_de_ayuda'];
			GroupMember groupMemberM = new GroupMember(groupId = groupMesa[0].Id, UserOrGroupId = usuarioMesa.Id);
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
				.withBody(WSCaseAPEmitirOrdenMock.getFound())
				.addForAddress(WSCaseAPEmitirOrden.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/generar/12345678');
		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
				.withStatus('La autorización solicitada es inválida.')
				.withStatusCode(404)
				.withBody(WSCasoEnviarASSMock.getError())
				.addForAddress(WSCaseAPEmitirOrden.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/generar/12345678');

		casoSeguimiento = new Case();
		casoSeguimiento.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		casoSeguimiento.Nro_AP__c = '12345678';

	}

	@isTest
	private static void validCaseChangesStatusWhenCaseEmitirOrden() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Case caso = new Case();
		caso.Status = 'CA-----A	';
		caso.Nro_AP__c = '12345678';
		insert caso;

		Test.startTest();
		CaseEmitirOrdenBtnCtrl.changeStatusToOrdenEmitida(caso.Nro_AP__c);
		Test.stopTest();

		Case caseToAssert = [SELECT Status FROM Case];
		System.assertEquals('CA-----E', caseToAssert.Status);
	}

//------------------------------------------------------------------------------------
	@isTest
	private static void validateUserWhenNoBelongsToFrontQueueAndCaseIsNivel1() {
		CaseEmitirOrdenBtnCtrl.Response resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '12345678';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 1';
			insert newCaso;

			Test.startTest();
			resp = CaseEmitirOrdenBtnCtrl.changeStatusToOrdenEmitida(newCaso.Nro_AP__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Front', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToMesaQueueAndCaseIsNivel2() {
		CaseEmitirOrdenBtnCtrl.Response resp;
		System.runAs(usuarioFront) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '12345678';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 2';
			insert newCaso;

			Test.startTest();
			resp = CaseEmitirOrdenBtnCtrl.changeStatusToOrdenEmitida(newCaso.Nro_AP__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Mesa de Ayuda', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToTeamCaseAndCaseIsNivel3() {
		CaseEmitirOrdenBtnCtrl.Response resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '12345678';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 3';
			insert newCaso;

			Test.startTest();
			resp = CaseEmitirOrdenBtnCtrl.changeStatusToOrdenEmitida(newCaso.Nro_AP__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece al equipo del caso', resp.message);
	}

	@isTest
	private static void whenAFrontUserBelongsToFrontQueue_revertirAP() {
		CaseEmitirOrdenBtnCtrl.Response resp;
		Case newCaso = new Case();

		System.runAs(usuarioFront) {
			newCaso.Nro_AP__c = '12345678';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 3';
			insert newCaso;

			System.runAs(new User(Id = UserInfo.getUserId())) {
				insert new CaseTeamMember(ParentId = newCaso.Id, MemberId = usuarioFront.Id, TeamRoleId = caseRole.Id);
			}

			Test.setMock(HttpCalloutMock.class,getResponseFound);
			Test.startTest();
			resp = CaseEmitirOrdenBtnCtrl.changeStatusToOrdenEmitida(newCaso.Nro_AP__c);
			Test.stopTest();
		}

		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: newCaso.Id];

		System.assertEquals('ok', resp.message);
		System.assertEquals('CA-----E', casoToAssert.Status);
	}

	@IsTest
	private static void emitirOrdenWhenRTIsSeguimiento() {
		casoSeguimiento.Status = 'Autorizada';

		insert casoSeguimiento;

		Test.startTest();
		CaseEmitirOrdenBtnCtrl.Response resp = CaseEmitirOrdenBtnCtrl.changeStatusToOrdenEmitida(casoSeguimiento.Nro_AP__c);
		Test.stopTest();

		casoSeguimiento = [SELECT Status FROM Case WHERE Id =: casoSeguimiento.Id];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
		System.assertEquals('CA-----E', casoSeguimiento.Status);
	}

	@IsTest 
	private static void WhenRTIsSeguimientoAndStatusIsNotAutorizada_showValidationErrorMsg() {
		casoSeguimiento.Status = 'CA-----G';

		insert casoSeguimiento;

		Test.startTest();
		CaseEmitirOrdenBtnCtrl.Response resp = CaseEmitirOrdenBtnCtrl.changeStatusToOrdenEmitida(casoSeguimiento.Nro_AP__c);
		Test.stopTest();

		casoSeguimiento = [SELECT Status FROM Case WHERE Id =: casoSeguimiento.Id];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('El estado debe estar autorizado para poder emitir la orden', resp.message);
		System.assertEquals('CA-----G', casoSeguimiento.Status);
	}

	@IsTest 
	private static void emitirOrdenAndSendEmailWhenTypeIsCOVID() {
		Account prestador = Build.anAccountEfector().build();
		prestador.Es_Prestador__c = true;
		prestador.Correo_electronico__c = 'test@test.com';
		insert prestador;

		Evento_medico__c emCovid = new Evento_medico__c();
		emCovid.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		emCovid.Tipo__c = 'COVID';
		insert emCovid;

		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		aCase.Nro_AP__c = '12345678';
		aCase.Prestador__c = prestador.Id;
		aCase.Status = 'Autorizada';
		aCase.Evento_Medico__c = emCovid.Id;
		//aCase.Type= 'COVID';
		insert aCase;

		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		CaseEmitirOrdenBtnCtrl.Response resp = CaseEmitirOrdenBtnCtrl.changeStatusToOrdenEmitida(aCase.Nro_AP__c);
		Integer AfterInvocations = Limits.getEmailInvocations();
		Test.stopTest();

		aCase = [SELECT Status FROM Case WHERE Id =: aCase.Id];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
		System.assertEquals('CA-----E', aCase.Status);
		System.assertEquals(1, AfterInvocations);
	}

	//@isTest
	//private static void whenAFrontUserNotBelongsToDelegacion_showTheErrorMsg() {
		//Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('123456').build();
		//insert delegacion;
		
		//Case newCaso = new Case();
		//newCaso.Nro_AP__c = '1014009821';
		//newCaso.Status = 'CA-----A';
		//newCaso.Nivel_de_derivacion__c = 'Nivel 1';
		////newCaso.OwnerId = usuarioFront.Id;
		//insert newCaso;

		//newCaso.Delegacion__c = delegacion.Id;
		//update newCaso;

		//CaseEmitirOrdenBtnCtrl.Response resp;
		//System.runAs(usuarioFront) {	
			//Test.startTest();
			//resp = CaseEmitirOrdenBtnCtrl.changeStatusToOrdenEmitida(newCaso.Nro_AP__c);
			//Test.stopTest();
		//}

		//System.assertEquals('El usuario puede modificar casos de su delegación solamente', resp.message);

	//}
}