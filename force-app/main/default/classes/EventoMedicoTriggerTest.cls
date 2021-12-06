@IsTest
private class EventoMedicoTriggerTest {
	private static final Webservice_endpoint_setting__mdt SERVICE_CONFIG = ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	private static final String AUTH_TOKEN_URL = SERVICE_CONFIG.URL__c + '/oauth/token';
	private static Map<String, Webservice_endpoint__mdt> endpointsEventosMedicos = ConfigUtils.getEndpointsByTipo('eventos-medicos');
	private static final String SEGUIMIENTO_URL = SERVICE_CONFIG.URL__c + endpointsEventosMedicos.get('seguimiento').Endpoint__c;
	private static XHttpCalloutMock getResponseFound;
    private static User medico;
	static {
		getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(AUTH_TOKEN_URL);
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEventoMedicoEnviarASSMock.getFound())
                .addForAddress(SEGUIMIENTO_URL);
        String uniqueUserName = 'standarduseremtriggertest' + DateTime.now().getTime() + '@testorg.com';
        Profile pMedico = [SELECT Id, Name FROM Profile WHERE Name = 'Auditor Medico'];
        medico = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
                LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
                UserName=uniqueUserName + 'Medico', ProfileId = pMedico.Id
        );
        insert medico;
	}
    @IsTest
    static void ifAnEventoMedicoIsAuthorizedItShouldNotAuthorizeTheRelatedCaseIfTheRecordTypeIsNotSeguimientoOrInternacion() {
        Evento_medico__c em = new Evento_medico__c();
        insert em;
        Case aCase = new Case(
			RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
            Evento_Medico__c = em.Id
		);
        insert aCase;
        Test.startTest();
        em.Estado__c = 'Autorizado';
        update em;
        Test.stopTest();
        Case updatedCase = [SELECT Id, Status FROM Case WHERE Id = :aCase.Id];
        System.assertEquals('CA-----G', updatedCase.Status , 'El estado debe ser CA-----G');
    }
	@IsTest
    static void assignDelegacionFromUserTest() {
        Account delegacion = new Account();
        delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
        delegacion.Name = 'Test';
        delegacion.Codigo_de_delegacion__c = '661089';
        insert  delegacion;
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
        User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
        );
        usuario.Codigo_delegacion__c = delegacion.Codigo_de_delegacion__c;
        insert usuario;
		User usuario2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser2@xappia.com'
        );
        usuario2.Codigo_delegacion__c = delegacion.Codigo_de_delegacion__c;
        insert usuario2;
		List<Evento_medico__c> ems = new List<Evento_medico__c> {
			new Evento_medico__c(OwnerId = usuario.Id),
			new Evento_medico__c(OwnerId = usuario2.Id),
			new Evento_medico__c(OwnerId = usuario2.Id)
		};
		Test.startTest();
		insert ems;
		Test.stopTest();
        List<Evento_medico__c> emsToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Evento_medico__c WHERE Id =: ems];
        for(Evento_medico__c emToAssert : emsToAssert) {
			System.assertEquals('661089', emToAssert.Delegacion__r.Codigo_de_delegacion__c, 'El código de delegación debe ser 661089');
		}
    }
    @IsTest
    static void ifTheDelegacionDoesNotExistInUserDoNotGiveError() {
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
        User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
        );
        usuario.Codigo_delegacion__c = '123456';
        insert usuario;
        Evento_medico__c em = new Evento_medico__c();
        System.runAs(usuario) {
            Test.startTest();
            insert em;
            Test.stopTest();
        }
        Evento_medico__c emToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Evento_medico__c WHERE Id =: em.Id];
        System.assertEquals(null, emToAssert.Delegacion__r.Codigo_de_delegacion__c, 'No debe haber un código de delegación');
    }
    @IsTest
    static void ifTheDelegacionIsNullInUserDoNotGiveError() {
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Back Administrativo'];
        User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='usertotestassignDelegacionFromUser@xappia.com'
        );
        insert usuario;
        Evento_medico__c em = new Evento_medico__c();
        System.runAs(usuario) {
            Test.startTest();
            insert em;
            Test.stopTest();
        }
        Evento_medico__c emToAssert = [SELECT Delegacion__r.Codigo_de_delegacion__c FROM Evento_medico__c WHERE Id =: em.Id];
        System.assertEquals(null, emToAssert.Delegacion__r.Codigo_de_delegacion__c,  'No debe haber un código de delegación');
    }
    @IsTest
    static void tryUpdateFormaDeEgresoWithFechaFinEMLessThanOrEqual_UpdateSuccess() {
        Boolean expectedExceptionThrown;
        Evento_medico__c em = new Evento_medico__c(
            Fecha_y_Hora_inicio_EMS__c = DateTime.now().addDays(-2),
            Fecha_y_hora_fin_ems__c = DateTime.now(),
            RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id
        );
        insert em;
        Case aCase = new Case(
            Evento_Medico__c = em.Id,
            Fecha__c = Date.today().addDays(-1)
        );
        insert aCase;
        Test.startTest();
            em.Forma_de_egreso__c = 'ALTA_MEDICA';
            update em;
        Test.stopTest();
        System.assertEquals('ALTA_MEDICA', em.Forma_de_egreso__c, 'La forma de egreso debe ser ALTA MEDICA');
    }
    @IsTest
    static void tryUpdateFormaDeEgresoWithFechaFinEMGreaterThanFechaDelCaso_UpdateSuccess() {
        Boolean expectedExceptionThrown;
        Evento_medico__c em = new Evento_medico__c(
            Fecha_y_Hora_inicio_EMS__c = DateTime.now().addDays(-2),
            Fecha_y_hora_fin_ems__c = DateTime.now(),
            RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id
        );
        insert em;
        Case aCase = new Case(
            Evento_Medico__c = em.Id,
            Fecha__c = Date.today().addDays(-1)
        );
        insert aCase;
        Test.startTest();
            em.Forma_de_egreso__c = 'ALTA_MEDICA';
            update em;
        Test.stopTest();
        System.assertEquals('ALTA_MEDICA', em.Forma_de_egreso__c, 'La forma de egreso debe ser ALTA MEDICA');
    }
    @IsTest
    static void tryUpdateFormaDeEgresoWithFechaFinEMLessThanOrEqualFechaDelCaso_UpdateFail() {
        String error;
        Evento_medico__c em = new Evento_medico__c(
            Fecha_y_Hora_inicio_EMS__c = DateTime.now().addDays(-2),
            Fecha_y_hora_fin_ems__c = DateTime.now(),
            RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id
        );
        insert em;
        Case aCase = new Case(
            Evento_Medico__c = em.Id,
            Fecha__c = Date.today()
        );
        insert aCase;
        Test.startTest();
        try{
            em.Forma_de_egreso__c = 'ALTA_MEDICA';
            update em;
        }catch(Exception e){
            error = e.getMessage();
        }
        Test.stopTest();
        Evento_medico__c eventoToAssert = [SELECT Forma_de_egreso__c FROM Evento_medico__c WHERE Id = :em.Id];
        System.assertEquals(null, eventoToAssert.Forma_de_egreso__c, 'No debe haber una forma de egreso');
        System.assert(error.contains(System.Label.Alerta_Trigger_EM_FechaCierreMenorAFechaCaso), 'El mensaje no indica el error esperado');
    }
	@IsTest
    static void whenFormaEgresoIsChanged_SendTheEMIToSS() {
		Evento_medico__c emi = new Evento_medico__c();
		emi.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
		emi.Nro_de_Evento_Medico_SS__c = '275751';
		insert emi;
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		emi.Forma_de_egreso__c = 'ALTA_MEDICA';
		emi.Fecha_y_hora_fin_ems__c = System.now();
		update emi;
		Test.stopTest();
		System.assertNotEquals(0, getResponseFound.callsMade, 'No deben haberse hecho ninguna llamada');
	}
	@IsTest
    static void whenFormaEgresoIsChanged_SendTheEMSToSS() {
		Evento_medico__c ems = new Evento_medico__c();
		ems.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		ems.Nro_de_Evento_Medico_SS__c = '275751';
		insert ems;
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		ems.Forma_de_egreso__c = 'ALTA_MEDICA';
		ems.Fecha_y_hora_fin_ems__c = System.now();
		update ems;
		Test.stopTest();
		System.assertNotEquals(0, getResponseFound.callsMade, 'No deben haberse hecho ninguna llamada');
	}
	@IsTest
    static void whenResultadoIsChanged_SendTheEMSToSS() {
		Evento_medico__c ems = new Evento_medico__c();
		ems.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		ems.Nro_de_Evento_Medico_SS__c = '275751';
        ems.Tipo__c = 'COVID';
		insert ems;
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		ems.Resultado__c = 'Positivo';
		update ems;
		Test.stopTest();
		System.assertNotEquals(0, getResponseFound.callsMade, 'No deben haberse hecho ninguna llamada');
	}
	@IsTest
    static void whenFormaEgresoIsChangedAndTheEMhasSegmentosWithoutClose_ShowErrorMsg() {
		Evento_medico__c ems = new Evento_medico__c();
		ems.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		ems.Nro_de_Evento_Medico_SS__c = '275751';
        ems.Tipo__c = 'COVID';
		insert ems;
		Segmentos__c seg = new Segmentos__c();
		seg.Evento_Medico__c = ems.Id;
		insert seg;
		Test.startTest();
		ems.Forma_de_egreso__c = 'ALTA_MEDICA';
		ems.Fecha_y_hora_fin_ems__c = System.now();
		Database.SaveResult res = Database.update(ems, false);
		Test.stopTest();
		System.assert(!res.isSuccess(), 'Debe haber un error');
		System.assertEquals(System.Label.Alerta_Trigger_EM_FaltanSegmentos, res.getErrors()[0].getMessage(), 'El mensaje no indica el error');
	}
    @IsTest
    static void whenNoUserAdminWantsDeleteAnEMShowError() {
        Database.DeleteResult result;
        Evento_medico__c em = new Evento_Medico__c();
        em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
        em.OwnerId = medico.Id;
        insert em;
        System.runAs(medico) {
            result = Database.delete(em, false);
        }
        System.assert(!result.isSuccess(), 'Debe haber un error');
        System.assertEquals(System.Label.Alerta_Trigger_EM_CantDeleteEM, result.getErrors()[0].getMessage(), 'El mensaje no indica el error');
    }
    @IsTest
    static void whenDiagnosticoIsChangedAndUserIsAuditorMedicoOrLider_SendTheEMIToSS() {
        System.runAs(medico) {
            Diagnostico__c diag1 = new Diagnostico__c();
            insert diag1;
            Diagnostico__c diag2 = new Diagnostico__c();
            insert diag2;
            Evento_medico__c emi = new Evento_medico__c();
            emi.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
            emi.Nro_de_Evento_Medico_SS__c = '275751';
            emi.Diagnostico__c = diag1.id;
            insert emi;
            Test.setMock(HttpCalloutMock.class, getResponseFound);
            Test.startTest();
            emi.Diagnostico__c = diag2.id;
            update emi;
            Test.stopTest();
            System.assertEquals(diag2.id, emi.Diagnostico__c, 'Los Ids no coinciden');
            System.assertNotEquals(0, getResponseFound.callsMade, 'No deben haberse hecho ninguna llamada');
        }
	}
	@IsTest
    static void whenDiagnosticoIsChangedAndUserIsAuditorMedicoOrLider_SendTheEMSToSS() {
        System.runAs(medico) {
            Diagnostico__c diag1 = new Diagnostico__c();
            insert diag1;
            Diagnostico__c diag2 = new Diagnostico__c();
            insert diag2;
            Evento_medico__c ems = new Evento_medico__c();
            ems.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
            ems.Nro_de_Evento_Medico_SS__c = '275751';
            ems.Diagnostico__c = diag1.id;
            insert ems;
            Test.setMock(HttpCalloutMock.class, getResponseFound);
            Test.startTest();
            ems.Diagnostico__c = diag2.id;
            update ems;
            Test.stopTest();
            System.assertEquals(diag2.id, ems.Diagnostico__c, 'Los Ids no coinciden');
            System.assertNotEquals(0, getResponseFound.callsMade, 'No deben haberse hecho ninguna llamada');
        }
	}
}