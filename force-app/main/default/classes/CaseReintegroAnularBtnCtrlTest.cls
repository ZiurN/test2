@isTest 
private class CaseReintegroAnularBtnCtrlTest {
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
				.withBody(WSCaseReintegroAnularMock.getFound())
				.addForAddress(WSCaseAPAnular.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/12345678/anula');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
				.withStatus('El reintegro solicitado es inválido.')
				.withStatusCode(404)
				.withBody(WSCaseReintegroAnularMock.getError())
				.addForAddress(WSCaseAPAnular.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/12345678/anula');

	}

	@isTest
	private static void checkCancelCaseTest() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		caso.Status = 'CA-----E';
		caso.Codigo_reintegro_SS__c = '12345678';
		insert caso;

		Test.startTest();
		BasicResponse resp = CaseReintegroAnularBtnCtrl.anularReintegro(caso.Id);
		Test.stopTest();

		Case caseToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		System.assertEquals('CA-----N', caseToAssert.Status);
	}

	@isTest
	private static void whenNroApIsEmptyCancelTheCaseInSFAnyway() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);

		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		caso.Status = 'CA-----E';
		insert caso;

		Test.startTest();
		BasicResponse resp = CaseReintegroAnularBtnCtrl.anularReintegro(caso.Id);
		Test.stopTest();

		Case caseToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		System.assertEquals('CA-----N', caseToAssert.Status);
	}

	//@isTest
	//private static void checkMessageDontCancelCaseBecauseRecordTypeIsNotSeguimientoTest() {
		//Test.setMock(HttpCalloutMock.class,getErrorResponse);
		//Case caso = new Case();
		//caso.Status = 'CA-----E';
		//caso.Codigo_reintegro_SS__c = '12345678';
		//insert caso;

		//Test.startTest();
		//BasicResponse resp = CaseReintegroAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(caso.Codigo_reintegro_SS__c);
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
		//caso.Codigo_reintegro_SS__c = '12345678';
		//insert caso;

		//Test.startTest();
		//BasicResponse resp = CaseReintegroAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(caso.Codigo_reintegro_SS__c);
		//Test.stopTest();

		//Case caseToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		//System.assertNotEquals('CA-----N', caseToAssert.Status);
		//System.assertEquals('- El estado no es orden emitida \n', resp.message);
	//}

	@isTest
	private static void showErrorMessageFromWs() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		caso.Status = 'CA-----E';
		caso.Codigo_reintegro_SS__c = '12345678';
		insert caso;

		Test.startTest();
		BasicResponse resp = CaseReintegroAnularBtnCtrl.anularReintegro(caso.Id);
		Test.stopTest();
		
		System.assertEquals('El reintegro solicitado es inválido.', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToFrontQueueAndCaseIsNivel1() {
		BasicResponse resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Codigo_reintegro_SS__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 1';
			insert newCaso;

			Test.startTest();
			resp = CaseReintegroAnularBtnCtrl.anularReintegro(newCaso.Id);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Front', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToMesaQueueAndCaseIsNivel2() {
		BasicResponse resp;
		System.runAs(usuarioFront) {
			Case newCaso = new Case();
			newCaso.Codigo_reintegro_SS__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 2';
			insert newCaso;

			Test.startTest();
			resp = CaseReintegroAnularBtnCtrl.anularReintegro(newCaso.Id);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece a Mesa de Ayuda', resp.message);
	}

	@isTest
	private static void validateUserWhenNoBelongsToTeamCaseAndCaseIsNivel3() {
		BasicResponse resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Codigo_reintegro_SS__c = '1014009821';
			newCaso.Status = 'CA-----A';
			newCaso.Nivel_de_derivacion__c = 'Nivel 3';
			insert newCaso;

			Test.startTest();
			resp = CaseReintegroAnularBtnCtrl.anularReintegro(newCaso.Id);
			Test.stopTest();
		}

		System.assertEquals('- El usuario no pertenece al equipo del caso', resp.message);
	}

	@isTest
	private static void whenAFrontUserBelongsToFrontQueue_anularAP() {
		BasicResponse resp;

		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		
		Case newCaso = new Case();
		newCaso.AccountId = acc.Id;
		newCaso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		newCaso.Codigo_reintegro_SS__c = '12345678';
		newCaso.Status = 'CA-----E';
		newCaso.Nivel_de_derivacion__c = 'Nivel 1';
		insert newCaso;

		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		System.runAs(usuarioFront) {
			//System.runAs(new User(Id = UserInfo.getUserId())) {
				//insert new CaseTeamMember(ParentId = newCaso.Id, MemberId = usuarioFront.Id, TeamRoleId = caseRole.Id);
			//}

			Test.startTest();
			resp = CaseReintegroAnularBtnCtrl.anularReintegro(newCaso.Id);
			Test.stopTest();
		}

		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: newCaso.Id];

		System.assertEquals('ok', resp.message);
		System.assertEquals('CA-----N', casoToAssert.Status);
	}

}