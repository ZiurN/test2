@IsTest
private class CotizacionTriggerTest  {

	@IsTest
	private static void copyLocIdWhenANewCotizacionIsCreated(){
		Localidad__c loc = new Localidad__c(Loc_Id__c='123',Codigo_Postal__c ='123ABC');
		insert loc;
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Opportunity op = Build.anOpportunityIndividuos().build();
		op.AccountId = acc.Id;
		insert op;
		Cotizacion__c coti = new Cotizacion__c(CP__c='123ABC',Oportunidad__c = op.Id,Localidad_new__c = loc.Id);
		Test.startTest();
		insert coti;
		Test.stopTest();
		Cotizacion__c updatedCot = [SELECT LocId__c FROM Cotizacion__c WHERE Id = :coti.Id];
		System.assertEquals(loc.Loc_Id__c,updatedCot.LocId__c);
	}

		@IsTest
	private static void copyLocIdWhenACotizacionIsUpdated(){
		Localidad__c loc = new Localidad__c(Loc_Id__c='123',Codigo_Postal__c ='123ABC');
		insert loc;
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Opportunity op = Build.anOpportunityIndividuos().build();
		op.AccountId = acc.Id;
		insert op;
		Cotizacion__c coti = new Cotizacion__c(Oportunidad__c = op.Id,Localidad_new__c = loc.Id);
		insert coti;
		coti.CP__c = '123ABC';
		Test.startTest();
		update coti;
		Test.stopTest();
		Cotizacion__c updatedCot = [SELECT LocId__c FROM Cotizacion__c WHERE Id = :coti.Id];
		System.assertEquals(loc.Loc_Id__c,updatedCot.LocId__c);
	}

	@isTest
	private static void copyDiferenciaAPagarToOpportunityAmountWhenUpdated(){
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Opportunity op = Build.anOpportunityIndividuos().build();
		op.AccountId = acc.Id;
		insert op;
		Cotizacion__c coti = new Cotizacion__c(Oportunidad__c = op.Id);
		coti.RecordTypeId = XappiaHelper.getRecordType('Cotizacion__c','Cotizacion_Individual').Id;
		insert coti;

		op.Cotizacion_elegida__c = coti.Id;
		update op;

		coti.Diferencia_a_pagar__c = '1919';

		Test.startTest();
		update coti;
		Test.stopTest();

		List<Opportunity> oppToAssert = [SELECT Id, Amount FROM Opportunity WHERE Id =: op.Id];

		System.assertEquals(1919, oppToAssert[0].Amount);
	}

	@isTest
	private static void copyDiferenciaAPagarToOpportunityAmountWhenUpdatedWithNullValue(){
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Opportunity op = Build.anOpportunityIndividuos().build();
		op.AccountId = acc.Id;
		insert op;
		Cotizacion__c coti = new Cotizacion__c(Oportunidad__c = op.Id);
		coti.RecordTypeId = XappiaHelper.getRecordType('Cotizacion__c','Cotizacion_Individual').Id;
		insert coti;

		coti.Diferencia_a_pagar__c = null;

		Test.startTest();
		update coti;
		Test.stopTest();

		List<Opportunity> oppToAssert = [SELECT Id, Amount FROM Opportunity WHERE Id =: op.Id];

		System.assertEquals(null, oppToAssert[0].Amount);
	}

	@isTest
	private static void validationTest(){
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Opportunity op = Build.anOpportunityIndividuos().build();
		op.AccountId = acc.Id;
		insert op;
		Cotizacion__c coti = new Cotizacion__c(Oportunidad__c = op.Id);
		coti.RecordTypeId = XappiaHelper.getRecordType('Cotizacion__c','Cotizacion_Individual').Id;
		coti.Tipo_de_afiliado__c = 'Relacion de dependencia';
		coti.Tipo_de_contacto__c = '1';
		coti.Sueldo_bruto__c = 50000;
		coti.Monotributista_conyuge__c = 'Si';
		coti.Grupo_de_potencialidad__c = true;
		coti.Aporta_por_hijos__c = 'Si';
		coti.Hijos_entre_21_y_25_aos__c = 24;
		coti.Hijos_hasta_20_aos__c = 1;
		coti.Edad_conyuge__c = 120;

		Cotizacion__c coti2 = new Cotizacion__c(Oportunidad__c = op.Id);
		coti2.RecordTypeId = XappiaHelper.getRecordType('Cotizacion__c','Cotizacion_Individual').Id;
		coti2.Tipo_de_afiliado__c = 'Voluntario';
		coti2.Tipo_de_contacto__c = '1';
		coti2.Sueldo_bruto__c = 50000;
		coti2.Monotributista_conyuge__c = 'Si';
		coti2.Grupo_de_potencialidad__c = true;
		coti2.Aporta_por_hijos__c = 'Si';
		coti2.Hijos_entre_21_y_25_aos__c = 24;
		coti2.Hijos_hasta_20_aos__c = 1;
		coti2.Edad_conyuge__c = 120;

		Cotizacion__c coti3 = new Cotizacion__c(Oportunidad__c = op.Id);
		coti3.RecordTypeId = XappiaHelper.getRecordType('Cotizacion__c','Cotizacion_Individual').Id;
		coti3.Tipo_de_afiliado__c = 'Monotributista';
		coti3.Tipo_de_contacto__c = '1';
		coti3.Sueldo_bruto__c = 50000;
		coti3.Monotributista_conyuge__c = 'Si';
		coti3.Grupo_de_potencialidad__c = true;
		coti3.Aporta_por_hijos__c = 'Si';
		coti3.Hijos_entre_21_y_25_aos__c = 24;
		coti3.Hijos_hasta_20_aos__c = 1;
		coti3.Edad_conyuge__c = 120;

		Test.startTest();
		Database.SaveResult res = Database.insert(coti,false);
		Database.SaveResult res2 = Database.insert(coti2,false);
		Database.SaveResult res3 = Database.insert(coti3,false);
		Test.stopTest();

		System.assertEquals(false, res.isSuccess());
		System.assertEquals(false, res2.isSuccess());
		System.assertEquals(false, res3.isSuccess());
	}

}