@isTest
private class CasoEnviarASSBtnCtrlTest {
	private static final Webservice_endpoint_setting__mdt SERVICE_CONFIG = ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	private static Map<String, Webservice_endpoint__mdt> endpoints = ConfigUtils.getEndpointsByTipo('autorizaciones');
	private static final String AUTH_TOKEN_URL = SERVICE_CONFIG.URL__c + '/oauth/token';
	private static final String AUTORIZACION_URL = SERVICE_CONFIG.URL__c + endpoints.get('autorizaciones').Endpoint__c;
	private static XHttpCalloutMock getResponseFound;
	private static XHttpCalloutMock getResponseMaterialFound;
    private static XHttpCalloutMock getErrorResponse;
	private static XHttpCalloutMock getResponsePresupuestoFound;
	private static XHttpCalloutMock getResponseFoundWithEM;
	private static Account agencia;
	private static Account efector;
	private static Consultorio__c consultorio;
	private static Diagnostico__c diag;
	private static Nomenclador_de_Prestacion__c nomPrest;
	private static Nomenclador_de_Prestacion__c nomPrest2;
	private static Case caso;
	private static Prestacion__c prest1;
	private static Account prestador;
	private static Account afiliado;
	private static User usuario;
    static {
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id, Name FROM UserRole WHERE Name = 'Administrador'];
		usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName, ProfileId = p.Id, UserRoleId = role.Id);
		System.runAs (new User(Id = UserInfo.getUserId())) {
			insert usuario;
		}
		agencia = new Account(RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id);
		agencia.Name = 'agenciaTest';
		agencia.Codigo_de_delegacion__c = '650098';
		agencia.Type = 'Agencia';
		insert agencia;
		efector = new Account(RecordTypeId = XappiaHelper.getRecordType('Account', 'Efector').Id);
		efector.Name = 'Efector prueba';
		efector.Es_Profesional__c = true;
		efector.Codigo_de_efector__c = '758415';
		efector.Estado__c = 'A';
		insert efector;
		prestador = new Account(RecordTypeId = XappiaHelper.getRecordType('Account', 'Efector').Id);
		prestador.Es_Prestador__c = true;
		prestador.Name = 'Prestador prueba';
		prestador.Codigo_de_efector__c = '700125';
		insert prestador;
		afiliado = Build.anAccountCuentapersonal().build();
		afiliado.Codigo_de_Afiliado__c = '86712/26';
		insert afiliado;
		consultorio = new Consultorio__c();
		consultorio.Secuencia__c = 1;
		consultorio.Efector_Prestador__c = prestador.Id;
		consultorio.Estado__c = 'A';
		insert consultorio;
		diag = new Diagnostico__c();
		diag.Codigo_del_Diagnostico__c = '999';
		insert diag;
		nomPrest = new Nomenclador_de_Prestacion__c();
		nomPrest.Codigo__c = '13904';
		nomPrest.Contexto__c = 'A';
		nomPrest.Tipo_Nomenclador__c = 'N';
		nomPrest.Estado__c = 'A';
		insert nomPrest;
		nomPrest2 = new Nomenclador_de_Prestacion__c();
		nomPrest2.Codigo__c = '02503102';
		nomPrest2.Contexto__c = 'A';
		nomPrest2.Tipo_Nomenclador__c = 'N';
		nomPrest2.Estado__c = 'A';
		insert nomPrest2;
		caso = new Case();
		caso.Fecha__c = Date.newInstance(2020, 2, 2);
		caso.Fecha_probable__c = Date.newInstance(2019, 2, 2);
		caso.AccountId = afiliado.Id;
		caso.Delegacion__c = agencia.Id;
		caso.Fecha_prescripcion__c = Date.newInstance(2020, 1, 31);
		caso.Diagnostico__c = diag.Id;
		caso.Prescriptor__c = efector.Id;
		caso.Prestador__c = prestador.Id;
		caso.Observaciones__c = 'Prueba AP SF';
		caso.Mail__c = 'test@mapplics.com';
		caso.AP_Material__c = true;
		caso.AP_Presupuesto__c = false;
		caso.Consultorio__c = consultorio.Id;
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		caso.Cambio_Manual__c = false;
		insert caso;
		prest1 = new Prestacion__c();
		prest1.Alerta__c = 'SAB';
		prest1.Observaciones__c = 'NO REQUIERE OBSERV';
		prest1.Cantidad__c = 1;
		prest1.Prestacion__c = nomPrest.Id;
		prest1.Ap__c = caso.Id;
		prest1.Tipo__c = 'N';
		insert prest1;
        getResponseFound = new XHttpCalloutMock();
		setMockResponse (getResponseFound, AUTORIZACION_URL, WSCaseAPGenerarCentroMock.getFound(caso.Id), 200);
		getResponsePresupuestoFound = new XHttpCalloutMock();
		setMockResponse (getResponsePresupuestoFound, AUTORIZACION_URL, WSCaseAPGenerarCentroMock.getFoundPresupuesto(caso.Id), 200);
		getResponseMaterialFound = new XHttpCalloutMock();
		setMockResponse (getResponseMaterialFound, AUTORIZACION_URL, WSCaseAPGenerarCentroMock.getFoundMaterial(caso.Id), 200);
		getResponseFoundWithEM = new XHttpCalloutMock();
		setMockResponse (getResponseFoundWithEM, AUTORIZACION_URL, WSCaseAPGenerarCentroMock.getFoundWithEM(caso.Id), 200);
		getErrorResponse = new XHttpCalloutMock();
		setMockResponse (getErrorResponse, AUTORIZACION_URL, WSCaseAPGenerarCentroMock.getError(), 422);
    }
	@isTest
	private static void whenACaseWithPresupuestoIsSentToSSWithCorrectData_ItShouldReturnAValidResponse() {
		caso.AP_Presupuesto__c = true;
		caso.Importe_presupuesto__c = 200;
		update caso;
		System.assertEquals(1, [SELECT COUNT() FROM Prestacion__c WHERE Ap__c = :caso.Id], 'Debe haber una prestación');
		Test.setMock(HttpCalloutMock.class, getResponsePresupuestoFound);
		Test.startTest();
        CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
        Test.stopTest();
		System.assertEquals(2, [SELECT COUNT() FROM Prestacion__c WHERE Ap__c = :caso.Id], 'Deben haber dos prestaciones');
	}
	@isTest
	private static void whenACaseWithMaterialIsSentToSSWithCorrectData_ItShouldReturnAValidResponse() {
		caso.AP_Material__c = true;
		update caso;
		Test.setMock(HttpCalloutMock.class, getResponseMaterialFound);
        Test.startTest();
        CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
        Test.stopTest();
		Case casoPadre = [
			SELECT Id, Celula__c, RecordType.Name, Type, Sub_tipo__c, Tiempo_SLA__c FROM Case WHERE Nro_AP__c = '1014010015'
		];
		System.assertEquals('Celula 2', casoPadre.Celula__c, 'La célula debe ser 2');
		System.assertEquals('24', casoPadre.Tiempo_SLA__c, 'El SLA es de 24');
		Case casoMaterial = [
			SELECT Id, Celula__c, RecordType.Name, Type, Sub_tipo__c, Tiempo_SLA__c FROM Case WHERE Nro_AP__c = '1014010632'
		];
		System.assertEquals('Celula 1', casoMaterial.Celula__c, 'La célula debe ser 1');
		System.assertEquals('Material', casoMaterial.Sub_tipo__c, 'El subtipo debe ser Material');
		System.assertEquals('48', casoMaterial.Tiempo_SLA__c, 'El tiempo SLA debe ser 48');
	}
	@isTest
	private static void whenACaseIsSentToSSWithCorrectData_ItShouldReturnAValidResponse() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
        Test.stopTest();
		System.assert(!responseToAssert.hasError, 'No debe haber mensaje de error');
		Case updatedCase = getCase(caso.Id);
		Prestacion__c[] prests = getPrestacion(updatedCase.Id);
		System.assertEquals('1014010015', updatedCase.Nro_AP__c, 'El número AP debe ser 1014010015');
		System.assertEquals(Date.valueOf('2019-02-02 00:00:00'), updatedCase.Fecha_probable__c, 'La fecha debe ser 2019-02-02 00:00:00');
		System.assertEquals('CA-----A', updatedCase.Status, 'El estatus debe ser CA-----A');
		System.assertEquals('86712/26', updatedCase.Account.Codigo_de_Afiliado__c, 'El código de afiliado debe ser 86712/26');
		System.assertEquals(Date.valueOf('2020-01-31 00:00:00'), updatedCase.Fecha_prescripcion__c, 'La fecha debe ser 2019-01-31 00:00:00');
		System.assertEquals('999', updatedCase.Diagnostico__r.Codigo_del_Diagnostico__c, 'El código de diagnóstico debe ser 999');
		System.assertEquals('758415', updatedCase.Prescriptor__r.Codigo_de_efector__c, 'El código del efector debe ser 758415');
		System.assertEquals('700125', updatedCase.Prestador__r.Codigo_de_efector__c, 'El codigo del efector debe ser 700125');
		System.assertEquals(1, updatedCase.Consultorio__r.Secuencia__c, 'La secuencia debe ser 1');
		System.assertEquals('Prueba AP SF', updatedCase.Observaciones__c, 'Las observaciones deben ser Prueba AP SF');
		System.assertEquals('test@mapplics.com', updatedCase.Mail__c, 'El correo debe ser test@mapplics.com');
		System.assertEquals(null, updatedCase.Otros_Mail__c, 'No debe tener otros correos');
		System.assertEquals('650098', updatedCase.Delegacion__r.Codigo_de_delegacion__c, 'El código de la delegación debe ser 650098');
		System.assertEquals('Nivel 1', updatedCase.Nivel_de_derivacion__c, 'El nivel de derivación debe ser Nivel 1');
		System.assertEquals('Medicamento', updatedCase.Type, 'El tipo del caso debe ser Medicamento');
		for(Prestacion__c pre : prests){
			System.assertEquals('C1-----A', pre.Estado__c, 'El estado de la prestación debe ser C1-----A');
			System.assertEquals('74042384', pre.Prestacion_CA__c, 'El número debe ser 74042384');
			System.assertEquals('NO REQUIERE OBSERV', pre.Texto_aclarativo_alerta__c, 'El texto debe ser NO REQUIERE OBSERV');
			System.assertEquals(null, pre.Alerta__c, 'No debe tener alerta');
			System.assertEquals('ILVICO N, COMP.X 20', pre.Nombre_de_Prestacion__c, 'Nombre de la prestación debe ser ILVICO N, COMP.X 20');
			System.assertEquals(false, pre.Cambio_automatico__c, 'El cambio no debe ser automático');
		}
		Alerta__c[] alerts = getAlertas(prests[0].Id);
		System.assertEquals('105', alerts[0].Control__c, 'El control debe ser 105');
		System.assertEquals('FCION_FRONT', alerts[0].Funcion__c, 'La fución debe ser FCION_FRONT');
		System.assertEquals('El medicamento no existe o no está activo', alerts[0].Texto_aclarativo__c, 'El texto aclarativo no coincide');
		System.assertEquals(Date.valueOf('2020-02-14 10:13:38'), alerts[0].Fecha_de_generacion_de_Alerta__c, 'La fecha debe ser 2020-02-14 10:13:38');
		System.assertEquals(null, alerts[0].Lectura_de_alerta_auditor__c, 'Debe ser nulo');
		System.assertEquals(null, alerts[0].Resolucion_de_alerta_auditor__c, 'Debe ser nulo');
		System.assertEquals(null, alerts[0].Fecha_resolucion_de_Alerta__c, 'Debe ser nulo');
		System.assertEquals('16461179', alerts[0].idalerta__c, 'El id de la alerta debe ser 16461179');
	}
	@isTest
	private static void whenACaseIsSentToSSWithIncorrectData_ItShouldReturnAnInvalidResponse() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Case caso2 = new Case();
		caso.Fecha__c = Date.newInstance(2020, 2, 2);
		caso.Fecha_probable__c = Date.newInstance(2019, 2, 2);
		caso.AccountId = afiliado.Id;
		caso.Delegacion__c = agencia.Id;
		caso.Fecha_prescripcion__c = Date.newInstance(2020, 1, 31);
		caso.Diagnostico__c = diag.Id;
		caso.Prescriptor__c = efector.Id;
		caso.Prestador__c = prestador.Id;
		caso.Observaciones__c = 'Prueba AP SF';
		caso.Mail__c = 'test@mapplics.com';
		caso.AP_Material__c = true;
		caso.AP_Presupuesto__c = false;
		caso.Consultorio__c = consultorio.Id;
		insert caso2;
		prest1.Ap__c = caso2.Id;
		update prest1;
        Test.startTest();
        CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso2.Id);
        Test.stopTest();
		System.assert(responseToAssert.hasError, 'Debe haber un error');
	}
	@isTest
	private static void whenACaseHasAttachments_ReturnTrue() {
		Case caso = new Case();
		insert caso;
		ContentVersion contentVersion = new ContentVersion(Title = 'test',
			PathOnClient = '/test.pdf',
			VersionData = Blob.valueOf('Test Content'),
			IsMajorVersion = true);
		insert contentVersion;
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = caso.Id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		insert cdl;
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		Boolean resp = CasoEnviarASSBtnCtrl.hasAttachments(caso.Id, null);
		Test.stopTest();
		System.assert(resp, 'La respuesta debe ser positiva');
	}
	@isTest
	private static void whenTheResponseHasAnEmAuthorizedUpdateTheEMStatus() {
		Evento_medico__c em = new Evento_medico__c();
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		em.Estado__c = 'En Auditoria';
		em.Asociado__c = afiliado.Id;
		insert em;
		Segmentos__c seg = new Segmentos__c();
		seg.Estado__c = 'En Auditoria';
		seg.Evento_Medico__c = em.Id;
		insert seg;
		caso.Evento_Medico__c = em.Id;
		update caso;
		Test.setMock(HttpCalloutMock.class, getResponseFoundWithEM);
        Test.startTest();
        CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
        Test.stopTest();
		System.assert(!responseToAssert.hasError, 'No debe haber errores');
		Case updatedCase = getCase(caso.Id);
		Prestacion__c[] prests = getPrestacion(updatedCase.Id);
		System.assertEquals('1014010015', updatedCase.Nro_AP__c, 'El número AP debe ser 1014010015');
		System.assertEquals(Date.valueOf('2019-02-02 00:00:00'), updatedCase.Fecha_probable__c, 'La fecha debe ser 2019-02-02 00:00:00');
		System.assertEquals('CA-----A', updatedCase.Status, 'El estatus debe ser CA-----A');
		System.assertEquals('86712/26', updatedCase.Account.Codigo_de_Afiliado__c, 'El código de afiliado debe ser 86712/26');
		System.assertEquals(Date.valueOf('2020-01-31 00:00:00'), updatedCase.Fecha_prescripcion__c, 'La fecha debe ser 2019-01-31 00:00:00');
		System.assertEquals('999', updatedCase.Diagnostico__r.Codigo_del_Diagnostico__c, 'El código de diagnóstico debe ser 999');
		System.assertEquals('758415', updatedCase.Prescriptor__r.Codigo_de_efector__c, 'El código del efector debe ser 758415');
		System.assertEquals('700125', updatedCase.Prestador__r.Codigo_de_efector__c, 'El codigo del efector debe ser 700125');
		System.assertEquals(1, updatedCase.Consultorio__r.Secuencia__c, 'La secuencia debe ser 1');
		System.assertEquals('Prueba AP SF', updatedCase.Observaciones__c, 'Las observaciones deben ser Prueba AP SF');
		System.assertEquals('test@mapplics.com', updatedCase.Mail__c, 'El correo debe ser test@mapplics.com');
		System.assertEquals(null, updatedCase.Otros_Mail__c, 'No debe tener otros correos');
		System.assertEquals('650098', updatedCase.Delegacion__r.Codigo_de_delegacion__c, 'El código de la delegación debe ser 650098');
		System.assertEquals('Nivel 1', updatedCase.Nivel_de_derivacion__c, 'El nivel de derivación debe ser Nivel 1');
		System.assertEquals('Medicamento', updatedCase.Type, 'El tipo del caso debe ser Medicamento');
		for(Prestacion__c pre : prests){
			System.assertEquals('C1-----A', pre.Estado__c, 'El estado de la prestación debe ser C1-----A');
			System.assertEquals('74042384', pre.Prestacion_CA__c, 'El número debe ser 74042384');
			System.assertEquals('NO REQUIERE OBSERV', pre.Texto_aclarativo_alerta__c, 'El texto debe ser NO REQUIERE OBSERV');
			System.assertEquals(null, pre.Alerta__c, 'No debe tener alerta');
			System.assertEquals('ILVICO N, COMP.X 20', pre.Nombre_de_Prestacion__c, 'Nombre de la prestación debe ser ILVICO N, COMP.X 20');
			System.assertEquals(false, pre.Cambio_automatico__c, 'El cambio no debe ser automático');
		}
		Alerta__c[] alerts = getAlertas(prests[0].Id);
		System.assertEquals('105', alerts[0].Control__c, 'El control debe ser 105');
		System.assertEquals('FCION_FRONT', alerts[0].Funcion__c, 'La fución debe ser FCION_FRONT');
		System.assertEquals('El medicamento no existe o no está activo', alerts[0].Texto_aclarativo__c, 'El texto aclarativo no coincide');
		System.assertEquals(Date.valueOf('2020-02-14 10:13:38'), alerts[0].Fecha_de_generacion_de_Alerta__c, 'La fecha debe ser 2020-02-14 10:13:38');
		System.assertEquals(null, alerts[0].Lectura_de_alerta_auditor__c, 'Debe ser nulo');
		System.assertEquals(null, alerts[0].Resolucion_de_alerta_auditor__c, 'Debe ser nulo');
		System.assertEquals(null, alerts[0].Fecha_resolucion_de_Alerta__c, 'Debe ser nulo');
		System.assertEquals('16461179', alerts[0].idalerta__c, 'El id de la alerta debe ser 16461179');
		em = [SELECT Id, Estado__c FROM Evento_medico__c WHERE Id = :em.Id];
		System.assertEquals('Autorizado', em.Estado__c, 'El evento médico debe estar autorizado');
		seg = [SELECT Id, Estado__c FROM Segmentos__c WHERE Id = :seg.Id];
		System.assertEquals('Autorizado', seg.Estado__c, 'El evento médico debe estar autorizado');
	}
	/** Utils */
	private static void setMockResponse (XHttpCalloutMock mock, String url, String body, Integer statusCode) {
		mock.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(AUTH_TOKEN_URL);
		mock.buildResponse().withStatus('OK')
			.withStatusCode(statusCode).withBody(body)
			.addForAddress(url);
	}
	private static Case getCase (Id casoId) {
		return [SELECT Id, Nro_AP__c, Fecha__c, Fecha_probable__c, Status, Consultorio__r.Secuencia__c,
					Account.Codigo_de_Afiliado__c, Fecha_prescripcion__c, Diagnostico__r.Codigo_del_Diagnostico__c,
					Prescriptor__r.Codigo_de_efector__c, Prestador__r.Codigo_de_efector__c, Consultorio__r.Codigo_externo__c,
					Observaciones__c, Mail__c, Otros_Mail__c, Delegacion__r.Codigo_de_delegacion__c, Nivel_de_derivacion__c, Type
				FROM Case
				WHERE Id = :casoId];
	}
	private static Prestacion__c[] getPrestacion (Id casoId) {
		return [SELECT Id, Estado__c, Prestacion_CA__c, Texto_aclarativo_alerta__c, Alerta__c, Nombre_de_Prestacion__c,
					Cambio_automatico__c
				FROM Prestacion__c
				WHERE Ap__c = :casoId];
	}
	private static Alerta__c[] getAlertas (Id prestacionId) {
		return [SELECT Id, Control__c, Funcion__c, Texto_aclarativo__c, Fecha_de_generacion_de_Alerta__c,
						Lectura_de_alerta_auditor__c, Resolucion_de_alerta_auditor__c, Fecha_resolucion_de_Alerta__c, idalerta__c
				FROM Alerta__c
				WHERE Prestacion__c = :prestacionId];
	}
}