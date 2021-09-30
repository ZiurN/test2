@IsTest
public class WSBatchEfectorTest  {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmpty;

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
			.withBody(WSBatchEfectorMock.getFound())
			.addForAddress(WSBatchEfector.SERVICE_CONFIG.URL__c + '/v1/salud/batch/efectores/09-12-2019?pageSize=100&page=1');

		getEmpty = new XHttpCalloutMock();
		getEmpty.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getEmpty.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSBatchEfectorMock.getEmpty())
			.addForAddress(WSBatchEfector.SERVICE_CONFIG.URL__c + '/v1/salud/batch/efectores/12-12-2019?pageSize=100&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSBatchEfectorMock.getError())
			.addForAddress(WSBatchEfector.SERVICE_CONFIG.URL__c + '/v1/salud/batch/efectores/?pageSize=100&page=1');
	}

	@IsTest
	private static void whenTheWSIsConsume_GetListOfEfectores(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSBatchEfector.Response responseToAssert = WSBatchEfector.getBatchEfector('09-12-2019', 100, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(4, responseToAssert.efector.data.size());
		System.assertEquals('700047', responseToAssert.efector.data[0].codigo);
		System.assertEquals('ASOC. MEDICA DE ROSARIO', responseToAssert.efector.data[0].nombre);
		System.assertEquals('ROS-P-200100100 ASOC. MEDICA DE ROSARIO', responseToAssert.efector.data[0].descripcion);
		System.assertEquals('V', responseToAssert.efector.data[0].es_prestador);
		System.assertEquals('ASOMED', responseToAssert.efector.data[0].codigo_clase);
		System.assertEquals('ASOCIACION MEDICA', responseToAssert.efector.data[0].clase);
		System.assertEquals(null, responseToAssert.efector.data[0].categoria);
		System.assertEquals(null, responseToAssert.efector.data[0].egresado);
		System.assertEquals(null, responseToAssert.efector.data[0].fecha_titulo);
		System.assertEquals(null, responseToAssert.efector.data[0].estado_civil);
		System.assertEquals(null, responseToAssert.efector.data[0].fecha_nacimiento);
		System.assertEquals('REPACTADO SIN VTO.-', responseToAssert.efector.data[0].observaciones);
		System.assertEquals('A', responseToAssert.efector.data[0].estado);
		System.assertEquals('1970-01-01 00:00:00', responseToAssert.efector.data[0].fecha_vigencia);
		System.assertEquals('30528073146', responseToAssert.efector.data[0].cuit);
		System.assertEquals('CONVENIO PDF - ojo, con tto. de linfedema del Dr. Gersman, se procesa con modificadores', responseToAssert.efector.data[0].obs_prestador);
		System.assertEquals('A', responseToAssert.efector.data[0].estado_prestador);
		System.assertEquals('2002-06-01 00:00:00', responseToAssert.efector.data[0].fecha_vigencia_prestador);
		System.assertEquals('2002-06-01 00:00:00', responseToAssert.efector.data[0].fecha_alta);
		System.assertEquals(null, responseToAssert.efector.data[0].fecha_baja);
		System.assertEquals(null, responseToAssert.efector.data[0].motivo_baja);
		System.assertEquals('F', responseToAssert.efector.data[0].es_profesional);
		System.assertEquals('2019-12-09 00:00:00', responseToAssert.efector.data[0].f_modif);
		System.assertEquals(null, responseToAssert.efector.data[0].f_modif_pre);

		
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




	@IsTest
	private static void whenTheWSIsConsume_GetEmpty(){
		Test.setMock(HttpCalloutMock.class, getEmpty);
		
		Test.startTest();
		WSBatchEfector.Response responseToAssert = WSBatchEfector.getBatchEfector('12-12-2019', 100, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(0, responseToAssert.efector.data.size());

	}
}