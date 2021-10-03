@isTest 
private class CaseReintegroRevertirBtnCtrlTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseError;
	static User usuarioFront;
	static User usuarioMesa;
	static CaseTeamRole caseRole;
	//static Case caso;

	static {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String uniqueUserName = 'standarduserRevertirReintegro' + DateTime.now().getTime() + '@testorg.com';
			Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
			UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
			usuarioFront = new User(Alias = 'standt', Email='standarduser@testorg.com',
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
					LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
					UserName=uniqueUserName + 'FrontReintRev', ProfileId = pFront.Id, UserRoleId = role.Id);
			insert usuarioFront;

			Profile pMesa = [SELECT Id FROM Profile WHERE Name='Mesa de ayuda'];
			usuarioMesa = new User(Alias = 'standt', Email='standarduser@testorg.com',
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
					LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
					UserName=uniqueUserName + 'MesaReintRev', ProfileId = pMesa.Id, UserRoleId = role.Id);
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
				.withBody(WSCaseReintegroRevertirMock.getFound())
				.addForAddress(WSCaseReintegroRevertir.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/553276');

		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
				.withStatus('error')
				.withStatusCode(404)
				.withBody(WSCaseReintegroRevertirMock.getError())
				.addForAddress(WSCaseReintegroRevertir.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/553276');
	}

	@isTest
	private static void deleteAlertasRelatedToCaseAndChangeStatusFromCaseTest() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		//Es el Api Name de Status = 'Centro Autorizador'
		caso.Codigo_reintegro_SS__c = '553276';
		caso.Status = 'CA-----A';
		insert caso;

		Prestacion_de_reintegro__c prestacion = new Prestacion_de_reintegro__c();
		prestacion.Caso__c = Caso.Id;
		insert prestacion;
		
		Alerta__c alerta1 = new Alerta__c();
		alerta1.Prestacion_de_reintegro__c = prestacion.Id;
		insert alerta1;

		Alerta__c alerta2 = new Alerta__c();
		alerta2.Prestacion_de_reintegro__c = prestacion.Id;
		insert alerta2;

		Prestacion_de_reintegro__c prestacion2 = new Prestacion_de_reintegro__c();
		prestacion2.Caso__c = Caso.Id;
		insert prestacion2;

		Alerta__c alerta3 = new Alerta__c();
		alerta3.Prestacion_de_reintegro__c = prestacion2.Id;
		insert alerta3;

		Test.startTest();
		CaseReintegroRevertirBtnCtrl.Response resp = 
			CaseReintegroRevertirBtnCtrl.deleteAlertasRelatedToReintegroAndChangeStatusToReintegro(caso.Codigo_reintegro_SS__c);
		Test.stopTest();

		Integer cantAlertas = [SELECT COUNT() FROM Alerta__c];
		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		System.assertEquals('ok', resp.message);
		//Es el Api Name de Status = 'generado'
		System.assertEquals('CA-----G', casoToAssert.Status);
		System.assertEquals(0, cantAlertas);
	}

	@isTest
	private static void ifStatusIsNotCentroAutorizadorDontDoAnything() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		caso.Codigo_reintegro_SS__c = '553276';
		caso.Status = 'CA-----E';
		insert caso;
		Prestacion__c prestacion = new Prestacion__c();
		prestacion.Ap__c = Caso.Id;
		insert prestacion;
		Alerta__c alerta1 = new Alerta__c();
		alerta1.Prestacion__c = prestacion.Id;
		insert alerta1;
		Alerta__c alerta2 = new Alerta__c();
		alerta2.Prestacion__c = prestacion.Id;
		insert alerta2;
		Prestacion__c prestacion2 = new Prestacion__c();
		prestacion2.Ap__c = Caso.Id;
		insert prestacion2;
		Alerta__c alerta3 = new Alerta__c();
		alerta3.Prestacion__c = prestacion2.Id;
		insert alerta3;

		Test.startTest();
		CaseReintegroRevertirBtnCtrl.Response resp = 
			CaseReintegroRevertirBtnCtrl.deleteAlertasRelatedToReintegroAndChangeStatusToReintegro(caso.Codigo_reintegro_SS__c);
		Test.stopTest();

		Integer cantAlertas = [SELECT COUNT() FROM Alerta__c];
		
		System.assertEquals('- El estado debe ser Centro Autorizador o Autorizado.', resp.message);
		System.assertEquals(3, cantAlertas);
	}

	@isTest
	private static void validateUserWhenNoBelongsToFrontQueueAndCaseIsNivel1() {
		CaseReintegroRevertirBtnCtrl.Response resp;
		System.runAs(usuarioMesa) {
			Case reintegro = new Case();
			reintegro.Codigo_reintegro_SS__c = '553276';
			reintegro.Status = 'CA-----A';
			reintegro.Nivel_de_derivacion__c = 'Nivel 1';
			insert reintegro;

			Test.startTest();
			resp = CaseReintegroRevertirBtnCtrl.deleteAlertasRelatedToReintegroAndChangeStatusToReintegro(reintegro.Codigo_reintegro_SS__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Front', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToMesaQueueAndCaseIsNivel2() {
		CaseReintegroRevertirBtnCtrl.Response resp;
		System.runAs(usuarioFront) {
			Case reintegro = new Case();
			reintegro.Codigo_reintegro_SS__c = '553276';
			reintegro.Status = 'CA-----A';
			reintegro.Nivel_de_derivacion__c = 'Nivel 2';
			insert reintegro;

			Test.startTest();
			resp = CaseReintegroRevertirBtnCtrl.deleteAlertasRelatedToReintegroAndChangeStatusToReintegro(reintegro.Codigo_reintegro_SS__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Mesa de Ayuda', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToTeamCaseAndCaseIsNivel3() {
		CaseReintegroRevertirBtnCtrl.Response resp;
		System.runAs(usuarioMesa) {
			Case reintegro = new Case();
			reintegro.Codigo_reintegro_SS__c = '553276';
			reintegro.Status = 'CA-----A';
			reintegro.Nivel_de_derivacion__c = 'Nivel 3';
			insert reintegro;

			Test.startTest();
			resp = CaseReintegroRevertirBtnCtrl.deleteAlertasRelatedToReintegroAndChangeStatusToReintegro(reintegro.Codigo_reintegro_SS__c);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece al equipo del caso', resp.message);
	}

	@isTest
	private static void whenAFrontUserBelongsToFrontQueue_revertirAP() {
		CaseReintegroRevertirBtnCtrl.Response resp;
		Case reintegro = new Case();

		System.runAs(usuarioFront) {
			reintegro.Codigo_reintegro_SS__c = '553276';
			reintegro.Status = 'CA-----A';
			reintegro.Nivel_de_derivacion__c = 'Nivel 3';
			insert reintegro;

			System.runAs(new User(Id = UserInfo.getUserId())) {
				insert new CaseTeamMember(ParentId = reintegro.Id, MemberId = usuarioFront.Id, TeamRoleId = caseRole.Id);
			}

			Test.setMock(HttpCalloutMock.class,getResponseFound);
			Test.startTest();
			resp = CaseReintegroRevertirBtnCtrl.deleteAlertasRelatedToReintegroAndChangeStatusToReintegro(reintegro.Codigo_reintegro_SS__c);
			Test.stopTest();
		}

		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: reintegro.Id];

		System.assertEquals('ok', resp.message);
		System.assertEquals('CA-----G', casoToAssert.Status);
	}

	// SE ELIMINO LA VALIDACION
	//@isTest
	//private static void whenAFrontUserNotBelongsToDelegacion_showTheErrorMsg() {
		//Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('123456').build();
		//insert delegacion;

		//Case newReint = new Case();
		//newReint.Status = 'CA-----A';
		//newReint.Nivel_de_derivacion__c = 'Nivel 1';
		////newReint.OwnerId = usuarioFront.Id;
		//insert newReint;

		//newReint.Delegacion__c = delegacion.Id;
		//update newReint;

		//CaseReintegroRevertirBtnCtrl.Response resp;
		//System.runAs(usuarioFront) {	
			//Test.startTest();
			//resp = CaseReintegroRevertirBtnCtrl.deleteAlertasRelatedToReintegroAndChangeStatusToReintegro(newReint.Codigo_reintegro_SS__c);
			//Test.stopTest();
		//}

		//System.assertEquals('El usuario puede modificar casos de su delegación solamente', resp.message);

	//}
}