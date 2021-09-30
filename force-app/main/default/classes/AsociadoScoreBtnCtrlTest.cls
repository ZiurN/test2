@isTest
public class AsociadoScoreBtnCtrlTest {
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
			.withBody(WSAsociadoScoreMock.getFound())
			.addForAddress(WSAsociadoScore.SERVICE_CONFIG.URL__c + '/v1/salud/score/202637-15');
        getResponseError = new XHttpCalloutMock();
        getResponseError.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
            getResponseError.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoScoreMock.getError())
            .addForAddress(WSAsociadoScore.SERVICE_CONFIG.URL__c + '/v1/salud/score/0');
    }

    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSLoteEnviarMailAgenciasSucess() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Account acc = Build.anAccount().build();
        acc.Codigo_de_Afiliado__c = '202637/15';
		acc.Tiene_evento_de_exclusion__c = true;
        insert acc;

        Test.startTest();
        AsociadoScoreBtnCtrl.Response responseToAssert = AsociadoScoreBtnCtrl.sendAccount(acc.Codigo_de_Afiliado__c);
        Test.stopTest();

        Account accToAssert = [
            SELECT Indice_de_Rentabilidad__c, Color_scoring__c, Tiene_evento_de_exclusion__c, Edad_maxima__c
            FROM Account
            WHERE Id =: acc.Id
        ];

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals(null,responseToAssert.message);
        System.assertEquals('-886034.17', accToAssert.Indice_de_Rentabilidad__c);
        System.assertEquals('ROJO', accToAssert.Color_scoring__c);
		System.assertEquals(44, accToAssert.Edad_maxima__c);
		System.assertEquals(false, accToAssert.Tiene_evento_de_exclusion__c);

    }

    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSWithError() {
        Test.setMock(HttpCalloutMock.class, getResponseError);
        Account acc = Build.anAccount().build();
        acc.Codigo_de_Afiliado__c = '0';
        insert acc;

        Test.startTest();
        AsociadoScoreBtnCtrl.Response responseToAssert = AsociadoScoreBtnCtrl.sendAccount(acc.Codigo_de_Afiliado__c);
        Test.stopTest();

        System.assertEquals(true,responseToAssert.hasError);
        System.assertEquals('Código de Afiliado inválido.',responseToAssert.message);
    }
}