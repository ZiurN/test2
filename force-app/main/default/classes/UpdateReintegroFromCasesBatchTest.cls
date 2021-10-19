@isTest
public without sharing class UpdateReintegroFromCasesBatchTest {
    
    @isTest
	public static void whenAPrestacionIsInsertMustUpdateTheCaseFieldWhichShowsTheTotalAmmountOfBothPrestacionDeReintegroSumm(){
		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		reintegro.Reintegro_Total__c = 0;
		reintegro.Nombre__c = 'prestacion batch prueba';
		insert reintegro;

		Prestacion_de_reintegro__c prest = new Prestacion_de_reintegro__c();
		prest.Estado__c = 'C1-----A';
		prest.Caso__r = reintegro;
		prest.HD__c = 'prestacion batch prueba';
		prest.Caso__c = reintegro.Id;
		prest.Importe_Reintegro_auditor__c = 150.00;

		Prestacion_de_reintegro__c prestDos = new Prestacion_de_reintegro__c();
		prestDos.Estado__c = 'C1-----A';
		prestDos.HD__c = 'prestacion batch prueba';
		prestDos.Caso__r = reintegro;
		prestDos.Caso__c = reintegro.Id;
		prestDos.Importe_Reintegro_auditor__c = 250.00;
		insert prestDos;
        insert prest;

		Test.startTest();	
		Database.executeBatch(new UpdateReintegroFromCasesBatch());
		Test.stopTest();

		reintegro = [SELECT Reintegro_Total__c,Prestaciones_en_auditoria__c FROM Case WHERE Id = :reintegro.Id];
		System.assertEquals(400.00,reintegro.Reintegro_Total__c);
	}
}