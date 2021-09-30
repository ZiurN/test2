@IsTest
public class WSAsociadoGetAsociadoTest  {
	@IsTest
	private static void whenTheWSIsConsume_GetAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		WSAsociadoGetAsociado.Response responseToAssert = WSAsociadoGetAsociado.getAsociado('131153');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(false, responseToAssert.asociadoApiRespValuesByasociadoApiRespFields.isEmpty());
	}
	

	static XHttpCalloutMock getResponseFound;

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
			.withBody(WSAsociadoGetAsociadoMock.getFound())
			.addForAddress(WSAsociadoGetAsociado.SERVICE_CONFIG.URL__c + '/v1/salud/consultar-afiliado/afi_id/131153');
	}
}