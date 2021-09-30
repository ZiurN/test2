@IsTest
public class WSBatchDelegacionTest  {
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
			.withBody(WSBatchDelegacionMock.getFoundSecondPage())
			.addForAddress(WSBatchDelegacion.SERVICE_CONFIG.URL__c + '/v1/salud/batch/delegaciones/2020-01-20?pageSize=1&page=2');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSBatchDelegacionMock.getError())
			.addForAddress(WSBatchDelegacion.SERVICE_CONFIG.URL__c + '/v1/salud/batch/afiliados/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfDelegaciones(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSBatchDelegacion.Response responseToAssert = WSBatchDelegacion.getBatchDelegacion('2020-01-20', 1, 2);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(1, responseToAssert.delegacion.data.size());
		System.assertEquals('AGENCIA', responseToAssert.delegacion.data[0].tipo_delegacion);
		System.assertEquals('650077', responseToAssert.delegacion.data[0].codigo);
		System.assertEquals('650077_AG. ELORTONDO - COOP. AGROP.UNIF. LTDA DE ELORTONDO.', responseToAssert.delegacion.data[0].nombre);
		System.assertEquals('COOPERATIVA AGROPECUARIA UNIFICADA LIMITADA DE ELORTONDO', responseToAssert.delegacion.data[0].descripcion);
		System.assertEquals('1900-01-01 00:00:00', responseToAssert.delegacion.data[0].fecha_activacion);
		System.assertEquals('A', responseToAssert.delegacion.data[0].estado);
		System.assertEquals('ROS', responseToAssert.delegacion.data[0].organizacion);
		System.assertEquals('serviciossociales@coopagroelortondo.com.ar', responseToAssert.delegacion.data[0].correo_electronico);
		System.assertEquals(null, responseToAssert.delegacion.data[0].observaciones);
		System.assertEquals('San Martín 1046  ', responseToAssert.delegacion.data[0].domicilio);
		System.assertEquals('ELORTONDO', responseToAssert.delegacion.data[0].localidad);
		System.assertEquals('SANTA FE', responseToAssert.delegacion.data[0].provincia);
		System.assertEquals(null, responseToAssert.delegacion.data[0].url_convenio);
		System.assertEquals('650497', responseToAssert.delegacion.data[0].filial_depende);
		System.assertEquals(null, responseToAssert.delegacion.data[0].pje_comis_dateras);
		System.assertEquals('D', responseToAssert.delegacion.data[0].nivel_permiso);
		System.assertEquals('caule-gerencia@arnetbiz.com.ar', responseToAssert.delegacion.data[0].correo_gerencia_coop);
		System.assertEquals('INCENTIVADA_B', responseToAssert.delegacion.data[0].tipo_comision_venta);
		
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