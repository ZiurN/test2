@isTest 
private class OpportunityFileUploadCtrlTest {

	static ContentVersion ver;
	static ContentVersion ingresoTest;
	static ContentVersion DDJJTest;


	static{
		ver= new ContentVersion();
		ver.VersionData = Blob.valueOf('TEST');
		ver.Title = 'NombreTest';
		ver.PathOnClient = '/NombreTest';
		insert ver;

		ingresoTest= new ContentVersion();
		ingresoTest.VersionData = Blob.valueOf('TEST');
		ingresoTest.Title = 'test ingreso test';
		ingresoTest.PathOnClient = '/NombreTest';
		insert ingresoTest;

		DDJJTest= new ContentVersion();
		DDJJTest.VersionData = Blob.valueOf('TEST');
		DDJJTest.Title = 'test DDJJ test';
		DDJJTest.PathOnClient = '/NombreTest';
		insert DDJJTest;
	}
	@isTest
	private static void activateUploadFilesTrueTipeAltaTest(){
		Opportunity op = Build.anOpportunityCorporativo().withTipodeSolicitud('ALTA').withActivateFiles(true).build();
		insert op;
		Test.startTest();
		OpportunityFileUploadCtrl.ResponseActivateFilesUpload resp = OpportunityFileUploadCtrl.getActivateFilesUpload(op.Id);
		Test.stopTest();
		System.assertEquals(false, resp.hasError);
		System.assertEquals(true, resp.checkbox, 'Debe devolver true el campo ActivatesFiles');
	}
	@isTest
	private static void activateUploadFilesTrueAltaTestBecauseIsFrontUser(){
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Front'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName, ProfileId = p.Id, UserRole = role);
		insert usuario;
		System.runAs(usuario){
			Opportunity op = Build.anOpportunityCorporativo().withTipodeSolicitud('ALTA').withActivateFiles(false).build();
			insert op;
			Test.startTest();
			OpportunityFileUploadCtrl.ResponseActivateFilesUpload resp = OpportunityFileUploadCtrl.getActivateFilesUpload(op.Id);
			Test.stopTest();
			System.assertEquals(false, resp.hasError);
			System.assertEquals(true, resp.checkbox, 'Debe devolver false el campo ActivatesFiles');
		}
	}

	@isTest
	private static void activateUploadFilesFalseAltaTestProfileAgente(){
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName, ProfileId = p.Id, UserRole = role);
		insert usuario;
		System.runAs(usuario){
			Opportunity op = Build.anOpportunityCorporativo().withTipodeSolicitud('ALTA').withActivateFiles(false).build();
			insert op;
			Test.startTest();
			OpportunityFileUploadCtrl.ResponseActivateFilesUpload resp = OpportunityFileUploadCtrl.getActivateFilesUpload(op.Id);
			Test.stopTest();
			System.assertEquals(false, resp.hasError);
			System.assertEquals(false, resp.checkbox, 'Debe devolver false el campo ActivatesFiles');
		}
	}

	@isTest
	private static void activateUploadFilesTrueAltaTestWithAgenteDeVentasProfile(){
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName, ProfileId = p.Id, UserRole = role);
		insert usuario;
		System.runAs(usuario){
			Opportunity op = Build.anOpportunityCorporativo().withTipodeSolicitud('ALTA').withActivateFiles(true).build();
			insert op;
			Test.startTest();
			OpportunityFileUploadCtrl.ResponseActivateFilesUpload resp = OpportunityFileUploadCtrl.getActivateFilesUpload(op.Id);
			Test.stopTest();
			System.assertEquals(false, resp.hasError);
			System.assertEquals(true, resp.checkbox, 'Debe devolver false el campo ActivatesFiles');
		}
	}

	@isTest 
	private static void testGetDocumentIngresoTrue(){
		Opportunity op = Build.anOpportunityCorporativo().build();
		insert op;
		ContentVersion updateVer = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :ingresoTest.Id
		];

		ContentDocumentLink linkInsert = new ContentDocumentLink();
		linkInsert.LinkedEntityId = op.Id;
		linkInsert.ContentDocumentId = updateVer.ContentDocumentId;
		insert linkInsert;
		Test.startTest();
		OpportunityFileUploadCtrl.ReponseVerifyDocumentUpload responseDocument = OpportunityFileUploadCtrl.getDocumentSolicitudIngreso(op.Id);
		Test.stopTest();
		System.assertEquals(false, responseDocument.hasError);
		System.assertEquals(true, responseDocument.hasDocument, 'Se esperaba que encuentre al menos 1 documento');
	}
	@isTest 
	private static void testGetDocumentIngresoFalse(){
		Opportunity op = Build.anOpportunityCorporativo().build();
		insert op;
		ContentVersion updateVer = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :ver.Id
		];

		ContentDocumentLink linkInsert = new ContentDocumentLink();
		linkInsert.LinkedEntityId = op.Id;
		linkInsert.ContentDocumentId = updateVer.ContentDocumentId;
		insert linkInsert;
		Test.startTest();
		OpportunityFileUploadCtrl.ReponseVerifyDocumentUpload responseDocument = OpportunityFileUploadCtrl.getDocumentSolicitudIngreso(op.Id);
		Test.stopTest();
		System.assertEquals(false, responseDocument.hasError);
		System.assertEquals(false, responseDocument.hasDocument, 'Se esperaba que no encuentre ningun documento de ingreso');
	}
	@isTest 
	private static void testGetDocumentDDJJTrue(){
		Opportunity op = Build.anOpportunityCorporativo().build();
		insert op;
		ContentVersion updateVer = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :DDJJTest.Id
		];

		ContentDocumentLink linkInsert = new ContentDocumentLink();
		linkInsert.LinkedEntityId = op.Id;
		linkInsert.ContentDocumentId = updateVer.ContentDocumentId;
		insert linkInsert;
		Test.startTest();
		OpportunityFileUploadCtrl.ReponseVerifyDocumentUpload responseDocument = OpportunityFileUploadCtrl.getDocumentDDJJ(op.Id);
		Test.stopTest();
		System.assertEquals(false, responseDocument.hasError);
		System.assertEquals(true, responseDocument.hasDocument, 'Se esperaba que encuentre al menos 1 documento');
	}
	@isTest 
	
	private static void testGetDocumentDDJJFalse(){
		Opportunity op = Build.anOpportunityCorporativo().build();
		insert op;
		ContentVersion updateVer = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :ver.Id
		];

		ContentDocumentLink linkInsert = new ContentDocumentLink();
		linkInsert.LinkedEntityId = op.Id;
		linkInsert.ContentDocumentId = updateVer.ContentDocumentId;
		insert linkInsert;
		Test.startTest();
		OpportunityFileUploadCtrl.ReponseVerifyDocumentUpload responseDocument = OpportunityFileUploadCtrl.getDocumentDDJJ(op.Id);
		Test.stopTest();
		System.assertEquals(false, responseDocument.hasError);
		System.assertEquals(false, responseDocument.hasDocument, 'Se esperaba que no encuentre ningun documento');
	}
	@isTest
	private static void testChangeFileName() {
		Opportunity op = Build.anOpportunityCorporativo().build();
		insert op;
		
		ContentVersion updateVer = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Id = :ver.Id
		];

		ContentDocumentLink link = new ContentDocumentLink();
		link.LinkedEntityId = op.Id;
		link.ContentDocumentId = updateVer.ContentDocumentId;
		insert link;

		Test.startTest();
		OpportunityFileUploadCtrl.Response resp = OpportunityFileUploadCtrl.changeFileName(
													updateVer.ContentDocumentId,op.Id,'documento_archivo');
		OpportunityFileUploadCtrl.ResponseFiles respFiles = OpportunityFileUploadCtrl.getFilesUploaded(op.Id);
		Test.stopTest();

		ContentVersion updateVer2 = [
			SELECT Title 
			FROM ContentVersion 
			WHERE Id = :ver.Id
		];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('documento_archivo', updateVer2.Title);
		System.assertEquals('documento_archivo', respFiles.files[0]);
	}

	@isTest
	private static void testGetIntegrantesFromOpp() {
		Opportunity op = Build.anOpportunityCorporativo().build();
		insert op;
		
		Test.startTest();
		OpportunityFileUploadCtrl.ResponseIntegrantes resp = OpportunityFileUploadCtrl.getIntegrantesFromOpp(op.Id);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals(0, resp.integrantes.size());
	}

	@isTest
	private static void testChangeFileNameToUnexistingFile() {
		Opportunity op = Build.anOpportunityCorporativo().build();
		insert op;

		Test.startTest();
		OpportunityFileUploadCtrl.Response resp = OpportunityFileUploadCtrl.changeFileName('ASDF', op.Id, 'documento_archivo');
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('No hay ningun archivo al cual modificar', resp.message);
	}
    
    @isTest
	private static void testGetProfileName() {
		Opportunity op = Build.anOpportunityCorporativo().build();
		insert op;

        op = [SELECT CreatedById 
			FROM Opportunity 
			WHERE Id = :op.Id
		];

        Test.startTest();
        OpportunityFileUploadCtrl.ResponseProfile resp = OpportunityFileUploadCtrl.getCreatorsProfile(op.CreatedById);
        Test.stopTest();
		
        System.assert(!resp.hasError);
        System.assert(resp.profile == 'Administrador del sistema' || resp.profile == 'System Administrator');
    }
}