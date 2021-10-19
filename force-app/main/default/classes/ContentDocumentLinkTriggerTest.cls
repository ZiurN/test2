@isTest 
private class ContentDocumentLinkTriggerTest {
	private static XHttpCalloutMock serverMock;

	static {
		serverMock = new XHttpCalloutMock();
		serverMock.buildResponse()
				.withBody('some body');
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

		System.debug(result);
		System.assertEquals(false, result.isSuccess());
		System.assertEquals(
			'Ya existe un archivo, adjunto a este registro, con el mismo nombre', 
			result.getErrors()[0].getMessage()
		);
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

		System.debug(result);
		System.assertEquals(false, result.isSuccess());
		System.assertEquals(
			'Ya existe un archivo, adjunto a este registro, con el mismo nombre', 
			result.getErrors()[0].getMessage()
		);
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

		System.debug(result);
		System.assertEquals(false, result.isSuccess());
		System.assertEquals(
			'Ya existe un archivo, adjunto a este registro, con el mismo nombre', 
			result.getErrors()[0].getMessage()
		);
	}

	@isTest(SeeAllData=true)
	private static void avoidInsertFilesLargerThan3Mb() {
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		ContentDocumentLink cdl = New ContentDocumentLink();

		List<ContentDocument> documents = [
			SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE ContentSize > 3145728 LIMIT 1
		];

		if(documents.isEmpty()) {
			return;
		}

		for (ContentDocument contentDocument: documents){
            //create ContentDocumentLink  record 
            cdl.LinkedEntityId = em.id;
            cdl.ContentDocumentId = contentDocument.Id;
            cdl.shareType = 'V';
        }
		
		Test.startTest();
		Database.SaveResult result = Database.insert(cdl, false);
		Test.stopTest();

		System.debug(result);
		System.assertEquals(false, result.isSuccess());
		System.assertEquals('El tamaño del archivo no debe superar los 3mb.', result.getErrors()[0].getMessage());
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
		System.assertEquals(false, result.isSuccess());
		System.assertEquals(
			'No se pueden eliminar archivos de oportunidades', 
			result.getErrors()[0].getMessage()
		);
	}

	@isTest
	private static void avoidDeleteAFileAlreadySendedToSSInSalesCases() {
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile perfil = [
            SELECT Id 
            FROM Profile 
            WHERE Name='Front'
        ];
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

			System.debug(result);
			System.assertEquals(false, result.isSuccess());
			System.assertEquals(
				'No se pueden eliminar archivos si el caso ya fue enviado a Salud Soft', 
				result.getErrors()[0].getMessage()
			);
		}
	}

	static User salesUser;
	static {
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile pSales = [SELECT Id FROM Profile WHERE Name='Agente de ventas'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Comercial AMBA'];
		System.debug(role);
		salesUser = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'sales', ProfileId = pSales.Id, UserRoleId = role.Id);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert salesUser;
		}
	}

	//Cancelacion s3
	/*@isTest
	private static void sendCaseFileToAWS() {
		Case aCase = new Case(RecordTypeId = XappiaHelper.getRecordType('Case','Consultas').Id);
		insert aCase;

		ContentVersion cv = new ContentVersion();
		cv.Title = 'TESTAWSTRIGGER';
		cv.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		cv.PathOnClient = '/TESTAWSTRIGGER.TXT';
		insert cv;

		cv = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cv.ContentDocumentId;
		cdl.LinkedEntityId = aCase.Id;
		insert cdl;
		
		serverMock.buildResponse()
				.addForAddress(AWS.url + 'case/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest();

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
		];

		System.assert(!archivos.isEmpty());	
	}

	@isTest
	private static void sendReintegroFileToAWS() {
		Case aCase = new Case(RecordTypeId = XappiaHelper.getRecordType('Case','Reintegro').Id);
		insert aCase;

		ContentVersion cv = new ContentVersion();
		cv.Title = 'TESTAWSTRIGGER';
		cv.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		cv.PathOnClient = '/TESTAWSTRIGGER.TXT';
		insert cv;

		cv = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cv.ContentDocumentId;
		cdl.LinkedEntityId = aCase.Id;
		insert cdl;
		
		serverMock.buildResponse()
			.addForAddress(AWS.url + 'reintegros/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest();

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
		];

		System.assert(!archivos.isEmpty());	
	}

	@isTest
	private static void sendSolicitudFileToAWS() {
		Case aCase = new Case(RecordTypeId = XappiaHelper.getRecordType('Case','Solicitud_de_nueva_credencial').Id);
		insert aCase;

		ContentVersion cv = new ContentVersion();
		cv.Title = 'TESTAWSTRIGGER';
		cv.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		cv.PathOnClient = '/TESTAWSTRIGGER.TXT';
		insert cv;

		cv = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cv.ContentDocumentId;
		cdl.LinkedEntityId = aCase.Id;
		insert cdl;
		
		serverMock.buildResponse()
			.addForAddress(AWS.url + 'solicitudes_sf/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest();

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
		];

		System.assert(!archivos.isEmpty());	
	}

	@isTest
	private static void sendEMFileToAWS() {
		Evento_medico__c em = new Evento_medico__c();
		insert em;

		ContentVersion cv = new ContentVersion();
		cv.Title = 'TESTAWSTRIGGER';
		cv.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		cv.PathOnClient = '/TESTAWSTRIGGER.TXT';
		insert cv;

		cv = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cv.ContentDocumentId;
		cdl.LinkedEntityId = em.Id;
		insert cdl;
		
		serverMock.buildResponse()
				.addForAddress(AWS.url + 'em/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);
		
		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest();

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
		];

		System.assert(!archivos.isEmpty());	
	}

	@isTest
	private static void sendOpportunityFileToAWS() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
		insert opp;

		ContentVersion cv = new ContentVersion();
		cv.Title = 'TESTAWSTRIGGER';
		cv.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		cv.PathOnClient = '/TESTAWSTRIGGER.TXT';
		insert cv;

		cv = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cv.ContentDocumentId;
		cdl.LinkedEntityId = opp.Id;
		insert cdl;
		
		serverMock.buildResponse()
				.addForAddress(AWS.url + 'solicitudes_sf/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest();

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
		];

		System.assert(!archivos.isEmpty());	
	}*/
}