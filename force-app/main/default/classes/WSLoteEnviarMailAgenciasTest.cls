@isTest
public class WSLoteEnviarMailAgenciasTest {
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

    @isTest
	private static void sendMailToAgencias() {
        String id = '1234';
        Test.setMock(HttpCalloutMock.class,getResponseFound);

		Test.startTest();
		WSLoteEnviarMailAgencias.Response resp = WSLoteEnviarMailAgencias.enviarIdLote(id);
		Test.stopTest();

		System.assertEquals(false,resp.hasError);
		System.assertEquals(null ,resp.message);
    }
    
    @isTest
	private static void sendMailToAgenciasError() {
        String id = '1234a';
        Test.setMock(HttpCalloutMock.class,getResponseFound);

		Test.startTest();
		WSLoteEnviarMailAgencias.Response resp = WSLoteEnviarMailAgencias.enviarIdLote(id);
		Test.stopTest();

		System.assertEquals(true,resp.hasError);
		System.assertEquals('no content to map to Object due to end of input' ,resp.message);
	}
}