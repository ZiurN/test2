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
		ContentDocumentLink cdl = New ContentDocumentLink();
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
	private static void avoidDeleteAFileAlreadySendedToSSInSalesCases() {
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile perfil = [SELECT Id FROM Profile WHERE Name='Front'];
        User front = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = perfil.Id, TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);
		Case aCase = Build.anCaseSolicitudDatosParticulares().build();
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
}