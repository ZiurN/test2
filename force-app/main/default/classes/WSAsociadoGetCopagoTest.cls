@IsTest
public class WSAsociadoGetCopagoTest  {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;

	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(201)
			.withBody(WSAsociadoGetCopagoMock.getFound())
			.addForAddress(WSAsociadoGetCopago.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/131151/pdf-copago');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetCopagoMock.getError())
			.addForAddress(WSAsociadoGetCopago.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/0/pdf-copago');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetAPDFLink(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetCopago.Response responseToAssert = WSAsociadoGetCopago.getAsociadoCopago('131151');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(201, responseToAssert.response.getStatusCode());
		System.assertEquals('http://www.extranet.acasalud.com.ar/SF/REPORTE_COPAGO_131151.pdf',responseToAssert.asociadoCopago.data.link);
	}

	@IsTest
	private static void whenTheWSIsConsume_GetAnError(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		WSAsociadoGetCopago.Response responseToAssert = WSAsociadoGetCopago.getAsociadoCopago('0');
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
	}
}