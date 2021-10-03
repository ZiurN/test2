@isTest 
private class CotizacionPrestadorTriggerTest {

	@isTest
	private static void testName() {
		Orden_de_Compra__c orden = new Orden_de_Compra__c();
		insert orden;
		
		Case caso = new Case();
		caso.Description = 'desc';
		caso.Orden_de_Compra__c = orden.Id;
		insert caso;
		
        //insert caso;
        //orden.Ap_orden__c = caso.Id;
		
		Prestacion__c prestacion = new Prestacion__c();
		prestacion.Ap__c = caso.Id;
		Prestacion__c prestacion2 = new Prestacion__c();
		prestacion2.Ap__c = caso.Id;
		List<Prestacion__c> prestacionList = new List<Prestacion__c>{ prestacion, prestacion2 };
		insert prestacionList;

		Cotizacion_Prestador__c cotiz = new Cotizacion_Prestador__c();
		cotiz.Orden_de_Compra__c = orden.Id;
		
		Test.startTest();
		insert cotiz;
		Test.stopTest();

		List<Presupuesto_de_Compra__c> presupuestosList = [
			SELECT Descripcion__c, Prestacion__c 
			FROM Presupuesto_de_Compra__c 
			WHERE Cotizacion_Prestador__c =: cotiz.Id
		];

		System.assertEquals(2, presupuestosList.size());
		System.assertEquals('desc', presupuestosList[0].Descripcion__c);
		System.assertEquals(prestacion.Id, presupuestosList[0].Prestacion__c);

		System.assertEquals('desc', presupuestosList[1].Descripcion__c);
		System.assertEquals(prestacion2.Id, presupuestosList[1].Prestacion__c);
	}
}