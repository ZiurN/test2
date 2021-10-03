@isTest
public class LoteEnviarMailAgenciasBtnCtrlTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getResponseError;

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
            .withBody(WSLoteEnviarMailAgenciasMock.getFound())
            .addForAddress(WSLoteEnviarMailAgencias.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/1234/mail');
        getResponseError = new XHttpCalloutMock();
        getResponseError.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseError.buildResponse()
            .withStatus('Error')
            .withStatusCode(422)
            .withBody(WSLoteEnviarMailAgenciasMock.getError())
            .addForAddress(WSLoteEnviarMailAgencias.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/1234a/mail');
        
    }

    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSLoteEnviarMailAgenciasSucess() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        LoteEnviarMailAgenciasBtnCtrl.Response responseToAssert = LoteEnviarMailAgenciasBtnCtrl.sendEmailToAgencias('1234');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals(null,responseToAssert.message);
    }

    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSLoteEnviarMailAgenciasWithError() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        LoteEnviarMailAgenciasBtnCtrl.Response responseToAssert = LoteEnviarMailAgenciasBtnCtrl.sendEmailToAgencias('1234a');
        Test.stopTest();

        System.assertEquals(true,responseToAssert.hasError);
        System.assertEquals('no content to map to Object due to end of input',responseToAssert.message);
    }
}