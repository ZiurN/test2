@isTest 
private class ContentDocumentTriggerTest {
	private static XHttpCalloutMock serverMock;
	private static List<String> nameList = new List<String>{'TESTAWSTRIGGER_solicitudes_sf',
															'TESTAWSTRIGGER_reintegros',
															'TESTAWSTRIGGER_em'};
	static {
		serverMock = new XHttpCalloutMock();
		serverMock.buildResponse()
				.withBody('some body');
	}
	@testSetup
	static void setup() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
		insert opp;
		Case aCase = new Case(RecordTypeId = XappiaHelper.getRecordType('Case','Reintegro').Id);
		insert aCase;
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		List<ContentVersion> cvsToInsert = new List<ContentVersion>();
		for (String name : nameList) {
			ContentVersion cv = new ContentVersion();
			cv.Title = name;
			cv.VersionData = Blob.valueOf(name);
			cv.PathOnClient = '/'+ name + '.TXT';
			cvsToInsert.add(cv);
		}
		insert cvsToInsert;
		List<ContentVersion> cvs = [SELECT ContentDocumentId, Title FROM ContentVersion WHERE Id IN: cvsToInsert];
		List<ContentDocumentLink> cdLinksToInsert = new List<ContentDocumentLink>();
		for (ContentVersion cv : cvs) {
			String urlType = cv.Title.replaceAll('TESTAWSTRIGGER_', '');
			Id parentId = urlType == 'solicitudes_sf' ? opp.Id
								: urlType == 'reintegros' ? aCase.Id
									: em.Id;
			ContentDocumentLink cdl = new ContentDocumentLink();
			cdl.ContentDocumentId = cv.ContentDocumentId;
			cdl.LinkedEntityId = parentId;
			cdLinksToInsert.add(cdl);
			serverMock.buildResponse()
				.addForAddress(AWS.url + urlType + '/' + cdl.LinkedEntityId + '/'+ cv.Title + '.TXT');
		}
		insert (cdLinksToInsert);
		Test.setMock(HttpCalloutMock.class, serverMock);
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
		System.assert(!result.isSuccess(), 'Debe haber un error');
		System.assertEquals(
			'No se pueden eliminar archivos de oportunidades',
			result.getErrors()[0].getMessage(),
			'El mensaje no indica el error'
		);
	}
	static User salesUser;
	static {
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
		System.assertEquals(null, cand.Nota__c, 'La nota debe ser nula');
	}
	@isTest
	private static void whenDeleteAContentNoteRelatedToLeadCopyTheBodyOfTheLastCreatedNoteToNotaField() {
		Lead cand = Build.aLead().build();
		cand.Phone = '1234567890';
		insert cand;
		List<ContentNote> contentNotesToInsert = new List<ContentNote>();
		ContentNote cn = new ContentNote();
		cn.Title = 'Test';
		cn.Content = Blob.valueOf('contentNote');
		contentNotesToInsert.add(cn);
		ContentNote cn2 = new ContentNote();
		cn2.Title = 'Test';
		cn2.Content = Blob.valueOf('contentNote2');
		contentNotesToInsert.add(cn2);
		insert contentNotesToInsert;
		List<ContentDocumentLink> contentDocLinksToInsert = new List<ContentDocumentLink>();
		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.ContentDocumentId = cn.Id;
		cdl.LinkedEntityId = cand.Id;
		contentDocLinksToInsert.add(cdl);
		ContentDocumentLink cdl2 = new ContentDocumentLink();
		cdl2.ContentDocumentId = cn2.Id;
		cdl2.LinkedEntityId = cand.Id;
		contentDocLinksToInsert.add(cdl2);
		insert contentDocLinksToInsert;
		Test.startTest();
		delete cn2;
		Test.stopTest();
		cand = [SELECT Id, Nota__c, (SELECT Id FROM AttachedContentNotes) FROM Lead WHERE Id = :cand.Id];
		System.assertEquals('contentNote', cand.Nota__c, 'La nota no tiene el contenido esperado');
	}
	@isTest
	private static void avoidDeleteAFileAlreadySendedToSSInSalesCases() {
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
            System.assertEquals(System.Label.Alerta_ArchivoEnviadoASS, result.getErrors()[0].getMessage()
            );
        }
    }
}