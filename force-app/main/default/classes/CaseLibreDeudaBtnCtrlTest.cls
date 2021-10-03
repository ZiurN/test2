@isTest 
private class CaseLibreDeudaBtnCtrlTest {
	static Account cuenta;
	static Case caso;

	static{
		cuenta = Build.anAccountCuentapersonal().build();
		cuenta.Plan_Nombre__c = 'INTEGRAL AS200';
		cuenta.Numero_de_documento__c = '12345678';
		cuenta.Type = 'TIT';
		cuenta.Estado__c = 'B';
		insert cuenta;

		caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Consultas').Id;
		caso.AccountId = cuenta.Id;
		insert caso;
	}

	@isTest
	private static void generatePdfCopago() {
		Test.startTest();
		CaseLibreDeudaBtnCtrl.Response resp = CaseLibreDeudaBtnCtrl.generatePdf(caso.Id);
		Test.stopTest();

		ContentDocumentLink[] links = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id]; 

		System.assertEquals(false, resp.hasError);
		System.assertEquals('Se ha adjuntado el pdf correctamente.', resp.message);
		System.assertEquals(1, links.size());

	}

	@isTest
	private static void generatePdfSinCopago() {
		cuenta.Plan_Nombre__c = 'PLAN 1';
		update cuenta;

		Test.startTest();
		CaseLibreDeudaBtnCtrl.Response resp = CaseLibreDeudaBtnCtrl.generatePdf(caso.Id);
		Test.stopTest();

		ContentDocumentLink[] links = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id]; 

		System.assertEquals(false, resp.hasError);
		System.assertEquals('Se ha adjuntado el pdf correctamente.', resp.message);
		System.assertEquals(1, links.size());
	}

	@isTest
	private static void ifCaseHaveNotAnAccountShowTheErrorMsg() {
		caso.AccountId = null;
		update caso;

		Test.startTest();
		CaseLibreDeudaBtnCtrl.Response resp = CaseLibreDeudaBtnCtrl.generatePdf(caso.Id);
		Test.stopTest();

		ContentDocumentLink[] links = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id]; 

		System.assertEquals(true, resp.hasError);
		System.assertEquals('El caso debe tener una cuenta asociada.', resp.message);
		System.assertEquals(0, links.size());
	}

	@isTest
	private static void updateContentVersion() {
		ContentVersion cv = new ContentVersion();
		cv.Title = 'Libre_deuda_asociado';
		cv.VersionData = Blob.valueOf('Libre_deuda_asociado_Test');
		cv.PathOnClient = '/Libre_deuda_asociado';
		insert cv;

		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

		ContentDocumentLink link = new ContentDocumentLink();
		link.ContentDocumentId = cv.ContentDocumentId;
		link.LinkedEntityId = caso.Id;
		insert link;

		Test.startTest();
		CaseLibreDeudaBtnCtrl.Response resp = CaseLibreDeudaBtnCtrl.generatePdf(caso.Id);
		Test.stopTest();

		ContentDocumentLink[] links = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id];
		ContentVersion[] versions = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :cv.ContentDocumentId];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('Se ha adjuntado el pdf correctamente.', resp.message);
		System.assertEquals(1, links.size());
		System.assertEquals(2, versions.size());
	}

	@isTest
	private static void whenAccountIsNotTitularShowTheErrorMsg() {
		cuenta.Type = 'FAM';
		update cuenta;

		Test.startTest();
		CaseLibreDeudaBtnCtrl.Response resp = CaseLibreDeudaBtnCtrl.generatePdf(caso.Id);
		Test.stopTest();

		ContentDocumentLink[] links = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id]; 

		System.assertEquals(true, resp.hasError);
		System.assertEquals('La cuenta asociada al caso no pertenece a un titular.', resp.message);
		System.assertEquals(0, links.size());
	}

	@isTest
	private static void whenAccountIsNotDadoDeBajaShowTheErrorMsg() {
		cuenta.Estado__c = 'A';
		update cuenta;

		Test.startTest();
		CaseLibreDeudaBtnCtrl.Response resp = CaseLibreDeudaBtnCtrl.generatePdf(caso.Id);
		Test.stopTest();

		ContentDocumentLink[] links = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id]; 

		System.assertEquals(true, resp.hasError);
		System.assertEquals('La cuenta asociada al caso no está dada de baja.', resp.message);
		System.assertEquals(0, links.size());
	}
	
}