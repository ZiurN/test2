@isTest 
private class CaseAPRevertirBtnCtrlTest {

	static XHttpCalloutMock getResponseFound;
	static User usuarioFront;
	static User usuarioMesa;
	static CaseTeamRole caseRole;
	static Case caso;
	static Prestacion__c prestacion;
	static Prestacion__c prestacion2;
	static Alerta__c alerta1;
	static Alerta__c alerta2;
	static Alerta__c alerta3;
	static Account delegacion;

    static {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String uniqueUserName = 'standarduserRevertirCase' + DateTime.now().getTime() + '@testorg.com';
			Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
			UserRole role = [SELECT Id, Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Filial_Casa_central'];
			usuarioFront = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650886',
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

		delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('650886').build();
		insert delegacion;

		caso = new Case();
		//Es el Api Name de Status = 'Centro Autorizador'
		caso.Status = 'CA-----A';
		insert caso;

		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = caso.Id, MemberId = usuarioFront.Id, TeamRoleId = caseRole.Id);
		}

		prestacion = new Prestacion__c();
		prestacion.Ap__c = Caso.Id;
		insert prestacion;

		alerta1 = new Alerta__c();
		alerta1.Prestacion__c = prestacion.Id;
		insert alerta1;

		alerta2 = new Alerta__c();
		alerta2.Prestacion__c = prestacion.Id;
		insert alerta2;

		prestacion2 = new Prestacion__c();
		prestacion2.Ap__c = Caso.Id;
		insert prestacion2;

		alerta3 = new Alerta__c();
		alerta3.Prestacion__c = prestacion2.Id;
		insert alerta3;

		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSCasoEnviarASSMock.getFound())
				.addForAddress(WSCaseAPRevertir.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/centro-autorizador/revertir/1014009821');
	}

	@isTest
	private static void deleteAlertasRelatedToCaseAndChangeStatusFromCaseTest() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		
		caso.Nro_AP__c = '1014009821';
		update caso;

		Test.startTest();
		CaseAPRevertirBtnCtrl.deleteAlertasRelatedToCaseAndChangeStatusFromCase(caso.Nro_AP__c);
		Test.stopTest();

		Integer cantAlertas = [SELECT COUNT() FROM Alerta__c];
		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		//Es el Api Name de Status = 'generado'
		System.assertEquals('CA-----G', casoToAssert.Status);
		System.assertEquals(0, cantAlertas);
	}

	@isTest
	private static void ifStatusIsNotCentroAutorizadorDontDoAnythingTest() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		
		caso.Status = 'CA-----E';
		caso.Nro_AP__c = '1014009821';
		update caso;

		Test.startTest();
		CaseAPRevertirBtnCtrl.deleteAlertasRelatedToCaseAndChangeStatusFromCase(caso.Nro_AP__c);
		Test.stopTest();

		Integer cantAlertas = [SELECT COUNT() FROM Alerta__c];
		System.assertEquals(3, cantAlertas);
	}

	@isTest
	private static void validateUserWhenNoBelongsToFrontQueueAndCaseIsNivel1() {
		CaseAPRevertirBtnCtrl.Response resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 1';
			insert newCaso;

			Test.startTest();
			resp = CaseAPRevertirBtnCtrl.deleteAlertasRelatedToCaseAndChangeStatusFromCase(newCaso.Nro_AP__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Front', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToMesaQueueAndCaseIsNivel2() {
		CaseAPRevertirBtnCtrl.Response resp;
		System.runAs(usuarioFront) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 2';
			newCaso.Delegacion__c = delegacion.Id;
			insert newCaso;

			Test.startTest();
			resp = CaseAPRevertirBtnCtrl.deleteAlertasRelatedToCaseAndChangeStatusFromCase(newCaso.Nro_AP__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Mesa de Ayuda', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToTeamCaseAndCaseIsNivel3() {
		CaseAPRevertirBtnCtrl.Response resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 3';
			insert newCaso;

			Test.startTest();
			resp = CaseAPRevertirBtnCtrl.deleteAlertasRelatedToCaseAndChangeStatusFromCase(newCaso.Nro_AP__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece al equipo del caso', resp.message);
	}

	@isTest 
	private static void whenAFrontUserBelongsToFrontQueue_revertirAP() {
		CaseAPRevertirBtnCtrl.Response resp;
		Case newCaso = new Case();

		System.runAs(usuarioFront) {
			newCaso.Nro_AP__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 3';
			newCaso.Delegacion__c = delegacion.Id;
			insert newCaso;
		}

		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = newCaso.Id, MemberId = usuarioFront.Id, TeamRoleId = caseRole.Id);
		}

		System.runAs(usuarioFront) {
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			resp = CaseAPRevertirBtnCtrl.deleteAlertasRelatedToCaseAndChangeStatusFromCase(newCaso.Nro_AP__c);
			Test.stopTest();
		}

		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: newCaso.Id];

		System.assertEquals('ok', resp.message);
		System.assertEquals('CA-----G', casoToAssert.Status);
	}

	@isTest
	private static void whenTheUserIsLeaderReturnTrue() {

		Test.startTest();
		Boolean resp = CaseAPRevertirBtnCtrl.isLeader();
		Test.stopTest();

		System.assert(resp);

	}

	@isTest
	private static void whenTheUserIsNotLeaderReturnFalse() {
		Boolean resp;

		System.runAs(usuarioFront) {
			Test.startTest();
			resp = CaseAPRevertirBtnCtrl.isLeader();
			Test.stopTest();
		}

		System.assert(!resp);

	}

	// SE ELIMINO LA VALIDACION
	//@isTest
	//private static void whenAFrontUserNotBelongsToDelegacion_showTheErrorMsg() {
		//CaseAPRevertirBtnCtrl.Response resp;
		//Case newCaso = new Case();
		//newCaso.Nro_AP__c = '1014009821';
		//newCaso.Status = 'CA-----A';
		//newCaso.Nivel_de_derivacion__c = 'Nivel 1';
		////newCaso.OwnerId = usuarioFront.Id;
		//insert newCaso;

		//System.runAs(usuarioFront) {
			//Test.startTest();
			//resp = CaseAPRevertirBtnCtrl.deleteAlertasRelatedToCaseAndChangeStatusFromCase(newCaso.Nro_AP__c);
			//Test.stopTest();
		//}

		//System.assertEquals('El usuario puede modificar casos de su delegación solamente', resp.message);

	//}

}