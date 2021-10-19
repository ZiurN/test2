@isTest 
private class LoteImprimirIFCtrlTest {

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
			.withBody(WSLoteImprimirIFMock.getFound())
			.addForAddress(WSLoteImprimirIF.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/123/reportes/preliquidacion');
		
		
	}

	@isTest
	private static void sendLoteToSSAndGetPDF() {

		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Test.startTest();
		LoteImprimirIFCtrl.Response resp = LoteImprimirIFCtrl.sendLoteToSS('123');
		Test.stopTest();

		System.assertEquals(false,resp.hasError);
		System.assertEquals('http://www.extranet.acasalud.com.ar/SF/PRELIQ_5397.pdf',resp.lote);

	}
}