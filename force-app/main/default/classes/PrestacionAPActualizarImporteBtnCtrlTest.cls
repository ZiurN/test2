@IsTest
public class PrestacionAPActualizarImporteBtnCtrlTest  {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static String body;
	static Prestacion__c prest;

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
			.withBody(WSPrestacionAPActualizarImporteMock.getFound())
			.addForAddress(WSPrestacionAPActualizarImporte.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/prestacion/74042009/importe');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSPrestacionAPActualizarImporteMock.getError())
			.addForAddress(WSPrestacionAPActualizarImporte.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/prestacion/74042009/importe');

		prest = new Prestacion__c();
		prest.Prestacion_CA__c = '74042009';
		prest.Importe_cargo_al_socio_auditor__c = 1000;
		prest.Importe_convenio_auditor__c = 999.50;
		prest.Importe_plan_auditor__c = 200.99;

		insert prest;
	}
	
	@IsTest
	private static void whenTheWSIsConsume_getPrestaciones(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		PrestacionAPActualizarImporteBtnCtrl.Response resp = PrestacionAPActualizarImporteBtnCtrl.updateImporte(prest.Id);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
		
	}

	@IsTest
	private static void whenTheWSIsConsume_GetErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		PrestacionAPActualizarImporteBtnCtrl.Response resp = PrestacionAPActualizarImporteBtnCtrl.updateImporte(prest.Id);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.debug(resp.message);
		System.assertEquals('La prestación solicitada es inválida.', resp.message);
	}
}