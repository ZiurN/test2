@IsTest
public class WSAsociadoGetClausulasTempoTest  {
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
			.withBody(WSAsociadoGetClausulasTempoMock.getFound())
			.addForAddress(WSAsociadoGetClausulasTempo.SERVICE_CONFIG.URL__c + '/v1/salud/clausulas/temporarias/169712');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetClausulasTempoMock.getError())
			.addForAddress(WSAsociadoGetClausulasTempo.SERVICE_CONFIG.URL__c + '/v1/salud/clausulas/temporarias/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfClausulasTempoOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetClausulasTempo.Response responseToAssert = WSAsociadoGetClausulasTempo.getAsociadoClausulasTempo('169712');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(1, responseToAssert.asociadoClausulasTempo.data.size());
		System.assertEquals('C_PMI-MADRE', responseToAssert.asociadoClausulasTempo.data[0].tipo_clausula);
		System.assertEquals('COBERTURA PMI PARA MADRES', responseToAssert.asociadoClausulasTempo.data[0].tipo_clausula_descripcion);
		System.assertEquals('2004-10-26', responseToAssert.asociadoClausulasTempo.data[0].fecha_vigencia_desde);
		System.assertEquals('2005-08-26', responseToAssert.asociadoClausulasTempo.data[0].fecha_vigencia_hasta);
		System.assertEquals('PMI_MADRE', responseToAssert.asociadoClausulasTempo.data[0].tipo_asignacion);
		System.assertEquals('PLAN MATERNO', responseToAssert.asociadoClausulasTempo.data[0].tipo_asignacion_descripcion);
		System.assertEquals('0', responseToAssert.asociadoClausulasTempo.data[0].nivel_aprobacion);
		System.assertEquals('F', responseToAssert.asociadoClausulasTempo.data[0].requiere_evento);
		System.assertEquals('V', responseToAssert.asociadoClausulasTempo.data[0].requiere_patologia);
		System.assertEquals('Z34', responseToAssert.asociadoClausulasTempo.data[0].diag_codigo);
		System.assertEquals('SUPERVISIÓN DE EMBARAZO NORMAL', responseToAssert.asociadoClausulasTempo.data[0].diag_descripcion);
		System.assertEquals('2004-10-26', responseToAssert.asociadoClausulasTempo.data[0].diag_fecha);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo.data[0].numero_evento);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo.data[0].descripcion_evento);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo.data[0].observaciones);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo.data[0].fecha_carga);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo.data[0].user_carga);
		
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