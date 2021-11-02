@isTest
private class CaseAPRevertirOrdenCtrlTest {
	private static XHttpCalloutMock getResponseFound;
	private static XHttpCalloutMock getResponseError;
	private static User usuarioFront;
	private static User usuarioMesa;
	private static CaseTeamRole caseRole;
	private static Case caso;
	private static Prestacion__c prestacion;
	private static Prestacion__c prestacion2;
	private static Alerta__c alerta1;
	private static Alerta__c alerta2;
	private static Alerta__c alerta3;
	private static Account delegacion;
	static {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String uniqueUserName = 'standarduserRevertirOrdenOnCase' + DateTime.now().getTime() + '@testorg.com';
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
		caso.Status = 'CA-----E';
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
				.withBody(WSCaseAPRevertirOrdenMock.getFound())
				.addForAddress(WSCaseAPRevertir.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/revertir/1017985413');
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
				.withStatus('Error')
				.withStatusCode(404)
				.withBody(WSCaseAPRevertirOrdenMock.getError())
				.addForAddress(WSCaseAPRevertir.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/revertir/1017985413');
	}
	@isTest
	private static void deleteAlertasRelatedToCaseAndChangeStatusFromCaseTest() {
		Orden_de_Compra__c orden = new Orden_de_Compra__c();
		orden.Estado_OC__c = 'Finalizada';
		orden.Caso__c = caso.Id;
		insert orden;
		caso.Nro_AP__c = '1017985413';
		caso.Orden_de_Compra__c = orden.Id;
		update caso;
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		ContentVersion version = new ContentVersion();
		version.PathOnClient = '/123456789.pdf';
		version.origin = 'H';
		version.Title = 'Orden_123456789.pdf';
		version.VersionData = Blob.valueOf('CaseAPRevertirOrdenCtrlTest');
		insert version;
		version = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id];
		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.LinkedEntityId = caso.Id;
		cdl.ContentDocumentId = version.ContentDocumentId;
		insert cdl;
		Test.startTest();
		CaseAPRevertirOrdenCtrl.revertirOrden(caso.Id);
		Test.stopTest();
		Integer cantAlertas = [SELECT COUNT() FROM Alerta__c];
		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		System.assertEquals('CA-----G', casoToAssert.Status, 'El estado del caso debe ser CA-----G');
		System.assertEquals(0, cantAlertas, 'No deben haber alertas');
		ContentDocument[] cds = [SELECT Id FROM ContentDocument WHERE Id = :version.ContentDocumentId];
		System.assert(cds.isEmpty(), 'No deben aver CVs');
		orden = [SELECT Id, Estado_OC__c FROM Orden_de_Compra__c WHERE Id = :orden.Id];
		System.assertEquals('Generada', orden.Estado_OC__c, 'El estado de la orden debe ser generada');
	}
	@isTest
	private static void errorWs() {
		caso.Nro_AP__c = '1017985413';
		update caso;
		Test.setMock(HttpCalloutMock.class, getResponseError);
		Test.startTest();
		BasicResponse resp = CaseAPRevertirOrdenCtrl.revertirOrden(caso.Id);
		Test.stopTest();
		System.assert(resp.hasError, 'La respuesta debe indicar un error');
		System.assertEquals('La autorización solicitada es inválida.', resp.message, 'El mensaje debe indicar que la autorización no es válida');
	}
	@isTest
	private static void ifStatusIsNotOrdenEmitidaShowErrorMsg() {
		caso.Status = 'CA-----A';
		caso.Nro_AP__c = '1017985413';
		update caso;
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Test.startTest();
		BasicResponse resp = CaseAPRevertirOrdenCtrl.revertirOrden(caso.Id);
		Test.stopTest();
		System.assert(!resp.hasError, 'La respuesta debe indicar que no hubo errores');
		System.assertEquals(System.Label.Alerta_NoAuth_EstadoOrdenDebeSerEmitida, resp.message, 'El mensaje debe indicar que la orden debe ser Emitida');
		Integer cantAlertas = [SELECT COUNT() FROM Alerta__c];
		System.assertEquals(3, cantAlertas, 'Deben haber tres alertas');
	}
	@isTest
	private static void validateUserWhenNoBelongsToFrontQueueAndCaseIsNivel1() {
		BasicResponse resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '1017985413';
			newCaso.Status = 'CA-----E';
			newCaso.Nivel_de_derivacion__c = 'Nivel 1';
			insert newCaso;
			Test.startTest();
			resp = CaseAPRevertirOrdenCtrl.revertirOrden(newCaso.Id);
			Test.stopTest();
		}
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoFront, resp.message, 'El mensaje debe indicar que el usuario no pertenece al front');
	}
	@isTest
	private static void validateUserWhenNoBelongsToMesaQueueAndCaseIsNivel2() {
		BasicResponse resp;
		System.runAs(usuarioFront) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '1017985413';
			newCaso.Status = 'CA-----E';
			newCaso.Nivel_de_derivacion__c = 'Nivel 2';
			newCaso.Delegacion__c = delegacion.Id;
			insert newCaso;
			Test.startTest();
			resp = CaseAPRevertirOrdenCtrl.revertirOrden(newCaso.Id);
			Test.stopTest();
		}
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoMesaAyuda, resp.message, 'El mensaje debe indicar que el usuario no pertenece a la Mesa de ayuda');
	}
	@isTest
	private static void validateUserWhenNoBelongsToTeamCaseAndCaseIsNivel3() {
		BasicResponse resp;
		System.runAs(usuarioMesa) {
			Case newCaso = new Case();
			newCaso.Nro_AP__c = '1017985413';
			newCaso.Status = 'CA-----E';
			newCaso.Nivel_de_derivacion__c = 'Nivel 3';
			insert newCaso;
			Test.startTest();
			resp = CaseAPRevertirOrdenCtrl.revertirOrden(newCaso.Id);
			Test.stopTest();
		}
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoEquipoCaso, resp.message, 'El mensaje debe indicar que el usuario no pertenece al equipo del caso');
	}
	@isTest
	private static void whenAFrontUserBelongsToFrontQueue_revertirAP() {
		BasicResponse resp;
		Case newCaso = new Case();
		System.runAs(usuarioFront) {
			newCaso.Nro_AP__c = '1017985413';
			newCaso.Status = 'CA-----E';
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
			resp = CaseAPRevertirOrdenCtrl.revertirOrden(newCaso.Id);
			Test.stopTest();
		}
		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: newCaso.Id];
		System.assertEquals('ok', resp.message, 'El mensaje debe ser ok');
		System.assertEquals('CA-----G', casoToAssert.Status, 'El estado del caso debe ser CA-----G');
	}
	@isTest
	private static void whenTheUserIsLeaderReturnTrue() {
		Test.startTest();
		Boolean resp = CaseAPRevertirOrdenCtrl.isLeader();
		Test.stopTest();
		System.assert(resp, 'La respuesta debe ser verdadera');
	}
	@isTest
	private static void whenTheUserIsNotLeaderReturnFalse() {
		Boolean resp;
		System.runAs(usuarioFront) {
			Test.startTest();
			resp = CaseAPRevertirOrdenCtrl.isLeader();
			Test.stopTest();
		}
		System.assert(!resp, 'La respuesta debe ser falsa');
	}
	@isTest
	public static void ifRevertimosACaseWithEMIMustDeleteThePDFlinkedToTheEMI(){
		Evento_medico__c em = new Evento_medico__c(
			Fecha_y_Hora_inicio_EMS__c = DateTime.now().addDays(-2),
			Fecha_y_hora_fin_ems__c = DateTime.now(),
			RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id
		);
		insert em;
		caso.Nro_AP__c = '1017985413';
		caso.Evento_Medico__c =  em.Id;
		update caso;
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		ContentVersion version = new ContentVersion();
		version.PathOnClient = '/123456789.pdf';
		version.origin = 'H';
		version.Title = 'Orden_123456789.pdf';
		version.VersionData = Blob.valueOf('CaseAPRevertirOrdenCtrlTest');
		insert version;
		version = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id];
		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.LinkedEntityId = em.Id;
		cdl.ContentDocumentId = version.ContentDocumentId;
		insert cdl;
		Test.startTest();
		CaseAPRevertirOrdenCtrl.revertirOrden(caso.Id);
		Test.stopTest();
		Case casoToAssert = [SELECT Status FROM Case WHERE Id =: caso.Id];
		System.assertEquals('CA-----G', casoToAssert.Status, 'El estado del caso debe ser CA-----G');
		ContentDocument[] cds = [SELECT Id FROM ContentDocument WHERE Id = :version.ContentDocumentId];
		System.assert(cds.isEmpty(), 'No deben haber CDs');
	}
}