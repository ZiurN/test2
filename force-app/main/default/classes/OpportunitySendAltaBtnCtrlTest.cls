@isTest 
private class OpportunitySendAltaBtnCtrlTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundNotasIdSF;
	static XHttpCalloutMock getResponseFoundIncomplete;
	static XHttpCalloutMock getResponseFoundTransformada;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getResponseFoundReingGFam;
	static XHttpCalloutMock getResponseFoundReingGFamWithFamId;
	static XHttpCalloutMock getResponseFoundIncompleteReingGFam;
	static XHttpCalloutMock getResponseFoundTransformadaReingGFam;
	static XHttpCalloutMock getErrorResponseReingGFam;
	static XHttpCalloutMock getResponseFoundReingreso;
	static XHttpCalloutMock getResponseFoundIncompleteReingreso;
	static XHttpCalloutMock getResponseFoundTransformadaReingreso;
	static XHttpCalloutMock getErrorResponseReingreso;
	static User userNotComercial;
	static Localidad__c loc;
	static Account acc;
	static Account os;
	static Account agencia;
	static Opportunity opp;
	static Cotizacion__c cotizacion;
	static {
		acc = Build.anAccountCuentapersonal().build();
		acc.FirstName = 'Fulano';
		acc.Codigo_de_Afiliado__c = '999999';
		acc.Referido__c = 'N';
		acc.PersonEmail = 'test@gmail.com';
		acc.Phone = '44445555';
		acc.Tipo_de_Telefono__c = 'TEL';
		acc.PersonDepartment = '4d';
		acc.Actividad_codigo__c = 'COM';
		acc.Type = 'TIT';
		os = Build.anAccountObrasocial().withCodigodeOS('99880').build();
		agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('170505').build();
		Account[] accounts = new List<Account>{acc, os, agencia};
		insert accounts;
		loc = new Localidad__c();
		loc.Loc_Id__c = '2000';
		loc.Codigo_Postal__c = '7102';
		insert loc;
		opp = Build.anOpportunityIndividuos().build();
		opp.AccountId = acc.Id;
		opp.Dpto__c = '4d';
		opp.StageName = 'Contactado';
		opp.CUIT__c = '20201233500';
		opp.Medio_de_cobro__c = 'Tarjeta';
		opp.Tarjeta_de_credito__c = 'TRO02';
		opp.Nmero_de_tarjeta_de_credito__c = '1111222233334444';
		opp.Indicador_de_Afiliacion_de_Inmediata__c = false;
		opp.Indicador_de_contratacion_de_emergencia__c = false;
		opp.Condicion_IVA__c = '1';
		opp.Numero_de_documento__c = '11222333';
		opp.Tipo_de_Documento__c = 'DNI';
		opp.Piso__c = '4';
		opp.Numero__c = 123;
		opp.Calle__c = 'Calle Falsa';
		opp.Localidad__c = 'Ciudadela';
		opp.Localidad_new__c = loc.Id;
		opp.Nacionalidad__c = '054';
		opp.Fecha_de_Nacimiento__c = Date.today().addYears(-30);
		opp.Sexo__c = 'M';
		opp.Estado_Civil__c = 'S';
		opp.Segmento_del_Grupo_Familiar__c = 'OBLDIR'; // VOLEMP
		opp.Aportes_del_titular__c = 1234.5;
		opp.Plan_del_grupo_familiar__c = 'AS200';
		opp.Obra_social_del_titular__c = os.Id;
		opp.Agencia__c = agencia.Id;
		opp.Fecha_de_vigencia_de_solicitud__c = Date.today().addDays(15);
		opp.Codigo_Postal__c = '7102';
		opp.Tipo_de_Solicitud__c = 'ALTA';
		opp.Asesor_comercial__c = 'Algo';
		opp.Tipo_de_Asociado__c = 'Relacion de Dependencia';
		opp.Tipo_contacto__c = 'Individuo';
		opp.Provincia__c = 'Buenos Aires';
		opp.ActividadProfesion_del_titular__c = 'COM';
		opp.Telefono__c = '1144449999';
		opp.Cobertura_anterior__c = os.Id;
		opp.Canal_de_contacto_Asesor_con_cliente__c = 'Telefono';
		insert opp;
		ContentVersion file1 = new ContentVersion();
		file1.Title = 'Sola_' + opp.Id;
		file1.PathOnClient = '/file1';
		file1.VersionData = Blob.valueOf('test 1');
		ContentVersion file2 = new ContentVersion();
		file2.Title = 'Solb_' + opp.Id;
		file2.PathOnClient = '/file2';
		file2.VersionData = Blob.valueOf('test 2');
		ContentVersion file3 = new ContentVersion();
		file3.Title = 'DDJJa_' + opp.Id;
		file3.PathOnClient = '/file3';
		file3.VersionData = Blob.valueOf('test 3');
		ContentVersion file4 = new ContentVersion();
		file4.Title = 'DDJJb_' + opp.Id;
		file4.PathOnClient = '/file4';
		file4.VersionData = Blob.valueOf('test 4');
		ContentVersion file5 = new ContentVersion();
		file5.Title = 'dni_titular_' + opp.Id;
		file5.PathOnClient = '/file5';
		file5.VersionData = Blob.valueOf('test 5');
		ContentVersion file6 = new ContentVersion();
		file6.Title = 'ultimo_recibo_sueldo_' + opp.Id;
		file6.PathOnClient = '/file6';
		file6.VersionData = Blob.valueOf('test 6');
		ContentVersion file7 = new ContentVersion();
		file7.Title = 'codem_' + opp.Id;
		file7.PathOnClient = '/file7';
		file7.VersionData = Blob.valueOf('test 7');
		ContentVersion file8 = new ContentVersion();
		file8.Title = 'cuil_' + opp.Id;
		file8.PathOnClient = '/file8';
		file8.VersionData = Blob.valueOf('test 8');
		cotizacion = new Cotizacion__c();
		cotizacion.Oportunidad__c = opp.Id;
		cotizacion.CP__c = '7102';
		cotizacion.Plan_a_cotizar__c = 'AS200';
		cotizacion.Total_de_capitas_cotizadas__c = '1';
		cotizacion.Tipo_de_afiliado__c = 'Relacion de Dependencia';
		cotizacion.Sueldo_bruto__c = 5000;
		insert cotizacion;
		opp.StageName = 'Cotizado';
		opp.Cotizacion_elegida__c = cotizacion.Id;
		update opp;
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSOpportunitySendAltaMock.getFound(opp.Id))
				.addForAddress(WSOpportunitySendAlta.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta');
		getResponseFoundIncomplete = new XHttpCalloutMock();
		getResponseFoundIncomplete.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundIncomplete.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSOpportunitySendAltaMock.getFoundIncomplete(opp.Id))
				.addForAddress(WSOpportunitySendAlta.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta');
		getResponseFoundTransformada = new XHttpCalloutMock();
		getResponseFoundTransformada.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundTransformada.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSOpportunitySendAltaMock.getFoundTransformada(opp.Id))
				.addForAddress(WSOpportunitySendAlta.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta');
		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(422)
				.withBody(WSOpportunitySendAltaMock.getError())
				.addForAddress(WSOpportunitySendAlta.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta');
		getResponseFoundReingGFam = new XHttpCalloutMock();
		getResponseFoundReingGFam.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundReingGFam.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSOpportunityReingresoGFamMock.getFound())
				.addForAddress(WSOpportunityReingresoGFam.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reingreso-grupo-familiar');
		getErrorResponseReingGFam = new XHttpCalloutMock();
		getErrorResponseReingGFam.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseReingGFam.buildResponse()
				.withStatus('OK')
				.withStatusCode(422)
				.withBody(WSOpportunityReingresoGFamMock.getError())
				.addForAddress(WSOpportunityReingresoGFam.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reingreso-grupo-familiar');
		getResponseFoundReingreso = new XHttpCalloutMock();
		getResponseFoundReingreso.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundReingreso.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSOpportunityReingresoMock.getFound(opp.Id))
				.addForAddress(WSOpportunityReingreso.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reingreso');
		getErrorResponseReingreso = new XHttpCalloutMock();
		getErrorResponseReingreso.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseReingreso.buildResponse()
				.withStatus('OK')
				.withStatusCode(422)
				.withBody(WSOpportunityReingresoMock.getError())
				.addForAddress(WSOpportunityReingreso.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reingreso');
	}
	@isTest
	private static void whenAnOppIsSendToSSWithCorrectData_ItShouldReturnAValidResponse() {
	//-------------------------------------------------------------------------------
	// **** IMPORTANTE **** Ingresar el integrante y la cotizacion antes de cambiar
	// la etapa de la oportunidad a "En tramitación"
	//-------------------------------------------------------------------------------
		opp.StageName = 'Cotizado';
		update opp;
		Integrante__c integrante = Build.anIntegrante().withSexo('M').withTelefono('55556666').withNroDocumento('24123123')
			.withTipoDeRelacionConTitular('Hijo/a').withTipoDocumento('DNI').withNacionalidad('054').withPrefijo(11)
			.withDiscapacidad('No').withIndicadorDeAporte(true).withMail('ej@gmail.com').withNombre('Fulanito')
			.withApellido('Test').withCUIT('20541231235').withFechaNacimiento(Date.today().addYears(-10)).withAportes(1234)
			.withEstadoCivil('S')
			.build();
		integrante.Oportunidad__c = opp.Id;
		insert integrante;
		cotizacion.Total_de_capitas_cotizadas__c = '2';
		update cotizacion;
		opp.StageName = 'En tramitación';
		update opp;
		ContentVersion file1 = new ContentVersion();
		file1.Title = 'dni_integrante_' + integrante.Id;
		file1.PathOnClient = '/file1';
		file1.VersionData = Blob.valueOf('test 1');
		ContentVersion file2 = new ContentVersion();
		file2.Title = 'recibo_sueldo_integrante_' + integrante.Id;
		file2.PathOnClient = '/file2';
		file2.VersionData = Blob.valueOf('test 2');
		ContentVersion file3 = new ContentVersion();
		file3.Title = 'cert_nacimiento_integrante_' + integrante.Id;
		file3.PathOnClient = '/file3';
		file3.VersionData = Blob.valueOf('test 2');
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert new List<ContentVersion>{file1, file2, file3,fileSolicitud};
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		Set<Id> setIds = new Set<Id>{file1.Id,file2.Id,file3.Id};
		Map<Id,ContentVersion> mapFiles = new Map<Id,ContentVersion>([
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id IN :setIds
		]);
		file1 = mapFiles.get(file1.Id);
		file2 = mapFiles.get(file2.Id);
		file3 = mapFiles.get(file3.Id);
		ContentDocumentLink link = new ContentDocumentLink();
		link.ContentDocumentId = file1.ContentDocumentId;
		link.LinkedEntityId = opp.Id;
		ContentDocumentLink link2 = new ContentDocumentLink();
		link2.ContentDocumentId = file2.ContentDocumentId;
		link2.LinkedEntityId = opp.Id;
		ContentDocumentLink link3 = new ContentDocumentLink();
		link3.ContentDocumentId = file3.ContentDocumentId;
		link3.LinkedEntityId = opp.Id;
		insert new List<ContentDocumentLink>{link, link2, link3};
		Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Ejemplo');
		nota.RecordTypeId = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Ventas').Id;
		nota.Oportunidad__c = opp.Id;
		insert nota;
		WSOpportunitySendAltaMock mock = new WSOpportunitySendAltaMock();
		getResponseFoundNotasIdSF = new XHttpCalloutMock();
		getResponseFoundNotasIdSF.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundNotasIdSF.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(mock.getFoundWithSFIdNota(nota.Id,opp.Id))
				.addForAddress(WSOpportunitySendAlta.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta');
		Test.setMock(HttpCalloutMock.class, getResponseFoundNotasIdSF);
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		Opportunity oppToAssert = [SELECT Estado_de_solicitud__c, Nro_de_solicitud__c FROM Opportunity WHERE Id =: opp.Id];
		System.assertEquals('OK', responseToAssert.message.toUpperCase(), 'Se espera un mensaje ok');
		System.assert(!responseToAssert.hasError, 'No deben haber errores');
		System.assertEquals('Completa', oppToAssert.Estado_de_solicitud__c, 'El estado debe ser Completa');
		System.assertEquals('724171', oppToAssert.Nro_de_solicitud__c, 'El número de solicitud debe ser 724171');
		List<Nota_de_Auditoria__c> notas = [SELECT Id, Nota__c, Id_externo_solicitudes__c, Oportunidad__c
											FROM Nota_de_Auditoria__c
											WHERE Oportunidad__c =: opp.Id];
		System.assertEquals('128805', notas[0].Id_externo_solicitudes__c, 'El Id de la solicitud es 128805');
	}
	@isTest
	private static void whenAnOppIsSendToSSWithCorrectData_ItShouldReturnAValidResponse2() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		opp.StageName = 'En tramitación';
		opp.Medio_de_cobro__c = 'CBU';
		opp.Tipo_CBU__c = 'CBUFR';
		opp.Nro_CBU_para_cobro_de_cuota__c = '111122223333444455551';
		opp.Segmento_del_Grupo_Familiar__c = 'OBLDIR';
		opp.CUIL_del_CBU__c = '20123456786';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		Opportunity oppToAssert = [SELECT Estado_de_solicitud__c, Nro_de_solicitud__c FROM Opportunity WHERE Id =: opp.Id];
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('OK', responseToAssert.message.toUpperCase(), 'Debe haber un mensaje de ok');
		System.assertEquals('Completa', oppToAssert.Estado_de_solicitud__c, 'El estado de la solicitud es Completa');
		System.assertEquals('724171', oppToAssert.Nro_de_solicitud__c, 'El id de la solicitud debe ser 724171');
	}
	@isTest
	private static void whenAnOppIsSendToSSWithCorrectData_ItShouldReturnAValidResponse3() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		opp.StageName = 'En tramitación';
		opp.Medio_de_cobro__c = 'Otros';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		Opportunity oppToAssert = [SELECT Estado_de_solicitud__c, Nro_de_solicitud__c, StageName
									FROM Opportunity WHERE Id =: opp.Id];
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('OK', responseToAssert.message.toUpperCase(), 'Debe haber un mensaje de ok');
		System.assertEquals('Completa', oppToAssert.Estado_de_solicitud__c, 'El estado de la solicitud es Completa');
		System.assertEquals('724171', oppToAssert.Nro_de_solicitud__c, 'El id de la solicitud debe ser 724171');
		System.assertEquals('En tramitación', oppToAssert.StageName, 'El Estado debe ser En tramitación');
	}
	@isTest
	private static void whenAnOppIsSendToSSWithCorrectData_ItShouldReturnAValidResponseTransformada() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundTransformada);
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		opp.StageName = 'En tramitación';
		opp.Nro_de_asociado__c = '123456/12';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		Opportunity oppToAssert = [SELECT Estado_de_solicitud__c, Nro_de_solicitud__c, StageName
									FROM Opportunity WHERE Id =: opp.Id];
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('OK', responseToAssert.message.toUpperCase(), 'Debe haber un mensaje de ok');
		System.assertEquals('Transformada', oppToAssert.Estado_de_solicitud__c, 'El estado de la solicitud es Transformada');
		System.assertEquals('724354', oppToAssert.Nro_de_solicitud__c, 'El id de la solicitud debe ser 724354');
		System.assertEquals('Cerrada ganada', oppToAssert.StageName, 'El Estado debe ser Cerrada ganada');
	}
	@isTest
	private static void whenAnOppIsSendToSSWithCorrectData_ItShouldReturnAValidResponseIncomplete() {
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		Test.setMock(HttpCalloutMock.class, getResponseFoundIncomplete);
		opp.Nro_de_solicitud__c = '724354';
		opp.Medio_de_cobro__c = 'CBU';
		opp.Tipo_CBU__c = 'CBUFR';
		opp.StageName = 'En tramitación';
		opp.Nro_CBU_para_cobro_de_cuota__c = '111122223333444455551';
		opp.Segmento_del_Grupo_Familiar__c = 'VOLEMP'; // OBLEMP
		opp.CUIL_del_CBU__c = '20123456786';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		Opportunity oppToAssert = [SELECT Estado_de_solicitud__c, Nro_de_solicitud__c FROM Opportunity WHERE Id =: opp.Id];
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('Se actualizó la solicitud de alta. Error al validar 20012: CUIT/CUIL no se corresponde con el nro. documento',
			responseToAssert.message, 'Debe haber un mensaje de error');
		System.assertEquals('Incompleta', oppToAssert.Estado_de_solicitud__c, 'El estado de la solicitud es Incompleta');
		System.assertEquals('724354', oppToAssert.Nro_de_solicitud__c, 'El id de la solicitud debe ser 724354');
	}
	@isTest
	private static void validateEmptyFields() {
		acc.PersonEmail = null;
		update acc;
		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.AccountId = acc.Id;
		opp.StageName = 'Contactado';
		opp.Tipo_de_Solicitud__c = 'ALTA';
		opp.Estado_Civil__c = 'S';
		opp.Segmento_del_Grupo_Familiar__c = 'VOLDIR';
		opp.Canal_de_contacto_Asesor_con_cliente__c = 'Telefono';
		opp.Telefono__c = '1234567890';
		insert opp;
		cotizacion = new Cotizacion__c();
		cotizacion.Oportunidad__c = opp.Id;
		cotizacion.CP__c = '7102';
		cotizacion.Total_de_capitas_cotizadas__c = '1';
		insert cotizacion;
		opp.StageName = 'Cotizado';
		opp.Cotizacion_elegida__c = cotizacion.Id;
		update opp;
		opp.StageName = 'En Negociación';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		String msg = 'Agencia: No puede estar vacío.\n'+
						'Fecha de vigencia de solicitud: No puede estar vacío.\n'+
						'Correo Electrónico: no puede estar vacío.\n'+
						'Sexo: no puede estar vacío.\n'+
						'Fecha de Nacimiento: no puede estar vacía.\n'+
						'Localidad: no puede estar vacía.\n'+
						'Nacionalidad: No puede estar vacía.\n'+
						'Tipo de Documento: No puede estar vacío.\n'+
						'Número de documento: No puede estar vacío.\n'+
						'Calle: No puede estar vacío.\n'+
						'Número: No puede estar vacío.\n'+
						'Condición IVA: No puede estar vacío.\n'+
						'Plan del grupo familiar: No puede estar vacío.\n'+
						'Actividad Profesional: No puede estar vacío.\n'+
						'Medio de cobro: No puede estar vacío.\n';
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals(msg, responseToAssert.message, 'Debe haber un mensaje de error');
	}
	@isTest
	private static void validateEmptyFieldsTarjeta() {
		opp.StageName = 'En tramitación';
		opp.Tarjeta_de_credito__c = null;
		opp.Nmero_de_tarjeta_de_credito__c = null;
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		String msg = 'Número de tarjeta de crédito: No puede estar vacío.\n' +
					'Tarjeta de crédito: No puede estar vacía.\n';
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals(msg, responseToAssert.message, 'Debe haber un mensaje de error');
	}
	@isTest
	private static void validateStageNameToSendToSS() {
		opp.StageName = 'Cotizado';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		String msg = 'La oportunidad debe estar en etapa "En tramitación" o "En Negociación" para poder enviarla';
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals(msg, responseToAssert.message, 'Debe haber un mensaje de error');
	}
	@isTest
	private static void whenAnOppIsSendToSSWithIncorrectData_ItShouldReturnAnInvalidResponse() {
		opp.StageName = 'En tramitación';
		update opp;
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		String errorMsg = 'Falta archivo adjunto: Avalian - Solicitud de ingreso y DDJJ completa.pdf\n';
		System.assert(responseToAssert.hasError, 'Debe haber un error');
		System.assertEquals(errorMsg, responseToAssert.message, 'Debe haber un mensaje de error');
	}
	@isTest
	private static void translateRelacionConTitularHI() {
		Test.startTest();
		String relacion = OpportunitySendAltaBtnCtrl.getRelacionConTitular('Hijo/a');
		Test.stopTest();
		System.assertEquals('HI', relacion, 'La relación debe ser HI');
	}
	@isTest
	private static void translateRelacionConTitularCO() {
		Test.startTest();
		String relacion = OpportunitySendAltaBtnCtrl.getRelacionConTitular('Conyuge');
		Test.stopTest();
		System.assertEquals('CO', relacion, 'La relación debe ser CO');
	}
	@isTest
	private static void translateRelacionConTitularOtro() {
		Test.startTest();
		String relacion = OpportunitySendAltaBtnCtrl.getRelacionConTitular('Otro');
		Test.stopTest();
		System.assertEquals('Otro', relacion, 'La relación debe ser Otro');
	}
	@isTest
	private static void TranslateRelacionConTitularNull() {
		Test.startTest();
		String relacion = OpportunitySendAltaBtnCtrl.getRelacionConTitular(null);
		Test.stopTest();
		System.assertEquals(null, relacion, 'La relación debe ser Nula');
	}
	@isTest
	private static void testReingreso() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundReingreso);
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		opp.Reingresa_como__c = 'Titular';
		opp.StageName = 'En tramitación';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('Se actualizó satisfactoriamente la solicitud de reingreso.', responseToAssert.message, 'Debe haber un mensaje satisfactorio');
	}
	@isTest
	private static void testReingresoGFam() {
		opp.Tipo_de_Solicitud__c = 'REING_GFAM';
		opp.Segmento_del_Grupo_Familiar__c = 'OBLDIR';
		opp.StageName = 'Contactado';
		update opp;
		cotizacion.Total_de_capitas_cotizadas__c = '2';
		update cotizacion;
		opp.StageName = 'Cotizado';
		update opp;
		opp.StageName = 'En Negociación';
		update opp;
		Integrante__c integrante = Build.anIntegrante().withSexo('M').withTelefono('55556666').withNroDocumento('24123123')
			.withTipoDeRelacionConTitular('Hijo/a').withTipoDocumento('DNI').withNacionalidad('054').withPrefijo(11)
			.withDiscapacidad('No').withIndicadorDeAporte(true).withMail('ej@gmail.com').withNombre('Fulanito')
			.withApellido('Test').withCUIT('20541231235').withFechaNacimiento(Date.today().addYears(-10)).withAportes(1234)
			.withEstadoCivil('S')
			.build();
		integrante.Oportunidad__c = opp.Id;
		insert integrante;
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		WSOpportunityReingresoGFamMock mock = new WSOpportunityReingresoGFamMock();
		getResponseFoundReingGFamWithFamId = new XHttpCalloutMock();
		getResponseFoundReingGFamWithFamId.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundReingGFamWithFamId.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(mock.getFoundWithFamId(opp.Id,integrante.Id))
				.addForAddress(WSOpportunityReingresoGFam.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reingreso-grupo-familiar');
		Test.setMock(HttpCalloutMock.class, getResponseFoundReingGFamWithFamId);
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		System.debug(responseToAssert);
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('OK', responseToAssert.message.toUpperCase(), 'Debe haber un mensaje ok');
		Integrante__c integranteToAssert = [SELECT Nro_de_asociado__c FROM Integrante__c WHERE Id =: integrante.Id];
		System.assertEquals('223483/24', integranteToAssert.Nro_de_asociado__c, 'El número de asociado debe ser 223483/24');
	}
	@isTest
	private static void ReingresoComoTitularMissingFields() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.AccountId = acc.Id;
		opp.StageName = 'Contactado';
		opp.Reingresa_como__c = 'Titular';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.Estado_Civil__c = 'S';
		opp.Segmento_del_Grupo_Familiar__c = 'VOLDIR';
		opp.Tipo_de_Asociado__c = 'Relacion de Dependencia';
		opp.Plan_del_grupo_familiar__c = 'AS200';
		insert opp;
		cotizacion = new Cotizacion__c();
		cotizacion.Oportunidad__c = opp.Id;
		cotizacion.CP__c = '7102';
		cotizacion.Total_de_capitas_cotizadas__c = '1';
		cotizacion.Plan_a_cotizar__c = 'AS200';
		cotizacion.Tipo_de_afiliado__c = 'Relacion de Dependencia';
		cotizacion.Sueldo_bruto__c = 5000;
		insert cotizacion;
		opp.StageName = 'Cotizado';
		opp.Cotizacion_elegida__c = cotizacion.Id;
		update opp;
		opp.StageName = 'En Negociación';
		opp.Telefono__c = '1234567890';
		opp.Canal_de_contacto_Asesor_con_cliente__c = 'Telefono';
		update opp;
		String msg = 'Agencia: No puede estar vacío.\n'+
					'Fecha de vigencia de solicitud: No puede estar vacío.\n'+
					'Sexo: no puede estar vacío.\n'+
					'Actividad/Profesión del titular: No puede estar vacía.\n'+
					'Obra social del titular: No puede estar vacío.\n'+
					'Medio de cobro: No puede estar vacío.\n'+
					'Condición IVA: No puede estar vacío.\n';
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals(msg, responseToAssert.message, 'Debe haber un mensaje de error');
	}
	@isTest
	private static void ReingresoComoFamiliarMissingFields() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
		opp.AccountId = acc.Id;
		opp.StageName = 'Contactado';
		opp.Reingresa_como__c = 'Familiar';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.Plan_del_grupo_familiar__c = 'AS200';
		opp.Estado_Civil__c = 'S';
		opp.Segmento_del_Grupo_Familiar__c = 'VOLDIR';
		insert opp;
		cotizacion = new Cotizacion__c();
		cotizacion.Oportunidad__c = opp.Id;
		cotizacion.CP__c = '7102';
		cotizacion.Plan_a_cotizar__c = 'AS200';
		cotizacion.Total_de_capitas_cotizadas__c = '1';
		insert cotizacion;
		opp.StageName = 'Cotizado';
		opp.Cotizacion_elegida__c = cotizacion.Id;
		update opp;
		opp.StageName = 'En Negociación';
		opp.Telefono__c = '1234567890';
		opp.Canal_de_contacto_Asesor_con_cliente__c = 'Telefono';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		String msg = 'Agencia: No puede estar vacío.\n' +
					'Fecha de vigencia de solicitud: No puede estar vacío.\n' +
					'Sexo: no puede estar vacío.\n' +
					'Actividad/Profesión del titular: No puede estar vacía.\n' +
					'Nro asociado titular anterior: No puede estar vacío.\n' +
					'En la Cuenta, Parentesco: No puede estar vacío.\n';
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals(msg, responseToAssert.message, 'Debe haber un mensaje de error');
	}
	@isTest
	private static void testReingresoVoluntarioCBU() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundReingreso);
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		opp.Reingresa_como__c = 'Titular';
		opp.StageName = 'En tramitación';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.Nro_de_solicitud__c = '123456';
		opp.Medio_de_cobro__c = 'CBU';
		opp.Tipo_CBU__c = 'CBUFR';
		opp.Nro_CBU_para_cobro_de_cuota__c = '1111222233334444555512';
		opp.CUIL_del_CBU__c = '20123456786';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('Se actualizó satisfactoriamente la solicitud de reingreso.', responseToAssert.message, 'Debe haber un mensaje satisfactorio');
	}
	@isTest
	private static void testReingresoObligatorioCBU() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundReingreso);
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		opp.Reingresa_como__c = 'Titular';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.StageName = 'En tramitación';
		opp.Nro_de_solicitud__c = '123456';
		opp.Medio_de_cobro__c = 'CBU';
		opp.Tipo_CBU__c = 'CBUFR';
		opp.Segmento_del_Grupo_Familiar__c = 'OBLDIR';
		opp.Nro_CBU_para_cobro_de_cuota__c = '1111222233334444555512';
		opp.CUIL_del_CBU__c = '20123456786';
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('Se actualizó satisfactoriamente la solicitud de reingreso.', responseToAssert.message, 'Debe haber un mensaje satisfactorio');
	}
	@isTest
	private static void testReingresoMedioDeCobroOtros() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundReingreso);
		acc.Parentesco__c = 'HI';
		update acc;
		Account titular = Build.anAccountCuentapersonal().build();
		titular.Codigo_de_Afiliado__c = '123456/12';
		insert titular;
		ContentVersion fileSolicitud = new ContentVersion();
		fileSolicitud.Title = 'Avalian - Solicitud de ingreso y DDJJ completa.pdf';
		fileSolicitud.PathOnClient = '/file1';
		fileSolicitud.VersionData = Blob.valueOf('test 1');
		insert fileSolicitud;
		ContentVersion fileRetrieved = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :fileSolicitud.Id];
		ContentDocumentLink linkDS = new ContentDocumentLink();
		linkDS.ContentDocumentId = fileRetrieved.ContentDocumentId;
		linkDS.LinkedEntityId = opp.Id;
		insert linkDS;
		opp.StageName = 'En tramitación';
		opp.Reingresa_como__c = 'Familiar';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';
		opp.Nro_de_solicitud__c = '123456';
		opp.Medio_de_cobro__c = 'Otros';
		opp.Titular_del_grupo_familiar_anterior__c = titular.Id;
		update opp;
		Test.startTest();
		OpportunitySendAltaBtnCtrl.Response responseToAssert = OpportunitySendAltaBtnCtrl.sendAltaToSS(opp.Id);
		Test.stopTest();
		System.assert(!responseToAssert.hasError, 'No debe haber un error');
		System.assertEquals('Se actualizó satisfactoriamente la solicitud de reingreso.', responseToAssert.message, 'Debe haber un mensaje satisfactorio');
	}
}