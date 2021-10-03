@isTest
private class WSDatosAfiliadosTest {
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
    public static final Account cuenta = build.anAccount()
                        .withAfiIddelTitular(182701)
                        .withAfiId('182701')
                        .withType('TIT')
                        .withCodigodeAfiliado('70332/34')
                        .withLastName('Testing182701')
                        .withEstado('A')
                        .build();
    public static final String successResponseBody = '{'+
        '"error": false,'+
        '"data": null,'+
        '"httpCode": 200,'+
        '"message": "Se ejecutó el proceso.",'+
        '"meta": {'+
          '"allowed_includes": [],'+
          '"default_includes": []'+
        '}'+
      '}';

    @isTest
    private static void onTryToInsertAnDuplicatedDomicilioShouldReturnError() {
        insert cuenta;

        Domicilio__c dom_COM = new Domicilio__c(Tipo_de_domicilio__c = 'COM', Cuenta__c = cuenta.Id);
        insert dom_COM;
        Domicilio__c dom_PART = new Domicilio__c(Tipo_de_domicilio__c = 'PART', Cuenta__c = cuenta.Id);
        Domicilio__c dom_POST = new Domicilio__c(Tipo_de_domicilio__c = 'POST', Cuenta__c = cuenta.Id);
        insert new List<Domicilio__c> {dom_PART, dom_POST};

        Domicilio__c domDuplicated = new Domicilio__c(Tipo_de_domicilio__c = 'COM', Cuenta__c = cuenta.Id);

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(successResponseBody)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        Database.SaveResult res = Database.insert(domDuplicated, false);
        Test.stopTest();

        System.assertEquals(false, res.isSuccess(), 'No se esta validando duplicidad');
    }

    @isTest
    private static void onTryToUpdateTypeOfDomicilioCOMToAnotherShouldReturnError() {
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(successResponseBody)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf');
        insert cuenta;

        Domicilio__c dom_COM = new Domicilio__c(Tipo_de_domicilio__c = 'COM', Cuenta__c = cuenta.Id);
        insert dom_COM;

        dom_COM.Tipo_de_domicilio__c = 'PART';

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        Database.SaveResult res = Database.update(dom_COM, false);
        Test.stopTest();

        System.assertEquals(false, res.isSuccess(), 'No se esta validando duplicidad');
    }

    @isTest
    private static void onTryToDeleteAnDomicilioCOMShouldReturnError() {
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(successResponseBody)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf');
        insert cuenta;

        Domicilio__c dom_COM = new Domicilio__c(Tipo_de_domicilio__c = 'COM', Cuenta__c = cuenta.Id);
        insert dom_COM;

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        Database.DeleteResult res = Database.delete(dom_COM, false);
        Test.stopTest();

        System.assertEquals(false, res.isSuccess(), 'No se esta validando duplicidad');
    }

    @isTest
    private static void onTryToInsertAnTelefonoActiveShouldDeactivateAnothers() {
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(successResponseBody)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf');
        insert cuenta;

        Telefono__c tel1 = new Telefono__c(Tipo__c = 'CEL', Cuenta__c = cuenta.Id, Telefono_principal__c = true);
        Telefono__c tel2 = new Telefono__c(Tipo__c = 'TEL', Cuenta__c = cuenta.Id, Telefono_principal__c = true);
        insert new List<Telefono__c> {tel1, tel2};
        
        Telefono__c tel3 = new Telefono__c(Tipo__c = 'TEL', Cuenta__c = cuenta.Id, Telefono_principal__c = true);
        
        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        Database.SaveResult res = Database.insert(tel3, false);
        Test.stopTest();
        tel1 = [SELECT Telefono_principal__c FROM Telefono__c WHERE Id = :tel1.Id];

        System.assertEquals(false, tel1.Telefono_principal__c, 'No se desactivando el telefono anterior');
    }

    @isTest
    private static void onUpdateAnAccountDetailtShouldSubmitToWS() {
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(successResponseBody)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf');
        insert cuenta;

        cuenta.Numero_de_documento__c = '013454789';
        cuenta.PersonEmail = 'test@test.com';

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        Database.SaveResult res = Database.update(cuenta, false);
        Test.stopTest();

        System.assertEquals(true, res.isSuccess(), 'No se esta actualizando la cuenta');
    }

    @isTest
    private static void onInsertAnDomicilioShouldSubmitToWS() {
        insert cuenta;

        Domicilio__c dom_COM = new Domicilio__c(Tipo_de_domicilio__c = 'COM', Cuenta__c = cuenta.Id);

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(successResponseBody)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        Database.SaveResult res = Database.insert(dom_COM, false);
        Test.stopTest();

        System.assertEquals(true, res.isSuccess(), 'No se esta enviando al WS');
    }

    @isTest
    private static void onDeleteAnDomicilioShouldSubmitToWS() {
        insert cuenta;

        Domicilio__c dom_PART = new Domicilio__c(Tipo_de_domicilio__c = 'PART', Cuenta__c = cuenta.Id);
        insert dom_PART;

        Domicilio__c dom_POST = new Domicilio__c(Tipo_de_domicilio__c = 'POST', Cuenta__c = cuenta.Id);
        insert dom_POST;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(successResponseBody)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf');
        
        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        List<Database.DeleteResult> res = Database.delete(new List<Domicilio__c> {dom_PART, dom_POST}, false);
        Test.stopTest();

        System.assertEquals(true, res[0].isSuccess(), 'No se esta enviando al WS');
        System.assertEquals(true, res[1].isSuccess(), 'No se esta enviando al WS');
    }

    @isTest
    private static void onUpdateAnTelefonoShouldSubmitToWS() {
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(successResponseBody)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf');
        insert cuenta;

         Telefono__c tel1 = new Telefono__c(Tipo__c = 'CEL', Cuenta__c = cuenta.Id, Telefono_principal__c = true);
        Telefono__c tel2 = new Telefono__c(Tipo__c = 'TEL', Cuenta__c = cuenta.Id, Telefono_principal__c = false);
        insert new List<Telefono__c> {tel1, tel2};
        

        tel2.Telefono__c = '1234567890';
        tel2.Telefono_principal__c = true;

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        Database.SaveResult res = Database.update(tel2, false);
        Test.stopTest();

        tel1 = [SELECT Telefono_principal__c FROM Telefono__c WHERE Id = :tel1.Id];

        System.assertEquals(false, tel1.Telefono_principal__c, 'No se desactivando el telefono anterior');
    }

    @isTest
    private static void onDeleteAnTelefonoShouldSubmitToWS() {
        insert cuenta;

        Telefono__c tel1 = new Telefono__c(Tipo__c = 'CEL', Telefono_principal__c = true, Cuenta__c = cuenta.Id);
        Telefono__c tel2 = new Telefono__c(Tipo__c = 'TEL', Telefono_principal__c = false, Cuenta__c = cuenta.Id);
        insert new List<Telefono__c> {tel1, tel2};

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(successResponseBody)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf');
        
        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        List<Database.DeleteResult> res = Database.delete(new List<Telefono__c> {tel1, tel2}, false);
        Test.stopTest();

        System.assertEquals(false, res[0].isSuccess(), 'No se esta enviando al WS');
        System.assertEquals(true, res[1].isSuccess(), 'No se esta enviando al WS');
    }
}