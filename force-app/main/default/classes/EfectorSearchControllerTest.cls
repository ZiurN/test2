@isTest 
private class EfectorSearchControllerTest {
	
	@testSetup 
	static void setup() {
        // Create common test accounts
		Localidad__c loc = new Localidad__c();
		loc.Loc_Id__c = '1234';
		loc.Nombre_de_Localidad__c = 'Test';
		insert loc;

        Account[] efectores = new List<Account>();
        for(Integer i = 0; i < 3; i++) {
			Account acc = Build.anAccountEfector().build();
			acc.Name = 'Efector Test' + i;
			acc.Codigo_de_efector__c = '12345' + i;
			acc.Localidad_new__c = loc.Id;

            efectores.add(acc);
        }
        insert efectores;

		Matricula__c[] matriculas = new List<Matricula__c>();
		for(Integer i = 0; i < 3; i++) {
			Matricula__c mat = new Matricula__c();
			mat.Matricula__c = '123' + i;
			mat.Tipo_de_Matricula__c = 'P';
			mat.Provincia_codigo__c = i == 0 ? 'C' : i == 1 ? 'B' : 'X';
			mat.Efector__c = efectores[i].Id;

            matriculas.add(mat);
        }
		insert matriculas;

    }

	@isTest
	private static void searchByMatricula() {
		EfectorSearchController.Response resp = EfectorSearchController.search('1230', '', '');
		EfectorSearchController.Response resp2 = EfectorSearchController.search('1232', '', '');

		System.assertEquals('Efector Test0', resp.efectores[0].Efector__r.Name);
		System.assertEquals('123450', resp.efectores[0].Efector__r.Codigo_de_efector__c);
		System.assertEquals('Efector Test2', resp2.efectores[0].Efector__r.Name);
		System.assertEquals('123452', resp2.efectores[0].Efector__r.Codigo_de_efector__c);
		
	}

	@isTest
	private static void searchByProvincia() {
		EfectorSearchController.Response resp = EfectorSearchController.search('', 'C', '');
		EfectorSearchController.Response resp2 = EfectorSearchController.search('', 'B', '');

		System.assertEquals('Efector Test0', resp.efectores[0].Efector__r.Name);
		System.assertEquals('123450', resp.efectores[0].Efector__r.Codigo_de_efector__c);
		System.assertEquals('Efector Test1', resp2.efectores[0].Efector__r.Name);
		System.assertEquals('123451', resp2.efectores[0].Efector__r.Codigo_de_efector__c);
	}

	@isTest
	private static void searchByLocalidad() {
		EfectorSearchController.Response resp = EfectorSearchController.search('', '', 'Test');
		
		System.assertEquals(3, resp.efectores.size());
	}
}