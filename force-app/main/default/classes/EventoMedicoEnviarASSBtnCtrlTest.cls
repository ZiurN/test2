@IsTest
private class EventoMedicoEnviarASSBtnCtrlTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getResponseFoundEMI;
    static XHttpCalloutMock getErrorResponse;
	static User usuario;
	static Nomenclador_de_Prestacion__c nom;
	static Nomenclador_de_Prestacion__c nom2;

    static {
		
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName, ProfileId = p.Id, UserRole = role, Codigo_delegacion__c='650098');
		insert usuario;

		nom = new Nomenclador_de_Prestacion__c();
		nom.Codigo__c = '02430199';
		nom.Contexto__c = 'A';
		nom.Tipo_Nomenclador__c = 'N';
		nom.Estado__c = 'A';
		insert nom;

		nom2 = new Nomenclador_de_Prestacion__c();
		nom2.Codigo__c = '02503102';
		nom2.Contexto__c = 'A';
		nom2.Tipo_Nomenclador__c = 'N';
		nom2.Estado__c = 'A';
		insert nom2;

        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEventoMedicoEnviarASSMock.getFound())
                .addForAddress(WSEventoMedicoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/seguimiento');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAPGenerarCentroMock.getArchivos())
                .addForAddress(WSCaseEnviarASSHelper.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');

        getResponseFoundEMI = new XHttpCalloutMock();
        getResponseFoundEMI.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFoundEMI.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEventoMedicoEnviarASSMock.getFoundEMI())
                .addForAddress(WSEventoMedicoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos');
        getResponseFoundEMI.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAPGenerarCentroMock.getArchivos())
                .addForAddress(WSCaseEnviarASSHelper.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');
    }

    @isTest
    private static void whenAnEMSIsSentToSSWithCorrectData_ItShouldReturnAValidResponse() {
        Account agencia = new Account(RecordTypeId = XappiaHelper.getRecordType('Account','Delegacion').Id);
        agencia.Name = 'agenciaTest';
        agencia.Codigo_de_delegacion__c = '650098';
        agencia.Type = 'Agencia';
        insert agencia;

        //Consultorio__c consultorio = new Consultorio__c();
        //consultorio.Secuencia__c = 1;
        //insert consultorio;

        Account efector = new Account(RecordTypeId = XappiaHelper.getRecordType('Account','Efector').Id);
        efector.Name = 'Efector Test';
        efector.Es_Profesional__c = true;
        efector.Codigo_de_efector__c = '753415';
        efector.Estado__c = 'A';
        insert efector;

		Account prestador = new Account(RecordTypeId = XappiaHelper.getRecordType('Account','Efector').Id);
		prestador.Name = 'Prestador Test';
		prestador.Es_Prestador__c = true;
		prestador.Codigo_de_efector__c = '700076';
		insert prestador;

        Account afiliado = Build.anAccountCuentapersonal().build();
        afiliado.Codigo_de_Afiliado__c = '46940/16';
        insert afiliado;

        Diagnostico__c diag = new Diagnostico__c();
        diag.Codigo_del_Diagnostico__c = '999';
        insert diag;

        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Evento_medico__c em = new Evento_medico__c();
        em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
        em.Asociado__c = afiliado.Id;
        em.Fecha_y_Hora_inicio_EMS__c = datetime.newInstance(2019, 12, 04);
        em.Tipo__c = 'LECHES';
		//em.Subtipo__c = '';
        em.Fecha_de_Vencimiento_Certificado__c = Date.newInstance(2019,12,1);
        em.Diferido__c = 'Si';
        em.Diagnostico__c = diag.Id;
        em.Sin_complicaciones__c = '1';
        em.Efector_Solicitante__c = efector.Id;
		em.Prestador__c = prestador.Id;
        //em.Consultorio__c = consultorio.Id;
        em.Descripcion__c = 'Descripción asd';
        em.Delegacion__c = agencia.Id;
        em.Observaciones__c = 'Sin observaciones';
        em.Mail__c = 'sa@assa.com';
        em.Domicilio_Entrega__c = 'Agencia';
        em.Via_Entrega__c = 'DROGUERIA';
		em.OwnerId = usuario.Id;
        insert em;

		ContentVersion contentVersion = new ContentVersion(
			Title = 'Test',
			PathOnClient = 'testEnviarEMS.pdf',
			VersionData = Blob.valueOf('Test Content'),
			IsMajorVersion = true
		);
		insert contentVersion;    
		
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = em.Id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		insert cdl;

		EventoMedicoEnviarASSBtnCtrl.Response responseToAssert;
		System.runAs(usuario) {
			Test.startTest();
			//EventoMedicoEnviarASSBtnCtrl.Response responseToAssert = EventoMedicoEnviarASSBtnCtrl.sendEventoMedicoToSS(em.Id);
			responseToAssert = EventoMedicoEnviarASSBtnCtrl.sendEventoMedicoToSS(em.Id);
			Test.stopTest();
		}
        
		Segmentos__c[] segmentosToAssert = [
			SELECT Segmento_actual__c, Semid__c FROM Segmentos__c WHERE Evento_Medico__c =: em.Id
		];
		
		System.assertEquals(2, segmentosToAssert.size());
        System.assertEquals(false, responseToAssert.hasError);
        System.assert(!segmentosToAssert[0].Segmento_actual__c);
		System.assert(segmentosToAssert[1].Segmento_actual__c);
        System.assertEquals('123456', segmentosToAssert[0].Semid__c);

        Evento_medico__c emToAssert = [
                SELECT Nro_de_Evento_Medico_SS__c, Estado__c, Existente_en_SS__c
                FROM Evento_medico__c
                WHERE Id = :em.Id
        ];

        System.assertEquals('275751', emToAssert.Nro_de_Evento_Medico_SS__c);
        System.assertEquals('En Auditoria', emToAssert.Estado__c);
        System.assertEquals(true, emToAssert.Existente_en_SS__c);
        
		String recordTypeIdSeg = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		String recordTypeIdAutPrev = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		List<Case> casesToAssert = [
                SELECT Id, Diagnostico__r.Codigo_del_Diagnostico__c, Delegacion__r.Codigo_de_delegacion__c,
                    Prescriptor__r.Codigo_de_efector__c, Prestador__r.Codigo_de_efector__c, Celula__c, Tiempo_SLA__c,
                    Consultorio__r.Secuencia__c, Nro_AP__c, RecordTypeId, Type, Sub_tipo__c, Importe_presupuesto__c
                FROM Case
                WHERE Evento_Medico__c =: emToAssert.Id
        ];

		System.debug('****Importe_presupuesto__c: ' + casesToAssert[0].Importe_presupuesto__c);
        System.assertEquals(2, casesToAssert.size());
		System.assertEquals(recordTypeIdSeg, casesToAssert[0].RecordTypeId);
		System.assertEquals('Leches', casesToAssert[0].Type);
		System.assertEquals(null, casesToAssert[0].Sub_tipo__c);
        System.assertEquals('1014009814', casesToAssert[0].Nro_AP__c);
        System.assertEquals('999', casesToAssert[0].Diagnostico__r.Codigo_del_Diagnostico__c);
        System.assertEquals('650098', casesToAssert[0].Delegacion__r.Codigo_de_delegacion__c);
        System.assertEquals('753415', casesToAssert[0].Prescriptor__r.Codigo_de_efector__c);
        System.assertEquals('700076', casesToAssert[0].Prestador__r.Codigo_de_efector__c);
		System.assertEquals('Celula 2', casesToAssert[0].Celula__c);
		System.assertEquals('120', casesToAssert[0].Tiempo_SLA__c);

        //System.assertEquals(1, casesToAssert[0].Consultorio__R.Secuencia__c);

		System.assertEquals(recordTypeIdAutPrev, casesToAssert[1].RecordTypeId);
        System.assertEquals('Prestacion', casesToAssert[1].Type);
		System.assertEquals('Presupuesto', casesToAssert[1].Sub_tipo__c);

		List<Prestacion__c> presentacionesToAssert = [
                SELECT Id, Prestacion_CA__c, Prestacion__r.Codigo__c
                FROM Prestacion__c
        ];
        System.assertEquals(2, presentacionesToAssert.size());
        System.assertEquals('74042109', presentacionesToAssert[0].Prestacion_CA__c);
		System.assertEquals('02430199', presentacionesToAssert[0].Prestacion__r.Codigo__c);

        System.assertEquals(4, [SELECT Count() FROM Alerta__c WHERE Prestacion__c =: presentacionesToAssert[0].Id]);
        System.assertEquals(5, [SELECT Count() FROM Alerta__c WHERE Prestacion__c =: presentacionesToAssert[1].Id]);


    }

    @isTest
    private static void whenAnEMIIsSentToSSWithCorrectData_ItShouldReturnAValidResponse() {
        Account agencia = new Account(RecordTypeId = XappiaHelper.getRecordType('Account','Delegacion').Id);
        agencia.Name = 'agenciaTest';
        agencia.Codigo_de_delegacion__c = '650098';
        agencia.Type = 'Agencia';
        insert agencia;

        Account efector = new Account(RecordTypeId = XappiaHelper.getRecordType('Account','Efector').Id);
        efector.Name = 'Efector Test';
        efector.Es_Profesional__c = true;
        efector.Codigo_de_efector__c = '753415';
        efector.Estado__c = 'A';
        insert efector;

		Account prestador = new Account(RecordTypeId = XappiaHelper.getRecordType('Account','Efector').Id);
		prestador.Name = 'Prestador Test';
		prestador.Es_Prestador__c = true;
		prestador.Codigo_de_efector__c = '700076';
		insert prestador;

        Consultorio__c consultorio = new Consultorio__c();
		consultorio.Efector_Prestador__c = prestador.Id;
        consultorio.Secuencia__c = 1;
		consultorio.Estado__c = 'A';
        insert consultorio;

        Account afiliado = Build.anAccountCuentapersonal().build();
        afiliado.Codigo_de_Afiliado__c = '46940/16';
        insert afiliado;

        Diagnostico__c diag = new Diagnostico__c();
        diag.Codigo_del_Diagnostico__c = '999';
        insert diag;


        Evento_medico__c em = new Evento_medico__c();
        em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
        em.Asociado__c = afiliado.Id;
        em.Fecha_y_Hora_inicio_EMS__c = datetime.newInstance(2019, 12, 04);
        em.Tipo__c = 'CLINICO';
		em.Subtipo__c = 'CLINICO';
        em.Fecha_de_Vencimiento_Certificado__c = Date.newInstance(2019,12,1);
        em.Diferido__c = 'Si';
        em.Diagnostico__c = diag.Id;
        em.Sin_complicaciones__c = '1';
        em.Efector_Solicitante__c = efector.Id;
		em.Prestador__c = prestador.Id;
        em.Consultorio__c = consultorio.Id;
        em.Descripcion__c = 'Descripción asd';
        em.Delegacion__c = agencia.Id;
        em.Observaciones__c = 'Sin observaciones';
        em.Mail__c = 'sa@assa.com';
        em.Domicilio_Entrega__c = 'Agencia';
        em.Via_Entrega__c = 'DROGUERIA';
        insert em;

		ContentVersion contentVersion = new ContentVersion(
			Title = 'testEnviarEMI',
			PathOnClient = '/testEnviarEMI.pdf',
			VersionData = Blob.valueOf('Test Content'),
			IsMajorVersion = true
		);
		insert contentVersion;    
		
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = em.Id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		insert cdl;

		/*getResponseFoundEMI.buildResponse()
			.addForAddress(AWS.url + cdl.LinkedEntityId + '/testEnviarEMI.pdf');*/
        Test.setMock(HttpCalloutMock.class, getResponseFoundEMI);
        Test.startTest();
        EventoMedicoEnviarASSBtnCtrl.Response responseToAssert = EventoMedicoEnviarASSBtnCtrl.sendEventoMedicoToSS(em.Id);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        Segmentos__c segmentoToAssert = [SELECT Segmento_actual__c, Semid__c FROM Segmentos__c WHERE Evento_Medico__c =: em.Id];
        System.assert(segmentoToAssert.Segmento_actual__c);
        System.assertEquals('123456', segmentoToAssert.Semid__c);

        Evento_medico__c emToAssert = [
                SELECT Nro_de_Evento_Medico_SS__c, Estado__c, Existente_en_SS__c
                FROM Evento_medico__c
                WHERE Id = :em.Id
        ];
        System.assertEquals('275751', emToAssert.Nro_de_Evento_Medico_SS__c);
        System.assertEquals('En Auditoria', emToAssert.Estado__c);
        System.assertEquals(true, emToAssert.Existente_en_SS__c);
        
		String recordTypeIdInternacion = XappiaHelper.getRecordType('Case', 'Internacion').Id;
		String recordTypeIdAutPrev = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		List<Case> casesToAssert = [
                SELECT Id, Diagnostico__r.Codigo_del_Diagnostico__c, Delegacion__r.Codigo_de_delegacion__c,
                        Prescriptor__r.Codigo_de_efector__c, Prestador__r.Codigo_de_efector__c,
                        Consultorio__r.Secuencia__c, Nro_AP__c, RecordTypeId, Type, Sub_tipo__c
                FROM Case
                WHERE Evento_Medico__c =: emToAssert.Id
        ];
        System.assertEquals(2, casesToAssert.size());
		System.assertEquals(recordTypeIdInternacion, casesToAssert[0].RecordTypeId);
		System.assertEquals('Clinico', casesToAssert[0].Type);
		System.assertEquals('Clinico', casesToAssert[0].Sub_tipo__c);
		System.assertEquals('1014009814', casesToAssert[0].Nro_AP__c);
        System.assertEquals('999', casesToAssert[0].Diagnostico__r.Codigo_del_Diagnostico__c);
        System.assertEquals('650098', casesToAssert[0].Delegacion__r.Codigo_de_delegacion__c);
        System.assertEquals('753415', casesToAssert[0].Prescriptor__r.Codigo_de_efector__c);
        System.assertEquals('700076', casesToAssert[0].Prestador__r.Codigo_de_efector__c);
        System.assertEquals(1, casesToAssert[0].Consultorio__R.Secuencia__c);
        
		System.assertEquals(recordTypeIdAutPrev, casesToAssert[1].RecordTypeId);
        System.assertEquals('Prestacion', casesToAssert[1].Type);
		System.assertEquals('Material', casesToAssert[1].Sub_tipo__c);

		List<Prestacion__c> presentacionesToAssert = [
                SELECT Id, Prestacion_CA__c
                FROM Prestacion__c
        ];
        System.assertEquals(2, presentacionesToAssert.size());
        System.assertEquals('74042109', presentacionesToAssert[0].Prestacion_CA__c);

        System.assertEquals(4, [SELECT Count() FROM Alerta__c WHERE Prestacion__c =: presentacionesToAssert[0].Id]);
        System.assertEquals(5, [SELECT Count() FROM Alerta__c WHERE Prestacion__c =: presentacionesToAssert[1].Id]);


    }

	@isTest
    private static void whenAnEMHasNotAttachments_ShowErrorMessage() {
		Evento_medico__c em = new Evento_medico__c();
        em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		insert em;

		Test.startTest();
		EventoMedicoEnviarASSBtnCtrl.Response responseToAssert = EventoMedicoEnviarASSBtnCtrl.sendEventoMedicoToSS(em.Id); 
		Test.stopTest();

		System.assertEquals('No se puede enviar porque no tiene archivos adjuntos', responseToAssert.message);
	}

	@isTest
    private static void whenTheUserIsNotTheOwnerOfAnEM_ShowErrorMessage() {
		Evento_medico__c em = new Evento_medico__c();
        em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		insert em;

		ContentVersion contentVersion = new ContentVersion(
			Title = 'Test',
			PathOnClient = 'testEnviarEMSOwner.pdf',
			VersionData = Blob.valueOf('Test Content'),
			IsMajorVersion = true
		);
		insert contentVersion;    
		
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = em.Id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		insert cdl;

		EventoMedicoEnviarASSBtnCtrl.Response responseToAssert;
		System.runAs(usuario) {
			Test.startTest();
			responseToAssert = EventoMedicoEnviarASSBtnCtrl.sendEventoMedicoToSS(em.Id); 
			Test.stopTest();
		}

		System.assertEquals('El usuario no es el propietario', responseToAssert.message);
	}

    @isTest
    public static void shouldParseIntoADateTimeTheStringIncome(){

        Datetime fechaEsperada = Datetime.newInstance(2008, 12, 1, 12, 30, 0);
        String fechaIncome = '1-12-2008 12:30';  
        Datetime fechaDevuelta;

        Test.startTest();
        fechaDevuelta = EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(fechaIncome);
        Test.stopTest();

        System.assertEquals(fechaEsperada,fechaDevuelta);
    }
}