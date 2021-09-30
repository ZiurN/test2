@isTest
public without sharing class TelefonoTriggerTest {
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
    ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
    /*public static final Account cuenta = build.anAccount()
                    .withAfiIddelTitular(182701)
                    .withAfiId('182701')
                    .withType('TIT')
                    .withCodigodeAfiliado('70332/34')
                    .withLastName('Testing182701')
                    .withEstado('A')
                    .build();*/
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

    
    public static Account cuenta;
    static {
        cuenta = Build.anAccountCuentapersonal().build();
		cuenta.Afi_Id__c = '167755';
		insert cuenta;
    }   

    @isTest
    public static void ifAPhoneNumberHasMoreThan10DigitsAnErrorMustShow(){
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

        Telefono__c tel = new Telefono__c(Telefono__c = '123456789123',Cuenta__c = cuenta.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(tel,false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        for(Database.Error err : result.getErrors()){
            System.assertEquals('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx',err.getMessage());
        }
    }

    @isTest
    public static void ifAPhoneNumberHaveALetterAnErrorMustShow(){
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
        
        Telefono__c tel = new Telefono__c(Telefono__c = '123456789a',Cuenta__c = cuenta.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(tel,false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        for(Database.Error err : result.getErrors()){
            System.assertEquals('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx',err.getMessage());
        }
    }

    
    @isTest
    public static void ifAPhoneHaveADashAnErrorMustShow(){
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
        Telefono__c tel = new Telefono__c(Telefono__c = '1234-67800',Cuenta__c = cuenta.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(tel,false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        for(Database.Error err : result.getErrors()){
            System.assertEquals('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx',err.getMessage());
        }
    }

    
    
    @isTest
    public static void ifAPhoneStarWith15AnErrorMustShow(){
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
        
        Telefono__c tel = new Telefono__c(Telefono__c = '153406780000',Cuenta__c = cuenta.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(tel,false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        for(Database.Error err : result.getErrors()){
            System.assertEquals('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx',err.getMessage());
        }
    }

    
    
    
    @isTest
    public static void ifAPhoneIsValidMustntShowError(){
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
        
        Telefono__c tel = new Telefono__c(Telefono__c = '4252062051',Cuenta__c = cuenta.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(tel,false);
        Test.stopTest();

        System.assert(result.isSuccess());
        
    }

    @isTest
    public static void UPDATEifAPhoneNumberHasMoreThan10DigitsAnErrorMustShow(){
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

        Telefono__c tel = new Telefono__c(Telefono__c = '1234567891',Cuenta__c = cuenta.Id);
        insert tel;
        Test.startTest();
        tel.Telefono__c = '125454548491631';
        Database.SaveResult result = Database.update(tel,false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        for(Database.Error err : result.getErrors()){
            System.assertEquals('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx',err.getMessage());
        }
    }

    @isTest
    public static void UPDATEifAPhoneNumberHaveALetterAnErrorMustShow(){
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
        
        Telefono__c tel = new Telefono__c(Telefono__c = '1234567890',Cuenta__c = cuenta.Id);
        insert tel;
        Test.startTest();
        tel.Telefono__c = '56877a1530';
        Database.SaveResult result = Database.update(tel,false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        for(Database.Error err : result.getErrors()){
            System.assertEquals('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx',err.getMessage());
        }
    }

    
    @isTest
    public static void UPDATEifAPhoneHaveADashAnErrorMustShow(){
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
        Telefono__c tel = new Telefono__c(Telefono__c = '1234567800',Cuenta__c = cuenta.Id);
        insert tel;
        Test.startTest();
        tel.Telefono__c = '2256-48201';
        Database.SaveResult result = Database.update(tel,false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        for(Database.Error err : result.getErrors()){
            System.assertEquals('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx',err.getMessage());
        }
    }

    
    
    @isTest
    public static void UPDATEifAPhoneStarWith15AnErrorMustShow(){
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
        
        Telefono__c tel = new Telefono__c(Telefono__c = '1234567800',Cuenta__c = cuenta.Id);
        insert tel;
        Test.startTest();
        tel.Telefono__c = '152255222000';
        Database.SaveResult result = Database.update(tel,false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        for(Database.Error err : result.getErrors()){
            System.assertEquals('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx',err.getMessage());
        }
    }

    
    
    
    @isTest
    public static void UPDATEifAPhoneIsValidMustntShowError(){
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
        
        Telefono__c tel = new Telefono__c(Telefono__c = '1234567800',Cuenta__c = cuenta.Id);
        insert tel;
        Test.startTest();
        tel.Telefono__c = '5836254120';
        Database.SaveResult result = Database.update(tel,false);
        Test.stopTest();

        System.assert(result.isSuccess());
        
    }
}