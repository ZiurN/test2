@IsTest
private class EventoMedicoAnularBtnCtrlTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
	static User usuario;

    static {
		
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName, ProfileId = p.Id, UserRole = role, Codigo_delegacion__c='650098');
		insert usuario;

        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEventoMedicoAnularMock.getFound())
                .addForAddress(WSEventoMedicoAnular.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/249818/anular');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSEventoMedicoAnularMock.getError())
                .addForAddress(WSEventoMedicoAnular.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/249818/anular');
    }

    @IsTest
    static void anularEMTest() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '249818', Estado__c = 'En Auditoria');
        insert em;
        Case caso = new Case(Evento_Medico__c = em.Id, Status = 'CA-----G');
        insert caso;


        Test.startTest();
        EventoMedicoAnularBtnCtrl.Response resp = EventoMedicoAnularBtnCtrl.anularEM(em.Id);
        Test.stopTest();

        Evento_medico__c emToAssert = [SELECT Estado__c, (
                SELECT Status FROM Casos__r
        )
        FROM Evento_medico__c
        WHERE Nro_de_Evento_Medico_SS__c = '249818'];

        System.assertEquals(false, resp.hasError);
        System.assertEquals('Anulado', emToAssert.Estado__c);
        System.assertEquals('CA-----N', emToAssert.Casos__r[0].Status);
    }

	@IsTest
    static void anularEMWhenExternalIdIsNull() {
        Evento_medico__c em = new Evento_medico__c(Estado__c = 'En Auditoria');
        insert em;

        Case caso = new Case(Evento_Medico__c = em.Id, Status = 'CA-----G');
        insert caso;

        Test.startTest();
        EventoMedicoAnularBtnCtrl.Response resp = EventoMedicoAnularBtnCtrl.anularEM(em.Id);
        Test.stopTest();

        Evento_medico__c emToAssert = [SELECT Estado__c, (
                SELECT Status FROM Casos__r
        )
        FROM Evento_medico__c
        WHERE Id = :em.Id];

        System.assertEquals(false, resp.hasError);
        System.assertEquals('Anulado', emToAssert.Estado__c);
        System.assertEquals('CA-----N', emToAssert.Casos__r[0].Status);
    }

    @IsTest
    static void showTheCorrectMessageWhenTheResponseHasError() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '249818');
        insert em;

        Test.startTest();
        EventoMedicoAnularBtnCtrl.Response resp = EventoMedicoAnularBtnCtrl.anularEM(em.Id);
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
        System.assertEquals('El evento médico solicitado es inválido.', resp.message);
    }

	@isTest
    private static void whenTheUserIsNotTheOwnerOfAnEM_ShowErrorMessage() {
		Evento_medico__c em = new Evento_medico__c();
        em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		em.Nro_de_Evento_Medico_SS__c = '249818';
		insert em;

		EventoMedicoAnularBtnCtrl.Response resp;
		System.runAs(usuario) {
			Test.startTest();
			resp = EventoMedicoAnularBtnCtrl.anularEM(em.Id);
			Test.stopTest();
		}

		System.assertEquals('El usuario no es el propietario', resp.message);
	}
}