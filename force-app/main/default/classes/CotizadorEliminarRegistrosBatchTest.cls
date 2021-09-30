@IsTest
private class CotizadorEliminarRegistrosBatchTest {
    static testMethod void itShouldDeletesAllCotizacionRecordsIf7DaysHavePassedAndTheFlagCotizacionPruebaHasValueTrue() {
        Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Opportunity opp = new Opportunity(Name = 'asd',Nro_CBU_para_cobro_de_cuota__c='123456789',
			StageName='Contactado',CloseDate=System.today(), AccountId = acc.Id);
        insert opp;
        Cotizacion__c cot = new Cotizacion__c(Cotizacion_de_prueba__c = true,Oportunidad__c = opp.Id);
        insert cot;
        Datetime sevenDaysBefore = Datetime.now().addDays(-8);
        Test.setCreatedDate(cot.Id, sevenDaysBefore);
        Test.startTest();
        CotizadorEliminarRegistrosBatch batch = new CotizadorEliminarRegistrosBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        System.assertEquals(0,[SELECT COUNT() FROM Cotizacion__c]);

    }

    static testMethod void itShouldNotDeleteAllCotizacionRecordsIfLessThan7DaysHavePassedAndTheFlagCotizacionPruebaHasValueTrue() {
        Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Opportunity opp = new Opportunity(Name = 'asd',Nro_CBU_para_cobro_de_cuota__c='123456789',
			StageName='Contactado',CloseDate=System.today(), AccountId = acc.Id);
        insert opp;
        Cotizacion__c cot = new Cotizacion__c(Cotizacion_de_prueba__c = true,Oportunidad__c = opp.Id);
        insert cot;
        Datetime sevenDaysBefore = Datetime.now().addDays(-2);
        Test.setCreatedDate(cot.Id, sevenDaysBefore);
        Test.startTest();
        CotizadorEliminarRegistrosBatch batch = new CotizadorEliminarRegistrosBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        System.assertEquals(1,[SELECT COUNT() FROM Cotizacion__c]);

    }

    static testMethod void itShouldNotDeleteAllCotizacionRecordsIf7DaysHavePassedAndTheFlagCotizacionPruebaHasValueFalse() {
        Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		Opportunity opp = new Opportunity(Name = 'asd',Nro_CBU_para_cobro_de_cuota__c='123456789',
			StageName='Contactado',CloseDate=System.today(), AccountId = acc.Id);
        insert opp;
        Cotizacion__c cot = new Cotizacion__c(Cotizacion_de_prueba__c = false,Oportunidad__c = opp.Id);
        insert cot;
        Datetime sevenDaysBefore = Datetime.now().addDays(-8);
        Test.setCreatedDate(cot.Id, sevenDaysBefore);
        Test.startTest();
        CotizadorEliminarRegistrosBatch batch = new CotizadorEliminarRegistrosBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        System.assertEquals(1,[SELECT COUNT() FROM Cotizacion__c]);

    }

	static testMethod void checkTheBatchLogsObjects() {
        Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		
		Opportunity opp = new Opportunity(Name = 'asd',Nro_CBU_para_cobro_de_cuota__c='123456789',
			StageName='Contactado',CloseDate=System.today(), AccountId = acc.Id);
        insert opp;
        
		Cotizacion__c cot = new Cotizacion__c(Cotizacion_de_prueba__c = true,Oportunidad__c = opp.Id);
        insert cot;

		opp.Cotizacion_elegida__c = cot.Id;
		opp.StageName='Cotizado';
		update opp;

		opp.Segmento_del_Grupo_Familiar__c = 'VOLDIR';
		opp.Canal_de_contacto_Asesor_con_cliente__c = 'Telefono';
		opp.Estado_Civil__c = 'S';
		opp.StageName='En Negociación';
		update opp;
        
		Datetime sevenDaysBefore = Datetime.now().addDays(-8);
        Test.setCreatedDate(cot.Id, sevenDaysBefore);
        Test.startTest();
        CotizadorEliminarRegistrosBatch batch = new CotizadorEliminarRegistrosBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        //System.assertEquals(0,[SELECT COUNT() FROM Cotizacion__c]);

		Batch_log__c[] logs = [SELECT Id, Error__c, Id_registro_error__c FROM Batch_log__c];

		System.debug(logs);
		System.assertNotEquals(null, logs[0].Error__c);
		System.assertEquals(cot.Id, logs[0].Id_registro_error__c);

    }
}