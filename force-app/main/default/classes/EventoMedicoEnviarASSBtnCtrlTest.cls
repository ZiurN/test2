@IsTest
private class EventoMedicoEnviarASSBtnCtrlTest {
	private static final String ARCHIVOS_URL = ConfigUtils.getEndpointsByTipo('archivos').get('archivos').Endpoint__c;
	private static Map<String, Webservice_endpoint__mdt> endpointsEventosMedicos = ConfigUtils.getEndpointsByTipo('eventos-medicos');
	private static final String SEGUIMIENTO_URL = endpointsEventosMedicos.get('seguimiento').Endpoint__c;
	private static final String EVENTOS_MEDICOS_URL = endpointsEventosMedicos.get('eventos-medicos').Endpoint__c;
	private static XHttpCalloutMock getResponseFound;
	private static XHttpCalloutMock getResponseFoundEMI;
	private static User usuario;
	private static Nomenclador_de_Prestacion__c nom;
	private static Nomenclador_de_Prestacion__c nom2;
	static {
		Profile p = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id, Name FROM UserRole WHERE Name = 'Administrador'];
		usuario = Build.anUser()
			.withProfile(p)
			.withRole(role)
			.withCodigoDelegacion('650098')
			.build();
		System.runAs(new User(id = UserInfo.getUserId())) {
			insert usuario;
		}
		nom = Build.aNomencladorDePrestacion()
			.withCodigo('02430199')
			.withContexto('A')
			.withTipoNomenclador('N')
			.withEstado('A')
			.build();
		insert nom;
		nom2 = Build.aNomencladorDePrestacion()
			.withCodigo('02503102')
			.withContexto('A')
			.withTipoNomenclador('N')
			.withEstado('A')
			.build();
		insert nom2;
		TestUtils.mockSettings archivosMockSettings = new  TestUtils.MockSettings();
		archivosMockSettings.statusCode = 200;
		archivosMockSettings.status = 'OK';
		archivosMockSettings.body = WSCaseAPGenerarCentroMock.getArchivos();
		archivosMockSettings.url = ARCHIVOS_URL;
		getResponseFound = new XHttpCalloutMock();
		List<TestUtils.mockSettings> getResponseFoundSettings = new List<TestUtils.mockSettings>();
		TestUtils.mockSettings getResponseFoundSetting = new  TestUtils.MockSettings();
		getResponseFoundSetting.statusCode = 200;
		getResponseFoundSetting.status = 'OK';
		getResponseFoundSetting.body = WSEventoMedicoEnviarASSMock.getFound();
		getResponseFoundSetting.url = SEGUIMIENTO_URL;
		getResponseFoundSettings.add(getResponseFoundSetting);
		getResponseFoundSettings.add(archivosMockSettings);
		TestUtils.setMockResponse(getResponseFound, getResponseFoundSettings);
		getResponseFoundEMI = new XHttpCalloutMock();
		List<TestUtils.mockSettings> getResponseFoundEMISettings = new List<TestUtils.mockSettings>();
		TestUtils.mockSettings getResponseFoundEMISetting = new  TestUtils.MockSettings();
		getResponseFoundEMISetting.statusCode = 200;
		getResponseFoundEMISetting.status = 'OK';
		getResponseFoundEMISetting.body = WSEventoMedicoEnviarASSMock.getFoundEMI();
		getResponseFoundEMISetting.url = EVENTOS_MEDICOS_URL;
		getResponseFoundEMISettings.add(getResponseFoundEMISetting);
		getResponseFoundEMISettings.add(archivosMockSettings);
		TestUtils.setMockResponse(getResponseFoundEMI, getResponseFoundEMISettings);
	}
	@isTest
	private static void whenAnEMSIsSentToSSWithCorrectData_ItShouldReturnAValidResponse() {
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
		em.Fecha_de_Vencimiento_Certificado__c = Date.newInstance(2019,12,1);
		em.Diferido__c = 'Si';
		em.Diagnostico__c = diag.Id;
		em.Sin_complicaciones__c = '1';
		em.Efector_Solicitante__c = efector.Id;
		em.Prestador__c = prestador.Id;
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
			responseToAssert = EventoMedicoEnviarASSBtnCtrl.sendEventoMedicoToSS(em.Id);
			Test.stopTest();
		}
		Segmentos__c[] segmentosToAssert = [SELECT Segmento_actual__c, Semid__c FROM Segmentos__c WHERE Evento_Medico__c =: em.Id];
		System.assertEquals(2, segmentosToAssert.size(), 'Se esperan dos segmentos');
		System.assert(!responseToAssert.hasError, 'No deben haber errores');
		System.assert(!segmentosToAssert[0].Segmento_actual__c, 'El primer segmento no debe ser el actual');
		System.assert(segmentosToAssert[1].Segmento_actual__c, 'El segundo segmento debe ser el actual');
		System.assertEquals('123456', segmentosToAssert[0].Semid__c, 'El valor de Semid debe ser 123456');
		Evento_medico__c emToAssert = [SELECT Nro_de_Evento_Medico_SS__c, Estado__c, Existente_en_SS__c
										FROM Evento_medico__c
										WHERE Id = :em.Id];
		System.assertEquals('275751', emToAssert.Nro_de_Evento_Medico_SS__c, 'El número del evento médico en SS debe ser 275751');
		System.assertEquals('En Auditoria', emToAssert.Estado__c, 'El estado del evento médico debe ser En Auditoria');
		System.assert(emToAssert.Existente_en_SS__c, 'El evento debe existir en SS');
		String recordTypeIdSeg = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		String recordTypeIdAutPrev = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		List<Case> casesToAssert = [SELECT Id, Diagnostico__r.Codigo_del_Diagnostico__c, Delegacion__r.Codigo_de_delegacion__c,
										Prescriptor__r.Codigo_de_efector__c, Prestador__r.Codigo_de_efector__c, Celula__c, Tiempo_SLA__c,
										Consultorio__r.Secuencia__c, Nro_AP__c, RecordTypeId, Type, Sub_tipo__c, Importe_presupuesto__c
									FROM Case
									WHERE Evento_Medico__c =: emToAssert.Id];
		System.assertEquals(2, casesToAssert.size(), 'Se esperan dos casos');
		System.assertEquals(recordTypeIdSeg, casesToAssert[0].RecordTypeId, 'El dato del caso no coincide con el esperado');
		System.assertEquals('Leches', casesToAssert[0].Type, 'El dato del caso no coincide con el esperado');
		System.assertEquals(null, casesToAssert[0].Sub_tipo__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('1014009814', casesToAssert[0].Nro_AP__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('999', casesToAssert[0].Diagnostico__r.Codigo_del_Diagnostico__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('650098', casesToAssert[0].Delegacion__r.Codigo_de_delegacion__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('753415', casesToAssert[0].Prescriptor__r.Codigo_de_efector__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('700076', casesToAssert[0].Prestador__r.Codigo_de_efector__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('Celula 2', casesToAssert[0].Celula__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('120', casesToAssert[0].Tiempo_SLA__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals(recordTypeIdAutPrev, casesToAssert[1].RecordTypeId, 'El dato del caso no coincide con el esperado');
		System.assertEquals('Prestacion', casesToAssert[1].Type, 'El dato del caso no coincide con el esperado');
		System.assertEquals('Presupuesto', casesToAssert[1].Sub_tipo__c, 'El dato del caso no coincide con el esperado');
		List<Prestacion__c> presentacionesToAssert = [SELECT Id, Prestacion_CA__c, Prestacion__r.Codigo__c FROM Prestacion__c];
		System.assertEquals(2, presentacionesToAssert.size(), 'Se esperan dos prestaciones');
		System.assertEquals('74042109', presentacionesToAssert[0].Prestacion_CA__c, 'El dato de la prestación no coincide con el esperado');
		System.assertEquals('02430199', presentacionesToAssert[0].Prestacion__r.Codigo__c, 'El dato de la prestación no coincide con el esperado');
		System.assertEquals(4, [SELECT Count() FROM Alerta__c WHERE Prestacion__c =: presentacionesToAssert[0].Id], 'Se esperan cuatro alertas para la primera prestación');
		System.assertEquals(5, [SELECT Count() FROM Alerta__c WHERE Prestacion__c =: presentacionesToAssert[1].Id], 'Se esperan cinco alertas para la primera prestación');
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
		Test.setMock(HttpCalloutMock.class, getResponseFoundEMI);
		Test.startTest();
		EventoMedicoEnviarASSBtnCtrl.Response responseToAssert = EventoMedicoEnviarASSBtnCtrl.sendEventoMedicoToSS(em.Id);
		Test.stopTest();
		System.assert(!responseToAssert.hasError, 'No deben haber errores');
		Segmentos__c segmentoToAssert = [SELECT Segmento_actual__c, Semid__c FROM Segmentos__c WHERE Evento_Medico__c =: em.Id];
		System.assert(segmentoToAssert.Segmento_actual__c, 'Debe ser el segmento actual');
		System.assertEquals('123456', segmentoToAssert.Semid__c, 'El valor de Semid debe ser 123456');
		Evento_medico__c emToAssert = [SELECT Nro_de_Evento_Medico_SS__c, Estado__c, Existente_en_SS__c
										FROM Evento_medico__c
										WHERE Id = :em.Id];
		System.assertEquals('275751', emToAssert.Nro_de_Evento_Medico_SS__c, 'El número de evento médico en SS debe ser 275751');
		System.assertEquals('En Auditoria', emToAssert.Estado__c, 'El estado de evento médico en SS debe ser En Auditoria');
		System.assert(emToAssert.Existente_en_SS__c, 'El evento debe existir en SS');
		String recordTypeIdInternacion = XappiaHelper.getRecordType('Case', 'Internacion').Id;
		String recordTypeIdAutPrev = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		List<Case> casesToAssert = [SELECT Id, Diagnostico__r.Codigo_del_Diagnostico__c, Delegacion__r.Codigo_de_delegacion__c,
										Prescriptor__r.Codigo_de_efector__c, Prestador__r.Codigo_de_efector__c,
										Consultorio__r.Secuencia__c, Nro_AP__c, RecordTypeId, Type, Sub_tipo__c
									FROM Case
									WHERE Evento_Medico__c =: emToAssert.Id];
		System.assertEquals(2, casesToAssert.size(), 'Se esperan dos casos');
		System.assertEquals(recordTypeIdInternacion, casesToAssert[0].RecordTypeId, 'El dato del caso no coincide con el esperado');
		System.assertEquals('Clinico', casesToAssert[0].Type, 'El dato del caso no coincide con el esperado');
		System.assertEquals('Clinico', casesToAssert[0].Sub_tipo__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('1014009814', casesToAssert[0].Nro_AP__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('999', casesToAssert[0].Diagnostico__r.Codigo_del_Diagnostico__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('650098', casesToAssert[0].Delegacion__r.Codigo_de_delegacion__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('753415', casesToAssert[0].Prescriptor__r.Codigo_de_efector__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals('700076', casesToAssert[0].Prestador__r.Codigo_de_efector__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals(1, casesToAssert[0].Consultorio__R.Secuencia__c, 'El dato del caso no coincide con el esperado');
		System.assertEquals(recordTypeIdAutPrev, casesToAssert[1].RecordTypeId, 'El dato del caso no coincide con el esperado');
		System.assertEquals('Prestacion', casesToAssert[1].Type, 'El dato del caso no coincide con el esperado');
		System.assertEquals('Material', casesToAssert[1].Sub_tipo__c, 'El dato del caso no coincide con el esperado');
		List<Prestacion__c> presentacionesToAssert = [SELECT Id, Prestacion_CA__c FROM Prestacion__c];
		System.assertEquals(2, presentacionesToAssert.size(), 'Se esperan dos prestaciones');
		System.assertEquals('74042109', presentacionesToAssert[0].Prestacion_CA__c, 'El valor debe ser 74042109');
		System.assertEquals(4, [SELECT Count() FROM Alerta__c WHERE Prestacion__c =: presentacionesToAssert[0].Id], 'Se esperan cuatro alertas para esta prestación');
		System.assertEquals(5, [SELECT Count() FROM Alerta__c WHERE Prestacion__c =: presentacionesToAssert[1].Id], 'Se esperan cinco alertas para esta prestación');
	}
	@isTest
	private static void whenAnEMHasNotAttachments_ShowErrorMessage() {
		Evento_medico__c em = new Evento_medico__c();
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		insert em;
		Test.startTest();
		EventoMedicoEnviarASSBtnCtrl.Response responseToAssert = EventoMedicoEnviarASSBtnCtrl.sendEventoMedicoToSS(em.Id);
		Test.stopTest();
		System.assertEquals(System.Label.Alerta_NoEnviarSInAdjuntos, responseToAssert.message, 'El mensaje no indica el error esperado');
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
		System.assertEquals(System.Label.Alerta_NoAuth_UsuarioNoPropietario, responseToAssert.message, 'El mensaje no indica el error esperado');
	}
	@isTest
	public static void shouldParseIntoADateTimeTheStringIncome(){
		Datetime fechaEsperada = Datetime.newInstance(2008, 12, 1, 12, 30, 0);
		String fechaIncome = '1-12-2008 12:30';
		Datetime fechaDevuelta;
		Test.startTest();
		fechaDevuelta = EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(fechaIncome);
		Test.stopTest();
		System.assertEquals(fechaEsperada, fechaDevuelta, 'Las fechas no coinciden');
	}
}