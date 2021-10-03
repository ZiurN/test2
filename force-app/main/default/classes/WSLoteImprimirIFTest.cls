@IsTest
public class WSLoteImprimirIFTest  {
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
		
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('El lote solicitado es invalido.')
			.withStatusCode(404)
			.withBody(WSLoteImprimirIFMock.getError())
			.addForAddress(WSLoteImprimirIF.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/123/reportes/preliquidacion');
		
	}

	@isTest
	private static void sendLoteToSSAndGetPDF() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Test.startTest();
		WSLoteImprimirIF.Response resp = WSLoteImprimirIF.imprimirIF('123');
		Test.stopTest();

		System.assertEquals(false,resp.hasError);
		System.assertEquals(null,resp.message);
		System.assertEquals('A',resp.lote.data.lote.estado);
		System.assertEquals('http://www.extranet.acasalud.com.ar/SF/PRELIQ_5397.pdf',resp.lote.data.lote.link_preliq);
	}

	@isTest
	private static void sendLoteToSSAndGetAnError() {
		Test.setMock(HttpCalloutMock.class,getResponseError);
		Test.startTest();
		WSLoteImprimirIF.Response resp = WSLoteImprimirIF.imprimirIF('123');
		Test.stopTest();

		System.assertEquals(true,resp.hasError);
		System.assertEquals('El lote solicitado es invalido.',resp.message);
		System.assertEquals(null,resp.lote);
	}


}