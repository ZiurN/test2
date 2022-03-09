@isTest
private class CaseAPRevertirBtnCtrlTest {
	private static String AUTORIZACIONES_URL = ConfigUtils.getEndpointsByTipo('autorizaciones').get('centro-autorizador/revertir').Endpoint__c;
	private static XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
	private static List<String> profilesList = new List<String>{'Front', 'Mesa de ayuda'};
	private static List<String> userRolesList = new List<String>{'Filial_Casa_central', 'Encargado_Filial_Mar_del_Plata'};
	private static List<String> queuesList =  new List<String>{'Front', 'Mesa_de_ayuda'};
	private static String uniqueUserName = 'standarduserRevertirCase' + DateTime.now().getTime() + '@testorg.com';
	private static User usuarioFront = Build.anUser()
		.withUserName(uniqueUserName + 'Front')
		.withCodigoDelegacion('650886')
		.build();
	private static User usuarioMesa = Build.anUser()
		.withUserName(uniqueUserName + 'Mesa')
		.build();
	private static User userEncargado = Build.anUser()
		.withUserName(uniqueUserName + 'EncargadoFilial')
		.build();
	private static CaseTeamRole caseRole = new CaseTeamRole(Name = 'Cel Test', AccessLevel = 'Edit');
	private static Case caso;
	private static Prestacion__c prestacion;
	private static Prestacion__c prestacion2;
	private static Alerta__c alerta1;
	private static Alerta__c alerta2;
	private static Alerta__c alerta3;
	private static Account delegacion;
    static {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('650886').build();
			insert delegacion;
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
		caso = new Case();
		caso.Status = 'CA-----A';
		insert caso;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = caso.Id, MemberId = usuarioFront.Id, TeamRoleId = caseRole.Id);
		}
		prestacion = new Prestacion__c();
		prestacion.Ap__c = Caso.Id;
		insert prestacion;
		List<Alerta__c> alertsToInsert = new List<Alerta__c>();
		alerta1 = new Alerta__c();
		alerta1.Prestacion__c = prestacion.Id;
		alertsToInsert.add(alerta1);
		alerta2 = new Alerta__c();
		alerta2.Prestacion__c = prestacion.Id;
		alertsToInsert.add(alerta2);
		prestacion2 = new Prestacion__c();
		prestacion2.Ap__c = Caso.Id;
		insert prestacion2;
		alerta3 = new Alerta__c();
		alerta3.Prestacion__c = prestacion2.Id;
		alertsToInsert.add(alerta3);
		insert alertsToInsert;
		TestUtils.setMockResponse(getResponseFound, AUTORIZACIONES_URL + '/1014009821', WSCasoEnviarASSMock.getFound());
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
		System.assertEquals('CA-----G', casoToAssert.Status, 'El Estado del caso debe ser CA-----G');
		System.assertEquals(0, cantAlertas, 'No deben haber alertas asociadas');
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
		System.assertEquals(3, cantAlertas, 'Deben haber tres alertas asociadas');
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
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoFront, resp.message, 'El mensaje no indica el error');
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
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoMesaAyuda, resp.message, 'El mensaje no indica el error');
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
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoEquipoCaso, resp.message, 'El mensaje no indica el error');
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
		System.assertEquals('ok', resp.message, 'El mensaje no coincide');
		System.assertEquals('CA-----G', casoToAssert.Status, 'El Estado del caso debe ser CA-----G');
	}
	@isTest
	private static void whenTheUserIsLeaderReturnTrue() {
		Test.startTest();
		Boolean resp = CaseAPRevertirBtnCtrl.canRevertAPs();
		Test.stopTest();
		System.assert(resp,  'La respuesta debe ser verdadera');
	}
	@isTest
	private static void whenTheUserIsEncargadoReturnTrue() {
		Boolean resp;
		System.runAs(userEncargado) {
			Test.startTest();
			resp = CaseAPRevertirBtnCtrl.canRevertAPs();
			Test.stopTest();
		}
		System.assert(resp, 'La respuesta debe ser verdadera');
	}
	@isTest
	private static void whenTheUserIsNotLeaderReturnFalse() {
		Boolean resp;
		System.runAs(usuarioFront) {
			Test.startTest();
			resp = CaseAPRevertirBtnCtrl.canRevertAPs();
			Test.stopTest();
		}
		System.assert(!resp, 'La respuesta debe ser false');
	}
}