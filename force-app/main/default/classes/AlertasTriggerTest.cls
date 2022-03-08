@IsTest
private class AlertasTriggerTest {
    @IsTest
    static void whenAnyAlertIsNotFinishedItShouldNotCheckApAutorizadaFieldOnTheAP() {
        Case caseTest = new Case();
        insert caseTest;
        Prestacion__c prestTest = new Prestacion__c(Ap__c = caseTest.Id);
        insert prestTest;
        Prestacion__c prestTest2 = new Prestacion__c(Ap__c = caseTest.Id);
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion__c = prestTest.Id,Estado__c='C1EA-RAA');
        Alerta__c alert2 = new Alerta__c(Prestacion__c = prestTest.Id);
        Alerta__c alert3 = new Alerta__c(Prestacion__c = prestTest2.Id);
        insert alert1;
        insert alert2;
        insert alert3;
        Test.startTest();
        alert3.Estado__c = 'C1EA--AA';
        update alert3;
        Test.stopTest();
        System.assertEquals(false,[SELECT Id,Ap_autorizada__c FROM Case WHERE Id = :caseTest.Id].Ap_autorizada__c);
    }
	@IsTest
    static void whenAllAlertsAreRefusedItShouldCheckApRechazadaFieldOnTheAP() {
        Case caseTest = new Case();
		caseTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
        insert caseTest;
        Prestacion__c prestTest = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA-RAA');
        insert prestTest;
        Prestacion__c prestTest2 = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA-RAA');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion__c = prestTest.Id,Estado__c='C1EA-RAA');
        insert alert1;
		Alerta__c alert2 = new Alerta__c(Prestacion__c = prestTest.Id,Estado__c='C1EA-RAA');
        insert alert2;
		Alerta__c alert3 = new Alerta__c(Prestacion__c = prestTest2.Id);
        insert alert3;
		Test.startTest();
        alert3.Estado__c = 'C1EA-RAA';
        update alert3;
        Test.stopTest();
		caseTest = [SELECT Caso_Rechazado__c, Status,Derivacion_de_lote__c FROM Case WHERE Id = :caseTest.Id];
        System.assertEquals(true, caseTest.Caso_Rechazado__c);
        System.assertEquals('Rechazado', caseTest.Status);
    }
	@IsTest
	static void whenPrestacionHaveNoRelationshipWithApDontDoNothing() {
		Prestacion__c prestTest = new Prestacion__c(Estado__c = 'C1EA-RAA');
        insert prestTest;
		Alerta__c alert1 = new Alerta__c(Prestacion__c = prestTest.Id);
        insert alert1;
		Test.startTest();
        alert1.Estado__c = 'C1EA-RAA';
        update alert1;
		Test.stopTest();
		// Solo se hace para el porcentaje de cobertura, por eso no hay ningun assert
	}
	@IsTest
	static void whenPrestacionHaveNoRelationshipWithReintegroDontDoNothing() {
		Prestacion_de_reintegro__c prestTest = new Prestacion_de_reintegro__c(Estado__c = 'C1EA-RAA');
        insert prestTest;
		Alerta__c alert1 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id);
        insert alert1;

		Test.startTest();
        alert1.Estado__c = 'C1EA-RAA';
        update alert1;
		Test.stopTest();
		// Solo se hace para el porcentaje de cobertura, por eso no hay ningun assert
	}
	@IsTest
    static void whenAllAlertsAreRefusedItShouldCheckApRechazadaFieldOnTheReintegro() {
        Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
        insert reintegro;
        Prestacion_de_reintegro__c prestTest = new Prestacion_de_reintegro__c(Caso__c = reintegro.Id, Estado__c = 'C1EA-RAA');
        insert prestTest;
        Prestacion_de_reintegro__c prestTest2 = new Prestacion_de_reintegro__c(Caso__c = reintegro.Id, Estado__c = 'C1EA-RAA');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id, Estado__c='C1EA-RAA');
        insert alert1;
		Alerta__c alert2 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id, Estado__c='C1EA-RAA');
        insert alert2;
		Alerta__c alert3 = new Alerta__c(Prestacion_de_reintegro__c = prestTest2.Id);
        insert alert3;
		Test.startTest();
        alert3.Estado__c = 'C1EA-RAA';
        update alert3;
        Test.stopTest();
		reintegro = [SELECT Caso_Rechazado__c, Status FROM Case WHERE Id = :reintegro.Id];
        System.assertEquals(true, reintegro.Caso_Rechazado__c);
		System.assertEquals('Rechazado', reintegro.Status);
    }
	@IsTest
    static void whenAllAlertsAMAreResolvedItShouldCheckSinAlertasAMPendientesOnCase() {
        Case caseTest = new Case();
		caseTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		caseTest.Correo_asociado__c = 'ej@test.com';
        insert caseTest;
        Prestacion__c prestTest = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest;
        Prestacion__c prestTest2 = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion__c = prestTest.Id, Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c alert2 = new Alerta__c(Prestacion__c = prestTest.Id,Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c alert3 = new Alerta__c(Prestacion__c = prestTest2.Id, Funcion__c = 'AM');
        insert alert1;
        insert alert2;
        insert alert3;
        Test.startTest();
        alert3.Estado__c = 'C1EA--AA';
        update alert3;
        Test.stopTest();
		Case aCase = [SELECT Id, Sin_alertas_AM_pendientes__c FROM Case WHERE Id = :caseTest.Id];
        System.assert(aCase.Sin_alertas_AM_pendientes__c);
    }
	@IsTest
    static void whenAllAlertsAMAreNotResolvedItShouldNotCheckSinAlertasAMPendientesOnCase() {
        Case caseTest = new Case();
		caseTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		caseTest.Correo_asociado__c = 'ej@test.com';
        insert caseTest;
        Prestacion__c prestTest = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest;
        Prestacion__c prestTest2 = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion__c = prestTest.Id, Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c alert2 = new Alerta__c(Prestacion__c = prestTest.Id, Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c alert3 = new Alerta__c(Prestacion__c = prestTest2.Id, Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c[] alerts = new List<Alerta__c>{alert1, alert2, alert3};
		insert alerts;
        Test.startTest();
        alert3.Estado__c = 'C1-----A';
        update alert3;
        Test.stopTest();
		Case aCase = [SELECT Id, Sin_alertas_AM_pendientes__c FROM Case WHERE Id = :caseTest.Id];
        System.assert(!aCase.Sin_alertas_AM_pendientes__c);
    }
	@IsTest
    static void whenAllAlertsAMAreResolvedItShouldCheckSinAlertasAMPendientesOnCaseReintegro() {
        Case caseTest = new Case();
		caseTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		caseTest.Correo_asociado__c = 'ej@test.com';
        insert caseTest;
        Prestacion_de_reintegro__c prestTest = new Prestacion_de_reintegro__c(Caso__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest;
        Prestacion_de_reintegro__c prestTest2 = new Prestacion_de_reintegro__c(Caso__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id, Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c alert2 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id,Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c alert3 = new Alerta__c(Prestacion_de_reintegro__c = prestTest2.Id, Funcion__c = 'AM');
        insert alert1;
        insert alert2;
        insert alert3;
        Test.startTest();
        alert3.Estado__c = 'C1EA--AA';
        update alert3;
        Test.stopTest();
		Case aCase = [SELECT Id, Sin_alertas_AM_pendientes__c FROM Case WHERE Id = :caseTest.Id];
        System.assert(aCase.Sin_alertas_AM_pendientes__c);
    }
	@IsTest
    static void whenAllAlertsAMAreNotResolvedItShouldNotCheckSinAlertasAMPendientesOnCaseReintegro() {
        Case caseTest = new Case();
		caseTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		caseTest.Correo_asociado__c = 'ej@test.com';
        insert caseTest;
        Prestacion_de_reintegro__c prestTest = new Prestacion_de_reintegro__c(Caso__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest;
        Prestacion_de_reintegro__c prestTest2 = new Prestacion_de_reintegro__c(Caso__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id, Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c alert2 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id, Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c alert3 = new Alerta__c(Prestacion_de_reintegro__c = prestTest2.Id, Estado__c='C1EA--AA', Funcion__c = 'AM');
        Alerta__c[] alerts = new List<Alerta__c>{alert1, alert2, alert3};
		insert alerts;
        Test.startTest();
        alert3.Estado__c = 'C1-----A';
        update alert3;
        Test.stopTest();
		Case aCase = [SELECT Id, Sin_alertas_AM_pendientes__c FROM Case WHERE Id = :caseTest.Id];
        System.assert(!aCase.Sin_alertas_AM_pendientes__c);
    }
    @IsTest
    static void whenNextAlertInAPrestacionIsDiscaIDCheckAlertasDiscaIDPendientesOnCase() {
        Case caseTest = new Case();
		caseTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		caseTest.Correo_asociado__c = 'ej@test.com';
        insert caseTest;
        Prestacion__c prestTest = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest;
        Prestacion__c prestTest2 = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion__c = prestTest.Id, Estado__c='C1-----A', Funcion__c = 'FCION_FRONT', Nivel_de_auditoria__c = 1);
        Alerta__c alert2 = new Alerta__c(Prestacion__c = prestTest.Id, Estado__c='C1-----A', Funcion__c = 'FCION_ID', Nivel_de_auditoria__c = 2);
        Alerta__c alert3 = new Alerta__c(Prestacion__c = prestTest2.Id, Estado__c='C1-----A', Funcion__c = 'FCION_FRONT', Nivel_de_auditoria__c = 1);
        Alerta__c alert4 = new Alerta__c(Prestacion__c = prestTest2.Id, Estado__c='C1-----A', Funcion__c = 'FCION_DISCA', Nivel_de_auditoria__c = 2);
        insert alert1;
        insert alert2;
        insert alert3;
        insert alert4;
		caseTest = [SELECT Alertas_disca_ID_pendientes__c FROM Case WHERE Id = :caseTest.Id];
		System.debug(caseTest);
        Test.startTest();
        alert1.Estado__c = 'C1EA--AA';
        update alert1;
        Test.stopTest();
		Case aCase = [SELECT Id, Alertas_disca_ID_pendientes__c, Alertas_disca_pendientes__c FROM Case WHERE Id = :caseTest.Id];
        System.assert(aCase.Alertas_disca_ID_pendientes__c);
        System.assert(!aCase.Alertas_disca_pendientes__c);
    }
    @IsTest
    static void whenAlertDiscaIdIsAuthorizedUnCheckAlertasDiscaIDPendientesOnCase() {
        Case caseTest = new Case();
		caseTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		caseTest.Correo_asociado__c = 'ej@test.com';
		caseTest.Alertas_disca_ID_pendientes__c = true;
        insert caseTest;
        Prestacion__c prestTest = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest;
        Prestacion__c prestTest2 = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion__c = prestTest.Id, Estado__c='C1EA--AA', Funcion__c = 'FCION_FRONT', Nivel_de_auditoria__c = 1);
        Alerta__c alert2 = new Alerta__c(Prestacion__c = prestTest.Id, Estado__c='C1-----A', Funcion__c = 'FCION_ID', Nivel_de_auditoria__c = 2);
        insert alert1;
        insert alert2;
		caseTest = [SELECT Alertas_disca_ID_pendientes__c FROM Case WHERE Id = :caseTest.Id];
		System.debug(caseTest);
        Test.startTest();
        alert2.Estado__c = 'C1EA--AA';
        update alert2;
        Test.stopTest();
		Case aCase = [SELECT Id, Alertas_disca_ID_pendientes__c FROM Case WHERE Id = :caseTest.Id];
        System.assert(!aCase.Alertas_disca_ID_pendientes__c);
    }
	@IsTest
    static void whenNextAlertsIsDiscaCheckAlertasDiscaPendientesOnCase() {
        Case caseTest = new Case();
		caseTest.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		caseTest.Correo_asociado__c = 'ej@test.com';
        insert caseTest;
        Prestacion__c prestTest = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest;
        Prestacion__c prestTest2 = new Prestacion__c(Ap__c = caseTest.Id, Estado__c = 'C1EA--AA');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion__c = prestTest.Id, Estado__c='C1-----A', Funcion__c = 'FCION_FRONT', Nivel_de_auditoria__c = 1);
        Alerta__c alert2 = new Alerta__c(Prestacion__c = prestTest.Id, Estado__c='C1-----A', Funcion__c = 'FCION_ID', Nivel_de_auditoria__c = 2);
        Alerta__c alert3 = new Alerta__c(Prestacion__c = prestTest2.Id, Estado__c='C1-----A', Funcion__c = 'FCION_DISCA', Nivel_de_auditoria__c = 2);
        Alerta__c[] alertas = new List<Alerta__c>{alert1, alert2, alert3};
        Test.startTest();
        insert alertas;
        Test.stopTest();
		Case aCase = [SELECT Id, Alertas_disca_ID_pendientes__c, Alertas_disca_pendientes__c FROM Case WHERE Id = :caseTest.Id];
        System.assert(aCase.Alertas_disca_pendientes__c);
        System.assert(!aCase.Alertas_disca_ID_pendientes__c);
    }
    @isTest
    public static void whenThePrestacionAssociateToACaseReintegroItsAutorizeShouldAutorizeTheCase(){
        Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
        insert reintegro;
        Prestacion_de_reintegro__c prestTest = new Prestacion_de_reintegro__c(Caso__c = reintegro.Id, Estado__c = 'C1----AS');
        insert prestTest;
        Prestacion_de_reintegro__c prestTest2 = new Prestacion_de_reintegro__c(Caso__c = reintegro.Id, Estado__c = 'C1----AS');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id, Estado__c='C1----AS');
        insert alert1;
		Alerta__c alert2 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id, Estado__c='C1----AS');
        insert alert2;
		Alerta__c alert3 = new Alerta__c(Prestacion_de_reintegro__c = prestTest2.Id);
        insert alert3;
		Test.startTest();
        alert3.Estado__c = 'C1EA--AA';
        update alert3;
        Test.stopTest();
		reintegro = [SELECT Caso_Rechazado__c, Status,	Derivacion_de_lote__c FROM Case WHERE Id = :reintegro.Id];
        System.assertEquals(false, reintegro.Caso_Rechazado__c);
		System.assertEquals('Autorizada', reintegro.Status);
    }
	@IsTest
    static void whenAllAlertsAreRefusedItShouldChangeTheLoteDerivacionInTheReintegro() {
        Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
        insert reintegro;
        Prestacion_de_reintegro__c prestTest = new Prestacion_de_reintegro__c(Caso__c = reintegro.Id, Estado__c = 'C1---RSA');
        insert prestTest;
        Prestacion_de_reintegro__c prestTest2 = new Prestacion_de_reintegro__c(Caso__c = reintegro.Id, Estado__c = 'C1---RSP');
        insert prestTest2;
        Alerta__c alert1 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id, Estado__c='C1EA-RAA');
        insert alert1;
		Alerta__c alert2 = new Alerta__c(Prestacion_de_reintegro__c = prestTest.Id, Estado__c='C1EA-RAA');
        insert alert2;
		Alerta__c alert3 = new Alerta__c(Prestacion_de_reintegro__c = prestTest2.Id);
        insert alert3;
		Test.startTest();
        alert3.Estado__c = 'C1EA-RAP';
        update alert3;
        Test.stopTest();
		reintegro = [SELECT Caso_Rechazado__c, Status,Derivacion_de_lote__c,Lote__c FROM Case WHERE Id = :reintegro.Id];
        System.debug('caso test ' + reintegro);
        System.assertEquals(true, reintegro.Caso_Rechazado__c);
		System.assertEquals('Rechazado', reintegro.Status);
    }
}