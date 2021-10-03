@isTest 
private class BatchIdExternoSucursalesTest {
	
	@testSetup 
    static void setup() {
		
		Account empresa = Build.anAccountEmpresa().build();
		empresa.Codigo_de_empresa__c = '12345';
		insert empresa;

		Account empresa2 = Build.anAccountEmpresa().build();
		insert empresa2;

		List<Sucursal__c> sucursales = new List<Sucursal__c>();

		for (Integer i = 1; i < 9; i++) {
			Sucursal__c suc = new Sucursal__c();
			suc.Codigo__c = String.valueOf(i);
			suc.Empresa__c = empresa.Id;

			sucursales.add(suc);
		}
		Sucursal__c suc1 = new Sucursal__c();
		suc1.Empresa__c = empresa.Id;
		sucursales.add(suc1);

		Sucursal__c suc2 = new Sucursal__c();
		suc2.Empresa__c = empresa2.Id;
		suc2.Codigo__c = '10';
		sucursales.add(suc2);

		insert sucursales;

	}

	@isTest
	private static void testName() {

		Test.startTest();
		BatchIdExternoSucursales myBatchObject = new BatchIdExternoSucursales(); 
		Id batchId = Database.executeBatch(myBatchObject);
		Test.stopTest();
    
		List<Sucursal__c> sucursalesQuery = [
			SELECT Id, Id_externo__c, Codigo__c, Empresa__r.Codigo_de_empresa__c FROM Sucursal__c WHERE Id_externo__c != null
		];

		for(Sucursal__c suc : sucursalesQuery) {
			String idExterno = suc.Empresa__r.Codigo_de_empresa__c + '-' + suc.Codigo__c;
			System.debug(suc.Id_externo__c);

			System.assertEquals(idExterno, suc.Id_externo__c);
		}
		// 2 no se actualizan porque uno no tiene codigo la sucursal y el otro no tiene codigo la empresa
		System.assertEquals(2, [SELECT count() FROM Sucursal__c WHERE Id_externo__c = null]);
		
	}

}