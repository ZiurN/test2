@isTest 
private class CasoEnviarASSBtnCtrlTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseMaterialFound;
    static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getResponsePresupuestoFound;
	static XHttpCalloutMock getResponseFoundWithEM;
	static Account agencia;
	static Account efector;
	static Consultorio__c consultorio;
	static Diagnostico__c diag;
	static Nomenclador_de_Prestacion__c nomPrest;
	static Nomenclador_de_Prestacion__c nomPrest2;
	static Case caso;
	static Prestacion__c prest1;
	static Account prestador;
	static Account afiliado;
	static User usuario;

    static {
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName, ProfileId = p.Id, UserRoleId = role.Id);
		System.runAs( new User( Id = UserInfo.getUserId() ) ) {
			insert usuario;
		}

		agencia = new Account(RecordTypeId = XappiaHelper.getRecordType('Account','Delegacion').Id);
		agencia.Name = 'agenciaTest';
		agencia.Codigo_de_delegacion__c = '650098';
		agencia.Type = 'Agencia';
		insert agencia;

		efector = new Account(RecordTypeId = XappiaHelper.getRecordType('Account','Efector').Id);
		efector.Name = 'Efector prueba';
		efector.Es_Profesional__c = true;
		efector.Codigo_de_efector__c = '758415';
		efector.Estado__c = 'A';
		insert efector;
		
		prestador = new Account(RecordTypeId = XappiaHelper.getRecordType('Account','Efector').Id);
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
		caso.Fecha__c = Date.newInstance(2020,2,2);
		caso.Fecha_probable__c = Date.newInstance(2019,2,2);
		caso.AccountId = afiliado.Id;
		caso.Delegacion__c = agencia.Id;
		caso.Fecha_prescripcion__c = Date.newInstance(2020,1,31);
		caso.Diagnostico__c = diag.Id;
		caso.Prescriptor__c = efector.Id;
		caso.Prestador__c = prestador.Id;
		caso.Observaciones__c = 'Prueba AP SF';
		caso.Mail__c = 'test@mapplics.com';
		caso.AP_Material__c = true;
		caso.AP_Presupuesto__c = false;
		caso.Consultorio__c = consultorio.Id;
		caso.RecordTypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id;
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
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAPGenerarCentroMock.getFound(caso.Id))
                .addForAddress(WSCasoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones');
		/*getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAPGenerarCentroMock.getArchivos())
                .addForAddress(WSCasoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');*/

		getResponsePresupuestoFound = new XHttpCalloutMock();
        getResponsePresupuestoFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponsePresupuestoFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAPGenerarCentroMock.getFoundPresupuesto(caso.Id))
                .addForAddress(WSCasoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones');
		/*getResponsePresupuestoFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAPGenerarCentroMock.getArchivos())
                .addForAddress(WSCasoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');*/

		getResponseMaterialFound = new XHttpCalloutMock();
		getResponseMaterialFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseMaterialFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSCaseAPGenerarCentroMock.getFoundMaterial(caso.Id))
				.addForAddress(WSCasoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones');		
        /*getResponseMaterialFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAPGenerarCentroMock.getArchivos())
                .addForAddress(WSCasoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');*/

		getResponseFoundWithEM = new XHttpCalloutMock();
        getResponseFoundWithEM.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFoundWithEM.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAPGenerarCentroMock.getFoundWithEM(caso.Id))
                .addForAddress(WSCasoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones');
		/*getResponseFoundWithEM.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAPGenerarCentroMock.getArchivos())
                .addForAddress(WSCasoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');*/

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
                .withStatus('The given data was invalid.')
                .withStatusCode(422)
                .withBody(WSCaseAPGenerarCentroMock.getError())
                .addForAddress(WSCasoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones');

    }

	@isTest
	private static void whenACaseWithPresupuestoIsSentToSSWithCorrectData_ItShouldReturnAValidResponse() {
		caso.AP_Presupuesto__c = true;
		caso.Importe_presupuesto__c = 200;
		update caso;
		System.assertEquals(1,[SELECT COUNT() FROM Prestacion__c WHERE Ap__c = :caso.Id]);
		Test.setMock(HttpCalloutMock.class, getResponsePresupuestoFound);
        //CasoEnviarASSBtnCtrl.Response responseToAssert;
		//System.runAs(usuario) {
		Test.startTest();

        CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
		//responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
        Test.stopTest();
		//}

		System.assertEquals(2,[SELECT COUNT() FROM Prestacion__c WHERE Ap__c = :caso.Id]);
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
		System.assertEquals('Celula 2', casoPadre.Celula__c);
		System.assertEquals('24', casoPadre.Tiempo_SLA__c);
		
		Case casoMaterial = [
			SELECT Id, Celula__c, RecordType.Name, Type, Sub_tipo__c, Tiempo_SLA__c FROM Case WHERE Nro_AP__c = '1014010632'
		];
		System.assertEquals('Celula 1', casoMaterial.Celula__c);
		System.assertEquals('Material', casoMaterial.Sub_tipo__c);
		System.assertEquals('48', casoMaterial.Tiempo_SLA__c);
		
	}

	//@isTest
	//private static void whenACaseIsSentToSSWithCorrectDataPrestType_Medicamento_ItShouldReturnAValidResponse() {
		//Test.setMock(HttpCalloutMock.class, getResponseFound);
		//prest1.Tipo__c = 'M';
		//Medicamento__c med1 = new Medicamento__c(Codigo_medicamento__c = '1234');
		//prest1.Medicamento__r = med1;
		//prest1.Prestacion__c = null;
		//insert med1;
		//update prest1;

        //Test.startTest();
		

        //CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
        //Test.stopTest();


		//System.assertEquals(false, responseToAssert.hasError);
		//Case updatedCase = [SELECT Id,Nro_AP__c,Fecha__c, Fecha_probable__c,Status,Consultorio__r.Secuencia__c,
				//Account.Codigo_de_Afiliado__c,Fecha_prescripcion__c,Diagnostico__r.Codigo_del_Diagnostico__c,
				//Prescriptor__r.Codigo_de_efector__c,Prestador__r.Codigo_de_efector__c,Consultorio__r.Codigo_externo__c,
				//Observaciones__c,Mail__c,Otros_Mail__c,Delegacion__r.Codigo_de_delegacion__c,Nivel_de_derivacion__c,Type
			//FROM Case
			//WHERE Id = :caso.Id
		//];

		//Prestacion__c[] prests = [
				//SELECT Id,Estado__c,Prestacion_CA__c,Texto_aclarativo_alerta__c,Alerta__c,Nombre_de_Prestacion__c
				//FROM Prestacion__c
				//WHERE Ap__c = :updatedCase.Id
		//];
		//System.assertEquals('1014010015',updatedCase.Nro_AP__c);
		//System.assertEquals(Date.valueOf('2019-02-02 00:00:00'),updatedCase.Fecha_probable__c);
		//System.assertEquals('CA-----A',updatedCase.Status);
		//System.assertEquals('86712/26',updatedCase.Account.Codigo_de_Afiliado__c);
		//System.assertEquals(Date.valueOf('2020-01-31 00:00:00'),updatedCase.Fecha_prescripcion__c);
		//System.assertEquals('999',updatedCase.Diagnostico__r.Codigo_del_Diagnostico__c);
		//System.assertEquals('758415',updatedCase.Prescriptor__r.Codigo_de_efector__c);
		//System.assertEquals('700125',updatedCase.Prestador__r.Codigo_de_efector__c);
		//System.assertEquals(1,updatedCase.Consultorio__r.Secuencia__c);
		//System.assertEquals('Prueba AP SF',updatedCase.Observaciones__c);
		//System.assertEquals('test@mapplics.com',updatedCase.Mail__c);
		//System.assertEquals(null,updatedCase.Otros_Mail__c);
		//System.assertEquals('650098',updatedCase.Delegacion__r.Codigo_de_delegacion__c);
		//System.assertEquals('Nivel 1',updatedCase.Nivel_de_derivacion__c);
		//System.assertEquals('Medicamento',updatedCase.Type);

		//for(Prestacion__c pre : prests){
			//System.assertEquals('C1-----A',pre.Estado__c);
			//System.assertEquals('74042384',pre.Prestacion_CA__c);
			//System.assertEquals('NO REQUIERE OBSERV',pre.Texto_aclarativo_alerta__c);
			//System.assertEquals(null,pre.Alerta__c);
			//System.assertEquals('ILVICO N, COMP.X 20',pre.Nombre_de_Prestacion__c);
		//}

		//Alerta__c[] alerts = [
				//SELECT Id, Control__c,Funcion__c,Texto_aclarativo__c,Fecha_de_generacion_de_Alerta__c,
						//Lectura_de_alerta_auditor__c,Resolucion_de_alerta_auditor__c,Fecha_resolucion_de_Alerta__c,idalerta__c
				//FROM Alerta__c
				//WHERE Prestacion__c = :prests[0].Id
		//];
		//System.assertEquals('105',alerts[0].Control__c);
		//System.assertEquals('FCION_FRONT',alerts[0].Funcion__c);
		//System.assertEquals('El medicamento no existe o no está activo',alerts[0].Texto_aclarativo__c);
////		System.assertEquals('199',alerts[0].Nivel_de_auditoria__c);
		//System.assertEquals(Date.valueOf('2020-02-14 10:13:38'),alerts[0].Fecha_de_generacion_de_Alerta__c);
		//System.assertEquals(null,alerts[0].Lectura_de_alerta_auditor__c);
		//System.assertEquals(null,alerts[0].Resolucion_de_alerta_auditor__c);
		//System.assertEquals(null,alerts[0].Fecha_resolucion_de_Alerta__c);
		//System.assertEquals('16461179',alerts[0].idalerta__c);


	//}


	@isTest
	private static void whenACaseIsSentToSSWithCorrectData_ItShouldReturnAValidResponse() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
		
		system.debug('1');
        CasoEnviarASSBtnCtrl.Response responseToAssert = CasoEnviarASSBtnCtrl.sendCaseToSS(caso.Id);
		system.debug('2');
        Test.stopTest();
		
		system.debug(responseToAssert);

		System.assertEquals(false, responseToAssert.hasError);
		Case updatedCase = [SELECT Id,Nro_AP__c,Fecha__c, Fecha_probable__c,Status,Consultorio__r.Secuencia__c,
				Account.Codigo_de_Afiliado__c,Fecha_prescripcion__c,Diagnostico__r.Codigo_del_Diagnostico__c,
				Prescriptor__r.Codigo_de_efector__c,Prestador__r.Codigo_de_efector__c,Consultorio__r.Codigo_externo__c,
				Observaciones__c,Mail__c,Otros_Mail__c,Delegacion__r.Codigo_de_delegacion__c,Nivel_de_derivacion__c,Type
			FROM Case
			WHERE Id = :caso.Id
		];

		Prestacion__c[] prests = [
			SELECT Id,Estado__c,Prestacion_CA__c,Texto_aclarativo_alerta__c,Alerta__c,Nombre_de_Prestacion__c, 
				Cambio_automatico__c
			FROM Prestacion__c
			WHERE Ap__c = :updatedCase.Id
		];

		System.debug('****' + prests.size());
		System.debug(prests);
		System.assertEquals('1014010015',updatedCase.Nro_AP__c);
		System.assertEquals(Date.valueOf('2019-02-02 00:00:00'),updatedCase.Fecha_probable__c);
		System.assertEquals('CA-----A',updatedCase.Status);
		System.assertEquals('86712/26',updatedCase.Account.Codigo_de_Afiliado__c);
		System.assertEquals(Date.valueOf('2020-01-31 00:00:00'),updatedCase.Fecha_prescripcion__c);
		System.assertEquals('999',updatedCase.Diagnostico__r.Codigo_del_Diagnostico__c);
		System.assertEquals('758415',updatedCase.Prescriptor__r.Codigo_de_efector__c);
		System.assertEquals('700125',updatedCase.Prestador__r.Codigo_de_efector__c);
		System.assertEquals(1,updatedCase.Consultorio__r.Secuencia__c);
		System.assertEquals('Prueba AP SF',updatedCase.Observaciones__c);
		System.assertEquals('test@mapplics.com',updatedCase.Mail__c);
		System.assertEquals(null,updatedCase.Otros_Mail__c);
		System.assertEquals('650098',updatedCase.Delegacion__r.Codigo_de_delegacion__c);
		System.assertEquals('Nivel 1',updatedCase.Nivel_de_derivacion__c);
		System.assertEquals('Medicamento',updatedCase.Type);

		for(Prestacion__c pre : prests){
			System.assertEquals('C1-----A',pre.Estado__c);
			System.assertEquals('74042384',pre.Prestacion_CA__c);
			System.assertEquals('NO REQUIERE OBSERV',pre.Texto_aclarativo_alerta__c);
			System.assertEquals(null,pre.Alerta__c);
			System.assertEquals('ILVICO N, COMP.X 20',pre.Nombre_de_Prestacion__c);
			System.assertEquals(false, pre.Cambio_automatico__c);
		}

		Alerta__c[] alerts = [
				SELECT Id, Control__c,Funcion__c,Texto_aclarativo__c,Fecha_de_generacion_de_Alerta__c,
						Lectura_de_alerta_auditor__c,Resolucion_de_alerta_auditor__c,Fecha_resolucion_de_Alerta__c,idalerta__c
				FROM Alerta__c
				WHERE Prestacion__c = :prests[0].Id
		];
		System.assertEquals('105',alerts[0].Control__c);
		System.assertEquals('FCION_FRONT',alerts[0].Funcion__c);
		System.assertEquals('El medicamento no existe o no está activo',alerts[0].Texto_aclarativo__c);
//		System.assertEquals('199',alerts[0].Nivel_de_auditoria__c);
		System.assertEquals(Date.valueOf('2020-02-14 10:13:38'),alerts[0].Fecha_de_generacion_de_Alerta__c);
		System.assertEquals(null,alerts[0].Lectura_de_alerta_auditor__c);
		System.assertEquals(null,alerts[0].Resolucion_de_alerta_auditor__c);
		System.assertEquals(null,alerts[0].Fecha_resolucion_de_Alerta__c);
		System.assertEquals('16461179',alerts[0].idalerta__c);


	}

	@isTest
	private static void whenACaseIsSentToSSWithIncorrectData_ItShouldReturnAnInvalidResponse() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Case caso2 = new Case();
		caso.Fecha__c = Date.newInstance(2020,2,2);
		caso.Fecha_probable__c = Date.newInstance(2019,2,2);
		caso.AccountId = afiliado.Id;
		caso.Delegacion__c = agencia.Id;
		caso.Fecha_prescripcion__c = Date.newInstance(2020,1,31);
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


		System.assertEquals(true, responseToAssert.hasError);

	}

	@isTest
	private static void whenACaseHasAttachments_ReturnTrue() {
		Case caso = new Case();
		insert caso;

		ContentVersion contentVersion = new ContentVersion(
			Title = 'test',
			PathOnClient = '/test.pdf',
			VersionData = Blob.valueOf('Test Content'),
			IsMajorVersion = true
		);
		insert contentVersion;    
		
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = caso.Id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		insert cdl;

		/*getResponseFound.buildResponse()
			.addForAddress(AWS.url + cdl.LinkedEntityId + '/test.pdf');*/
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		Boolean resp = CasoEnviarASSBtnCtrl.hasAttachments(caso.Id, null);
		Test.stopTest();

		System.assertEquals(resp, true);
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

		System.assertEquals(false, responseToAssert.hasError);
		Case updatedCase = [SELECT Id,Nro_AP__c,Fecha__c, Fecha_probable__c,Status,Consultorio__r.Secuencia__c,
				Account.Codigo_de_Afiliado__c,Fecha_prescripcion__c,Diagnostico__r.Codigo_del_Diagnostico__c,
				Prescriptor__r.Codigo_de_efector__c,Prestador__r.Codigo_de_efector__c,Consultorio__r.Codigo_externo__c,
				Observaciones__c,Mail__c,Otros_Mail__c,Delegacion__r.Codigo_de_delegacion__c,Nivel_de_derivacion__c,Type
			FROM Case
			WHERE Id = :caso.Id
		];

		Prestacion__c[] prests = [
			SELECT Id,Estado__c,Prestacion_CA__c,Texto_aclarativo_alerta__c,Alerta__c,Nombre_de_Prestacion__c, 
				Cambio_automatico__c
			FROM Prestacion__c
			WHERE Ap__c = :updatedCase.Id
		];

		System.debug('****' + prests.size());
		System.debug(prests);
		System.assertEquals('1014010015',updatedCase.Nro_AP__c);
		System.assertEquals(Date.valueOf('2019-02-02 00:00:00'),updatedCase.Fecha_probable__c);
		System.assertEquals('CA-----A',updatedCase.Status);
		System.assertEquals('86712/26',updatedCase.Account.Codigo_de_Afiliado__c);
		System.assertEquals(Date.valueOf('2020-01-31 00:00:00'),updatedCase.Fecha_prescripcion__c);
		System.assertEquals('999',updatedCase.Diagnostico__r.Codigo_del_Diagnostico__c);
		System.assertEquals('758415',updatedCase.Prescriptor__r.Codigo_de_efector__c);
		System.assertEquals('700125',updatedCase.Prestador__r.Codigo_de_efector__c);
		System.assertEquals(1,updatedCase.Consultorio__r.Secuencia__c);
		System.assertEquals('Prueba AP SF',updatedCase.Observaciones__c);
		System.assertEquals('test@mapplics.com',updatedCase.Mail__c);
		System.assertEquals(null,updatedCase.Otros_Mail__c);
		System.assertEquals('650098',updatedCase.Delegacion__r.Codigo_de_delegacion__c);
		System.assertEquals('Nivel 1',updatedCase.Nivel_de_derivacion__c);
		System.assertEquals('Medicamento',updatedCase.Type);

		for(Prestacion__c pre : prests){
			System.assertEquals('C1-----A',pre.Estado__c);
			System.assertEquals('74042384',pre.Prestacion_CA__c);
			System.assertEquals('NO REQUIERE OBSERV',pre.Texto_aclarativo_alerta__c);
			System.assertEquals(null,pre.Alerta__c);
			System.assertEquals('ILVICO N, COMP.X 20',pre.Nombre_de_Prestacion__c);
			System.assertEquals(false, pre.Cambio_automatico__c);
		}

		Alerta__c[] alerts = [
				SELECT Id, Control__c,Funcion__c,Texto_aclarativo__c,Fecha_de_generacion_de_Alerta__c,
						Lectura_de_alerta_auditor__c,Resolucion_de_alerta_auditor__c,Fecha_resolucion_de_Alerta__c,idalerta__c
				FROM Alerta__c
				WHERE Prestacion__c = :prests[0].Id
		];
		System.assertEquals('105',alerts[0].Control__c);
		System.assertEquals('FCION_FRONT',alerts[0].Funcion__c);
		System.assertEquals('El medicamento no existe o no está activo',alerts[0].Texto_aclarativo__c);
//		System.assertEquals('199',alerts[0].Nivel_de_auditoria__c);
		System.assertEquals(Date.valueOf('2020-02-14 10:13:38'),alerts[0].Fecha_de_generacion_de_Alerta__c);
		System.assertEquals(null,alerts[0].Lectura_de_alerta_auditor__c);
		System.assertEquals(null,alerts[0].Resolucion_de_alerta_auditor__c);
		System.assertEquals(null,alerts[0].Fecha_resolucion_de_Alerta__c);
		System.assertEquals('16461179',alerts[0].idalerta__c);

		em = [SELECT Id, Estado__c FROM Evento_medico__c WHERE Id = :em.Id];
		System.assertEquals('Autorizado', em.Estado__c);

		seg = [SELECT Id, Estado__c FROM Segmentos__c WHERE Id = :seg.Id];
		System.assertEquals('Autorizado', seg.Estado__c);

	}

	// SE ELIMINO LA VALIDACION
	//@isTest
	//private static void whenAFrontUserNotBelongsToDelegacion_showTheErrorMsg() {
		//Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('123456').build();
		//insert delegacion;
		
		//Case newCaso = new Case();
		//newCaso.Nro_AP__c = '1014009821';
		//newCaso.Status = 'CA-----A';
		//newCaso.Nivel_de_derivacion__c = 'Nivel 1';
		////newCaso.OwnerId = usuarioFront.Id;
		//insert newCaso;

		//newCaso.Delegacion__c = delegacion.Id;
		//update newCaso;

		//CasoEnviarASSBtnCtrl.Response resp;
		//System.runAs(usuario) {	
			//Test.startTest();
			//resp = CasoEnviarASSBtnCtrl.sendCaseToSS(newCaso.Id);
			//Test.stopTest();
		//}

		//System.assertEquals('El usuario puede modificar casos de su delegación solamente', resp.message);

	//}
}