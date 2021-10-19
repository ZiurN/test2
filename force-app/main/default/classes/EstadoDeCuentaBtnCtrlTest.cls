@isTest
public class EstadoDeCuentaBtnCtrlTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getResponseError;

    static {
		WSCaseReintegroEnviarASSMock mock = new WSCaseReintegroEnviarASSMock();
		
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSEstadoDeCuentaMock.getFound())
			.addForAddress(WSEstadoDeCuenta.SERVICE_CONFIG.URL__c + '/v1/salud/semaforo/458495');
        getResponseError = new XHttpCalloutMock();
        getResponseError.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
            getResponseError.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSEstadoDeCuentaMock.getError())
            .addForAddress(WSEstadoDeCuenta.SERVICE_CONFIG.URL__c + '/v1/salud/semaforo/0');
    }

    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSSucess() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Account acc = Build.anAccount().build();
        acc.Afi_Id__C = '458495';
        insert acc;

        Test.startTest();
        EstadoDeCuentaBtnCtrl.Response responseToAssert = EstadoDeCuentaBtnCtrl.sendAccount(acc.Afi_Id__C);
        Test.stopTest();

        Account accToAssert = [
            SELECT Color_estado_de_cuenta__c
            FROM Account
            WHERE Id =: acc.Id
        ];

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals(null,responseToAssert.message);
        System.assertEquals('VERDE', accToAssert.Color_estado_de_cuenta__c);

    }

    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSWithError() {
        Test.setMock(HttpCalloutMock.class, getResponseError);
        Account acc = Build.anAccount().build();
        acc.Afi_Id__C = '0';
        insert acc;

        Test.startTest();
        EstadoDeCuentaBtnCtrl.Response responseToAssert = EstadoDeCuentaBtnCtrl.sendAccount(acc.Afi_Id__C);
        Test.stopTest();

        System.assertEquals(true,responseToAssert.hasError);
        System.assertEquals('El ID del Afiliado es inválido.',responseToAssert.message);
    }
}