@isTest
private class CaseAPAnularBtnCtrlTest {
	private static String AUTORIZACIONES_ANULAR = ConfigUtils.getEndpointsByTipo('autorizaciones').get('orden-ap/anular').Endpoint__c;
	private static XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
	private static XHttpCalloutMock getErrorResponse = new XHttpCalloutMock();
	private static List<String> profilesList = new List<String>{'Front', 'Mesa de ayuda'};
	private static List<String> userRolesList = new List<String>{'Filial_Casa_central', 'Encargado_Filial_Mar_del_Plata'};
	private static List<String> queuesList =  new List<String>{'Front', 'Mesa_de_ayuda'};
	private static String uniqueUserName = 'standarduserRevertirCase' + DateTime.now().getTime() + '@testorg.com';
	private static User usuarioFront = Build.anUser()
		.withUserName(uniqueUserName + 'Front')
		.build();
	private static User usuarioMesa = Build.anUser()
		.withUserName(uniqueUserName + 'Mesa')
		.build();
	private static User userEncargado = Build.anUser()
		.withUserName(uniqueUserName + 'EncargadoFilial')
		.build();
	private static CaseTeamRole caseRole = new CaseTeamRole(Name = 'Cel Test', AccessLevel = 'Edit');
	private static Case caso;
	static {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert caseRole;
			List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Name IN: profilesList];
			List<UserRole> roles = [SELECT Id, Name, DeveloperName FROM UserRole WHERE DeveloperName IN: userRolesList];
			List<Group> queues = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName IN: queuesList];
			List<User> usersToInsert = new List<User>();
			for (Profile profileToAssign : profiles) {
				switch on profileToAssign.Name {
					when 'Front' {
						usuarioFront.profileId = profileToAssign.Id;
						userEncargado.profileId = profileToAssign.Id;
					} when 'Mesa de ayuda'{
						usuarioMesa.profileId = profileToAssign.Id;
					}
				}
			}
			for (UserRole role : roles) {
				switch on role.DeveloperName {
					when 'Filial_Casa_central' {
						usuarioFront.UserRoleId = role.Id;
						usersToInsert.add(usuarioFront);
						usuarioMesa.UserRoleId = role.Id;
						usersToInsert.add(usuarioMesa);
					} when 'Encargado_Filial_Mar_del_Plata'{
						userEncargado.UserRoleId = role.Id;
						usersToInsert.add(userEncargado);
					}
				}
			}
			insert usersToInsert;
			List<GroupMember> membersToInsert = new List<GroupMember>();
			for (Group queue : queues) {
				GroupMember memberToinsert;
				switch on queue.DeveloperName {
					when 'Front' {
						memberToinsert = new GroupMember(
							groupId = queue.Id,
							UserOrGroupId = usuarioFront.Id
						);
					} when 'Mesa_de_ayuda'{
						memberToinsert = new GroupMember(
							groupId = queue.Id,
							UserOrGroupId = usuarioMesa.Id
						);
					}
				}
				membersToInsert.add(memberToinsert);
			}
			insert membersToInsert;
		}
		TestUtils.setMockResponse(getResponseFound, AUTORIZACIONES_ANULAR + '/12345678', WSCaseAPAnularMock.getFound());
		TestUtils.setMockResponse(
			getErrorResponse,
			AUTORIZACIONES_ANULAR + '/12345678',
			WSCaseAPAnularMock.getError(),
			404,
			'La autorización solicitada es inválida.'
		);
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
		System.assertEquals('CA-----N', caseToAssert.Status, 'El estado del caso debe ser CA-----N');
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
		System.assertEquals('CA-----N', caseToAssert.Status, 'El estado del caso debe ser CA-----N');
	}
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
		System.assertEquals('La autorización solicitada es inválida.', resp.message, 'El mensaje no indica el error esperado');
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
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoFront, resp.message, 'El mensaje debe indicar que el usuario no pertenece al front');
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
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoMesaAyuda, resp.message, 'El mensaje debe indicar que el usuario no pertenece a la Mesa de ayuda');
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
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoEquipoCaso, resp.message, 'El mensaje debe indicar que el usuario no pertenece al equipo del caso');
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
			Test.startTest();
			resp = CaseAPAnularBtnCtrl.ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(newCaso.Id);
			Test.stopTest();
		}
		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: newCaso.Id];
		System.assertEquals('ok', resp.message, 'El mensaje debe ser ok');
		System.assertEquals('CA-----N', casoToAssert.Status, 'El estado del caso debe ser CA-----G');
	}
	@isTest
	private static void whenTheUserIsLeaderReturnTrue() {
		Test.startTest();
		Boolean resp = CaseAPAnularBtnCtrl.canCancelAPs();
		Test.stopTest();
		System.assert(resp, 'La respuesta debe ser verdadera');
	}
	@isTest
	private static void whenTheUserIsEncargadoReturnTrue() {
		Boolean resp;
		System.runAs(userEncargado) {
			Test.startTest();
			resp = CaseAPAnularBtnCtrl.canCancelAPs();
			Test.stopTest();
		}
		System.assert(resp, 'La respuesta debe ser verdadera');
	}
	@isTest
	private static void whenTheUserIsNotLeaderReturnFalse() {
		Boolean resp;
		System.runAs(usuarioFront) {
			Test.startTest();
			resp = CaseAPAnularBtnCtrl.canCancelAPs();
			Test.stopTest();
		}
		System.assert(!resp, 'La respuesta debe ser falsa');
	}
}