@IsTest
public class WSBatchConvenioTest  {
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
			.withStatusCode(200)
			.withBody(WSBatchConvenioMock.getFound())
			.addForAddress(WSBatchConvenio.SERVICE_CONFIG.URL__c + '/v1/salud/batch/convenios-prestadores/07-01-2020?pageSize=1&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSBatchConvenioMock.getError())
			.addForAddress(WSBatchConvenio.SERVICE_CONFIG.URL__c + '/v1/salud/batch/convenios-prestadores/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfConvenios(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSBatchConvenio.Response responseToAssert = WSBatchConvenio.getBatchConvenio('07-01-2020', 1, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(2, responseToAssert.Convenio.data.size());
		System.assertEquals('R700711', responseToAssert.Convenio.data[0].convenio);
		System.assertEquals('2008-08-01 00:00:00', responseToAssert.Convenio.data[0].fecha_desde);
		System.assertEquals(null, responseToAssert.Convenio.data[0].fecha_hasta);
		System.assertEquals('700711', responseToAssert.Convenio.data[0].prestador);
		System.assertEquals(null, responseToAssert.Convenio.data[0].cons_secuencia);
		System.assertEquals(null, responseToAssert.Convenio.data[0].modconv_codigo);
		System.assertEquals(null, responseToAssert.Convenio.data[0].coeficiente_modelo);
		System.assertEquals('GO', responseToAssert.Convenio.data[0].an_codigo);
		System.assertEquals('A', responseToAssert.Convenio.data[0].estado);
		System.assertEquals('2008-11-24 10:10:20', responseToAssert.Convenio.data[0].fecha_activacion);
		System.assertEquals(null, responseToAssert.Convenio.data[0].fecha_baja);
		System.assertEquals('prestador que tiene VALORES PROPIOS VER AL FINAL DE LA GRILLA//  FERTYA', responseToAssert.Convenio.data[0].observaciones);
		System.assertEquals('2020-01-07 00:00:00', responseToAssert.Convenio.data[0].f_modif);
	}

	@IsTest
	private static void whenTheWSIsConsume_GetTokenErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		WSAuthToken.Response responseToAssert = WSAuthToken.getToken();
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('404 not found', responseToAssert.response.getStatus());
		System.assertEquals(null, responseToAssert.token);
	}
	

}