@isTest 
private class CaseAutorizarAPRechazadaBtnCtrlTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static Case caso;
	static Prestacion__c prestacion;
	static Alerta__c alerta;
	static Alerta__c alerta2;
	static User usuario;

	static {
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'Front', ProfileId = pFront.Id, UserRoleId = role.Id);
		System.runAs( new User( Id = UserInfo.getUserId() ) ) {
			insert usuario;
		}

        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseAutorizarAPRechazadaMock.getFound())
                .addForAddress(WSCaseAutorizarAPRechazada.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/rechazadas/1014011025');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSCaseAPEmitirOrdenMock.getFound())
				.addForAddress(WSCaseAPEmitirOrden.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/generar/1014011025');

		getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(400)
                .withBody(WSCaseAutorizarAPRechazadaMock.getError())
                .addForAddress(WSCaseAutorizarAPRechazada.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/rechazadas/1014011025');		
	
		caso = new Case();
		caso.Nro_AP__c = '1014011025';
		caso.Status = 'Rechazado';
		caso.Caso_Rechazado__c = true;
		insert caso;

		prestacion = new Prestacion__c();
		prestacion.Prestacion_CA__c = '74043569';
		prestacion.Ap__c = caso.Id;
		insert prestacion;

		alerta = new Alerta__c();
		alerta.idalerta__c = '16465741';
		alerta.Prestacion__c = prestacion.Id;
		insert alerta;

		alerta2 = new Alerta__c();
		alerta2.idalerta__c = '16465740';
		alerta2.Prestacion__c = prestacion.Id;
		insert alerta2;
    }

	@IsTest
    private static void whenClickTheButton_autorizarAPRechazada() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        
        Test.startTest();
        CaseAutorizarAPRechazadaBtnCtrl.Response resp = CaseAutorizarAPRechazadaBtnCtrl.autorizarAPRechazada(caso.Id);
        Test.stopTest();

		caso = [SELECT Status FROM Case WHERE Id =: caso.Id];
		prestacion = [SELECT Id, (SELECT Id FROM Alertas__r) FROM Prestacion__c WHERE Id =: prestacion.Id];

        System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
		System.assertEquals('CA-----E', caso.Status);
		System.assertEquals(6, prestacion.Alertas__r.size());
    }

	@IsTest
    private static void whenClickTheButton_showErrorMsg() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        
        Test.startTest();
        CaseAutorizarAPRechazadaBtnCtrl.Response resp = CaseAutorizarAPRechazadaBtnCtrl.autorizarAPRechazada(caso.Id);
        Test.stopTest();

		caso = [SELECT Status FROM Case WHERE Id =: caso.Id];

        System.assertEquals(true, resp.hasError);
		System.assertEquals('La autorización solicitada es inválida.', resp.message);
		System.assertEquals('Rechazado', caso.Status);
    }

	@IsTest
    private static void whenAPIsNotRefused_showValidationError() {
        //Test.setMock(HttpCalloutMock.class, getErrorResponse);

		caso.Caso_Rechazado__c = false;
		update caso;

		Test.startTest();
        CaseAutorizarAPRechazadaBtnCtrl.Response resp = CaseAutorizarAPRechazadaBtnCtrl.autorizarAPRechazada(caso.Id);
        Test.stopTest();

        System.assertEquals(false, resp.hasError);
		System.assertEquals('El caso debe estar rechazado', resp.message);
    }

	@IsTest
    private static void whenAPIsInNivel1AndUserNotIsLeader_showValidationError() {
		caso.OwnerId = usuario.Id;
		update caso;

		CaseAutorizarAPRechazadaBtnCtrl.Response resp;
		System.runAs(usuario) {
			Test.startTest();
			resp = CaseAutorizarAPRechazadaBtnCtrl.autorizarAPRechazada(caso.Id);
			Test.stopTest();
		}

        System.assertEquals(false, resp.hasError);
		System.assertEquals('- El usuario debe ser el líder de la célula', resp.message);
    }

	@IsTest
    private static void whenAPIsInNivel2AndUserNotIsLeader_showValidationError() {
		caso.Nivel_de_derivacion__c = 'Nivel 2';
		update caso;

		CaseAutorizarAPRechazadaBtnCtrl.Response resp;
		System.runAs(usuario) {
			Test.startTest();
			resp = CaseAutorizarAPRechazadaBtnCtrl.autorizarAPRechazada(caso.Id);
			Test.stopTest();
		}

        System.assertEquals(false, resp.hasError);
		System.assertEquals('- El usuario debe ser el líder de Mesa de Ayuda', resp.message);
    }

	@IsTest
    private static void whenAPIsInNivel3WithEmptyCelulaAndUserNotIsLeader_showValidationError() {
		caso.Nivel_de_derivacion__c = 'Nivel 3';
		update caso;

		CaseAutorizarAPRechazadaBtnCtrl.Response resp;
		System.runAs(usuario) {
			Test.startTest();
			resp = CaseAutorizarAPRechazadaBtnCtrl.autorizarAPRechazada(caso.Id);
			Test.stopTest();
		}

        System.assertEquals(false, resp.hasError);
		System.assertEquals('- El campo célula debe estar completo', resp.message);
    }

	@IsTest
    private static void whenAPIsInNivel3Celula1AndUserNotIsLeader_showValidationError() {
		caso.Nivel_de_derivacion__c = 'Nivel 3';
		caso.Celula__c = 'Celula 1';
		update caso;

		CaseAutorizarAPRechazadaBtnCtrl.Response resp;
		System.runAs(usuario) {
			Test.startTest();
			resp = CaseAutorizarAPRechazadaBtnCtrl.autorizarAPRechazada(caso.Id);
			Test.stopTest();
		}

        System.assertEquals(false, resp.hasError);
		System.assertEquals('- El usuario debe ser el líder de la célula', resp.message);
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
		//newCaso.Caso_Rechazado__c = true;
		////newCaso.OwnerId = usuarioFront.Id;
		//insert newCaso;

		//newCaso.Delegacion__c = delegacion.Id;
		//update newCaso;

		//CaseAutorizarAPRechazadaBtnCtrl.Response resp;
		//System.runAs(usuario) {	
			//Test.startTest();
			//resp = CaseAutorizarAPRechazadaBtnCtrl.autorizarAPRechazada(newCaso.Id);
			//Test.stopTest();
		//}

		//System.assertEquals('El usuario puede modificar casos de su delegación solamente', resp.message);

	//}

}