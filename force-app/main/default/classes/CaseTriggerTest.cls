/**
 * Created by xappia on 12/2/20.
 */
@IsTest
private class CaseTriggerTest {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG = ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	static XHttpCalloutMock getSuccessResponse;
	static XHttpCalloutMock getErrorResponse;
	static User medico;
	static User medico2;
	static User userBack;
	static Account centro;
	static CaseTeamRole caseRole;
	static {
		String uniqueUserName = 'standardusercasetriggertest' + DateTime.now().getTime() + '@testorg.com';
		Profile pMedico = [SELECT Id, Name FROM Profile WHERE Name = 'Auditor Medico'];
		Profile pBack = [SELECT Id FROM Profile WHERE Name='Back Administrativo'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		medico = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'Medico', ProfileId = pMedico.Id, UserRole = role
		);
		insert medico;
		medico2 = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'Medico2', ProfileId = pMedico.Id, UserRole = role
		);
		insert medico2;
		userBack = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'Back', ProfileId = pBack.Id, UserRole = role
		);
		insert userBack;
		caseRole = new CaseTeamRole();
		caseRole.Name = 'Cel Test';
		caseRole.AccessLevel = 'Edit';
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert caseRole;
		}
		centro =  new Account();
		centro.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		centro.Name = 'Centro de Contacto';
		centro.Codigo_de_delegacion__c = '661090';
		centro.Correo_electronico__c = 'test@xysssssss.org';
		insert centro;
		getSuccessResponse = new XHttpCalloutMock();
		getSuccessResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getSuccessResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSCaseReintegroReasignarMock.getFound())
				.addForAddress(WSCaseReintegroReasignar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/553276');
		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
				.withStatus('Error')
				.withStatusCode(500)
				.withBody(WSCaseReintegroReasignarMock.getError())
				.addForAddress(WSCaseReintegroReasignar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/123');
	}
	@IsTest
	static void ItShouldAssignASLA24ToTheCase() {
		List<SlaProcess> slaProcesses = [SELECT Id, Name FROM SlaProcess WHERE Name = '24'];
		if (slaProcesses.isEmpty()) {return;}
		Account cta = Build.anAccount().build();
		insert cta;
		Case nCase = new Case(
			Type='Prestacion',
			RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
			Categorizacion_SS__c = 'Baja complejidad',
			AP_Presupuesto__c = false,
			AP_Material__c = false,
			AccountId = cta.Id,
			Tiempo_SLA__c = '24');
		Test.startTest();
		insert nCase;
		Test.stopTest();
		Case upCase = [SELECT SlaStartDate,Entitlement.Name,MilestoneStatus FROM Case];
		System.assertNotEquals(null,upCase.SlaStartDate);
		System.assertEquals('24 STRING',upCase.Entitlement.Name);
		System.assertEquals('Compliant',upCase.MilestoneStatus);
		List<CaseMilestone> caseMilestones = [ SELECT Id FROM CaseMilestone WHERE CaseId = :upCase.Id ];
		System.assertEquals(1, caseMilestones.size());
	}
	@IsTest
	static void ItShouldAssignASLA724ToTheCase() {
		List<SlaProcess> slaProcesses = [ SELECT Id, Name FROM SlaProcess WHERE Name = '72'];
		if (slaProcesses.isEmpty()) {return;}
		Account cta = Build.anAccount().build();
		insert cta;
		Case nCase = new Case(
			Type='Prestacion',
			RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
			Sub_tipo__c= 'Presupuesto',
			Categorizacion_SS__c = 'Alta complejidad',
			AP_Presupuesto__c = false,
			AP_Material__c = false,
			AccountId = cta.Id,
			Tiempo_SLA__c = '72'
		);
		Test.startTest();
		insert nCase;
		Test.stopTest();
		Case upCase = [SELECT SlaStartDate,Entitlement.Name,MilestoneStatus FROM Case];
		System.assertNotEquals(null,upCase.SlaStartDate);
		System.assertEquals('72 STRING',upCase.Entitlement.Name);
		System.assertEquals('Compliant',upCase.MilestoneStatus);
		List<CaseMilestone> caseMilestones = [ SELECT Id FROM CaseMilestone WHERE CaseId = :upCase.Id ];
		System.assertEquals(1, caseMilestones.size());
	}
	@IsTest
	static void ItShouldAssignASLA120_12ToTheCase() {
		List<SlaProcess> slaProcesses = [SELECT Id FROM SlaProcess WHERE Name = '120'];
		if (slaProcesses.isEmpty()) {return;}
		Account cta = Build.anAccount().build();
		insert cta;
		Case nCase = new Case(
			Type='Prestacion',
			RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
			Sub_tipo__c= 'Material',
			Categorizacion_SS__c = 'ACM / No nomencladas',
			AP_Presupuesto__c = false,
			AP_Material__c = false,
			AccountId = cta.Id,
			Tiempo_SLA__c = '120'
		);
		Test.startTest();
		insert nCase;
		Test.stopTest();
		Case upCase = [SELECT SlaStartDate,Entitlement.Name,MilestoneStatus FROM Case];
		System.assertNotEquals(null,upCase.SlaStartDate);
		System.assertEquals('120 STRING',upCase.Entitlement.Name);
		System.assertEquals('Compliant',upCase.MilestoneStatus);
		List<CaseMilestone> caseMilestones = [ SELECT Id FROM CaseMilestone WHERE CaseId = :upCase.Id ];
		System.assertEquals(1, caseMilestones.size());
	}
	@IsTest
	static void ItShouldAssignASLA120_4ToTheCase() {
		List<SlaProcess> slaProcesses = [SELECT Id FROM SlaProcess WHERE Name = '120'];
		if (slaProcesses.isEmpty()) {return;}
		Account cta = Build.anAccount().build();
		insert cta;
		Case nCase = new Case(
			Type='Quirurgico',
			RecordTypeId = XappiaHelper.getRecordType('Case','Internacion').Id,
			Sub_tipo__c= 'Quirurgico',
			Categorizacion_SS__c = 'Baja complejidad',
			AP_Presupuesto__c = false,
			AP_Material__c = true,
			AccountId = cta.Id,
			Tiempo_SLA__c = '120'
		);
		Test.startTest();
		insert nCase;
		Test.stopTest();
		Case upCase = [SELECT SlaStartDate,Entitlement.Name,MilestoneStatus FROM Case];
		System.assertNotEquals(null,upCase.SlaStartDate);
		System.assertEquals('120 STRING',upCase.Entitlement.Name);
		System.assertEquals('Compliant',upCase.MilestoneStatus);
		List<CaseMilestone> caseMilestones = [ SELECT Id FROM CaseMilestone WHERE CaseId = :upCase.Id ];
		System.assertEquals(1, caseMilestones.size());
	}
	@IsTest
	static void SLA120_AutorizacionPrevia_Medicamento_CubiertosPorProvision(){
		List<SlaProcess> slaProcesses = [SELECT Id FROM SlaProcess WHERE Name = '120'];
		if (slaProcesses.isEmpty()) {return;}
		Account cta = Build.anAccount().build();
		insert cta;
		Case nCase = new Case(
			RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
			Type = 'Medicamento',
			Categorizacion_SS__c = 'Cubiertos por provision',
			AccountId = cta.Id,
			Tiempo_SLA__c = '120'
		);
		Test.startTest();
		insert nCase;
		Test.stopTest();
		Case upCase = [SELECT Id,SlaStartDate,Entitlement.Name,MilestoneStatus FROM Case];
		System.assertNotEquals(null,upCase.SlaStartDate);
		System.assertEquals('120 STRING',upCase.Entitlement.Name);
		List<CaseMilestone> caseMilestones = [ SELECT Id FROM CaseMilestone WHERE CaseId = :upCase.Id ];
		System.assertEquals(1, caseMilestones.size());
	}
	@IsTest
	static void whenUpdateCase_changeSLA120ToSLA24_AutorizacionPrevia_Medicamento_NoCubiertos(){
		List<SlaProcess> slaProcesses = [SELECT Id FROM SlaProcess WHERE Name = '24'];
		if (slaProcesses.isEmpty()) {return;}
		Account cta = Build.anAccount().build();
		insert cta;
		Case nCase = new Case(
			RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
			Type = 'Medicamento',
			Categorizacion_SS__c = 'Cubiertos por provision',
			AccountId = cta.Id, Tiempo_SLA__c = '24'
		);
		Test.startTest();
		insert nCase;
		nCase.Categorizacion_SS__c = 'No cubiertos';
		update nCase;
		Test.stopTest();
		Case upCase = [SELECT Id,SlaStartDate,Entitlement.Name,MilestoneStatus FROM Case];
		System.assertNotEquals(null,upCase.SlaStartDate);
		System.assertEquals('24 STRING',upCase.Entitlement.Name);
		List<CaseMilestone> caseMilestones = [ SELECT Id FROM CaseMilestone WHERE CaseId = :upCase.Id ];
		System.assertEquals(1, caseMilestones.size());
	}
	@IsTest
	static void assignDelegacionFromUserTest() {
		Account delegacion = new Account();
		delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacion.Name = 'Test';
		delegacion.Codigo_de_delegacion__c = '661089';
		insert  delegacion;
		List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = profileList[0].Id,
				TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
		);
		usuario.Codigo_delegacion__c = delegacion.Codigo_de_delegacion__c;
		insert usuario;
		User usuario2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = profileList[0].Id,
				TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser2@xappia.com'
		);
		usuario2.Codigo_delegacion__c = delegacion.Codigo_de_delegacion__c;
		insert usuario2;
		List<Case> casos = new List<Case> {
			new Case(OwnerId = usuario.Id),
			new Case(OwnerId = usuario2.Id),
			new Case(OwnerId = usuario2.Id)
		};
		Test.startTest();
		insert casos;
		Test.stopTest();
		List<Case> casosToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id =: casos];
		for(Case casoToAssert : casosToAssert) {
			System.assertEquals('661089', casoToAssert.Delegacion__r.Codigo_de_delegacion__c);
		}
	}
	@IsTest
	static void ifTheDelegacionDoesNotExistInUserDoNotGiveError() {
		List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = profileList[0].Id,
				TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
		);
		usuario.Codigo_delegacion__c = '123456';
		insert usuario;
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Case caso = new Case();
		caso.AccountId = acc.Id;
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		System.runAs(usuario) {
			Test.startTest();
			insert caso;
			Test.stopTest();
		}
		Case casoToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id =: caso.Id];
		System.assertEquals(null, casoToAssert.Delegacion__r.Codigo_de_delegacion__c);
	}
	@IsTest
	static void ifTheDelegacionIsNullInUserDoNotGiveError() {
		List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
		List<Group> groupList = [SELECT Id,Name FROM Group WHERE type= 'queue'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',profileId=profileList[0].Id,
				UserName='usertotestassignDelegacionFromUser@xappia.com'
		);
		insert usuario;
		GroupMember groupMember = new GroupMember( groupId = groupList[0].Id);
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Case caso = new Case();
		caso.AccountId = acc.Id;
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		System.runAs(usuario) {
			Test.startTest();
			insert caso;
			Test.stopTest();
		}
		Case casoToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Case WHERE Id =: caso.Id];
		System.assertEquals(null, casoToAssert.Delegacion__r.Codigo_de_delegacion__c);
	}
	@isTest
	static void whenCreateCaseTypeReintegroItAssignToEntitlementSLA240(){
		List<SlaProcess> slaProcesses = [SELECT Id FROM SlaProcess WHERE Name = '240'];
		System.assert( !slaProcesses.isEmpty() , 'Deberia existir la metadata');
		Account cta = Build.anAccount().build();
		insert cta;
		Case nCase = new Case(
			RecordTypeId = XappiaHelper.getRecordType('Case','Reintegro').Id,
			Type = 'Medicamento',
			CBU__c = '12345',
			AccountId = cta.Id,
			Status='Generada',
			Tiempo_SLA__c = '240'
		);
		Test.startTest();
		insert nCase;
		Test.stopTest();
		Case caseAfterInsert = [SELECT Id,CBU__C,AccountId,Status,Entitlement.Name,(SELECT Id FROM CaseMilestones) FROM Case WHERE ID = :nCase.Id];
		System.assertEquals(1, caseAfterInsert.CaseMilestones.size());
		System.assertEquals('12345', caseAfterInsert.CBU__c, 'El CBU deberia ser 12345');
		System.assertEquals('Generada', caseAfterInsert.Status, 'El estado deberia ser Generada');
		System.assertEquals('240 STRING', caseAfterInsert.Entitlement.Name, 'Entitlement.Name deberia ser SLA240');
	}
	@isTest
	static void whenEstadoDeComunicacionUpdatesToSolicitarDocumentacion_shouldMakeTheseChanges_withCelula(){
		List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator'];
		List<Group> colaFront = [SELECT Id, Name, DeveloperName FROM Group WHERE Type='Queue' AND DeveloperName = 'Front'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = profileList[0].Id, isActive = true,
				TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
		);
		insert usuario;
		User usuarioDos = new User(Alias = 'test', Email='teststandarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = profileList[0].Id,
				TimeZoneSidKey='America/Los_Angeles', UserName='testuserexamplexappia@xappia.com'
		);
		insert usuarioDos;
		List<RecordType> rt = [SELECT Id, name, developername FROM RecordType WHERE sObjecttype ='Account' AND IsPersonType=true];
		Account cta = Build.anAccount().build();
		cta.RecordTypeId = rt[0].id;
		Case nCase = new Case(RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
							  AccountId = cta.Id, Status='Generada', CBU__c='12354');
		Case nCaseDos = new Case(RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
								 AccountId = cta.Id, Status='Generada', CBU__c='12354');
		List<Case> cases = new list<Case>();
		cases.add(nCase);
		cases.add(nCaseDos);
		System.runAs(usuario){
			insert cta;
			cases[0].AccountId = cta.Id;
			cases[1].AccountId = cta.Id;
			insert cases;
		}
		System.runAs(usuarioDos){
			Test.startTest();
			cases[0].Estado_de_documentacion__c = 'Solicitar documentacion';
			cases[0].Informacion_de_documentacion_faltante__c = 'test';
			cases[0].Celula__c = 'Celula 1';
			cases[1].Estado_de_documentacion__c = 'Solicitar documentacion';
			cases[1].Informacion_de_documentacion_faltante__c = 'testtt';
			cases[1].Celula__c = 'Celula 1';
			update cases;
			Test.stopTest();
		}
		List<Id>idCases = new List<Id>();
		idCases.add(cases[0].Id);
		idCases.add(cases[1].Id);
		List<Case> casesAfterInsert = [SELECT Id,Status,OwnerId,
											CreatedById,
											LastModifiedById,
											estado_de_documentacion__c,
											id_usuario_solicitante__c,
											id_equipo_solicitante__c,
											id_celula_solicitante__c,
											Celula__c,
											Usuario__c
										FROM Case WHERE id IN :idCases];
		for( Case caseAfterInsert : casesAfterInsert){
			System.assertEquals(usuarioDos.id, caseAfterInsert.id_usuario_solicitante__c ,'El id del usuario solicitante deberia ser el ultimo que modifico el caso' );
			System.assertEquals(usuario.Id, caseAfterInsert.id_equipo_solicitante__c, 'El id equipo solicitante deberia ser quien era el owner antes de solicitar');
			System.assertEquals(colaFront[0].Id, caseAfterInsert.OwnerId, 'El owner deberia ser la cola "Front"');
			System.assertEquals('Solicitar documentacion', caseAfterInsert.estado_de_documentacion__c , 'El estado de documentacion deberia ser Solicitar documentacion.');
			System.assertEquals(usuarioDos.Id, caseAfterInsert.LastModifiedById, 'El ultimo usuario que modifico el caso deberia ser ' + usuarioDos.Id);
			System.assertEquals(caseAfterInsert.id_celula_solicitante__c , caseAfterInsert.Celula__c , 'El Id de la celular solicitante deberia ser: ' + caseAfterInsert.Celula__c);
			System.assertEquals('Generada', caseAfterInsert.Status, 'El estado deberia ser Generada');
		}
	}
	@isTest
	static void whenEstadoDeComunicacionUpdatesToSolicitarDocumentacion_shouldMakeTheseChanges_caseWithoutCelula(){
		List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator'] ;
		List<Group> colaFront = [SELECT Id, Name, DeveloperName FROM Group WHERE Type='Queue' AND DeveloperName = 'Front'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = profileList[0].Id, isActive=true,
				TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
		);
		insert usuario;
		List<RecordType> rt = [SELECT Id, name, developername FROM RecordType WHERE sObjecttype ='Account' AND IsPersonType=true];
		Account cta = Build.anAccount().build();
		cta.RecordTypeId = rt[0].id;
		Case nCase = new Case(	RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
								CBU__c = '12345', AccountId = cta.Id, Status='Generada',
								Informacion_de_documentacion_faltante__c = 'test');
		System.runAs(usuario){
			insert cta;
			insert nCase;
			Test.startTest();
			nCase.estado_de_documentacion__c = 'Solicitar documentacion';
			nCase.Nivel_de_derivacion__c = 'Nivel 2';
			update nCase;
			Test.stopTest();
		}
		Case caseAfterInsert = [SELECT Id,
									Status,
									OwnerId,
									CreatedById,
									CBU__c,
									LastModifiedById,
									estado_de_documentacion__c,
									id_usuario_solicitante__c,
									nivel_de_derivacion__c,
									id_equipo_solicitante__c,
									Celula__c,
									Usuario__c
								FROM Case WHERE ID = :nCase.Id];
		System.assertEquals('Solicitar documentacion', caseAfterInsert.estado_de_documentacion__c , 'El estado de documentacion deberia ser Solicitar documentacion.');
		System.assertEquals(usuario.Id, caseAfterInsert.LastModifiedById, 'El ultimo usuario que modifico el caso deberia ser ' + usuario.Id);
		System.assertEquals('12345', caseAfterInsert.CBU__c, 'El CBU Deberia ser 12345');
		System.assertEquals(colaFront[0].Id, caseAfterInsert.OwnerId , 'El owner deberia ser la cola "Front"');
		System.assertEquals(null, caseAfterInsert.Celula__c , 'La celula deberia ser null.');
		System.assertEquals('Generada', caseAfterInsert.Status, 'El estado deberia ser Generada');
	}
	@isTest
	static void whenEstadoDeComunicacionUpdatesToDocumentacionFinalizada_shouldMakeTheseChanges_caseWithCelula(){
		List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator'];
		List<QueueSobject> queueObject = [SELECT Id,QueueId FROM QueueSobject WHERE SobjectType='Case'];
		List<Group> groupp = [SELECT Id,Name, DeveloperName FROM Group WHERE Type='Queue' AND Id=:queueObject[0].QueueId];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = profileList[0].Id, isActive=true,
				TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
		);
		insert usuario;
		List<RecordType> rt = [SELECT Id, name, developername FROM RecordType WHERE sObjecttype ='Account' AND IsPersonType=true];
		Account cta = Build.anAccount().build();
		cta.RecordTypeId = rt[0].id;
		Case nCase = new Case(	RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
								CBU__c = '12345', AccountId = cta.Id, Status='Generada', ownerId = groupp[0].Id,
								id_equipo_solicitante__c = 'Nivel 1',
								Informacion_de_documentacion_faltante__c='test', Celula__c='Celula 1',id_celula_solicitante__c='Celula 1',
								Correo_electronico_responsable__c = 'test34222test33@gmail.com', usuario__c = usuario.id);
		Case nCaseDos = new Case(RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
								CBU__c = '12345', AccountId = cta.Id, Status='Generada', ownerId = groupp[0].Id,
								id_equipo_solicitante__c = 'Nivel 1',
								Informacion_de_documentacion_faltante__c='test', Celula__c='Celula 1',id_celula_solicitante__c='Celula 1',
								Correo_electronico_responsable__c = 'test34222test@gmail.com', usuario__c = usuario.id);
		list<Case> cases = new List<Case>();
		cases.add(nCase);
		cases.add(nCaseDos);
		System.runAs(usuario){
			insert cta;
			insert cases;
			Test.startTest();
			cases[0].estado_de_documentacion__c = 'Solicitar documentacion';
			cases[1].estado_de_documentacion__c = 'Solicitar documentacion';
			update cases;
			cases[0].estado_de_documentacion__c = 'Documentacion finalizada';
			cases[1].estado_de_documentacion__c = 'Documentacion finalizada';
			update cases;
			Test.stopTest();
		}
				List<Id>idCases = new List<Id>();
		idCases.add(cases[0].Id);
		idCases.add(cases[1].Id);
		List<Case> casesAfterInsert = [SELECT OwnerId,
										CBU__c,
										estado_de_documentacion__c,
										id_usuario_solicitante__c,
										id_equipo_solicitante__c,
										Nivel_de_derivacion__c,
										id_celula_solicitante__c,
										Celula__c,
										Usuario__c
									FROM Case WHERE id IN :idCases];
		for(Case caseAfterInsert : casesAfterInsert){
			System.assertEquals('Documentacion finalizada', caseAfterInsert.estado_de_documentacion__c , 'El estado de documentacion deberia ser Documentacion finalizada.');
			System.assertEquals('Nivel 1', caseAfterInsert.Nivel_de_derivacion__c , 'El nivel de derivacion deberia ser Nivel 1');
			System.assertEquals('12345', caseAfterInsert.CBU__c, 'El CBU Deberia ser 12345');
			System.assertEquals(caseAfterInsert.id_celula_solicitante__c, caseAfterInsert.Celula__c , 'El id de celula solicitante deberia ser ' + caseAfterInsert.Celula__c);
		}
	}
	@isTest
	static void whenEstadoDeComunicacionUpdatesToDocumentacionFinalizada_shouldMakeTheseChanges_WithoutCelula(){
		List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = profileList[0].Id, isActive=true,
				TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
		);
		insert usuario;
		Group groupMesa = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Mesa_de_ayuda'];
		GroupMember groupMemberOfMesa = new GroupMember(groupId = groupMesa.Id, UserOrGroupId = usuario.Id);
		List<RecordType> rt = [SELECT Id, name, developername FROM RecordType WHERE sObjecttype ='Account' AND IsPersonType=true];
		Account cta = Build.anAccount().build();
		cta.RecordTypeId = rt[0].id;
		Case nCase = new Case(	RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
								CBU__c = '12345', Status='Generada', Nivel_de_derivacion__c = 'Nivel 2',
								Informacion_de_documentacion_faltante__c='test', Description='test',Fecha_prescripcion__c = Date.today(),
								Fecha__c = Date.today().addDays(1),
							 	Fecha_probable__c = Date.today().addDays(2), usuario__c = usuario.Id, id_usuario_solicitante__c = usuario.Id,
							 	Correo_electronico_responsable__c= 'soyuntesttttt@gmail.com');
		System.runAs(usuario){
			insert cta;
			nCase.AccountId = cta.Id;
			insert nCase;
			nCase = [SELECT OwnerId FROM Case WHERE Id = :nCase.Id];
			nCase.Estado_de_documentacion__c = 'Solicitar documentacion';
			update nCase;
			Test.startTest();
			nCase = [
				SELECT Id,casenumber,RecordTypeId,
				CBU__c, Status, OwnerId, Estado_de_documentacion__c,
				id_equipo_solicitante__c, Informacion_de_documentacion_faltante__c,
				Description, Fecha_prescripcion__c, Fecha_probable__c, usuario__c,
				id_usuario_solicitante__c, Correo_electronico_responsable__c
				FROM CASE
				WHERE id = :nCase.id
			][0];
			nCase.Estado_de_documentacion__c = 'Documentacion finalizada';
			update nCase;
			Test.stopTest();
		}
		Case caseAfterInsert = [
			SELECT
			OwnerId, Owner.Name,
			CBU__c,
			Estado_de_documentacion__c,
			id_usuario_solicitante__c,
			id_equipo_solicitante__c,
			Nivel_de_derivacion__c,
			Celula__c,
			Usuario__c
			FROM Case WHERE id = :nCase.Id];
		System.assertEquals('Documentacion finalizada', caseAfterInsert.Estado_de_documentacion__c , 'El estado de documentacion deberia ser Solicitar documentacion.');
		System.assertEquals(caseAfterInsert.Nivel_de_derivacion__c, caseAfterInsert.id_equipo_solicitante__c, 'El id del equipo solicitante deberia ser el mismo que el nivel de derivacion');
		System.assertEquals(groupMesa.Id, caseAfterInsert.OwnerId, 'el owner debe volver a ser la cola "Mesa_de_ayuda"');
		System.assertEquals('12345', caseAfterInsert.CBU__c, 'El CBU Deberia ser 12345');
		System.assertEquals(null, caseAfterInsert.Celula__c , 'El id de celula solicitante deberia ser null');
	}
	@IsTest
	private static void reingresoReasignacionDeLote(){
		Test.setMock(HttpCalloutMock.class, getSuccessResponse);
		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		reintegro.Codigo_reintegro_SS__c = '553276';
		insert reintegro;
		Lote__c lote = new Lote__c();
		lote.Id_lote_SS__c = '999999';
		insert lote;
		Test.startTest();
		reintegro.Lote__c = lote.Id;
		update reintegro;
		Test.stopTest();
		reintegro = [SELECT Error_reasignacion__c, Fecha_error_reasignacion__c, Usuario_error_reasignar__c FROM Case WHERE Id = :reintegro.Id];
		System.assertEquals(null, reintegro.Error_reasignacion__c);
		System.assertEquals(null, reintegro.Fecha_error_reasignacion__c);
		System.assertEquals(null, reintegro.Usuario_error_reasignar__c);
	}
	@IsTest
	private static void reingresoReasignacionDeLoteConError(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		reintegro.Codigo_reintegro_SS__c = '123';
		insert reintegro;
		Lote__c lote = new Lote__c();
		lote.Id_lote_SS__c = '999999';
		insert lote;
		User usuario = [SELECT CommunityNickname FROM User WHERE Id = :UserInfo.getUserId()];
		String nick = usuario.CommunityNickname.toUpperCase();
		Test.startTest();
		reintegro.Lote__c = lote.Id;
		update reintegro;
		Test.stopTest();
		reintegro = [SELECT Error_reasignacion__c, Fecha_error_reasignacion__c,Usuario_error_reasignar__c FROM Case WHERE Id = :reintegro.Id];
		System.assertEquals('El reintegro solicitado es inválido.', reintegro.Error_reasignacion__c);
		System.assertNotEquals(null, reintegro.Fecha_error_reasignacion__c);
		System.assertEquals(nick, reintegro.Usuario_error_reasignar__c);
	}
	@isTest
	private static void whenCasoRechazadoIsTrue_EstadoDeSuOCPasaARechazada(){
		Case casoTest = new Case();
		casoTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		casoTest.Status = 'CA-----G';
		casoTest.Fecha_probable__c = Date.today();
		casoTest.Nro_AP__c = '12345678';
		casoTest.caso_rechazado__c = false;
		insert casoTest;
		Orden_de_Compra__c orden = new Orden_de_Compra__c ();
		orden.forma_de_Pago__c = 'Aca Salud';
		orden.Caso__c = casoTest.Id;
		insert orden;
		Test.startTest();
		casoTest.caso_rechazado__c = true;
		update casoTest;
		Test.stopTest();
		Orden_de_Compra__c ordenToAssert = [
			SELECT Estado_OC__c
			FROM Orden_de_Compra__c
			WHERE Caso__c = :casoTest.Id
		];
		System.assertEquals('Rechazada', ordenToAssert.Estado_OC__c);
	}
	@isTest
	private static void estadoCasoEsEmitidoYSuOCNoTieneCotizacion_EstadoDeSuOCPasaADesestimada(){
		Case casoTest = new Case();
		casoTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		casoTest.Status = 'CA-----G';
		casoTest.Fecha_probable__c = Date.today();
		casoTest.Nro_AP__c = '12345678';
		insert casoTest;
		Orden_de_Compra__c orden = new Orden_de_Compra__c ();
		orden.forma_de_Pago__c = 'Aca Salud';
		orden.Caso__c = casoTest.Id;
		insert orden;
		Test.startTest();
		casoTest.Status = 'CA-----E';
		update casoTest;
		Test.stopTest();
		Orden_de_Compra__c ordenToAssert = [SELECT Id, Estado_OC__c, Caso__c FROM Orden_de_Compra__c WHERE Caso__c = :casoTest.Id];
		Case caseToAssert = [SELECT Orden_de_Compra__c FROM Case WHERE Id = :casoTest.Id];
		System.assertEquals('Desestimada', ordenToAssert.Estado_OC__c);
		System.assertEquals(ordenToAssert.Id, caseToAssert.Orden_de_Compra__c);
	}
	@isTest
	private static void estadoCasoEsEmitidoYSuOCTieneCotizacion_EstadoDeSuOCPasaAFinalizada() {
		Account acc = new Account();
		acc.RecordTypeId = XappiaHelper.getRecordType('Account', 'Efector').Id;
		acc.Name = 'Test';
		acc.Es_Prestador__c = true;
		insert acc;
		Case casoTest = new Case();
		casoTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		casoTest.Status = 'CA-----G';
		casoTest.Fecha_probable__c = Date.today();
		casoTest.Nro_AP__c = '12345678';
		insert casoTest;
		Orden_de_Compra__c orden = new Orden_de_Compra__c ();
		orden.forma_de_Pago__c = 'Aca Salud';
		orden.Estado_OC__c = 'Emitida';
		orden.Caso__c = casoTest.Id;
		insert orden;
		Cotizacion_Prestador__c coti = new Cotizacion_Prestador__c ();
		coti.Prestador__c = acc.Id;
		coti.Orden_de_Compra__c = orden.Id;
		insert coti;
		Test.startTest();
		casoTest.Status = 'CA-----E';
		update casoTest;
		Test.stopTest();
		Orden_de_Compra__c ordenToAssert = [SELECT Id, Estado_OC__c, Caso__c, (SELECT Id FROM Cotizaciones_Prestadores__r) FROM Orden_de_Compra__c WHERE Id = :orden.Id];
		Case caseToAssert = [SELECT Orden_de_Compra__c FROM Case WHERE Id = :casoTest.Id];
		System.assertEquals(false, ordenToAssert.Cotizaciones_Prestadores__r.isEmpty());
		System.assertEquals('Finalizada', ordenToAssert.Estado_OC__c);
		System.assertEquals(ordenToAssert.Id, caseToAssert.Orden_de_Compra__c);
	}
	@isTest
	private static void estadoCasoEsAnuladoYSuOCNoTieneCotizacion_EstadoDeSuOCPasaAFinalizada() {
		Case casoTest = new Case();
		casoTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		casoTest.Status = 'CA-----G';
		casoTest.Fecha_probable__c = Date.today();
		casoTest.Nro_AP__c = '12345678';
		insert casoTest;
		Orden_de_Compra__c orden = new Orden_de_Compra__c ();
		orden.forma_de_Pago__c = 'Aca Salud';
		orden.Caso__c = casoTest.Id;
		insert orden;
		Test.startTest();
		casoTest.Status = 'CA-----N';
		update casoTest;
		Test.stopTest();
		Orden_de_Compra__c ordenToAssert = [SELECT Id, Estado_OC__c, Caso__c FROM Orden_de_Compra__c WHERE Caso__c = :casoTest.Id];
		Case caseToAssert = [SELECT Orden_de_Compra__c FROM Case WHERE Id = :casoTest.Id];
		System.assertEquals('Anulada', ordenToAssert.Estado_OC__c);
		System.assertEquals(ordenToAssert.Id, caseToAssert.Orden_de_Compra__c);
	}
	@isTest
	private static void whenFieldMedicoAsignadoChangesAndCaseIsNotInLevel2or3_ShowErrorMsg() {
		Case aCase = new Case();
		aCase.OwnerId = userBack.Id;
		aCase.Contiene_alerta_AM__c = true;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;
		Database.SaveResult result;
		System.runAs(userBack) {
			Test.startTest();
			aCase.Medico_asignado__c = medico.Id;
			aCase.Usuario__c = userBack.Id;
			aCase.Responsable_de_presupuesto__c = userBack.Id;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(!result.isSuccess());
		for(Database.Error err : result.getErrors()) {
			System.assert(err.getMessage().contains('El caso debe estar en nivel 2 o 3 para poder asignar/desasignar'));
		}
	}
	@isTest
	private static void ifAMedicoWantsToAssignHimselfAndThereIsAnotherMedicoAssigned_ShowErrorMsg() {
		Case aCase = new Case();
		aCase.OwnerId = medico.Id;
		aCase.Celula__c = 'Celula 1';
		aCase.Contiene_alerta_AM__c = true;
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.Medico_asignado__c = medico2.Id;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		insert aCase;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = aCase.Id, MemberId = medico.Id, TeamRoleId = caseRole.Id);
		}
		Database.SaveResult result;
		System.runAs(medico) {
			Test.startTest();
			aCase.Medico_asignado__c = medico.Id;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(!result.isSuccess());
		System.assertEquals('No tiene los permisos necesarios para modificar este campo', result.getErrors()[0].getMessage());
	}
	@isTest
	private static void ifAMedicoWantsToAssignHimselfAndMedicoAsignadoThereWasNull_heShouldBeAble() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.OwnerId = medico.Id;
		aCase.Celula__c = 'Celula 1';
		aCase.Contiene_alerta_AM__c = true;
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Internacion').Id;
		insert aCase;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = aCase.Id, MemberId = medico.Id, TeamRoleId = caseRole.Id);
		}
		Database.SaveResult result;
		System.runAs(medico) {
			Test.startTest();
			aCase.Medico_asignado__c = medico.Id;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess());
	}
	@isTest
	private static void ifACaseHasNotAlertsAMAndTheFieldMedicoAsinadoChanges_ShowErrorMsg() {
		Case aCase = new Case();
		aCase.OwnerId = medico.Id;
		aCase.Celula__c = 'Celula 1';
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.Medico_asignado__c = medico2.Id;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert aCase;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = aCase.Id, MemberId = medico.Id, TeamRoleId = caseRole.Id);
		}
		Database.SaveResult result;
		System.runAs(medico) {
			Test.startTest();
			aCase.Medico_asignado__c = medico.Id;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(!result.isSuccess());
		System.assertEquals(
			'El Caso debe tener alertas AM para poder modificar el médico asignado', result.getErrors()[0].getMessage()
		);
	}
	@isTest
	private static void ifAnUserIsTheLiderOfCelulaAndChangesTheMedicoAsignado_heShouldBeAble() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.Celula__c = 'Celula 1';
		aCase.Contiene_alerta_AM__c = true;
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.Medico_asignado__c = medico2.Id;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;
		Group groupCelula1 = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Celula_1'];
		GroupMember groupMemberC1 = new GroupMember(groupId = groupCelula1.Id, UserOrGroupId = medico.Id);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert groupMemberC1;
		}
		Database.SaveResult result;
		System.runAs(medico) {
			Test.startTest();
			aCase.Medico_asignado__c = medico.Id;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess());
	}
	@isTest
	private static void ifADoctorWantsToAssignAnotherDoctor_ShowTheErrorMsg() {
		Case aCase = new Case();
		aCase.Celula__c = 'Celula 1';
		aCase.Contiene_alerta_AM__c = true;
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		insert aCase;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = aCase.Id, MemberId = medico.Id, TeamRoleId = caseRole.Id);
		}
		Database.SaveResult result;
		System.runAs(medico) {
			Test.startTest();
			aCase.Medico_asignado__c = medico2.Id;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(!result.isSuccess());
		System.assertEquals(
			'No tiene los permisos necesarios para modificar este campo', result.getErrors()[0].getMessage()
		);
	}
	@isTest
	private static void ifAnUserIsTheResponsableAndChangesTheMedicoAsignado_heShouldBeAble() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.Celula__c = 'Celula 1';
		aCase.Usuario__c = medico.Id;
		aCase.Contiene_alerta_AM__c = true;
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.Medico_asignado__c = medico2.Id;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert aCase;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = aCase.Id, MemberId = medico.Id, TeamRoleId = caseRole.Id);
		}
		Database.SaveResult result;
		System.runAs(medico) {
			Test.startTest();
			aCase.Medico_asignado__c = medico.Id;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess());
	}
	@isTest
	private static void ifAnUserBelongsToMesaQueueInLevel2AndAssignToHimselfAsResponsableWhenTheFieldIsEmpty_heShouldBeAble() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.Nivel_de_derivacion__c = 'Nivel 2';
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Internacion').Id;
		insert aCase;
		Group groupMesa = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Mesa_de_ayuda'];
		GroupMember groupMemberOfMesa = new GroupMember(groupId = groupMesa.Id, UserOrGroupId = userBack.Id);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert groupMemberOfMesa;
		}
		Database.SaveResult result;
		System.runAs(userBack) {
			Test.startTest();
			aCase.Usuario__c = userBack.Id;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess());
	}
	@isTest
	private static void ifAnUserWantsToDeleteTheResponsable_ShowErrorMsg() {
		Case aCase = new Case();
		aCase.Celula__c = 'Celula 1';
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.Usuario__c = medico.Id;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		insert aCase;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = aCase.Id, MemberId = userBack.Id, TeamRoleId = caseRole.Id);
		}
		Database.SaveResult result;
		System.runAs(userBack) {
			Test.startTest();
			aCase.Usuario__c = null;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(!result.isSuccess());
		System.assertEquals(
			'No tiene los permisos necesarios para modificar este campo', result.getErrors()[0].getMessage()
		);
	}
	@isTest
	private static void ifAnUserWantsToAssingHimselfAsResponsablePresupuesto_HeShouldBeAble() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.Celula__c = 'Celula 1';
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		insert aCase;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = aCase.Id, MemberId = userBack.Id, TeamRoleId = caseRole.Id);
		}
		Database.SaveResult result;
		System.runAs(userBack) {
			Test.startTest();
			aCase.Responsable_de_presupuesto__c = userBack.Id;
			result = Database.update(aCase);
			Test.stopTest();
		}
		System.assert(result.isSuccess());
	}
	@isTest
	private static void ifAnUserWantsToDeleteTheResponsablePresupuesto_ShowErrorMsg() {
		Case aCase = new Case();
		aCase.Celula__c = 'Celula 1';
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.Responsable_de_presupuesto__c = medico.Id;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		insert aCase;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = aCase.Id, MemberId = userBack.Id, TeamRoleId = caseRole.Id);
		}
		Database.SaveResult result;
		System.runAs(userBack) {
			Test.startTest();
			aCase.Responsable_de_presupuesto__c = null;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(!result.isSuccess());
		System.assertEquals('No tiene los permisos necesarios para modificar este campo', result.getErrors()[0].getMessage());
	}
	@isTest
	private static void ifAnUserWantsToAssignAnotherResponsable_ShowErrorMsg() {
		Case aCase = new Case();
		aCase.Celula__c = 'Celula 1';
		aCase.Nivel_de_derivacion__c = 'Nivel 3';
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new CaseTeamMember(ParentId = aCase.Id, MemberId = userBack.Id, TeamRoleId = caseRole.Id);
		}
		Database.SaveResult result;
		System.runAs(userBack) {
			Test.startTest();
			aCase.Usuario__c = medico.Id;
			result = Database.update(aCase, false);
			Test.stopTest();
		}
		System.assert(!result.isSuccess());
		System.assertEquals('No tiene los permisos necesarios para modificar este campo', result.getErrors()[0].getMessage());
	}
	@isTest
	private static void whenAllCasesHaveNotAlertsAMPending_uncheckTheAlertsPendingOnEM() {
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		Case aCase = new Case();
		aCase.Contiene_alerta_AM__c = true;
		aCase.Evento_Medico__c = em.Id;
		insert aCase;
		Test.startTest();
		aCase.Sin_alertas_AM_pendientes__c = true;
		update aCase;
		Test.stopTest();
		em = [SELECT Id, Alertas_AM_pendientes__c FROM Evento_medico__c WHERE Id = :em.Id];
		System.assert(!em.Alertas_AM_pendientes__c);
	}
	@isTest
	private static void whenACaseHaveAlertAMAndAndAnAlertIsPending_checkTheAlertsPendingOnEM() {
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		Case aCase = new Case();
		aCase.Contiene_alerta_AM__c = true;
		aCase.Sin_alertas_AM_pendientes__c = true;
		aCase.Evento_Medico__c = em.Id;
		insert aCase;
		Test.startTest();
		aCase.Sin_alertas_AM_pendientes__c = false;
		update aCase;
		Test.stopTest();
		em = [SELECT Id, Alertas_AM_pendientes__c FROM Evento_medico__c WHERE Id = :em.Id];
		System.assert(em.Alertas_AM_pendientes__c);
	}
	@isTest
	private static void whenOnCaseChangesContieneAlertasAMAndAHaveAlertsAMPending_checkTheAlertsPendingOnEM() {
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		Case aCase = new Case();
		aCase.Evento_Medico__c = em.Id;
		insert aCase;
		Test.startTest();
		aCase.Contiene_alerta_AM__c = true;
		update aCase;
		Test.stopTest();
		em = [SELECT Id, Alertas_AM_pendientes__c FROM Evento_medico__c WHERE Id = :em.Id];
		System.assert(em.Alertas_AM_pendientes__c);
	}
	@isTest
	private static void whenACaseAltaFamiliarChangeToTRANSFORMADAAndInfoIsIncompleteShouldChangeStatusToClosedWithPendingInfo () {
		Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('650098').build();
		insert delegacion;
		Account entidad = Build.anAccountEmpresa().build();
		entidad.CUIT__c = '30676863822';
		entidad.Codigo_de_empresa__c = '639506';
		insert entidad;
		Account cuenta = build.anAccount()
									.withAfiIddelTitular(182701)
									.withType('TIT')
									.withCodigodeAfiliado('70332/34')
									.withLastName('Testing182701')
									.build();
		cuenta.Estado__c = 'A';
		insert cuenta;
		Account obraSocial = Build.anAccountObrasocial().build();
		insert obraSocial;
		Date fechaNacimiento = Date.newInstance(1990, 05, 01);
		Date fechaVigencia = Date.newInstance(2020, 08, 01);
		Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
								.withDerivaAportes(true)
								.withAporte(5000)
								.withBebeSinDNI(true)
								.withInformacionCompleta(false)
								.withBebeNacidoEnElSistema(true)
								.withInformacionAlAsociado('info')
								.withCuit('20414624416')
								.withCuitEmpleador('20434624726')
								.withDiscapacidad(false)
								.withDNI('41462441')
								.withEstadoCivil('N')
								.withFechaDeNacimiento(fechaNacimiento)
								.withFechaDeVigencia(fechaVigencia)
								.withFirstName('Santiago')
								.withLastName('Test')
								.withNacionalidad('Argentina')
								.withSexo('Masculino')
								.withTipodedocumento('DNI')
								.withTipoDeParentesco('CO')
								.withObraSocial2(obraSocial.Id)
								.withEmpleador(entidad.Id)
								.withCuil('20414624416')
								.withAccountId(cuenta.Id)
								.withDelegacionId(delegacion.Id)
								.build();
		insert casoSolicitudAltaFamiliar;
		Test.startTest();
		casoSolicitudAltaFamiliar.Estado_de_solicitud__c = 'TRANSFORMADA';
		update casoSolicitudAltaFamiliar;
		Test.stopTest();
		System.assertEquals('Cerrado con documentacion pendiente', [SELECT Status FROM Case WHERE id = :casoSolicitudAltaFamiliar.Id LIMIT 1].Status, 'No se esta cambiando el estado');
	}
	@isTest
	private static void whenACaseAltaFamiliarToTRANSFORMADAAnd_BebeNacidoEnSistema_IsFalseShouldChangeStatusToClosed () {
		Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('650098').build();
		insert delegacion;
		Account entidad = Build.anAccountEmpresa().build();
		entidad.CUIT__c = '30676863822';
		entidad.Codigo_de_empresa__c = '639506';
		insert entidad;
		Account cuenta = build.anAccount()
									.withAfiIddelTitular(182701)
									.withType('TIT')
									.withCodigodeAfiliado('70332/34')
									.withLastName('Testing182701')
									.build();
		cuenta.Estado__c = 'A';
		insert cuenta;
		Account obraSocial = Build.anAccountObrasocial().build();
		insert obraSocial;
		Date fechaNacimiento = Date.newInstance(1990, 05, 01);
		Date fechaVigencia = Date.newInstance(2020, 08, 01);
		Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
								.withBebeNacidoEnElSistema(false)
								.withFechaDeNacimiento(fechaNacimiento)
								.withFechaDeVigencia(fechaVigencia)
								.withObraSocial2(obraSocial.Id)
								.withEmpleador(entidad.Id)
								.withAccountId(cuenta.Id)
								.withDelegacionId(delegacion.Id)
								.build();
		insert casoSolicitudAltaFamiliar;
		Test.startTest();
		casoSolicitudAltaFamiliar.Estado_de_solicitud__c = 'TRANSFORMADA';
		update casoSolicitudAltaFamiliar;
		Test.stopTest();
		System.assertEquals('Cerrado', [SELECT Status FROM Case WHERE id = :casoSolicitudAltaFamiliar.Id LIMIT 1].Status, 'No se esta cambiando el estado');
	}
	@isTest
	private static void whenACaseAltaFamiliarChangeToTRANSFORMADAAndInfoCompleteChangeToTrueShouldSubmitToService () {
		XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		String jsonResponse = '{' +
			'"error": false,' +
			'"data": {'+
			  '"resultado": "F"' +
			'},' +
			'"httpCode": 200,' +
			'"message": "Se procesó correctamente",' +
			'"meta": {' +
			  '"allowed_includes": [],' +
			  '"default_includes": []' +
			'}' +
		  '}';
		getResponseFound.buildResponse()
			.withStatusCode(200)
			.withStatus('OK')
			.withBody(jsonResponse)
			.addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/868663/proceso-archivos');
		Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('868663').build();
		insert delegacion;
		Account entidad = Build.anAccountEmpresa().build();
		entidad.CUIT__c = '30676863822';
		entidad.Codigo_de_empresa__c = '639506';
		insert entidad;
		Account cuenta = build.anAccount()
									.withAfiIddelTitular(182701)
									.withType('TIT')
									.withCodigodeAfiliado('70332/34')
									.withLastName('Testing182701')
									.build();
		cuenta.Estado__c = 'A';
		insert cuenta;
		Account obraSocial = Build.anAccountObrasocial().build();
		insert obraSocial;
		Date fechaNacimiento = Date.newInstance(1990, 05, 01);
		Date fechaVigencia = Date.newInstance(2020, 08, 01);
		Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
								.withDerivaAportes(true)
								.withAporte(5000)
								.withBebeSinDNI(true)
								.withInformacionCompleta(false)
								.withBebeNacidoEnElSistema(true)
								.withInformacionAlAsociado('info')
								.withEstadoDeSolicitud('TRANSFORMADA')
								.withNroDeSolicitudSS('868663')
								.withCuit('20414624416')
								.withCuitEmpleador('20434624726')
								.withDiscapacidad(false)
								.withDNI('41462441')
								.withEstadoCivil('N')
								.withFechaDeNacimiento(fechaNacimiento)
								.withFechaDeVigencia(fechaVigencia)
								.withFirstName('Santiago')
								.withLastName('Test')
								.withNacionalidad('Argentina')
								.withSexo('Masculino')
								.withTipodedocumento('DNI')
								.withTipoDeParentesco('CO')
								.withObraSocial2(obraSocial.Id)
								.withEmpleador(entidad.Id)
								.withCuil('20414624416')
								.withAccountId(cuenta.Id)
								.withDelegacionId(delegacion.Id)
								.build();
		insert casoSolicitudAltaFamiliar;
		Test.setMock(HttpCalloutMock.class, getResponseFound );
		Test.startTest();
		casoSolicitudAltaFamiliar.Informacion_completa__c = true;
		update casoSolicitudAltaFamiliar;
		Test.stopTest();
		Case caso = [SELECT Status, Informacion_completa__c FROM Case WHERE id = :casoSolicitudAltaFamiliar.Id LIMIT 1];
		System.assertEquals('Cerrado', caso.Status, 'No se esta cambiando el estado');
	}
	@isTest
	private static void whenACaseDespegueChangeToTRANSFORMADAShouldChangeStatusToClosed() {
		Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('650098').build();
		insert delegacion;
		Account entidad = Build.anAccountEmpresa().build();
		entidad.CUIT__c = '30676863822';
		entidad.Codigo_de_empresa__c = '639506';
		insert entidad;
		Account cuenta = build.anAccount()
									.withType('TIT')
									.withAfiIddelTitular(182701)
									.withCodigodeAfiliado('70332/34')
									.withLastName('Testing182701')
									.build();
		cuenta.Estado__c = 'A';
		insert cuenta;
		Account obraSocial = Build.anAccountObrasocial().build();
		insert obraSocial;
		Date fechaNacimiento = Date.newInstance(1990, 05, 01);
		Date fechaVigencia = Date.newInstance(2020, 08, 01);
		Case casoSolicitudDespeguesFT = Build.aCaseSolicituddedespegues()
				.withDerivaAportes(true)
				.withAporte(5000)
				.withBebeSinDNI(true)
				.withCuit('20414624416')
				.withCuitEmpleador('20434624726')
				.withDiscapacidad(false)
				.withDNI('41462441')
				.withEstadoCivil('N')
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withFirstName('Santiago')
				.withLastName('Test')
				.withNacionalidad('Argentina')
				.withSexo('Masculino')
				.withTipodedocumento('DNI')
				.withTipoDeParentesco('CO')
				.withTitular(cuenta.Id)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withCuil('20414624416')
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.withType('TF')
				.build();
		insert casoSolicitudDespeguesFT;
		Test.startTest();
		casoSolicitudDespeguesFT.Estado_de_solicitud__c = 'TRANSFORMADA';
		update casoSolicitudDespeguesFT;
		Test.stopTest();
		System.assertEquals('Cerrado', [SELECT Status FROM Case WHERE id = :casoSolicitudDespeguesFT.Id LIMIT 1].Status, 'No se esta cambiando el estado');
	}
	@isTest
	private static void whenACaseCambioPlanChangeToTRANSFORMADAShouldCloseCase() {
		Account delegacion = Build.anAccountDelegacion()
					.withCodigoDeDelegacion('650098')
					.build();
		Account cuenta = build.anAccount()
					.withAfiIddelTitular(182701)
					.withCodigodeAfiliado('70332/34')
					.withLastName('Testing182701')
					.withEstado('A')
					.build();
		insert cuenta;
		insert delegacion;
		Case casoCambioPlan = Build.aCaseSolicitudCambioPlan()
										.withPlanDespegue('AS300')
										.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
										.withAccountId(cuenta.Id)
										.withDelegacionId(delegacion.Id)
										.withNroDeSolicitudSS('868663')
										.withEstadoDeSolicitud('INCOMPLETA')
										.build();
		insert casoCambioPlan;
		Test.startTest();
		casoCambioPlan.Estado_de_solicitud__c = 'TRANSFORMADA';
		update casoCambioPlan;
		Test.stopTest();
		System.assertEquals('Cerrado', [SELECT Status FROM Case WHERE id = :casoCambioPlan.Id LIMIT 1].Status, 'No se esta cambiando el estado');
	}
	@isTest
	private static void whenACaseAltaFamiliarHasDuplicatedDNIAndBebeHasDNIShouldReturnError () {
		Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('868663').build();
		insert delegacion;
		Account entidad = Build.anAccountEmpresa().build();
		entidad.CUIT__c = '30676863822';
		entidad.Codigo_de_empresa__c = '639506';
		insert entidad;
		Account cuenta = build.anAccount()
									.withAfiIddelTitular(182701)
									.withType('TIT')
									.withCodigodeAfiliado('70332/34')
									.withLastName('Testing182701')
									.withNroDeDocumento('41462441')
									.build();
		cuenta.Estado__c = 'A';
		insert cuenta;
		Account obraSocial = Build.anAccountObrasocial().build();
		insert obraSocial;
		Date fechaNacimiento = Date.newInstance(1990, 05, 01);
		Date fechaVigencia = Date.newInstance(2020, 08, 01);
		Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
								.withDerivaAportes(true)
								.withAporte(5000)
								.withBebeSinDNI(false)
								.withInformacionCompleta(false)
								.withBebeNacidoEnElSistema(true)
								.withInformacionAlAsociado('info')
								.withEstadoDeSolicitud('TRANSFORMADA')
								.withNroDeSolicitudSS('868663')
								.withCuit('20414624416')
								.withCuitEmpleador('20434624726')
								.withDiscapacidad(false)
								.withDNI('41462441')
								.withEstadoCivil('N')
								.withFechaDeNacimiento(fechaNacimiento)
								.withFechaDeVigencia(fechaVigencia)
								.withFirstName('Santiago')
								.withLastName('Test')
								.withNacionalidad('Argentina')
								.withSexo('Masculino')
								.withTipodedocumento('DNI')
								.withTipoDeParentesco('CO')
								.withObraSocial2(obraSocial.Id)
								.withEmpleador(entidad.Id)
								.withCuil('20414624416')
								.withAccountId(cuenta.Id)
								.withDelegacionId(delegacion.Id)
								.build();
		casoSolicitudAltaFamiliar.Status = '';
		casoSolicitudAltaFamiliar.Estado_DDJJ__c = '';
		casoSolicitudAltaFamiliar.Estado_de_Solicitud__c = '';
		Test.startTest();
		Database.SaveResult res = Database.insert(casoSolicitudAltaFamiliar, false);
		Test.stopTest();
		System.assertEquals(false, res.isSuccess(), 'No esta validando el DNI repetido');
		System.assertEquals('El numero de DNI ya se encuentra registrado.', res.getErrors()[0].getMessage());
	}
	@isTest
	private static void whenACaseAltaFamiliarHasDuplicatedDNIAndBebeNotHasDNIShouldReturnNoError() {
		Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('868663').build();
		insert delegacion;
		Account entidad = Build.anAccountEmpresa().build();
		entidad.CUIT__c = '30676863822';
		entidad.Codigo_de_empresa__c = '639506';
		insert entidad;
		Account cuenta = build.anAccount()
									.withAfiIddelTitular(182701)
									.withType('TIT')
									.withCodigodeAfiliado('70332/34')
									.withLastName('Testing182701')
									.withNroDeDocumento('41462441')
									.build();
		cuenta.Estado__c = 'A';
		insert cuenta;
		Account obraSocial = Build.anAccountObrasocial().build();
		insert obraSocial;
		Date fechaNacimiento = Date.newInstance(1990, 05, 01);
		Date fechaVigencia = Date.newInstance(2020, 08, 01);
		Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
								.withDerivaAportes(true)
								.withAporte(5000)
								.withBebeSinDNI(true)
								.withInformacionCompleta(false)
								.withBebeNacidoEnElSistema(true)
								.withInformacionAlAsociado('info')
								.withEstadoDeSolicitud('TRANSFORMADA')
								.withNroDeSolicitudSS('868663')
								.withCuit('20414624416')
								.withCuitEmpleador('20434624726')
								.withDiscapacidad(false)
								.withDNI('41462441')
								.withEstadoCivil('N')
								.withFechaDeNacimiento(fechaNacimiento)
								.withFechaDeVigencia(fechaVigencia)
								.withFirstName('Santiago')
								.withLastName('Test')
								.withNacionalidad('Argentina')
								.withSexo('Masculino')
								.withTipodedocumento('DNI')
								.withTipoDeParentesco('CO')
								.withObraSocial2(obraSocial.Id)
								.withEmpleador(entidad.Id)
								.withCuil('20414624416')
								.withAccountId(cuenta.Id)
								.withDelegacionId(delegacion.Id)
								.build();
		Test.startTest();
		Database.SaveResult res = Database.insert(casoSolicitudAltaFamiliar, false);
		Test.stopTest();
		System.assertEquals(true, res.isSuccess(), 'No esta validando el DNI repetido');
	}
	@isTest
	private static void whenADoctorSolicitaDocumentacionAssignHimselfAsMedicoAsignadoInCase() {
		Group groupMesa = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Mesa_de_ayuda'];
		GroupMember groupMemberOfMesa = new GroupMember(groupId = groupMesa.Id, UserOrGroupId = medico.Id);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert groupMemberOfMesa;
		}
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.Contiene_alerta_AM__c = true;
		aCase.Nivel_de_derivacion__c = 'Nivel 2';
		insert aCase;
		System.runAs(medico) {
			Test.startTest();
			aCase.Informacion_de_documentacion_faltante__c = 'Test';
			aCase.Estado_de_documentacion__c = 'Solicitar documentacion';
			update aCase;
			Test.stopTest();
		}
		aCase = [SELECT Nivel_de_derivacion__c, Medico_asignado__c FROM Case WHERE Id = :aCase.Id];
		System.assertEquals('Nivel 1', aCase.Nivel_de_derivacion__c);
		System.assertEquals(medico.Id, aCase.Medico_asignado__c);
	}
	@isTest
	private static void whenChangeAFieldOnACaseWithRTSeguimientoUpdateTheFieldOnEM() {
		Account pres = Build.anAccountEfector().build();
		pres.Es_Prestador__c = true;
		pres.Es_Profesional__c = true;
		pres.Estado__c = 'A';
		insert pres;
		Consultorio__c consultorio = new Consultorio__c();
		consultorio.Efector_Prestador__c = pres.Id;
		consultorio.Estado__c = 'A';
		insert consultorio;
		Diagnostico__c diag = new Diagnostico__c();
		insert diag;
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		aCase.Evento_Medico__c = em.Id;
		insert aCase;
		aCase.Prestador__c = pres.Id;
		aCase.Prescriptor__c = pres.Id;
		aCase.Consultorio__c = consultorio.Id;
		aCase.Observaciones__c = 'test';
		aCase.Diagnostico__c = diag.Id;
		Test.startTest();
		update aCase;
		Test.stopTest();
		em = [
			SELECT Id, Prestador__c, Efector_Solicitante__c, Diagnostico__c, Observaciones__c,
					Consultorio__c, Responsable__c
			FROM Evento_medico__c
			WHERE Id = :em.Id
		];
		System.assertEquals(aCase.Prestador__c, em.Prestador__c);
		System.assertEquals(aCase.Prescriptor__c, em.Efector_Solicitante__c);
		System.assertEquals(aCase.Prescriptor__c, em.Responsable__c);
		System.assertEquals(aCase.Consultorio__c, em.Consultorio__c);
		System.assertEquals(aCase.Observaciones__c, em.Observaciones__c);
		System.assertEquals(aCase.Diagnostico__c, em.Diagnostico__c);
	}
	@isTest
	public static void whenTryToChangeOwnerOfAnCaseConsultaWithoutEquiposDeCasoShouldReturnError() {
		Case aCaseConsulta = Build.aCaseConsultas().withStatus('Pendiente').Build();
		insert aCaseConsulta;
		Group IDOM = [SELECT Id FROM Group WHERE Name = 'IDOM' and Type = 'Queue'];
		Test.startTest();
		aCaseConsulta.OwnerId = IDOM.id;
		Database.saveResult res = database.update(aCaseConsulta, false);
		Test.stopTest();
		System.assertEquals(false, res.isSuccess(), 'No genera errores');
	}
	@isTest
	public static void whenTryToChangeOwnerOfAnCaseReclamoWithoutEquiposDeCasoShouldReturnError() {
		Case aCaseReclamos = Build.aCaseReclamos().withStatus('Pendiente').Build();
		insert aCaseReclamos;
		Group IDOM = [SELECT Id FROM Group WHERE Name = 'IDOM' and Type = 'Queue'];
		Test.startTest();
		aCaseReclamos.OwnerId = IDOM.id;
		Database.saveResult res = database.update(aCaseReclamos, false);
		Test.stopTest();
		System.assertEquals(false, res.isSuccess(), 'No genera errores');
	}
	@isTest
	public static void whenTryToChangeOwnerOfAnCaseReclamoWithEquiposDeCasoShouldUpdateOwner() {
		Case aCaseReclamos = Build.aCaseReclamos()
									.withStatus('Pendiente').Build();
		insert aCaseReclamos;
		Group IDOM = [SELECT Id FROM Group WHERE Name = 'IDOM' and Type = 'Queue'];
		CaseTeamTemplate caseTeamTemplate = [SELECT id FROM CaseTeamTemplate LIMIT 1];
		CaseTeamTemplateRecord caseTeam = new CaseTeamTemplateRecord(ParentId = aCaseReclamos.Id, TeamTemplateId = caseTeamTemplate.Id);
		insert caseTeam;
		Test.startTest();
		aCaseReclamos.OwnerId = IDOM.id;
		Database.saveResult res = database.update(aCaseReclamos, false);
		Test.stopTest();
		System.assertEquals(true, res.isSuccess(), 'No deberia generar errores');
	}
	@isTest
	public static void whenTryToChangeOwnerOfAnCaseConsultaWithEquiposDeCasoShouldUpdateOwner() {
		Case aCaseConsulta = Build.aCaseConsultas()
									.withStatus('Pendiente')
									.Build();
		insert aCaseConsulta;
		Group IDOM = [SELECT Id FROM Group WHERE Name = 'IDOM' and Type = 'Queue'];
		CaseTeamTemplate caseTeamTemplate = [SELECT id FROM CaseTeamTemplate LIMIT 1];
		CaseTeamTemplateRecord caseTeam = new CaseTeamTemplateRecord(ParentId = aCaseConsulta.Id, TeamTemplateId = caseTeamTemplate.Id);
		insert caseTeam;
		Test.startTest();
		aCaseConsulta.OwnerId = IDOM.id;
		Database.saveResult res = database.update(aCaseConsulta, false);
		Test.stopTest();
		System.assertEquals(true, res.isSuccess(), JSON.serialize(res.getErrors()));
	}
	@isTest
	public static void whenARejectedCaseIsUndone_reopenTheSLA() {
		Case[] cases = new List<Case>();
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		for(Integer i = 0; i < 2; i++) {
			Case aCase = new Case();
			aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
			aCase.Type = 'Prestacion';
			aCase.Tiempo_SLA__c = '24';
			aCase.AccountId = acc.Id;
			cases.add(aCase);
		}
		insert cases;
		for(Case aCase : cases) {
			aCase.Status = 'Rechazado';
			aCase.Caso_Rechazado__c = true;
		}
		update cases;
		Test.startTest();
		cases[1].Status = 'CA-----G';
		cases[1].Caso_Rechazado__c = false;
		update cases[1];
		Test.stopTest();
		Case caseSlaClosed = [
			SELECT Id, SLAcerrado__c,
				(SELECT Id, IsCompleted FROM CaseMilestones)
			FROM Case
			WHERE Id = :cases[0].Id
		];
		Case caseSlaReopen = [
			SELECT Id, SLAcerrado__c,
				(SELECT Id, IsCompleted FROM CaseMilestones)
			FROM Case
			WHERE Id = :cases[1].Id
		];
		System.assert(caseSlaClosed.CaseMilestones[0].IsCompleted);
		System.assert(caseSlaClosed.SLAcerrado__c);
		System.assert(!caseSlaReopen.CaseMilestones[0].IsCompleted);
		System.assert(!caseSlaReopen.SLAcerrado__c);
	}
	@IsTest
	static void assignDelegacionFromUserWhenOwnerIsCDC() {
		Account delegacion = new Account();
		delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacion.Name = 'Test';
		delegacion.Codigo_de_delegacion__c = '650078';
		insert  delegacion;
		Group[] cdc = [SELECT id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'CDC'];
		if(cdc.isEmpty()) {
			return;
		}
		Case aCase = new Case();
		aCase.OwnerId = cdc[0].Id;
		Test.startTest();
		insert aCase;
		Test.stopTest();
		List<Case> casosToAssert = [SELECT Delegacion__c,
										Delegacion__r.Codigo_de_delegacion__c
									FROM Case WHERE Id = :aCase.Id];
		for(Case casoToAssert : casosToAssert) {
			System.assertEquals(delegacion.Id, casoToAssert.Delegacion__c, 'El id de la delegación debe ser la de CDC');
			System.assertEquals('650078', casoToAssert.Delegacion__r.Codigo_de_delegacion__c, 'El número de la delegación debe ser 650078');
		}
	}
	@IsTest
	static void avoidCreationOfReintegroWithALoteThatIsClosed() {
		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		Lote__c lote = new Lote__c();
		lote.Estado__c = 'C';
		insert lote;
		Test.startTest();
		reintegro.Lote__c = lote.Id;
		Database.SaveResult result = Database.insert(reintegro, false);
		Test.stopTest();
		System.assert(!result.isSuccess());
		for(Database.Error err : result.getErrors()) {
			System.assertEquals(err.getMessage(), 'No puede asignar un Lote cerrado a un Reintegro');
		}
	}
	@isTest
	public static void ifTheCaseIsIFPagodeReintegroMustFillAtLeastOneFieldInMedioDePagoSectionOtherwiseMustShowError(){
		Case interfaz = new Case();
		interfaz.RecordTypeId = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
		interfaz.Type = 'T';
		interfaz.CUIT_CUIL_Titular_CBU__c = null;
		interfaz.Numero_CBU__c = null;
		Test.startTest();
		Database.saveResult result = Database.insert(interfaz,false);
		Test.stopTest();
		System.assert(!result.isSuccess());
		for(Database.Error err : result.getErrors()){
			System.assertEquals('Para IF Pago de reintegros, es obligatorio completar todos los campos de la sección &quot;Medio de pago&quot; y no puede completar los campos de &quot;Medio de cobro&quot;',err.getMessage());
		}
	}
	@isTest
	public static void ifTheCaseIsIFPagodeReintegroAndTheUserFillsAtLeastOneFieldInMedioDePagoSectionTheInsertMustSuccess(){
		Case interfaz = new Case();
		interfaz.RecordTypeId = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
		interfaz.Type = 'T';
		interfaz.CUIT_CUIL_Titular_CBU__c = '20401444263';
		interfaz.Numero_CBU__c = '2345620212300212312';
		Test.startTest();
		Database.saveResult result = Database.insert(interfaz,false);
		Test.stopTest();
		System.assert(result.isSuccess());
	}
	@isTest
	public static void ifTheCaseIsIFPagodeReintegroAndTheUserFillsBothFieldInMedioDePagoSectionTheInsertMustSuccess(){
		Case interfaz = new Case();
		interfaz.RecordTypeId = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
		interfaz.Type = 'T';
		interfaz.CUIT_CUIL_Titular_CBU__c = '20123456789';
		interfaz.Numero_CBU__c = '2345620212300212312';
		Test.startTest();
		Database.saveResult result = Database.insert(interfaz,false);
		Test.stopTest();
		System.assert(result.isSuccess());
	}
	@isTest
	public static void ifTheCaseIsIFFacturacionMustFillAtLeastOneFieldInMedioDeCobroSectionOtherwiseMustShowError(){
		Case interfaz = new Case();
		interfaz.RecordTypeId = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
		interfaz.Type = 'C';
		interfaz.CUIT__c = null;
		interfaz.Condicion_IVA__c = null;
		interfaz.Tarjeta_de_credito__c = null;
		interfaz.Numero_de_tarjeta_de_credito__c = null;
		interfaz.Tipo_de_debito_por_ACA__c = null;
		interfaz.Cdigo_debito_por_ACA__c = null;
		interfaz.CBU__c = null;
		interfaz.CUIL_del_CBU__c = null;
		interfaz.Borrar_tarjeta_debito_o_cobro_por_CBU__c = false;
		Test.startTest();
		Database.saveResult result = Database.insert(interfaz,false);
		Test.stopTest();
		System.assert(!result.isSuccess());
		for(Database.Error err : result.getErrors()){
			System.assertEquals('Para el caso &quot;IF Facturación&quot;, no se permitirá completar los campos &quot;Medios de pago&quot;, se debera completar al menos un campo de &quot;Medios de cobro&quot;.',err.getMessage());
		}
	}
	@isTest
	public static void ifTheCaseIsIFFacturacionAndTheUsertFillsAtLeastOneFieldInMedioDeCobroSectionMustSuccess(){
		Case interfaz = new Case();
		interfaz.RecordTypeId = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
		interfaz.Type = 'C';
		interfaz.CUIT__c = '20123456789';
		interfaz.Condicion_IVA__c = null;
		interfaz.Condicion_IVA__c = null;
		interfaz.Tarjeta_de_credito__c = null;
		interfaz.Numero_de_tarjeta_de_credito__c = null;
		interfaz.Tipo_de_debito_por_ACA__c = null;
		interfaz.Cdigo_debito_por_ACA__c = null;
		interfaz.CBU__c = null;
		interfaz.CUIL_del_CBU__c = null;
		interfaz.Borrar_tarjeta_debito_o_cobro_por_CBU__c = false;
		Test.startTest();
		Database.saveResult result = Database.insert(interfaz,false);
		Test.stopTest();
		System.assert(result.isSuccess());
	}
	@isTest
	public static void ifTheCaseIsIFFacturacionAndTheUserDontFillAnyMedioDeCobroFieldButTheCheckboxBorrarTarjetaIsTrueShouldCreate(){
		Case interfaz = new Case();
		interfaz.RecordTypeId = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
		interfaz.Type = 'C';
		interfaz.CUIT__c = null;
		interfaz.Condicion_IVA__c = null;
		interfaz.Condicion_IVA__c = null;
		interfaz.Tarjeta_de_credito__c = null;
		interfaz.Numero_de_tarjeta_de_credito__c = null;
		interfaz.Tipo_de_debito_por_ACA__c = null;
		interfaz.Cdigo_debito_por_ACA__c = null;
		interfaz.CBU__c = null;
		interfaz.CUIL_del_CBU__c = null;
		interfaz.Borrar_tarjeta_debito_o_cobro_por_CBU__c = true;
		Test.startTest();
		Database.saveResult result = Database.insert(interfaz,false);
		Test.stopTest();
		System.assert(result.isSuccess());
	}
	@isTest
	public static void ifACaseChangeTheRecordTypeFromCasoATipificarToAnotherOneShouldThePicklistEstadoUpdate(){
		Case casoATipificar = new Case();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
		insert casoATipificar;
		Test.startTest();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case','Reintegro').Id;
		update casoATipificar;
		Test.stopTest();
		Case casoUpdated = [SELECT Id,Status FROM Case WHERE Id = :casoATipificar.Id LIMIT 1];
		System.assertEquals('CA-----G',casoUpdated.Status);
	}
	@isTest
	public static void ifACaseChangeTheRecordTypeFromCasoATipificarToAnotherWichDoesntNeedChangeShouldtChange(){
		Case casoATipificar = new Case();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
		insert casoATipificar;
		Test.startTest();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case','Solicitud_de_segmento').Id;
		update casoATipificar;
		Test.stopTest();
		Case casoUpdated = [SELECT Id,Status FROM Case WHERE Id = :casoATipificar.Id LIMIT 1];
		System.assertEquals('Pendiente',casoUpdated.Status);
	}
	@isTest
	public static void ifACaseChangeTheRecordTypeFromCasoATipificarToSolicitudDeDespegueShowBlankTheDatosGeograficosSectionWhenItIsFF(){
		Account cuenta = new Account();
		cuenta.Name = 'testcuetna';
		cuenta.Type = 'T';
		insert cuenta;
		Case casoATipificar = new Case();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
		insert casoATipificar;
		Test.startTest();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case','Solicitud_de_despegues').Id;
		casoATipificar.Estado_civil__c = 'S';
		casoATipificar.Titular__c = cuenta.Id;
		casoATipificar.Tipo_de_Parentesco__c = 'HI';
		casoATipificar.Type = 'FF';
		update casoATipificar;
		Test.stopTest();
		Case casoUpdated = [SELECT Id,Status FROM Case WHERE Id = :casoATipificar.Id LIMIT 1];
		System.assertEquals('EN PROCESO',casoUpdated.Status.toUpperCase());
	}
	@isTest
	public static void ifACaseChangeTheRecordTypeFromCasoATipificarToSolicitudDeAltaFamiliarShouldWork(){
		Account cuenta = new Account();
		cuenta.Name = 'testcuetna';
		cuenta.Type = 'T';
		insert cuenta;
		Case casoATipificar = new Case();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
		insert casoATipificar;
		Test.startTest();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case','Solicitud_de_alta_familiar').Id;
		update casoATipificar;
		Test.stopTest();
		Case casoUpdated = [SELECT Id,Status FROM Case WHERE Id = :casoATipificar.Id LIMIT 1];
		System.assertEquals('EN PROCESO',casoUpdated.Status.toUpperCase());
	}
	@isTest
	public static void ifTheOwnerOfTheCaseIsCDCShouldAssignTheDelegacionOfTheAccountRelatedTo(){
		Profile pCDC = [SELECT Id FROM Profile WHERE Name='CDC'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		String uniqueUserName = 'standardusercasetriggertest' + DateTime.now().getTime() + '@testorg.com';
		Account delegacion = new Account();
		delegacion.Type = 'Filial';
		delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacion.Name = 'Test';
		delegacion.Codigo_de_delegacion__c = '661089';
		insert  delegacion;
		User userCDC = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'CDC', ProfileId = pCDC.Id, UserRole = role
		);
		insert userCDC;
		Account cuenta = new Account();
		cuenta.Delegacion__c = delegacion.Id;
		cuenta.Name = 'testcuetna';
		cuenta.Type = 'T';
		insert cuenta;
		Case casoATipificar = new Case();
		casoATipificar.AccountId = cuenta.Id;
		casoATipificar.OwnerId = userCDC.Id;
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
		insert casoATipificar;
		Test.startTest();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case','Solicitud_de_despegues').Id;
		casoATipificar.Estado_civil__c = 'S';
		casoATipificar.Titular__c = cuenta.Id;
		casoATipificar.Tipo_de_Parentesco__c = 'HI';
		casoATipificar.Type = 'FF';
		update casoATipificar;
		Test.stopTest();
		Case casoUpdated = [SELECT Id,Status,Delegacion__c FROM Case WHERE Id = :casoATipificar.Id LIMIT 1];
		System.assertEquals(delegacion.Id,casoUpdated.Delegacion__c);
		System.assertEquals('EN PROCESO',casoUpdated.Status.toUpperCase());
	}
	@isTest
	public static void ifTheOwnerOfTheCaseIsCDCQueueShouldAssignTheDelegacionOfTheAccountRelatedTo(){
		Account delegacionCDC = new Account();
		delegacionCDC.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacionCDC.Name = 'Test';
		delegacionCDC.Codigo_de_delegacion__c = '650078';
		insert  delegacionCDC;
		Group colaCDC = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'CDC'];
		String uniqueUserName = 'standardusercasetriggertest' + DateTime.now().getTime() + '@testorg.com';
		Account delegacion = new Account();
		delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacion.Type = 'Filial';
		delegacion.Name = 'Test';
		delegacion.Codigo_de_delegacion__c = '661089';
		insert  delegacion;
		Account cuenta = new Account();
		cuenta.Delegacion__c = delegacion.Id;
		cuenta.Name = 'testcuetna';
		cuenta.Type = 'T';
		insert cuenta;
		Case casoATipificar = new Case();
		casoATipificar.AccountId = cuenta.Id;
		casoATipificar.OwnerId = colaCDC.Id;
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
		insert casoATipificar;
		Test.startTest();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case','Solicitud_de_despegues').Id;
		casoATipificar.Estado_civil__c = 'S';
		casoATipificar.Titular__c = cuenta.Id;
		casoATipificar.Tipo_de_Parentesco__c = 'HI';
		casoATipificar.Type = 'FF';
		update casoATipificar;
		Test.stopTest();
		Case casoUpdated = [SELECT Id,Status,Delegacion__c FROM Case WHERE Id = :casoATipificar.Id LIMIT 1];
		System.assertEquals(delegacion.Id,casoUpdated.Delegacion__c);
		System.assertEquals('EN PROCESO',casoUpdated.Status.toUpperCase());
	}
	@isTest
	public static void ifTheOwnerOfTheCaseIsCDCQueueAndDelegacionIsAgenciaShouldAssignTheDelegacion2OfTheAccountRelatedTo(){
		Account delegacion2CDC = new Account();
		delegacion2CDC.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacion2CDC.Type = 'Filial';
		delegacion2CDC.Name = 'Test Dos';
		delegacion2CDC.Codigo_de_delegacion__c = '650079';
		insert  delegacion2CDC;
		Account delegacionCDC = new Account();
		delegacionCDC.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacionCDC.Type = 'Agencia';
		delegacionCDC.Name = 'Test';
		delegacionCDC.Codigo_de_delegacion__c = '650078';
		delegacionCDC.Delegacion2__c = delegacion2CDC.Id;
		insert  delegacionCDC;
		Group colaCDC = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'CDC'];
		String uniqueUserName = 'standardusercasetriggertest' + DateTime.now().getTime() + '@testorg.com';
		Account cuenta = new Account();
		cuenta.Delegacion__c = delegacionCDC.Id;
		cuenta.Name = 'testcuetna';
		cuenta.Type = 'T';
		insert cuenta;
		Case casoATipificar = new Case();
		casoATipificar.AccountId = cuenta.Id;
		casoATipificar.OwnerId = colaCDC.Id;
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
		insert casoATipificar;
		Test.startTest();
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case','Solicitud_de_despegues').Id;
		casoATipificar.Estado_civil__c = 'S';
		casoATipificar.Titular__c = cuenta.Id;
		casoATipificar.Tipo_de_Parentesco__c = 'HI';
		casoATipificar.Type = 'FF';
		update casoATipificar;
		Test.stopTest();
		Case casoUpdated = [SELECT Id,Status,Delegacion__c FROM Case WHERE Id = :casoATipificar.Id LIMIT 1];
		System.assertEquals(delegacion2CDC.Id,casoUpdated.Delegacion__c);
		System.assertEquals('EN PROCESO',casoUpdated.Status.toUpperCase());
	}
	@isTest
	public static void ifTheOwnerOfTheCaseIsFrontQueueShouldAssignTheDelegacionOfTheAccountRelatedTo(){
		Group colaFront = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Front'];
		Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		String uniqueUserName = 'standardusercasetriggertest' + DateTime.now().getTime() + '@testorg.com';
		Account delegacion = new Account();
		delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacion.Name = 'Test';
		delegacion.Codigo_de_delegacion__c = '661089';
		delegacion.Correo_electronico__c = 'test@xyz.org';
		insert  delegacion;
		User userFront = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'Front', ProfileId = pFront.Id, UserRole = role
		);
		insert userFront;
		Account cuenta = new Account();
		cuenta.Delegacion__c = delegacion.Id;
		cuenta.Name = 'testcuetna';
		cuenta.Type = 'T';
		insert cuenta;
		Case casoATipificar = new Case();
		casoATipificar.AccountId = cuenta.Id;
		casoATipificar.OwnerId = colaFront.Id;
		casoATipificar.RecordTypeId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
		Test.startTest();
		EmailMessage email = new EmailMessage();
		email.FromAddress = 'test@abc.org';
		email.Incoming = True;
		email.ToAddress= 'test@xyz.org';
		email.Subject = 'Test email';
		email.HtmlBody = 'Test email body';
		email.ParentId = casoATipificar.Id;
		insert email;
		insert casoATipificar;
		Test.stopTest();
		Case casoUpdated = [SELECT Id,Status,Delegacion__c,Usuario__c FROM Case WHERE Id = :casoATipificar.Id LIMIT 1];
		System.assertEquals(null,casoUpdated.Usuario__c);
		System.assertEquals('PENDIENTE',casoUpdated.Status.toUpperCase());
	}
	@isTest
	public static void ifACaseIsTypeMedicamentoAndStatusIsNotGeneradaShowErrorWhenChangesUrgenteField(){
		Case caso = new case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case','Reintegro').Id;
		caso.Type = 'Medicamento';
		caso.Urgente__c = 'S';
		insert caso;
		caso.Status = 'Autorizada';
		update caso;
		caso.Urgente__c = 'N';
		Test.startTest();
		Database.saveResult result = Database.update(caso,false);
		Test.stopTest();
		System.assert(!result.isSuccess());
		for(Database.Error err : result.getErrors()){
			System.assertEquals(err.getMessage(),'La urgencia de un caso de tipo medicamento sólo podrá ser cambiada cuando el caso este en estado Generado');
		}
	}
	@isTest
	public static void ifACaseIsTypeMedicamentoAndStatusIsGeneradaDoesntShowErrorWhenChangesUrgenteField(){
		Case caso = new case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case','Reintegro').Id;
		caso.Type = 'Medicamento';
		caso.Urgente__c = 'S';
		insert caso;
		caso.Urgente__c = 'N';
		Test.startTest();
		Database.saveResult result = Database.update(caso,false);
		Test.stopTest();
		System.assert(result.isSuccess());
	}
}