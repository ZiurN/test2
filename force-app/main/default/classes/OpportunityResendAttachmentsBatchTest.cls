@isTest 
private class OpportunityResendAttachmentsBatchTest {
	
	static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
	static Localidad__c loc;
	static Account acc;
	static Account os;
	static Account agencia;
	static Opportunity opp;
	static Cotizacion__c cotizacion;	

	static{
		

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

		
	}

	
	@testSetup static void setup(){
		Test.startTest();
		acc = Build.anAccountCuentapersonal().build();
		acc.FirstName = 'Fulano';
		acc.Codigo_de_Afiliado__c = '999999';
		acc.Referido__c = 'N';
		acc.PersonEmail = 'test@gmail.com';
		acc.Phone = '44445555';
		acc.Tipo_de_Telefono__c = 'TEL';
		acc.PersonDepartment = '4d';
		acc.Actividad_codigo__c = 'COM';
		acc.Type = 'Titular';
		insert acc;

		os = Build.anAccountObrasocial().withCodigodeOS('99880').build();
		insert os;

		agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('170505').build();
		insert agencia;
		
		opp = Build.anOpportunityIndividuos().build();
		opp.AccountId = acc.Id;
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
		opp.Nacionalidad__c = '054';
		opp.Fecha_de_Nacimiento__c = Date.today().addYears(-30);
		opp.Sexo__c = 'M';
		opp.Estado_Civil__c = 'S';
		//-----------------------------------------------------
		opp.Segmento_del_Grupo_Familiar__c = 'OBLDIR'; // VOLEMP
		//-----------------------------------------------------
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
		opp.Cobertura_anterior__c = os.Id;
		insert opp;

		Opportunity opp2 = opp.clone(false, false, false, false);
		opp2.Numero_de_documento__c = '11222334';
		opp2.Error_archivos__c = 'error';
		insert opp2;
		
		cotizacion = new Cotizacion__c();
		cotizacion.Oportunidad__c = opp.Id;
		cotizacion.CP__c = '7102';
		insert cotizacion;

		opp.Cotizacion_elegida__c = cotizacion.Id;
		update opp;

		loc = new Localidad__c();
		loc.Loc_Id__c = '2000';
		loc.Codigo_Postal__c = '7102';
		insert loc;

		opp.Localidad_new__c = loc.Id;


		Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Ejemplo');
		nota.RecordTypeId = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Ventas').Id;
		nota.Oportunidad__c = opp.Id;
		insert nota;

		User usuario = [SELECT UserRole.Name, UserRole.DeveloperName, CommunityNickname, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
	
		opp.Error_archivos__c = 'Error';
		opp.Fecha_error_archivos__c = Datetime.now();
        opp.Usuario_error__c = 'CRIOS';
		opp.Tipo_de_Solicitud__c = 'REINGRESO';

		//ContentVersion ver1 = new ContentVersion();
		//ver1.VersionData = Blob.valueOf('test 1');
		//ver1.Title = 'test 1';
		//ver1.PathOnClient = '/test';
		//ver1.Enviado__c = false;
		//insert ver1;
		//ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];

		//ContentVersion ver2 = new ContentVersion();
		//ver2.VersionData = Blob.valueOf('test 2');
		//ver2.Title = 'test 2';
		//ver2.PathOnClient = '/test2';
		//ver2.Enviado__c = false;
		//insert ver2;
		//ver2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver2.Id];

		//ContentDocumentLink link1 = new ContentDocumentLink();
		//link1.ContentDocumentId = ver1.ContentDocumentId;
		//link1.LinkedEntityId = opp.Id;
		//insert link1;

		//ContentDocumentLink link2 = new ContentDocumentLink();
		//link2.ContentDocumentId = ver2.ContentDocumentId;
		//link2.LinkedEntityId = opp.Id;
		//insert link2;

		update opp;
		Test.stopTest();
	}

	@isTest
	private static void testResendFailedDocumentsToSS() {
		
		opp = [SELECT Id,Error_archivos__c,Fecha_error_archivos__c FROM Opportunity LIMIT 1];

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
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		Database.executeBatch(new OpportunityResendAttachmentsBatch());
		Test.stopTest();

		List<Opportunity>  opps= [SELECT Id,Error_archivos__c,Fecha_error_archivos__c FROM Opportunity LIMIT 2];

		System.assertEquals('Error', opps[0].Error_archivos__c);
		System.assertEquals('error', opps[1].Error_archivos__c);
	}

		@isTest
	private static void testResendFailedDocumentsToSS4() {
		
		opp = [SELECT Id,Error_archivos__c,Fecha_error_archivos__c FROM Opportunity LIMIT 1];
		opp.Tipo_de_Solicitud__c = 'ALTA';
		update opp;

				ContentVersion ver1 = new ContentVersion();
		ver1.VersionData = Blob.valueOf('test 1');
		ver1.Title = 'test 1';
		ver1.PathOnClient = '/test';
		ver1.Enviado__c = false;
		insert ver1;
		ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];

		ContentVersion ver2 = new ContentVersion();
		ver2.VersionData = Blob.valueOf('test 2');
		ver2.Title = 'test 2';
		ver2.PathOnClient = '/test2';
		ver2.Enviado__c = false;
		insert ver2;
		ver2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver2.Id];

		ContentDocumentLink link1 = new ContentDocumentLink();
		link1.ContentDocumentId = ver1.ContentDocumentId;
		link1.LinkedEntityId = opp.Id;
		insert link1;

		ContentDocumentLink link2 = new ContentDocumentLink();
		link2.ContentDocumentId = ver2.ContentDocumentId;
		link2.LinkedEntityId = opp.Id;
		insert link2;

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
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		Database.executeBatch(new OpportunityResendAttachmentsBatch());
		Test.stopTest();

		List<Opportunity>  opps= [SELECT Id,Error_archivos__c,Fecha_error_archivos__c FROM Opportunity LIMIT 2];

		System.assertEquals(null, opps[0].Error_archivos__c);
		System.assertEquals('error', opps[1].Error_archivos__c);
	}

		@isTest
	private static void testResendFailedDocumentsToSS3() {
		
		opp = [SELECT Id,Error_archivos__c,Fecha_error_archivos__c FROM Opportunity LIMIT 1];
		opp.Tipo_de_Solicitud__c = 'REING_GFAM';
		update opp;

				ContentVersion ver1 = new ContentVersion();
		ver1.VersionData = Blob.valueOf('test 1');
		ver1.Title = 'test 1';
		ver1.PathOnClient = '/test';
		ver1.Enviado__c = false;
		insert ver1;
		ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];

		ContentVersion ver2 = new ContentVersion();
		ver2.VersionData = Blob.valueOf('test 2');
		ver2.Title = 'test 2';
		ver2.PathOnClient = '/test2';
		ver2.Enviado__c = false;
		insert ver2;
		ver2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver2.Id];

		ContentDocumentLink link1 = new ContentDocumentLink();
		link1.ContentDocumentId = ver1.ContentDocumentId;
		link1.LinkedEntityId = opp.Id;
		insert link1;

		ContentDocumentLink link2 = new ContentDocumentLink();
		link2.ContentDocumentId = ver2.ContentDocumentId;
		link2.LinkedEntityId = opp.Id;
		insert link2;

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
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		Database.executeBatch(new OpportunityResendAttachmentsBatch());
		Test.stopTest();

		List<Opportunity>  opps= [SELECT Id,Error_archivos__c,Fecha_error_archivos__c FROM Opportunity LIMIT 2];

		System.assertEquals(null, opps[0].Error_archivos__c);
		System.assertEquals('error', opps[1].Error_archivos__c);
	}

		@isTest
	private static void testResendFailedDocumentsToSS2() {
		opp = [SELECT Id,Error_archivos__c,Fecha_error_archivos__c FROM Opportunity LIMIT 1];

		ContentVersion ver1 = new ContentVersion();
		ver1.VersionData = Blob.valueOf('test 1');
		ver1.Title = 'test 1';
		ver1.PathOnClient = '/test';
		ver1.Enviado__c = false;
		insert ver1;
		ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];

		ContentVersion ver2 = new ContentVersion();
		ver2.VersionData = Blob.valueOf('test 2');
		ver2.Title = 'test 2';
		ver2.PathOnClient = '/test2';
		ver2.Enviado__c = false;
		insert ver2;
		ver2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver2.Id];

		ContentDocumentLink link1 = new ContentDocumentLink();
		link1.ContentDocumentId = ver1.ContentDocumentId;
		link1.LinkedEntityId = opp.Id;
		insert link1;

		ContentDocumentLink link2 = new ContentDocumentLink();
		link2.ContentDocumentId = ver2.ContentDocumentId;
		link2.LinkedEntityId = opp.Id;
		insert link2;

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
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		Database.executeBatch(new OpportunityResendAttachmentsBatch());
		Test.stopTest();

		List<Opportunity>  opps= [SELECT Id,Error_archivos__c,Fecha_error_archivos__c FROM Opportunity LIMIT 2];

		System.assertEquals(null, opps[0].Error_archivos__c);
		System.assertEquals('error', opps[1].Error_archivos__c);
	}
}