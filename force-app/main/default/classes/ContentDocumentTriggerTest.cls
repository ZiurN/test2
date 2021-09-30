@isTest 
private class ContentDocumentTriggerTest {
	private static XHttpCalloutMock serverMock;

	static {
		serverMock = new XHttpCalloutMock();
		serverMock.buildResponse()
				.withBody('some body');
	}

	@testSetup static void setup() {
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

		//Cancelacion s3
		/*serverMock.buildResponse()
			.addForAddress(AWS.url + 'solicitudes_sf/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');*/

		Case aCase = new Case(RecordTypeId = XappiaHelper.getRecordType('Case','Reintegro').Id);
		insert aCase;

		cv = new ContentVersion();
		cv.Title = 'TESTAWSTRIGGER';
		cv.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		cv.PathOnClient = '/TESTAWSTRIGGER.TXT';
		insert cv;

		cv = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cv.ContentDocumentId;
		cdl.LinkedEntityId = aCase.Id;

		insert cdl;
		//Cancelacion s3
		/*serverMock.buildResponse()
			.addForAddress(AWS.url + 'reintegros/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');*/

		Evento_medico__c em = new Evento_medico__c();
		insert em;

		cv = new ContentVersion();
		cv.Title = 'TESTAWSTRIGGER';
		cv.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		cv.PathOnClient = '/TESTAWSTRIGGER.TXT';
		insert cv;

		cv = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :cv.Id
		];

		cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cv.ContentDocumentId;
		cdl.LinkedEntityId = em.Id;
		insert cdl;
		
		//Cancelacion s3
		/*serverMock.buildResponse()
				.addForAddress(AWS.url + 'em/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');*/
		
		Test.setMock(HttpCalloutMock.class, serverMock);

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest();       
    }

	@isTest
	private static void avoidDeleteAFileAlreadySendedToSS() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
        opp.OwnerId = salesUser.Id;
		insert opp;
        
        Database.DeleteResult result;

		System.runAs(salesUser) {
			ContentVersion cv = new ContentVersion();
			cv.Title = 'AVOIDDELETECDTEST';
			cv.VersionData = Blob.valueOf('AVOIDDELETECDTEST');
			cv.PathOnClient = '/AVOIDDELETECDTEST';
			cv.Enviado__c = true;
			insert cv;

			cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

			ContentDocumentLink link = new ContentDocumentLink();
			link.ContentDocumentId = cv.ContentDocumentId;
			link.LinkedEntityId = opp.Id;
			insert link;

			ContentDocument cd = [SELECT Id FROM ContentDocument WHERE Id = :cv.ContentDocumentId];
		
			Test.startTest();
			result = Database.delete(cd, false);
			Test.stopTest();
		}

		System.debug(result);
		System.assertEquals(false, result.isSuccess());
		System.assertEquals(
			'No se pueden eliminar archivos de oportunidades', 
			result.getErrors()[0].getMessage()
		);
	
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

	@isTest
	private static void whenDeleteTheOnlyOneContentNoteRelatedToLeadTheNotaFieldShouldBeEmpty() {
		Lead cand = Build.aLead().build();
		cand.Phone = '1234567890';
		insert cand;

		ContentNote cn = new ContentNote();
		cn.Title = 'Test';
		cn.Content = Blob.valueOf('contentNote');
		insert cn;

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cn.Id;
		cdl.LinkedEntityId = cand.Id;
		insert cdl;
		
		Test.startTest();
		delete cn;
		Test.stopTest();

		cand = [SELECT Id, Nota__c, (SELECT Id FROM AttachedContentNotes) FROM Lead WHERE Id = :cand.Id];
		System.assertEquals(null, cand.Nota__c);
	}

	@isTest
	private static void whenDeleteAContentNoteRelatedToLeadCopyTheBodyOfTheLastCreatedNoteToNotaField() {
		Lead cand = Build.aLead().build();
		cand.Phone = '1234567890';
		insert cand;

		ContentNote cn = new ContentNote();
		cn.Title = 'Test';
		cn.Content = Blob.valueOf('contentNote');
		insert cn;

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cn.Id;
		cdl.LinkedEntityId = cand.Id;
		insert cdl;

		ContentNote cn2 = new ContentNote();
		cn2.Title = 'Test';
		cn2.Content = Blob.valueOf('contentNote2');
		insert cn2;

		ContentDocumentLink cdl2 = new ContentDocumentLink();
		cdl2.ContentDocumentId = cn2.Id;
		cdl2.LinkedEntityId = cand.Id;
		insert cdl2;
		
		Test.startTest();
		delete cn2;
		Test.stopTest();

		cand = [SELECT Id, Nota__c, (SELECT Id FROM AttachedContentNotes) FROM Lead WHERE Id = :cand.Id];
		System.assertEquals('contentNote', cand.Nota__c);
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
            cv.Title = 'AVOIDDELETECDSALESCASETEST';
            cv.VersionData = Blob.valueOf('AVOIDDELETECDSALESCASETEST');
            cv.PathOnClient = '/AVOIDDELETECDSALESCASETEST';
            cv.Enviado__c = true;
            insert cv;
    
            cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
    
            ContentDocumentLink link = new ContentDocumentLink();
            link.ContentDocumentId = cv.ContentDocumentId;
            link.LinkedEntityId = aCase.Id;
            insert link;
    
            ContentDocument cd = [SELECT Id FROM ContentDocument WHERE Id = :cv.ContentDocumentId];
        
            Test.startTest();
                result = Database.delete(cd, false);
            
            Test.stopTest();
    
            System.debug(result);
            System.assertEquals(false, result.isSuccess());
            System.assertEquals(
                'No se pueden eliminar archivos si el caso ya fue enviado a Salud Soft', 
                result.getErrors()[0].getMessage()
            );
        }
    }

	//Cancelacion s3
	/*@isTest
	private static void deleteOpportunityFileFromAWS() {
		Opportunity opp = [
			SELECT Id 
			FROM Opportunity
		];

		ContentDocumentLink cdl = [
			SELECT Id, ContentDocumentId, LinkedEntityId 
			FROM ContentDocumentLink 
			WHERE LinkedEntityId =: opp.Id
		];

		ContentDocument cd = [
			SELECT Id
			FROM ContentDocument
			WHERE Id =: cdl.ContentDocumentId 
		];

		serverMock.buildResponse()
			.withStatus('No Content')
			.withStatusCode(204)
			.addForAddress(AWS.url + 'solicitudes_sf/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);

		delete cd;

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest(); 

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
			WHERE Oportunidad__c =: opp.Id
		];

		System.assert(archivos.isEmpty());
	}

	@isTest
	private static void deleteCaseFileFromAWS() {
		Case aCase = [
			SELECT Id 
			FROM Case
		];

		ContentDocumentLink cdl = [
			SELECT Id, ContentDocumentId, LinkedEntityId 
			FROM ContentDocumentLink 
			WHERE LinkedEntityId =: aCase.Id
		];

		ContentDocument cd = [
			SELECT Id
			FROM ContentDocument
			WHERE Id =: cdl.ContentDocumentId 
		];

		serverMock.buildResponse()
			.withStatus('No Content')
			.withStatusCode(204)
			.addForAddress(AWS.url + 'reintegros/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);

		delete cd;

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest(); 

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
			WHERE Oportunidad__c =: aCase.Id
		];

		System.assert(archivos.isEmpty());
	}

	@isTest
	private static void deleteEventoMedicoFileFromAWS() {
		Evento_Medico__c em = [
			SELECT Id 
			FROM Evento_Medico__c
		];

		ContentDocumentLink cdl = [
			SELECT Id, ContentDocumentId, LinkedEntityId 
			FROM ContentDocumentLink 
			WHERE LinkedEntityId =: em.Id
		];

		ContentDocument cd = [
			SELECT Id
			FROM ContentDocument
			WHERE Id =: cdl.ContentDocumentId 
		];

		serverMock.buildResponse()
			.withStatus('No Content')
			.withStatusCode(204)
			.addForAddress(AWS.url + 'em/' + cdl.LinkedEntityId + '/TESTAWSTRIGGER.TXT');
		Test.setMock(HttpCalloutMock.class, serverMock);

		delete cd;

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest(); 

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
			WHERE Evento_Medico__c =: em.Id
		];

		System.assert(archivos.isEmpty());
	}*/

	/*@isTest
	private static void avoidDeletionOfOpportunityFile() {
		Opportunity opp = [
			SELECT Id 
			FROM Opportunity
		];

		ContentDocumentLink cdl = [
			SELECT Id, ContentDocumentId, LinkedEntityId 
			FROM ContentDocumentLink 
			WHERE LinkedEntityId =: opp.Id
		];

		ContentDocument cd = [
			SELECT Id
			FROM ContentDocument
			WHERE Id =: cdl.ContentDocumentId 
		];

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
			WHERE Oportunidad__c =: opp.Id
		];

		archivos[0].Enviado__c = true;
		update archivos;

		Database.DeleteResult result = Database.delete(cd, false);

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest(); 

		System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('No se puede eliminar el archivo, ya fue enviado a SaludSoft', result.getErrors()[0].getMessage());
	}*/

	/*private static void avoidDeletionOfCaseFile() {
		Case aCase = [
			SELECT Id 
			FROM Case
		];

		ContentDocumentLink cdl = [
			SELECT Id, ContentDocumentId, LinkedEntityId 
			FROM ContentDocumentLink 
			WHERE LinkedEntityId =: aCase.Id
		];

		ContentDocument cd = [
			SELECT Id
			FROM ContentDocument
			WHERE Id =: cdl.ContentDocumentId 
		];

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
			WHERE Caso__c =: aCase.Id
		];

		archivos[0].Enviado__c = true;
		update archivos;

		Database.DeleteResult result = Database.delete(cd, false);

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest(); 

		System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('No se puede eliminar el archivo, ya fue enviado a SaludSoft', result.getErrors()[0].getMessage());
	}*/

	/*@isTest
	private static void avoidDeletionOfEventoMedicoFile() {
		Evento_Medico__c em = [
			SELECT Id 
			FROM Evento_Medico__c
		];

		ContentDocumentLink cdl = [
			SELECT Id, ContentDocumentId, LinkedEntityId 
			FROM ContentDocumentLink 
			WHERE LinkedEntityId =: em.Id
		];

		ContentDocument cd = [
			SELECT Id
			FROM ContentDocument
			WHERE Id =: cdl.ContentDocumentId 
		];

		Archivo_url__c[] archivos = [
			SELECT Id 
			FROM Archivo_url__c
			WHERE Evento_Medico__c =: em.Id
		];

		archivos[0].Enviado__c = true;
		update archivos;

		Database.DeleteResult result = Database.delete(cd, false);

		Test.startTest();
		//Database.SaveResult result = Database.insert(cv2, false);
		Test.stopTest(); 

		System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('No se puede eliminar el archivo, ya fue enviado a SaludSoft', result.getErrors()[0].getMessage());
	}*/
}