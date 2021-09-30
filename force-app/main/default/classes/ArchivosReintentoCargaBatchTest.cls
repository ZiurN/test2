@isTest 
private class ArchivosReintentoCargaBatchTest {

	static XHttpCalloutMock getSuccessResponse;
	static XHttpCalloutMock getErrorResponse;

	static{
		getSuccessResponse = new XHttpCalloutMock();
        getSuccessResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getSuccessResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSArchivosCargaMock.getFound())
                .addForAddress(WSArchivosCarga.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error al cargar archivos.')
                .withStatusCode(422)
                .withBody(WSArchivosCargaMock.getError())
                .addForAddress(WSArchivosCarga.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');
	}

	@isTest
	private static void reintentoDeEnvioArchivosExitoso() {
		Test.setMock(HttpCalloutMock.class, getSuccessResponse);
		Case nCase = new Case(
            Type='Prestacion',
            RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
            Sub_tipo__c= 'Presupuesto',
            Categorizacion_SS__c = 'Alta complejidad',
            AP_Presupuesto__c = false, 
            AP_Material__c = false,
			Tiempo_SLA__c = '72',
			Nro_de_solicitud_SS__c = '123'
        );
		insert nCase;

		ContentVersion ver1 = new ContentVersion();
		ver1.VersionData = Blob.valueOf('test 1');
		ver1.Title = 'test 1';
		ver1.PathOnClient = '/test';
		ver1.Error_al_enviar__c = 'error';
		ver1.Fecha_de_error__c = Datetime.now();
		ver1.Id_reintento__c = '123';
		ver1.Tipo_entidad_error__c = 'evento_medico';

		insert ver1;

		ContentVersion cv = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :ver1.Id
		];

		
		ContentDocumentLink contLink = new ContentDocumentLink();
		contLink.ContentDocumentId = cv.ContentDocumentId;
		contLink.LinkedEntityId =nCase.Id;
		contLink.ShareType = 'V';
		insert contLink;
		
		/*ContentVersion ver2 = new ContentVersion();
		ver2.VersionData = Blob.valueOf('test 2');
		ver2.Title = 'test 2';
		ver2.PathOnClient = '/test2';
		ver2.Error_al_enviar__c = 'error';
		ver2.Fecha_de_error__c = Datetime.now();
		ver2.Id_reintento__c = '123';
		ver2.Tipo_entidad_error__c = 'autorizacion';

		insert ver2;*/

		ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];
		//ver2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver2.Id];

		Test.startTest();
		Database.executeBatch(new ArchivosReintentoCargaBatch());
		Test.stopTest();


		ver1 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver1.ContentDocumentId AND IsLatest = true
			];
		/*ver2 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver2.ContentDocumentId AND IsLatest = true
			];*/

		System.assertEquals(true, ver1.Enviado__c);
		//System.assertEquals(true, ver2.Enviado__c);
		System.assertEquals(null, ver1.Error_al_enviar__c);
		//System.assertEquals(null, ver2.Error_al_enviar__c);
		System.assertEquals(null, ver1.Id_reintento__c);
		//System.assertEquals(null, ver2.Id_reintento__c);


	}


		@isTest
	private static void reintentoDeEnvioArchivosNoExitoso() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		

		ContentVersion ver1 = new ContentVersion();
		ver1.VersionData = Blob.valueOf('test 1');
		ver1.Title = 'test 1';
		ver1.PathOnClient = '/test';
		ver1.Error_al_enviar__c = 'error';
		ver1.Fecha_de_error__c = Datetime.now();
		ver1.Id_reintento__c = '123';
		ver1.Tipo_entidad_error__c = 'evento_medico';
		ver1.Usuario_error__c = 'CRIOS';

		insert ver1;

		
		ContentVersion ver2 = new ContentVersion();
		ver2.VersionData = Blob.valueOf('test 2');
		ver2.Title = 'test 2';
		ver2.PathOnClient = '/test2';
		ver2.Error_al_enviar__c = 'error';
		ver2.Fecha_de_error__c = Datetime.now();
		ver2.Id_reintento__c = '1234';
		ver2.Tipo_entidad_error__c = 'autorizacion';
		ver2.Usuario_error__c = 'CRIOS';

		insert ver2;

		ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];
		ver2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver2.Id];

		Test.startTest();
		Database.executeBatch(new ArchivosReintentoCargaBatch());
		Test.stopTest();

		ver1 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver1.ContentDocumentId AND IsLatest = true
			];
		ver2 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver2.ContentDocumentId AND IsLatest = true
			];

		System.assertEquals(false, ver1.Enviado__c);
		System.assertEquals(false, ver2.Enviado__c);
		//System.assertEquals('El id ingresado no coincide con un evento medico valido.', ver1.Error_al_enviar__c);
		//System.assertEquals('El id ingresado no coincide con un evento medico valido.', ver2.Error_al_enviar__c);
		System.assertEquals('123', ver1.Id_reintento__c);
		System.assertEquals('1234', ver2.Id_reintento__c);


	}

	@isTest
	public static void ifTheFileHaveACaseAssociateMustTakeTheDataFromThatObject(){

		Test.setMock(HttpCalloutMock.class, getSuccessResponse);
		Case nCase = new Case(
            Type='Prestacion',
            RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id,
            Sub_tipo__c= 'Presupuesto',
            Categorizacion_SS__c = 'Alta complejidad',
            AP_Presupuesto__c = false, 
            AP_Material__c = false,
			Tiempo_SLA__c = '72',
			Nro_de_solicitud_SS__c = '123'
        );

		insert nCase;

		/*ContentDocument doc = new ContentDocument();
		insert doc;*/


		ContentVersion ver1 = new ContentVersion();
		ver1.Title = 'TESTAWSTRIGGER';
		ver1.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		ver1.PathOnClient = '/TESTAWSTRIGGER.TXT';
		ver1.VersionData = Blob.valueOf('test 1');
		ver1.Title = 'test 1';
		ver1.PathOnClient = '/test';
		ver1.Error_al_enviar__c = 'error';
		ver1.Fecha_de_error__c = Datetime.now();
		ver1.Id_reintento__c = '123';
		ver1.Tipo_entidad_error__c = 'evento_medico';

		insert ver1;

		ContentVersion cv = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :ver1.Id
		];
		
		ContentDocumentLink contLink = new ContentDocumentLink();
		contLink.ContentDocumentId = cv.ContentDocumentId;
		contLink.LinkedEntityId =nCase.Id;
		contLink.ShareType = 'V';
		insert contLink;
		
		ContentVersion ver2 = new ContentVersion();
		ver2.VersionData = Blob.valueOf('test 2');
		ver2.Title = 'test 2';
		ver2.PathOnClient = '/test2';
		ver2.Error_al_enviar__c = 'error';
		ver2.Fecha_de_error__c = Datetime.now();
		ver2.Id_reintento__c = '123';
		ver2.Tipo_entidad_error__c = 'autorizacion';
		

		insert ver2;

		ContentVersion cv2 = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :ver2.Id
		];
		
		ContentDocumentLink contLink2 = new ContentDocumentLink();
		contLink2.ContentDocumentId = cv2.ContentDocumentId;
		contLink2.LinkedEntityId =nCase.Id;
		contLink2.ShareType = 'V';
		insert contLink2;
		

		ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];
		ver2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver2.Id];

		Test.startTest();
		Database.executeBatch(new ArchivosReintentoCargaBatch());
		Test.stopTest();


		ver1 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver1.ContentDocumentId AND IsLatest = true
			];
		ver2 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver2.ContentDocumentId AND IsLatest = true
			];

		System.assertEquals(true, ver1.Enviado__c);
		System.assertEquals(true, ver2.Enviado__c);
		System.assertEquals(null, ver1.Error_al_enviar__c);
		System.assertEquals(null, ver2.Error_al_enviar__c);
		System.assertEquals(null, ver1.Id_reintento__c);
		System.assertEquals(null, ver2.Id_reintento__c);

	}

	@isTest
	public static void ifTheFileHaveASegmentoAssociateMustTakeTheDataFromThatObject(){

		Test.setMock(HttpCalloutMock.class, getSuccessResponse);
		Segmentos__c seg = new Segmentos__c(Semid__c = '111');
		insert seg;

		/*ContentDocument doc = new ContentDocument();
		insert doc;*/


		ContentVersion ver1 = new ContentVersion();
		ver1.Title = 'TESTAWSTRIGGER';
		ver1.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		ver1.PathOnClient = '/TESTAWSTRIGGER.TXT';
		ver1.VersionData = Blob.valueOf('test 1');
		ver1.Title = 'test 1';
		ver1.PathOnClient = '/test';
		ver1.Error_al_enviar__c = 'error';
		ver1.Fecha_de_error__c = Datetime.now();
		ver1.Id_reintento__c = '123';
		ver1.Tipo_entidad_error__c = 'evento_medico';

		insert ver1;

		ContentVersion cv = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :ver1.Id
		];
		
		ContentDocumentLink contLink = new ContentDocumentLink();
		contLink.ContentDocumentId = cv.ContentDocumentId;
		contLink.LinkedEntityId =seg.Id;
		contLink.ShareType = 'V';
		insert contLink;
		
		ContentVersion ver2 = new ContentVersion();
		ver2.VersionData = Blob.valueOf('test 2');
		ver2.Title = 'test 2';
		ver2.PathOnClient = '/test2';
		ver2.Error_al_enviar__c = 'error';
		ver2.Fecha_de_error__c = Datetime.now();
		ver2.Id_reintento__c = '123';
		ver2.Tipo_entidad_error__c = 'autorizacion';
		

		insert ver2;

		ContentVersion cv2 = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :ver2.Id
		];
		
		ContentDocumentLink contLink2 = new ContentDocumentLink();
		contLink2.ContentDocumentId = cv2.ContentDocumentId;
		contLink2.LinkedEntityId =seg.Id;
		contLink2.ShareType = 'V';
		insert contLink2;
		

		ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];
		ver2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver2.Id];

		Test.startTest();
		Database.executeBatch(new ArchivosReintentoCargaBatch());
		Test.stopTest();


		ver1 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver1.ContentDocumentId AND IsLatest = true
			];
		ver2 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver2.ContentDocumentId AND IsLatest = true
			];

		System.assertEquals(true, ver1.Enviado__c);
		System.assertEquals(true, ver2.Enviado__c);
		System.assertEquals(null, ver1.Error_al_enviar__c);
		System.assertEquals(null, ver2.Error_al_enviar__c);
		System.assertEquals(null, ver1.Id_reintento__c);
		System.assertEquals(null, ver2.Id_reintento__c);

	}


	@isTest
	public static void ifTheFileHaveAEventoMedicoAssociateMustTakeTheDataFromThatObject(){

		Test.setMock(HttpCalloutMock.class, getSuccessResponse);
		Evento_medico__c em = new Evento_medico__c();
		em.Nro_de_Evento_Medico_SS__c = '1234';
        insert em;

		/*ContentDocument doc = new ContentDocument();
		insert doc;*/


		ContentVersion ver1 = new ContentVersion();
		ver1.Title = 'TESTAWSTRIGGER';
		ver1.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		ver1.PathOnClient = '/TESTAWSTRIGGER.TXT';
		ver1.VersionData = Blob.valueOf('test 1');
		ver1.Title = 'test 1';
		ver1.PathOnClient = '/test';
		ver1.Error_al_enviar__c = 'error';
		ver1.Fecha_de_error__c = Datetime.now();
		ver1.Id_reintento__c = '123';
		ver1.Tipo_entidad_error__c = 'evento_medico';

		insert ver1;

		ContentVersion cv = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :ver1.Id
		];
		
		ContentDocumentLink contLink = new ContentDocumentLink();
		contLink.ContentDocumentId = cv.ContentDocumentId;
		contLink.LinkedEntityId =em.Id;
		contLink.ShareType = 'V';
		insert contLink;
		
		/*ContentVersion ver2 = new ContentVersion();
		ver2.VersionData = Blob.valueOf('test 2');
		ver2.Title = 'test 2';
		ver2.PathOnClient = '/test2';
		ver2.Error_al_enviar__c = 'error';
		ver2.Fecha_de_error__c = Datetime.now();
		ver2.Id_reintento__c = '123';
		ver2.Tipo_entidad_error__c = 'autorizacion';
		

		insert ver2;*/

		ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];
		//ver2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver2.Id];

		Test.startTest();
		Database.executeBatch(new ArchivosReintentoCargaBatch());
		Test.stopTest();


		ver1 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver1.ContentDocumentId AND IsLatest = true
			];
		/*ver2 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver2.ContentDocumentId AND IsLatest = true
			];*/

		System.assertEquals(true, ver1.Enviado__c);
		//System.assertEquals(true, ver2.Enviado__c);
		System.assertEquals(null, ver1.Error_al_enviar__c);
		//System.assertEquals(null, ver2.Error_al_enviar__c);
		System.assertEquals(null, ver1.Id_reintento__c);
		//System.assertEquals(null, ver2.Id_reintento__c);

	}


	@isTest
	public static void ifTheFileHaveAnOpportunityAssociateMustTakeTheDataFromThatObject(){

		Test.setMock(HttpCalloutMock.class, getSuccessResponse);
		Opportunity opp = new Opportunity();
		opp.Name = 'Test opp';
		opp.StageName = 'En Edición';
		opp.CloseDate = Date.today().addDays(15);
		opp.Nro_de_Solicitud__c = '1234';
        insert opp;

		/*ContentDocument doc = new ContentDocument();
		insert doc;*/


		ContentVersion ver1 = new ContentVersion();
		ver1.Title = 'TESTAWSTRIGGER';
		ver1.VersionData = Blob.valueOf('TESTAWSTRIGGER');
		ver1.PathOnClient = '/TESTAWSTRIGGER.TXT';
		ver1.VersionData = Blob.valueOf('test 1');
		ver1.Title = 'test 1';
		ver1.PathOnClient = '/test';
		ver1.Error_al_enviar__c = 'error';
		ver1.Fecha_de_error__c = Datetime.now();
		ver1.Id_reintento__c = '123';
		ver1.Tipo_entidad_error__c = 'evento_medico';

		insert ver1;

		ContentVersion cv = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :ver1.Id
		];
		
		ContentDocumentLink contLink = new ContentDocumentLink();
		contLink.ContentDocumentId = cv.ContentDocumentId;
		contLink.LinkedEntityId =opp.Id;
		contLink.ShareType = 'V';
		insert contLink;

		ver1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver1.Id];
		
		Test.startTest();
		Database.executeBatch(new ArchivosReintentoCargaBatch());
		Test.stopTest();


		ver1 = [
				SELECT Enviado__c, Error_al_enviar__c, Id_reintento__c, Fecha_de_error__c, Tipo_entidad_error__c 
				FROM ContentVersion 
				WHERE ContentDocumentId = :ver1.ContentDocumentId AND IsLatest = true
			];
	

		System.assertEquals(true, ver1.Enviado__c);
		
		System.assertEquals(null, ver1.Error_al_enviar__c);
		
		System.assertEquals(null, ver1.Id_reintento__c);
		

	}
}