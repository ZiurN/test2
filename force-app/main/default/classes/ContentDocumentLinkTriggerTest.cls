@isTest
private class ContentDocumentLinkTriggerTest {
	private static XHttpCalloutMock serverMock;
	private static String duplicateMessage = System.Label.Alerta_YaExisteArchivoMismoNombre;
	static User salesUser;
	static {
		serverMock = new XHttpCalloutMock();
		serverMock.buildResponse()
				.withBody('some body');
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile pSales = [SELECT Id FROM Profile WHERE Name='Agente de ventas'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Comercial AMBA'];
		salesUser = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'sales', ProfileId = pSales.Id, UserRoleId = role.Id);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert salesUser;
		}
	}
	@isTest
	private static void avoidInsertTwoFilesWhithTheSameNameInCase() {
		Case caso = new Case();
		insert caso;
		ContentVersion cv = new ContentVersion();
		cv.Title = 'AvoidDuplicateTest';
		cv.VersionData = Blob.valueOf('AvoidDuplicateTest');
		cv.PathOnClient = '/AvoidDuplicateTest';
		insert cv;
		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
		ContentDocumentLink link = new ContentDocumentLink();
		link.ContentDocumentId = cv.ContentDocumentId;
		link.LinkedEntityId = caso.Id;
		insert link;
		ContentVersion cvDuplicate = new ContentVersion();
		cvDuplicate.Title = 'AvoidDuplicateTest';
		cvDuplicate.VersionData = Blob.valueOf('AvoidDuplicateTest');
		cvDuplicate.PathOnClient = '/AvoidDuplicateTest(1)';
		insert cvDuplicate;
		cvDuplicate = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cvDuplicate.Id];
		ContentDocumentLink linkDuplicate = new ContentDocumentLink();
		linkDuplicate.ContentDocumentId = cvDuplicate.ContentDocumentId;
		linkDuplicate.LinkedEntityId = caso.Id;
		Test.startTest();
		Database.SaveResult result = Database.insert(linkDuplicate, false);
		Test.stopTest();
		System.assert(!result.isSuccess(), 'Debe ocurrir un error al tratar de guardar el cdLink');
		System.assertEquals(duplicateMessage, result.getErrors()[0].getMessage(), 'El mensaje debe indicar que ya existe otro archivo');
	}
	@isTest
	private static void avoidInsertTwoFilesWhithTheSameNameInEM() {
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		ContentVersion cv = new ContentVersion();
		cv.Title = 'AvoidDuplicateTestEM';
		cv.VersionData = Blob.valueOf('AvoidDuplicateTestEM');
		cv.PathOnClient = '/AvoidDuplicateTestEM';
		insert cv;
		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
		ContentDocumentLink link = new ContentDocumentLink();
		link.ContentDocumentId = cv.ContentDocumentId;
		link.LinkedEntityId = em.Id;
		insert link;
		ContentVersion cvDuplicate = new ContentVersion();
		cvDuplicate.Title = 'AvoidDuplicateTestEM';
		cvDuplicate.VersionData = Blob.valueOf('AvoidDuplicateTestEM');
		cvDuplicate.PathOnClient = '/AvoidDuplicateTestEM(1)';
		insert cvDuplicate;
		cvDuplicate = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cvDuplicate.Id];
		ContentDocumentLink linkDuplicate = new ContentDocumentLink();
		linkDuplicate.ContentDocumentId = cvDuplicate.ContentDocumentId;
		linkDuplicate.LinkedEntityId = em.Id;
		Test.startTest();
		Database.SaveResult result = Database.insert(linkDuplicate, false);
		Test.stopTest();
		System.assert(!result.isSuccess(), 'Debe ocurrir un error al tratar de guardar el cdLink');
		System.assertEquals(duplicateMessage, result.getErrors()[0].getMessage(), 'El mensaje debe indicar que ya existe otro archivo');
	}
	@isTest
	private static void avoidInsertTwoFilesWhithTheSameNameInOpportunity() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
		insert opp;
		ContentVersion cv = new ContentVersion();
		cv.Title = 'AvoidDuplicateTestOpp';
		cv.VersionData = Blob.valueOf('AvoidDuplicateTestOpp');
		cv.PathOnClient = '/AvoidDuplicateTestOpp';
		insert cv;
		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
		ContentDocumentLink link = new ContentDocumentLink();
		link.ContentDocumentId = cv.ContentDocumentId;
		link.LinkedEntityId = opp.Id;
		insert link;
		ContentVersion cvDuplicate = new ContentVersion();
		cvDuplicate.Title = 'AvoidDuplicateTestOpp';
		cvDuplicate.VersionData = Blob.valueOf('AvoidDuplicateTestOpp');
		cvDuplicate.PathOnClient = '/AvoidDuplicateTestOpp(2)';
		insert cvDuplicate;
		cvDuplicate = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cvDuplicate.Id];
		ContentDocumentLink linkDuplicate = new ContentDocumentLink();
		linkDuplicate.ContentDocumentId = cvDuplicate.ContentDocumentId;
		linkDuplicate.LinkedEntityId = opp.Id;
		Test.startTest();
		Database.SaveResult result = Database.insert(linkDuplicate, false);
		Test.stopTest();
		System.assert(!result.isSuccess(), 'Debe ocurrir un error al tratar de guardar el cdLink');
		System.assertEquals(duplicateMessage, result.getErrors()[0].getMessage(), 'El mensaje debe indicar que ya existe otro archivo');
	}
	@isTest(SeeAllData=true)
	private static void avoidInsertFilesLargerThan3Mb() {
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		ContentDocumentLink cdl = new ContentDocumentLink();
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE ContentSize > 3145728 LIMIT 1];
		if(documents.isEmpty()) {
			return;
		}
		for (ContentDocument contentDocument: documents){
			cdl.LinkedEntityId = em.id;
			cdl.ContentDocumentId = contentDocument.Id;
			cdl.shareType = 'V';
		}
		Test.startTest();
		Database.SaveResult result = Database.insert(cdl, false);
		Test.stopTest();
		System.assert(!result.isSuccess(), 'Debe ocurrir un error al tratar de guardar el cdLink');
		System.assertEquals(System.Label.Alerta_ArchivoMayor3MB, result.getErrors()[0].getMessage(), 'El mensaje debe indicar que el archivo es muy grande');
	}
	@isTest(SeeAllData=true)
	private static void ifEmail_to_Case_AllowInsertFilesLargerThan3Mb() {
		Case emailToCaseCase = Build.aCaseFromEmail().build();
		insert emailToCaseCase;
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE ContentSize > 3145728 LIMIT 1];
		System.assertEquals(1, documents.size(), 'Debe haber un archivo de más de 3Mb');
		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.LinkedEntityId = emailToCaseCase.id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		List<User> platIntUsers = [SELECT Id FROM User WHERE isActive = true AND UserName LIKE 'automatedcase%'];
		System.assertEquals(1, platIntUsers.size(), 'Debe haber un usuario para los casos Email-to-Case');
		Database.SaveResult result;
		System.runAs (platIntUsers[0]) {
			Test.startTest();
			result = Database.insert(cdl, false);
			Test.stopTest();
		}
		System.assert(result.isSuccess(), 'No debio ocurrir nada al tratar de guardar el cdLink');
		List<ContentDocumentLink> cDLinks = [SELECT LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId =: documents[0].Id];
		System.debug(JSON.serializePretty(cDLinks));
		// Ya existen tres CDLinks apra este ContentDocument.
		System.assertEquals(4, cDLinks.size(), 'Debe haber cuatro CDLink');
	}
	@isTest
	private static void avoidDeleteAFileAlreadySendedToSS() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.OwnerId = salesUser.Id;
		insert opp;
		Database.DeleteResult result;
		System.runAs(salesUser) {
			ContentVersion cv = new ContentVersion();
			cv.Title = 'AvoidDeleteTest';
			cv.VersionData = Blob.valueOf('AvoidDeleteTest');
			cv.PathOnClient = '/AvoidDeleteTest';
			cv.Enviado__c = true;
			insert cv;
			cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
			ContentDocumentLink link = new ContentDocumentLink();
			link.ContentDocumentId = cv.ContentDocumentId;
			link.LinkedEntityId = opp.Id;
			insert link;
			Test.startTest();
			result = Database.delete(link, false);
			Test.stopTest();
		}
		System.debug(result);
		System.assert(!result.isSuccess(), 'Debe ocurrir un error al tratar de guardar el cdLink');
		System.assertEquals(System.Label.Alerta_ArchivoDeOportunidad, result.getErrors()[0].getMessage() , 'El errro debe indicar que el archivo es de oportundades');
	}
	@isTest
	private static void avoidDeleteAFileAlreadySendedToSSInSalesCases () {
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile perfil = [SELECT Id FROM Profile WHERE Name='Front'];
		User front = new User(Alias = 'standt', Email='standarduser@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', ProfileId = perfil.Id, TimeZoneSidKey='America/Los_Angeles',
			UserName=uniqueUserName);
		Case aCase = Build.aCaseSolicitudDatosParticulares().build();
		aCase.Nro_de_solicitud_SS__c = '123456';
		insert aCase;
		Database.DeleteResult result;
		System.runAs(front) {
			ContentVersion cv = new ContentVersion();
			cv.Title = 'AvoidDeleteTestCase';
			cv.VersionData = Blob.valueOf('AvoidDeleteTestCase');
			cv.PathOnClient = '/AvoidDeleteTestCase';
			cv.Enviado__c = true;
			insert cv;
			cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
			ContentDocumentLink link = new ContentDocumentLink();
			link.ContentDocumentId = cv.ContentDocumentId;
			link.LinkedEntityId = aCase.Id;
			insert link;
			Test.startTest();
			result = Database.delete(link, false);
			Test.stopTest();
			System.assert(!result.isSuccess(), 'Debe ocurrir un error al tratar de guardar el cdLink');
			System.assertEquals(System.Label.Alerta_ArchivoEnviadoASS,result.getErrors()[0].getMessage(), 'El error debe indicar que el archivo ya fue enviado a SS');
		}
	}
	@isTest
	private static void ifEmailToCase_ChangeContentDocOwnerAndContentDocLinkParent () {
		Integer numberOfCases = [SELECT count () FROM Case];
		System.assertEquals(0, numberOfCases, 'No deben haber casos');
		List<User> platIntUsers = [SELECT Id FROM User WHERE isActive = true AND UserName LIKE 'automatedcase%'];
		System.assertEquals(1, platIntUsers.size(), 'Debe haber un usuario para los casos Email-to-Case');
		Case emailToCaseCase = Build.aCaseFromEmail().build();
		ContentVersion cv;
		ContentDocumentLink cDLink;
		Group fromQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'CDC'];
		Account delegacion = new Account();
		delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacion.Name = 'Test';
		delegacion.Codigo_de_delegacion__c = '650078';
		insert  delegacion;
		System.runAs (platIntUsers[0]) {
			insert emailToCaseCase;
			emailToCaseCase.OwnerId = fromQueue.Id;
			update emailToCaseCase;
			EmailMessage email = new EmailMessage();
			email.ToAddress = 'test@example.com';
			email.ParentId = emailToCaseCase.Id;
			email.TextBody = 'Test message';
			insert email;
			cv = new ContentVersion();
			cv.Title = 'Email-to-Case File';
			cv.VersionData = Blob.valueOf('Email-to-Case File');
			cv.PathOnClient = '/EmailToCaseFile';
			cv.FirstPublishLocationId = platIntUsers[0].Id;
			cv.ContentLocation = 'S';
			cv.Enviado__c = false;
			insert cv;
			cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
			cDLink = new ContentDocumentLink();
			cDLink.ContentDocumentId = cv.ContentDocumentId;
			cDLink.LinkedEntityId = email.Id;
			Test.startTest();
			insert cDLink;
			Test.stopTest();
		}
		emailToCaseCase = [SELECT OwnerId FROM Case WHERE id =: emailToCaseCase.Id];
		System.assertEquals(fromQueue.Id, emailToCaseCase.OwnerId, 'El dueño del caso debe ser el usuario');
		cv = [SELECT ContentDocumentId, OwnerId, ContentDocument.ParentId FROM ContentVersion WHERE Id = :cv.Id];
		String libraryId = [SELECT Id FROM ContentWorkspace WHERE DeveloperName = 'Front_PG_Library'].Id;
		System.assertEquals(libraryId, cv.ContentDocument.ParentId, 'El parent Id del CV debe ser la libreria de la cola');
		List<ContentDocumentLink> cDLinks = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId =: cv.ContentDocumentId];
		System.assertEquals(3, cDLinks.size(), 'Debe haber tres CDLink');
		for (ContentDocumentLink cDL: cDLinks) {
			String sObjectType = cDL.LinkedEntityId.getSObjectType().getDescribe().getName();
			if (sObjectType == 'Case') {
				System.assertEquals(emailToCaseCase.Id, cDL.LinkedEntityId, 'Un CDLink debe ser estar asociado al caso');
			} else if (sObjectType == 'User') {
				System.assertEquals(platIntUsers[0].Id, cDL.LinkedEntityId, 'Un CDLink debe estar asociado al usuario de integración');
			} else {
				System.assertEquals('ContentWorkspace', sObjectType, 'Un CDLink debe estar asociado a la libreria');
				System.assertEquals(libraryId, cDL.LinkedEntityId, 'Un CDLink debe estar asociado a la libreria');
			}
		}
	}
	@isTest
	private static void ifNotEmailToCase_DoNothing () {
		Integer numberOfCases = [SELECT count () FROM Case];
		System.assertEquals(0, numberOfCases, 'No deben haber casos');
		Account testAccount = Build.anAccountCuentapersonal().build();
		insert testAccount;
		Case emailToCaseCase;
		ContentVersion cv;
		ContentDocumentLink cDLink;
		Group fromQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Front'];
		List<GroupMember> fromUsers = [SELECT UserOrGroupId From GroupMember where GroupId =: fromQueue.Id];
		System.runAs (new User(Id = fromUsers[0].UserOrGroupId)) {
			emailToCaseCase = Build.aCaseAP().build();
			emailToCaseCase.AccountId = testAccount.Id;
			insert emailToCaseCase;
			cv = new ContentVersion();
			cv.Title = 'Email-to-Case File';
			cv.VersionData = Blob.valueOf('Email-to-Case File');
			cv.PathOnClient = '/EmailToCaseFile';
			cv.Enviado__c = false;
			insert cv;
			cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
			cDLink = new ContentDocumentLink();
			cDLink.ContentDocumentId = cv.ContentDocumentId;
			cDLink.LinkedEntityId = emailToCaseCase.Id;
			insert cDLink;
		}
		emailToCaseCase = [SELECT OwnerId FROM Case WHERE id =: emailToCaseCase.Id];
		System.assertEquals(fromUsers[0].UserOrGroupId, emailToCaseCase.OwnerId, 'El dueño del caso debe ser el usuario');
		cv = [SELECT ContentDocumentId, OwnerId FROM ContentVersion WHERE Id = :cv.Id];
		System.assertEquals(emailToCaseCase.OwnerId, cv.OwnerId, 'El dueño del CV debe ser el mismo dueño del caso');
		List<ContentDocumentLink> cDLinks = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId =: cv.ContentDocumentId];
		System.assertEquals(2, cDLinks.size(), 'Debe haber dos CDLink');
		for (ContentDocumentLink cDL: cDLinks) {
			if (cDL.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Case') {
				System.assertEquals(emailToCaseCase.Id, cDL.LinkedEntityId, 'Un CDLink debe estar asociado al caso');
			} else {
				System.assertEquals('User', cDL.LinkedEntityId.getSObjectType().getDescribe().getName(), 'Un CDLink debe ser estar asociado al usuario');
				System.assertEquals(fromUsers[0].UserOrGroupId, cDL.LinkedEntityId, 'Un CDLink debe estar asociado al usuario');
			}
		}
	}
	@isTest
	private static void ifEmail_DontTryToCreateNewCDLinkToCase () {
		Integer numberOfCases = [SELECT count () FROM Case];
		System.assertEquals(0, numberOfCases, 'No deben haber casos');
		List<User> platIntUsers = [SELECT Id FROM User WHERE isActive = true AND UserName LIKE 'automatedcase%'];
		System.assertEquals(1, platIntUsers.size(), 'Debe haber un usuario para los casos Email-to-Case');
		Case emailToCaseCase = Build.aCaseFromEmail().build();
		ContentVersion cv;
		ContentDocumentLink cDLink;
		Group fromQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'CDC'];
		Account delegacion = new Account();
		delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
		delegacion.Name = 'Test';
		delegacion.Codigo_de_delegacion__c = '650078';
		insert  delegacion;
		System.runAs (platIntUsers[0]) {
			insert emailToCaseCase;
			emailToCaseCase.OwnerId = fromQueue.Id;
			update emailToCaseCase;
			EmailMessage email = new EmailMessage();
			email.ToAddress = 'test@example.com';
			email.ParentId = emailToCaseCase.Id;
			email.TextBody = 'Test message';
			insert email;
			cv = new ContentVersion();
			cv.Title = 'Email-to-Case File';
			cv.VersionData = Blob.valueOf('Email-to-Case File');
			cv.PathOnClient = '/EmailToCaseFile';
			cv.FirstPublishLocationId = platIntUsers[0].Id;
			cv.ContentLocation = 'S';
			cv.Enviado__c = false;
			insert cv;
			cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
			cDLink = new ContentDocumentLink();
			cDLink.ContentDocumentId = cv.ContentDocumentId;
			cDLink.LinkedEntityId = email.Id;
			insert cDLink;
		}
		Test.startTest();
		EmailMessage email = new EmailMessage();
		email.ToAddress = 'test@example.com';
		email.ParentId = emailToCaseCase.Id;
		email.TextBody = 'Test message respond';
		insert email;
		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
		cDLink = new ContentDocumentLink();
		cDLink.ContentDocumentId = cv.ContentDocumentId;
		cDLink.LinkedEntityId = email.Id;
		insert cDLink;
		Test.stopTest();
		emailToCaseCase = [SELECT OwnerId FROM Case WHERE id =: emailToCaseCase.Id];
		System.assertEquals(fromQueue.Id, emailToCaseCase.OwnerId, 'El dueño del caso debe ser el usuario');
		cv = [SELECT ContentDocumentId, OwnerId, ContentDocument.ParentId FROM ContentVersion WHERE Id = :cv.Id];
		String libraryId = [SELECT Id FROM ContentWorkspace WHERE DeveloperName = 'Front_PG_Library'].Id;
		System.assertEquals(libraryId, cv.ContentDocument.ParentId, 'El parent Id del CV debe ser la libreria de la cola');
		List<ContentDocumentLink> cDLinks = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId =: cv.ContentDocumentId];
		System.assertEquals(4, cDLinks.size(), 'Debe haber tres CDLink');
		for (ContentDocumentLink cDL: cDLinks) {
			String sObjectType = cDL.LinkedEntityId.getSObjectType().getDescribe().getName();
			if (sObjectType == 'Case') {
				System.assertEquals(emailToCaseCase.Id, cDL.LinkedEntityId, 'Un CDLink debe ser estar asociado al caso');
			} else if (sObjectType == 'User') {
				System.assertEquals(platIntUsers[0].Id, cDL.LinkedEntityId, 'Un CDLink debe estar asociado al usuario de integración');
			} else if (sObjectType == 'EmailMessage'){
				System.assertEquals(email.Id, cDL.LinkedEntityId, 'Un CDLink debe estar asociado al nuevo correo');
			} else {
				System.assertEquals('ContentWorkspace', sObjectType, 'Un CDLink debe estar asociado a la libreria');
				System.assertEquals(libraryId, cDL.LinkedEntityId, 'Un CDLink debe estar asociado a la libreria');
			}
		}
	}
}