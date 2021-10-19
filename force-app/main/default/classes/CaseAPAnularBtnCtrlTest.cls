@isTest 
private class CaseAPAnularBtnCtrlTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static CaseTeamRole caseRole;
	static Case caso;
	static User usuarioFront;
	static User usuarioMesa;

	static {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
			Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
			UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
			usuarioFront = new User(Alias = 'standt', Email='standarduser@testorg.com',
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
					LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
					UserName=uniqueUserName + 'Front', ProfileId = pFront.Id, UserRole = role);
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
				.withBody(WSCaseAPAnularMock.getFound())
				.addForAddress(WSCaseAPAnular.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/anular/12345678');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
				.withStatus('La autorización solicitada es inválida.')
				.withStatusCode(404)
				.withBody(WSCaseAPAnularMock.getError())
				.addForAddress(WSCaseAPAnular.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/anular/12345678');

	}

	@isTest
	private static void checkCancelCaseTest() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		caso.Status = 'CA-----E';
		caso.Nro_AP__c = '12345678';
		insert caso;

		Test.startTest();
		CaseAPAnularBtnCtrl.Response resp = 
			CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(caso.Id);
		Test.stopTest();

		Case caseToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		System.assertEquals('CA-----N', caseToAssert.Status);
	}

	@isTest
	private static void whenNroApIsEmptyCancelTheCaseInSFAnyway() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);

		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		caso.Status = 'CA-----E';
		insert caso;

		Test.startTest();
		CaseAPAnularBtnCtrl.Response resp = 
			CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(caso.Id);
		Test.stopTest();

		Case caseToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		System.assertEquals('CA-----N', caseToAssert.Status);
	}

	//@isTest
	//private static void checkMessageDontCancelCaseBecauseRecordTypeIsNotSeguimientoTest() {
		//Test.setMock(HttpCalloutMock.class,getErrorResponse);
		//Case caso = new Case();
		//caso.Status = 'CA-----E';
		//caso.Nro_AP__c = '12345678';
		//insert caso;

		//Test.startTest();
		//CaseAPAnularBtnCtrl.Response resp = CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(caso.Nro_AP__c);
		//Test.stopTest();

		//Case caseToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		//System.assertNotEquals('CA-----N', caseToAssert.Status);
		//System.assertEquals('CA-----E', caseToAssert.Status);
		//System.assertEquals('- El caso no es de seguimiento \n', resp.message);
	//}

	//@isTest
	//private static void checkMessageDontCancelCaseBecauseStatusIsNotOrdenEmitidaTest() {
		//Test.setMock(HttpCalloutMock.class,getErrorResponse);
		//Case caso = new Case();
		//caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		//caso.Status = 'CA-----G';
		//caso.Nro_AP__c = '12345678';
		//insert caso;

		//Test.startTest();
		//CaseAPAnularBtnCtrl.Response resp = CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(caso.Nro_AP__c);
		//Test.stopTest();

		//Case caseToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		//System.assertNotEquals('CA-----N', caseToAssert.Status);
		//System.assertEquals('- El estado no es orden emitida \n', resp.message);
	//}

	@isTest
	private static void showErrorMessageFromWs() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		caso.Status = 'CA-----E';
		caso.Nro_AP__c = '12345678';
		insert caso;

		Test.startTest();
		CaseAPAnularBtnCtrl.Response resp = 
				CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(caso.Id);
		Test.stopTest();
		
		System.assertEquals('La autorización solicitada es inválida.', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToFrontQueueAndCaseIsNivel1() {
		CaseAPAnularBtnCtrl.Response resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 1';
			insert newCaso;

			Test.startTest();
			resp = CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(newCaso.Id);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Front', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToMesaQueueAndCaseIsNivel2() {
		CaseAPAnularBtnCtrl.Response resp;
		System.runAs(usuarioFront) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 2';
			insert newCaso;

			Test.startTest();
			resp = CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(newCaso.Id);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Mesa de Ayuda', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToTeamCaseAndCaseIsNivel3() {
		CaseAPAnularBtnCtrl.Response resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 3';
			insert newCaso;

			Test.startTest();
			resp = CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(newCaso.Id);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece al equipo del caso', resp.message);
	}

	@isTest
	private static void whenAFrontUserBelongsToFrontQueue_anularAP() {
		CaseAPAnularBtnCtrl.Response resp;

		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		
		Case newCaso = new Case();
		newCaso.AccountId = acc.Id;
		newCaso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		newCaso.Nro_AP__c = '12345678';
		newCaso.Status = 'CA-----E';
		newCaso.Nivel_de_derivacion__c = 'Nivel 1';
		insert newCaso;

		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		System.runAs(usuarioFront) {
			//System.runAs(new User(Id = UserInfo.getUserId())) {
				//insert new CaseTeamMember(ParentId = newCaso.Id, MemberId = usuarioFront.Id, TeamRoleId = caseRole.Id);
			//}

			Test.startTest();
			resp = CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(newCaso.Id);
			Test.stopTest();
		}

		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: newCaso.Id];

		System.assertEquals('ok', resp.message);
		System.assertEquals('CA-----N', casoToAssert.Status);
	}

	@isTest
	private static void whenTheUserIsLeaderReturnTrue() {

		Test.startTest();
		Boolean resp = CaseAPAnularBtnCtrl.isLeader();
		Test.stopTest();

		System.assert(resp);

	}

	@isTest
	private static void whenTheUserIsNotLeaderReturnFalse() {
		Boolean resp;

		System.runAs(usuarioFront) {
			Test.startTest();
			resp = CaseAPAnularBtnCtrl.isLeader();
			Test.stopTest();
		}

		System.assert(!resp);

	}

}