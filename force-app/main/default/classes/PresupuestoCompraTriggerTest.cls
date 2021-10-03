@isTest
public with sharing class PresupuestoCompraTriggerTest {
    @TestSetup public static void InitializeAllVars() {
        Orden_de_Compra__c orden = new Orden_de_Compra__c();
		orden.forma_de_Pago__c = 'Prestador';
        insert orden;

        Cotizacion_Prestador__c cotiz = new Cotizacion_Prestador__c();
        cotiz.orden_de_Compra__c = orden.Id;
        insert cotiz;

        Presupuesto_de_Compra__c pres = new Presupuesto_de_Compra__c();
        pres.Importe_unitario__c = 50;
        pres.Importe_mejorado__c = 0;
        pres.Cargo_al_socio__c = 0;
        pres.Cotizacion_Prestador__c = cotiz.Id;
        insert pres;
    }
   
    @isTest public static void removerPresupuestoDeberiaRestarLosValoresALaCotizacion() {
       List<Cotizacion_Prestador__c> cotiz = [SELECT id FROM Cotizacion_Prestador__c LIMIT 1];
        System.AssertEquals(1, cotiz.Size(), 'La cotizacion prestador no se agrega en el init.');

        List<Presupuesto_de_compra__c> pres = [SELECT id FROM Presupuesto_de_compra__c WHERE Cotizacion_Prestador__c = :cotiz[0].Id];
        System.AssertEquals(1, pres.Size(),'La cotizacion de compra no esta siendo correctamente asignada.');

        Test.startTest();
        Delete pres;
        Test.stopTest();
        
        pres = [SELECT id FROM Presupuesto_de_compra__c WHERE Cotizacion_Prestador__c = :cotiz[0].Id];
        System.AssertEquals(0, pres.Size(),'La cotizacion de compra no esta siendo correctamente desasignada.');

        List<Cotizacion_Prestador__c> cotizUpdated = [SELECT Id, Total_Presupuesto__c, Total_mejorado__c, Total_Socio__c  FROM Cotizacion_Prestador__c LIMIT 1];
        System.AssertEquals(0, cotizUpdated[0].Total_Presupuesto__c,'El campo "Total_Presupuesto__c" no esta actualizando su valor en la cotizacion.');
        System.AssertEquals(0, cotizUpdated[0].Total_Mejorado__c,'El campo "Total_Mejorado__c" no esta actualizando su valor en la cotizacion.');
        System.AssertEquals(0, cotizUpdated[0].Total_Socio__c,'El campo "Total_Socio__c" no esta actualizando su valor en la cotizacion.');
    }

    @isTest public static void modificarPresupuestoDeberiaRecalcularLosValoresALaCotizacion() {
        List<Cotizacion_Prestador__c> cotiz = [SELECT id FROM Cotizacion_Prestador__c LIMIT 1];
        System.AssertEquals(1, cotiz.Size(), 'La cotizacion prestador no se agrega en el init.');
        
        List<Presupuesto_de_compra__c> pres = [SELECT id, Importe_unitario__c, Importe_mejorado__c, Cargo_al_socio__c FROM Presupuesto_de_compra__c WHERE Cotizacion_Prestador__c = :cotiz[0].Id];
        System.AssertEquals(1, pres.Size(),'La cotizacion de compra no esta siendo correctamente asignada.');
        
        pres[0].Importe_unitario__c = 0;
        pres[0].Importe_mejorado__c = 200;
        pres[0].Cargo_al_socio__c = 500;

        Test.startTest();
        update pres;
        Test.stopTest();
        List<Cotizacion_Prestador__c> cotizUpdated = [SELECT Id, Total_Presupuesto__c, Total_mejorado__c, Total_Socio__c  FROM Cotizacion_Prestador__c LIMIT 1];
        
        System.AssertEquals(0, cotizUpdated[0].Total_Presupuesto__c,'El campo "Total_Presupuesto__c" no esta actualizando su valor en la cotizacion.');
        System.AssertEquals(200, cotizUpdated[0].Total_Mejorado__c,'El campo "Total_Mejorado__c" no esta actualizando su valor en la cotizacion.');
        System.AssertEquals(500, cotizUpdated[0].Total_Socio__c,'El campo "Total_Socio__c" no esta actualizando su valor en la cotizacion.');
    }

	@isTest public static void modificarPresupuestoDeberiaRecalcularLosValoresALaCotizacionConVariosPresupuestos() {
        List<Cotizacion_Prestador__c> cotiz = [SELECT id FROM Cotizacion_Prestador__c LIMIT 1];
        System.AssertEquals(1, cotiz.Size(), 'La cotizacion prestador no se agrega en el init.');
        
        List<Presupuesto_de_compra__c> pres = [SELECT id, Importe_unitario__c, Importe_mejorado__c, Cargo_al_socio__c FROM Presupuesto_de_compra__c WHERE Cotizacion_Prestador__c = :cotiz[0].Id];
        System.AssertEquals(1, pres.Size(),'La cotizacion de compra no esta siendo correctamente asignada.');
        
        pres[0].Importe_unitario__c = 0;
        pres[0].Importe_mejorado__c = 200;
        pres[0].Cargo_al_socio__c = 500;

		Presupuesto_de_Compra__c pres2 = new Presupuesto_de_Compra__c();
        pres2.Importe_unitario__c = 1000;
        pres2.Importe_mejorado__c = 500;
        pres2.Cargo_al_socio__c = 50;
        pres2.Cotizacion_Prestador__c = cotiz[0].Id;
        insert pres2;

        Test.startTest();
        update pres;
        Test.stopTest();
        List<Cotizacion_Prestador__c> cotizUpdated = [SELECT Id, Total_Presupuesto__c, Total_mejorado__c, Total_Socio__c  FROM Cotizacion_Prestador__c LIMIT 1];
        
        System.AssertEquals(1000, cotizUpdated[0].Total_Presupuesto__c,'El campo "Total_Presupuesto__c" no esta actualizando su valor en la cotizacion.');
        System.AssertEquals(700, cotizUpdated[0].Total_Mejorado__c,'El campo "Total_Mejorado__c" no esta actualizando su valor en la cotizacion.');
        System.AssertEquals(550, cotizUpdated[0].Total_Socio__c,'El campo "Total_Socio__c" no esta actualizando su valor en la cotizacion.');
    }
}