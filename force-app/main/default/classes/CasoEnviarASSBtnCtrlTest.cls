@isTest
private class CasoEnviarASSBtnCtrlTest {
	private static Map<String, Webservice_endpoint__mdt> endpointsAutorizaciones = ConfigUtils.getEndpointsByTipo('autorizaciones');
	private static Map<String, Webservice_endpoint__mdt> endpointsReintegros = ConfigUtils.getEndpointsByTipo('reintegros');
	private static final String AUTORIZACION_URL = endpointsAutorizaciones.get('autorizaciones').Endpoint__c;
	private static final String REINTEGROS_URL = endpointsReintegros.get('reintegros').Endpoint__c;
	private static final String UNIQUE_USER_NAME = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
	private static Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
	private static List<UserRole> roles = [SELECT Id, Name FROM UserRole WHERE Name = 'Administrador' OR Name = 'Filial_Casa_central'];
	/** Para Reintegro */
	private static String medicamentoRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Medicamento').Id;
	private static String odontologicaRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Odontologica').Id;
	private static String prestacionalRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Prestacional').Id;
	/** Mocks para AP */
	private static XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
	private static XHttpCalloutMock getResponseMaterialFound = new XHttpCalloutMock();
	private static XHttpCalloutMock getErrorResponse = new XHttpCalloutMock();
	private static XHttpCalloutMock getResponsePresupuestoFound = new XHttpCalloutMock();
	private static XHttpCalloutMock getResponseFoundWithEM = new XHttpCalloutMock();
	/** Mocks para Reintegro */
	private static XHttpCalloutMock getResponseReintegroFound = new XHttpCalloutMock();
	private static XHttpCalloutMock getErrorReintegroResponse = new XHttpCalloutMock();
	/** Generales */
	private static Diagnostico__c diagnostico;
	private static Case caso;
	/** Para Autorización AP */
	private static Account agencia;
	private static Account efector;
	private static Consultorio__c consultorio;
	private static Nomenclador_de_Prestacion__c nomPrest;
	private static Nomenclador_de_Prestacion__c nomPrest2;
	private static Prestacion__c prest1;
	private static Account prestador;
	private static Account afiliado;
	private static User usuario = Build.anUser()
		.withUserName(UNIQUE_USER_NAME)
		.withProfile(pFront)
		.build();
	/** Para Reintegro */
	private static Case reintegro;
	private static Lote__c lote;
	static Prestacion_de_reintegro__c prestacion;
	private static User userFront = Build.anUser()
		.withUserName(UNIQUE_USER_NAME + 'FrontEnviarReintegro')
		.withProfile(pFront)
		.withCodigoDelegacion('650886')
		.build();
	static {
		for (UserRole role : roles) {
			if (role.Name == 'Administrador') {
				usuario.UserRoleId = role.Id;
			} else if (role.Name == 'Filial_Casa_central') {
				userFront.UserRoleId = role.Id;
			}
		}
		List<User> usersToInsert = new List<User>();
		usersToInsert.add(usuario);
		usersToInsert.add(userFront);
		System.runAs (new User(Id = UserInfo.getUserId())) {
			insert usersToInsert;
		}
		agencia = Build.anAccountDelegacion()
			.withCodigoDeDelegacion('650098').build();
			agencia.Name = 'agenciaTest';
			agencia.Type = 'Agencia';
		insert agencia;
		efector = Build.anAccountEfector().build();
			efector.Name = 'Efector prueba';
			efector.Codigo_de_efector__c = '758415';
			efector.Es_Profesional__c = true;
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
		diagnostico = new Diagnostico__c();
			diagnostico.Codigo_del_Diagnostico__c = '999';
		insert diagnostico;
		lote = new Lote__c();
			lote.Id_lote_SS__c = '5392';
		insert lote;
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
			caso.Diagnostico__c = diagnostico.Id;
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
			reintegro = new Case();
			reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
			reintegro.Efector_realizador__c = efector.Id;
			reintegro.Prescriptor__c = efector.Id;
			reintegro.AccountId = afiliado.Id;
			reintegro.Fecha__c = Date.today();
			reintegro.Fecha_prescripcion__c = Date.today().addDays(-25);
			reintegro.Diagnostico__c = diagnostico.Id;
			reintegro.Observaciones__c = 'observaciones';
			reintegro.Importe_presupuesto__c = 2500;
			reintegro.Tipo_de_Comprobante__c = 'FACA';
			reintegro.Razon_social__c = 'Fulano SA.';
			reintegro.Delegacion__c = agencia.Id;
			reintegro.CUIT__c = '20231231230';
			reintegro.Lote__c = lote.Id;
		insert reintegro;
		setContentDocLinks(reintegro.Id);
		prest1 = new Prestacion__c();
			prest1.Alerta__c = 'SAB';
			prest1.Observaciones__c = 'NO REQUIERE OBSERV';
			prest1.Cantidad__c = 1;
			prest1.Prestacion__c = nomPrest.Id;
			prest1.Ap__c = caso.Id;
			prest1.Tipo__c = 'N';
		insert prest1;
		prestacion = new Prestacion_de_reintegro__c();
			prestacion.Estado__c = 'C1-----G';
			prestacion.Id_Externo__c = '74043156';
			prestacion.Caso__c = reintegro.Id;
			prestacion.Observaciones__c = 'obs';
			prestacion.Fecha_de_realizacion__c = Date.today();
			prestacion.Caras__c = 'Caras';
			prestacion.Pieza_dental__c = 'Pieza';
			prestacion.Importe_a_pagar__c = 2000;
			prestacion.Importe_total__c = 2000;
			prestacion.Cantidad__c = 1;
		insert prestacion;
		TestUtils.setMockResponse (getResponseFound, AUTORIZACION_URL, WSSendSSResponsesMock.getFound(caso.Id), 200, 'OK');
		TestUtils.setMockResponse (getResponsePresupuestoFound, AUTORIZACION_URL, WSSendSSResponsesMock.getFoundPresupuesto(caso.Id), 200, 'OK');
		TestUtils.setMockResponse (getResponseMaterialFound, AUTORIZACION_URL, WSSendSSResponsesMock.getFoundMaterial(caso.Id), 200, 'OK');
		TestUtils.setMockResponse (getResponseFoundWithEM, AUTORIZACION_URL, WSSendSSResponsesMock.getFoundWithEM(caso.Id), 200, 'OK');
		TestUtils.setMockResponse (getErrorResponse, AUTORIZACION_URL, WSSendSSResponsesMock.getError(), 422, 'Not Found');
		TestUtils.setMockResponse (getResponseReintegroFound, REINTEGROS_URL, WSSendSSResponsesMock.getFoundReintegro(prestacion.Id), 200, 'OK');
		TestUtils.setMockResponse (getErrorReintegroResponse, REINTEGROS_URL, WSSendSSResponsesMock.getErrorReintegro(), 404, 'Not Found');
	}
	/**-----------------------------------------------------------------------------------------------------------------------
		AP
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void whenACaseWithPresupuestoIsSentToSSWithCorrectData_ItShouldReturnAValidResponse () {
			caso.AP_Presupuesto__c = true;
			caso.Importe_presupuesto__c = 200;
			update caso;
			System.assertEquals(1, [SELECT COUNT() FROM Prestacion__c WHERE Ap__c = :caso.Id], 'Debe haber una prestación');
			Test.setMock(HttpCalloutMock.class, getResponsePresupuestoFound);
			Test.startTest();
			CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
			Test.stopTest();
			System.assertEquals(2, [SELECT COUNT() FROM Prestacion__c WHERE Ap__c = :caso.Id], 'Deben haber dos prestaciones');
			System.assert(!responseToAssert.hasError, 'No deben haber errores');
			System.assertEquals('success', responseToAssert.auraMessage.status, 'El estado debe ser éxitoso');
			System.assertEquals('Ok', responseToAssert.auraMessage.message, 'El estado debe ser éxitoso');
		}
		@isTest
		private static void whenACaseWithMaterialIsSentToSSWithCorrectData_ItShouldReturnAValidResponse () {
			caso.AP_Material__c = true;
			update caso;
			Test.setMock(HttpCalloutMock.class, getResponseMaterialFound);
			Test.startTest();
			CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
			Test.stopTest();
			Case casoPadre = getCaseByNroAP('1014010015');
			System.assertEquals('Celula 2', casoPadre.Celula__c, 'La célula debe ser 2');
			System.assertEquals('24', casoPadre.Tiempo_SLA__c, 'El SLA es de 24');
			Case casoMaterial = getCaseByNroAP('1014010632');
			System.assertEquals('Celula 1', casoMaterial.Celula__c, 'La célula debe ser 1');
			System.assertEquals('Material', casoMaterial.Sub_tipo__c, 'El subtipo debe ser Material');
			System.assertEquals('48', casoMaterial.Tiempo_SLA__c, 'El tiempo SLA debe ser 48');
			System.assert(!responseToAssert.hasError, 'No deben haber errores');
			System.assertEquals('success', responseToAssert.auraMessage.status, 'El estado debe ser éxitoso');
			System.assertEquals('Ok', responseToAssert.auraMessage.message, 'El estado debe ser éxitoso');
		}
		@isTest
		private static void whenACaseIsSentToSSWithCorrectData_ItShouldReturnAValidResponse () {
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
			Test.stopTest();
			System.assert(!responseToAssert.hasError, 'No deben haber errores');
			System.assertEquals('success', responseToAssert.auraMessage.status, 'El estado debe ser éxitoso');
			System.assertEquals('Ok', responseToAssert.auraMessage.message, 'El estado debe ser éxitoso');
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
		private static void whenACaseIsSentToSSWithIncorrectData_ItShouldReturnAnInvalidResponse () {
			Test.setMock(HttpCalloutMock.class, getErrorResponse);
			Case caso2 = new Case();
			caso.Fecha__c = Date.newInstance(2020, 2, 2);
			caso.Fecha_probable__c = Date.newInstance(2019, 2, 2);
			caso.AccountId = afiliado.Id;
			caso.Delegacion__c = agencia.Id;
			caso.Fecha_prescripcion__c = Date.newInstance(2020, 1, 31);
			caso.Diagnostico__c = diagnostico.Id;
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
			String msg = 'El campo user insert es obligatorio.\n' + 'El campo chk material debe estar presente.\n';
			msg += 'El campo chk presupuesto debe estar presente.\n' + 'El campo observaciones debe estar presente.\n';
			msg += 'El campo contexto debe estar presente.\n' + 'El campo alerta debe estar presente.\n';
			System.assert(responseToAssert.hasError, 'Deben haber errores');
			System.assertEquals('error', responseToAssert.auraMessage.status, 'El estado debe ser error');
			System.assertEquals(msg, responseToAssert.auraMessage.message, 'Mensaje debe indicar el error');
		}
		@isTest
		private static void whenACaseHasAttachments_ReturnTrue () {
			Case caso = new Case();
			insert caso;
			setContentDocLinks(caso.Id);
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			Boolean resp = CasoEnviarASSBtnCtrl.hasAttachments(caso.Id, null);
			Test.stopTest();
			System.assert(resp, 'La respuesta debe ser positiva');
		}
		@isTest
		private static void whenTheResponseHasAnEmAuthorizedUpdateTheEMStatus () {
			Evento_medico__c em = new Evento_medico__c();
			em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
			em.Estado__c = 'En Auditoria';
			em.Asociado__c = afiliado.Id;
			insert em;
			Segmentos__c seg = new Segmentos__c();
			seg.Estado__c = 'En Auditoria';
			seg.Evento_Medico__c = em.Id;
			seg.Solicitante__c = 'NO ENCOLAR';
			insert seg;
			caso.Evento_Medico__c = em.Id;
			update caso;
			Test.setMock(HttpCalloutMock.class, getResponseFoundWithEM);
			Test.startTest();
			CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
			Test.stopTest();
			System.assert(!responseToAssert.hasError, 'No deben haber errores');
			System.assertEquals('success', responseToAssert.auraMessage.status, 'El estado debe ser éxitoso');
			System.assertEquals('Ok', responseToAssert.auraMessage.message, 'El estado debe ser éxitoso');
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
		@isTest
		private static void ifSomeCaseHaveNotAttachmentsButEmailMessageRelateHasItSendTrue () {
			Case caso = new Case();
			insert caso;
			EmailMessage relatedEmail = new EmailMessage();
			relatedEmail.ParentId = caso.Id;
			insert relatedEmail;
			setContentDocLinks(relatedEmail.Id);
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			Boolean resp = CasoEnviarASSBtnCtrl.hasAttachments(caso.Id, null);
			Test.stopTest();
			System.assert(resp, 'La respuesta debe ser positiva');
		}
	/**-----------------------------------------------------------------------------------------------------------------------
		Reintegros
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void whenTheResponseIsCorrect_updateTheReintegroPrestacionesAndAlerts () {
			Test.setMock(HttpCalloutMock.class, getResponseReintegroFound);
			reintegro.Type = 'Prestacion';
			update reintegro;
			Nomenclador_de_Prestacion__c nom = new Nomenclador_de_Prestacion__c();
			nom.Codigo__c = '2222';
			nom.Estado__c = 'A';
			insert nom;
			prestacion.RecordTypeId = prestacionalRTId;
			prestacion.Prestacional__c = nom.Id;
			update prestacion;
			Test.startTest();
			CasoEnviarASSBtnCtrl.Response resp = CasoEnviarASSBtnCtrl.sendReintegroToSS(reintegro.Id);
			Test.stopTest();
			Case reintegroToAssert = getCase(reintegro.Id);
			System.assertEquals(false, resp.hasError, 'No debe haber errores');
			System.assertEquals('553276', reintegroToAssert.Codigo_reintegro_SS__c, 'El código de reingreso debe ser 553276');
			System.assertEquals('CA-----A', reintegroToAssert.Status, 'El estado del caso debe ser CA-----A');
			System.assertEquals(true, reintegroToAssert.Existente_SS__c, 'El campo Existente debe ser true');
			System.assertEquals('Celula 8', reintegroToAssert.Celula__c, 'Debe ser la célula 8');
			System.assertEquals('240', reintegroToAssert.Tiempo_SLA__c , 'EL tiempo del SLA debe ser 240');
			List<Prestacion_de_reintegro__c> prestacionesToAssert = [SELECT Estado__c,
																		(SELECT Id FROM Alertas__r)
																	FROM Prestacion_de_reintegro__c WHERE Caso__c =: reintegro.Id];
			System.assertEquals('C1-----A', prestacionesToAssert[0].Estado__c, 'El estado de la prestación debe ser C1-----A');
			System.assertEquals(4, prestacionesToAssert[0].Alertas__r.size(), 'Deben haber cuatro alertas');
		}
		@isTest
		private static void whenTheResponseIsInvalid_ShowTheErrorMsgFromWs () {
			Test.setMock(HttpCalloutMock.class, getErrorReintegroResponse);
			Test.startTest();
			CasoEnviarASSBtnCtrl.Response resp = CasoEnviarASSBtnCtrl.sendReintegroToSS(reintegro.Id);
			Test.stopTest();
			String msg = 'El campo lote es obligatorio.\n' + 'El campo agencia codigo es obligatorio.\n';
			System.assertEquals(true, resp.hasError, 'Debe haber un error');
			System.assertEquals(msg, resp.auraMessage.message, 'El mensaje indicar que el cambio lote y agencia es obligatorio');
		}
		@isTest
		private static void whenAnEMHasNotAttachments_ShowErrorMessage () {
			Case reintegro = new Case();
			reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
			insert reintegro;
			Test.startTest();
			CasoEnviarASSBtnCtrl.Response resp = CasoEnviarASSBtnCtrl.sendReintegroToSS(reintegro.Id);
			Test.stopTest();
			System.assertEquals('No se puede enviar porque no tiene archivos adjuntos', resp.auraMessage.message, 'El mensaje debe indicar que no se puede enviar sin archivos adjuntos');
		}
	/** Utils */
	private static void setContentDocLinks (String recordId) {
		ContentVersion contentVersion = new ContentVersion(
			Title = 'title',
			PathOnClient = '/title.pdf',
			VersionData = Blob.valueOf('Test Content'),
			IsMajorVersion = true
		);
		insert contentVersion;
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink cdl = new ContentDocumentLink();
			cdl.LinkedEntityId = recordId;
			cdl.ContentDocumentId = documents[0].Id;
			cdl.shareType = 'V';
		insert cdl;
	}
	private static Case getCase (Id casoId) {
		return [SELECT Id,
					Nro_AP__c,
					Fecha__c,
					Fecha_probable__c,
					Status,
					Consultorio__r.Secuencia__c,
					Account.Codigo_de_Afiliado__c,
					Fecha_prescripcion__c,
					Diagnostico__r.Codigo_del_Diagnostico__c,
					Prescriptor__r.Codigo_de_efector__c,
					Prestador__r.Codigo_de_efector__c,
					Consultorio__r.Codigo_externo__c,
					Observaciones__c,
					Mail__c,
					Otros_Mail__c,
					Delegacion__r.Codigo_de_delegacion__c,
					Nivel_de_derivacion__c,
					Type,
					Codigo_reintegro_SS__c,
					Existente_SS__c,
					Celula__c,
					Tiempo_SLA__c
				FROM Case
				WHERE Id = :casoId];
	}
	private static Case getCaseByNroAP (String nroAP) {
		return [SELECT Id,
					Celula__c,
					RecordType.Name,
					Type,
					Sub_tipo__c,
					Tiempo_SLA__c
				FROM Case
				WHERE Nro_AP__c =: nroAP];
	}
	private static Prestacion__c[] getPrestacion (Id casoId) {
		return [SELECT Id,
					Estado__c,
					Prestacion_CA__c,
					Texto_aclarativo_alerta__c,
					Alerta__c,
					Nombre_de_Prestacion__c,
					Cambio_automatico__c
				FROM Prestacion__c
				WHERE Ap__c = :casoId];
	}
	private static Alerta__c[] getAlertas (Id prestacionId) {
		return [SELECT Id,
					Control__c,
					Funcion__c,
					Texto_aclarativo__c,
					Fecha_de_generacion_de_Alerta__c,
					Lectura_de_alerta_auditor__c,
					Resolucion_de_alerta_auditor__c,
					Fecha_resolucion_de_Alerta__c,
					idalerta__c
				FROM Alerta__c
				WHERE Prestacion__c = :prestacionId];
	}
}