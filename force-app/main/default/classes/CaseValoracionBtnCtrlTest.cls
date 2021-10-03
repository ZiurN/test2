@IsTest
private class CaseValoracionBtnCtrlTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorDateResponse;
    static XHttpCalloutMock getErrorAfiResponse;

    static {
        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseValoracionMock.getFound())
                .addForAddress(WSCaseValoracion.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/458495/04-2019');
        
        getErrorDateResponse = new XHttpCalloutMock();
        getErrorDateResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorDateResponse.buildResponse()
                .withStatus('404 Not Found')
                .withStatusCode(404)
                .withBody(WSCaseValoracionMock.getErrorInvalidDate())
                .addForAddress(WSCaseValoracion.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/458495/04-19');

        getErrorAfiResponse = new XHttpCalloutMock();
        getErrorAfiResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorAfiResponse.buildResponse()
                .withStatus('404 Not Found')
                .withStatusCode(404)
                .withBody(WSCaseValoracionMock.getErrorInvalidAfi())
                .addForAddress(WSCaseValoracion.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/123/04-2019');

    }
    @IsTest
    private static void getValoracionFromAValidAfiliadoWithOtherDiscountOf75Percent() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Case nCase = new Case();
        nCase.Valor_de_descuento__c = 'Otro';
        nCase.Otro_valor__c = 75;
        insert nCase;
        Test.startTest();
        CaseValoracionBtnCtrl.Response resp = CaseValoracionBtnCtrl.getValoracionAfi(nCase.Id,'458495','04-2019');
        Test.stopTest();

        nCase = [SELECT Cuota_bonificada_sin_iva__c FROM Case WHERE Id = :nCase.Id];
        System.assertEquals(false,resp.hasError);
        System.assertEquals('Valor de cuota bonificada sin iva actualizado.',resp.message);
		System.assertEquals(3125.00, nCase.Cuota_bonificada_sin_iva__c);
    }
    
    @IsTest
    private static void getValoracionFromAValidAfiliadoWith5PercentDiscount() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Case nCase = new Case();
        nCase.Valor_de_descuento__c = '5%';
        insert nCase;
        Test.startTest();
        CaseValoracionBtnCtrl.Response resp = CaseValoracionBtnCtrl.getValoracionAfi(nCase.Id,'458495','04-2019');
        Test.stopTest();

        nCase = [SELECT Cuota_bonificada_sin_iva__c FROM Case WHERE Id = :nCase.Id];
        System.assertEquals(false,resp.hasError);
        System.assertEquals('Valor de cuota bonificada sin iva actualizado.',resp.message);
		System.assertEquals(11875.00, nCase.Cuota_bonificada_sin_iva__c);
    }

	@IsTest
    private static void getValoracionFromAValidAfiliadoWith10PercentDiscount() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Case nCase = new Case();
        nCase.Valor_de_descuento__c = '10%';
        insert nCase;
        Test.startTest();
        CaseValoracionBtnCtrl.Response resp = CaseValoracionBtnCtrl.getValoracionAfi(nCase.Id,'458495','04-2019');
        Test.stopTest();

        nCase = [SELECT Cuota_bonificada_sin_iva__c FROM Case WHERE Id = :nCase.Id];
        System.assertEquals(false,resp.hasError);
        System.assertEquals('Valor de cuota bonificada sin iva actualizado.',resp.message);
		System.assertEquals(11250.00, nCase.Cuota_bonificada_sin_iva__c);
    }
    
    @IsTest
    private static void getValoracionFromAValidAfiliadoWith15PercentDiscount() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Case nCase = new Case();
        nCase.Valor_de_descuento__c = '15%';
        insert nCase;
        Test.startTest();
        CaseValoracionBtnCtrl.Response resp = CaseValoracionBtnCtrl.getValoracionAfi(nCase.Id,'458495','04-2019');
        Test.stopTest();

        nCase = [SELECT Cuota_bonificada_sin_iva__c FROM Case WHERE Id = :nCase.Id];
        System.assertEquals(false,resp.hasError);
        System.assertEquals('Valor de cuota bonificada sin iva actualizado.',resp.message);
		System.assertEquals(10625.00, nCase.Cuota_bonificada_sin_iva__c);
    }
    
    @IsTest
    private static void getValoracionFromAValidAfiliadoWith20PercentDiscount() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Case nCase = new Case();
        nCase.Valor_de_descuento__c = '20%';
        insert nCase;
        Test.startTest();
        CaseValoracionBtnCtrl.Response resp = CaseValoracionBtnCtrl.getValoracionAfi(nCase.Id,'458495','04-2019');
        Test.stopTest();

        nCase = [SELECT Cuota_bonificada_sin_iva__c FROM Case WHERE Id = :nCase.Id];
        System.assertEquals(false,resp.hasError);
        System.assertEquals('Valor de cuota bonificada sin iva actualizado.',resp.message);
		System.assertEquals(10000.00, nCase.Cuota_bonificada_sin_iva__c);
    }
    
    
    @IsTest
    private static void getValoracionWithInvalidAfiliado() {
        Test.setMock(HttpCalloutMock.class, getErrorAfiResponse);
        Case nCase = new Case();
        nCase.Valor_de_descuento__c = '20%';
        insert nCase;
        Test.startTest();
        CaseValoracionBtnCtrl.Response resp = CaseValoracionBtnCtrl.getValoracionAfi(nCase.Id,'123','04-2019');
        Test.stopTest();

        System.assertEquals(true,resp.hasError);
        System.assertEquals('El ID del Afiliado es inválido.',resp.message);

    }
    
    @IsTest
    private static void getValoracionWithInvalidDate() {
        Test.setMock(HttpCalloutMock.class, getErrorDateResponse);
        Case nCase = new Case();
        nCase.Valor_de_descuento__c = '20%';
        insert nCase;
        Test.startTest();
        CaseValoracionBtnCtrl.Response resp = CaseValoracionBtnCtrl.getValoracionAfi(nCase.Id,'458495','04-19');
        Test.stopTest();
        nCase = [SELECT Cuota_bonificada_sin_iva__c FROM Case WHERE Id = :nCase.Id];

        System.assertEquals(true,resp.hasError);
        System.assertEquals('Formato de fecha hasta invalido',resp.message);
        System.assertEquals(null,nCase.Cuota_bonificada_sin_iva__c);	
    }
    
    @IsTest
    private static void getValoracionWithInvalidCase() {
        Test.setMock(HttpCalloutMock.class, getErrorDateResponse);

        Test.startTest();
        CaseValoracionBtnCtrl.Response resp = CaseValoracionBtnCtrl.getValoracionAfi('555','458495','04-2019');
        Test.stopTest();

        System.assertEquals(true,resp.hasError);
        System.assertEquals('No existe un caso con el id 555',resp.message);
    }
    
    @IsTest
    private static void getValoracionWithANullParameter() {
        Test.setMock(HttpCalloutMock.class, getErrorAfiResponse);
        Case nCase = new Case();
        nCase.Valor_de_descuento__c = '20%';
        insert nCase;
        Test.startTest();
        CaseValoracionBtnCtrl.Response resp = CaseValoracionBtnCtrl.getValoracionAfi(nCase.Id,null,'04-2019');
        Test.stopTest();

        System.assertEquals(true,resp.hasError);
        System.assertEquals('Los valores id de caso, codigo de afiliado y periodo no pueden estar vacios.',resp.message);

    }
    
    
}