@isTest 
private class PrestacionReintegroTriggerTest {

	@isTest
	private static void checkTheFieldPrestacionesEnAuditoriaInCaseWhenAPrestacionChangesToThatStatus() {
		System.debug(XappiaHelper.getPicklistFieldValues('Prestacion_de_reintegro__c', 'Estado__c'));

		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;

		Prestacion_de_reintegro__c prest = new Prestacion_de_reintegro__c();
		prest.Caso__c = reintegro.Id;
		insert prest;

		Test.startTest();
		prest.Estado__c = 'C1-----A';
		update prest;
		Test.stopTest();

		reintegro = [SELECT Prestaciones_en_auditoria__c FROM Case WHERE Id = :reintegro.Id];
		System.assert(reintegro.Prestaciones_en_auditoria__c);
	}

	@isTest
	private static void uncheckTheFieldPrestacionesEnAuditoriaInCaseWhenNoOnePrestacionHaveThatStatus() {
		System.debug(XappiaHelper.getPicklistFieldValues('Prestacion_de_reintegro__c', 'Estado__c'));

		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		reintegro.Prestaciones_en_auditoria__c = true;
		insert reintegro;

		Prestacion_de_reintegro__c prest = new Prestacion_de_reintegro__c();
		prest.Caso__c = reintegro.Id;
		insert prest;

		Test.startTest();
		prest.Estado__c = 'C1----AS';
		update prest;
		Test.stopTest();

		reintegro = [SELECT Prestaciones_en_auditoria__c FROM Case WHERE Id = :reintegro.Id];
		System.assert(!reintegro.Prestaciones_en_auditoria__c);
	}

	@isTest
	private static void checkTheFieldPrestacionesEnAuditoriaInCaseWhenAPrestacionIsInsertWithThatStatus() {
		System.debug(XappiaHelper.getPicklistFieldValues('Prestacion_de_reintegro__c', 'Estado__c'));

		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;

		Prestacion_de_reintegro__c prest = new Prestacion_de_reintegro__c();
		prest.Estado__c = 'C1-----A';
		prest.Caso__c = reintegro.Id;

		Test.startTest();
		insert prest;
		Test.stopTest();

		reintegro = [SELECT Prestaciones_en_auditoria__c FROM Case WHERE Id = :reintegro.Id];
		System.assert(reintegro.Prestaciones_en_auditoria__c);
	}

	
	@isTest
	public static void whenAPrestacionIsInsertMustUpdateTheCaseFieldWhichShowsTheTotalAmmountOfThePrestacionDeReintegro(){
		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;

		Prestacion_de_reintegro__c prest = new Prestacion_de_reintegro__c();
		prest.Estado__c = 'C1-----A';
		prest.Caso__c = reintegro.Id;
		prest.Importe_Reintegro_auditor__c = 150.00;

		Test.startTest();
		insert prest;
		Test.stopTest();

		reintegro = [SELECT Reintegro_Total__c,Prestaciones_en_auditoria__c FROM Case WHERE Id = :reintegro.Id];
		System.assertEquals(150.00,reintegro.Reintegro_Total__c);
	}

	@isTest
	public static void whenAPrestacionIsInsertMustUpdateTheCaseFieldWhichShowsTheTotalAmmountOfBothPrestacionDeReintegroSumm(){
		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;

		Prestacion_de_reintegro__c prest = new Prestacion_de_reintegro__c();
		prest.Estado__c = 'C1-----A';
		prest.Caso__c = reintegro.Id;
		prest.Importe_Reintegro_auditor__c = 150.00;

		Prestacion_de_reintegro__c prestDos = new Prestacion_de_reintegro__c();
		prestDos.Estado__c = 'C1-----A';
		prestDos.Caso__c = reintegro.Id;
		prestDos.Importe_Reintegro_auditor__c = 250.00;
		insert prestDos;

		Test.startTest();
		insert prest;
		Test.stopTest();

		reintegro = [SELECT Reintegro_Total__c,Prestaciones_en_auditoria__c FROM Case WHERE Id = :reintegro.Id];
		System.assertEquals(400.00,reintegro.Reintegro_Total__c);
	}

	@isTest
	public static void whenAPrestacionIsInsertMustUpdateTheCaseFieldWhichShowsTheTotalAmmountOfBothPrestacionDeReintegroSummByTheQuantity(){
		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;

		Prestacion_de_reintegro__c prest = new Prestacion_de_reintegro__c();
		prest.Estado__c = 'C1-----A';
		prest.Caso__c = reintegro.Id;
		prest.Cantidad__c = 1;
		prest.Importe_Reintegro_auditor__c = 150.00;

		Prestacion_de_reintegro__c prestDos = new Prestacion_de_reintegro__c();
		prestDos.Estado__c = 'C1-----A';
		prestDos.Caso__c = reintegro.Id;
		prestDos.Cantidad__c = 3;
		prestDos.Importe_Reintegro_auditor__c = 250.00;
		insert prestDos;

		Test.startTest();
		insert prest;
		Test.stopTest();

		reintegro = [SELECT Reintegro_Total__c,Prestaciones_en_auditoria__c FROM Case WHERE Id = :reintegro.Id];
		System.assertEquals(900.00,reintegro.Reintegro_Total__c);
	}
}