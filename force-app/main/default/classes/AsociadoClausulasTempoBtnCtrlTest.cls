@IsTest
public class AsociadoClausulasTempoBtnCtrlTest  {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmptyListResponse;

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
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetClausulasTempoMock.getError())
			.addForAddress(WSAsociadoGetClausulasTempo.SERVICE_CONFIG.URL__c + '/v1/salud/clausulas/temporarias/');
	}
	
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoClausulasTempoSucess_returnAListOfClausulasTempo(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		AsociadoClausulasTempoBtnCtrl.Response responseToAssert = AsociadoClausulasTempoBtnCtrl.getAsociadoClausulasTempo('169712');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('C_PMI-MADRE', responseToAssert.asociadoClausulasTempo[0].tipo_clausula);
		System.assertEquals('COBERTURA PMI PARA MADRES', responseToAssert.asociadoClausulasTempo[0].tipo_clausula_descripcion);
		System.assertEquals('2004-10-26', responseToAssert.asociadoClausulasTempo[0].fecha_vigencia_desde);
		System.assertEquals('2005-08-26', responseToAssert.asociadoClausulasTempo[0].fecha_vigencia_hasta);
		System.assertEquals('PMI_MADRE', responseToAssert.asociadoClausulasTempo[0].tipo_asignacion);
		System.assertEquals('PLAN MATERNO', responseToAssert.asociadoClausulasTempo[0].tipo_asignacion_descripcion);
		System.assertEquals('0', responseToAssert.asociadoClausulasTempo[0].nivel_aprobacion);
		System.assertEquals('F', responseToAssert.asociadoClausulasTempo[0].requiere_evento);
		System.assertEquals('V', responseToAssert.asociadoClausulasTempo[0].requiere_patologia);
		System.assertEquals('Z34', responseToAssert.asociadoClausulasTempo[0].diag_codigo);
		System.assertEquals('SUPERVISIÓN DE EMBARAZO NORMAL', responseToAssert.asociadoClausulasTempo[0].diag_descripcion);
		System.assertEquals('2004-10-26', responseToAssert.asociadoClausulasTempo[0].diag_fecha);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo[0].numero_evento);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo[0].descripcion_evento);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo[0].observaciones);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo[0].fecha_carga);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo[0].user_carga);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoClausulasTempoError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		AsociadoClausulasTempoBtnCtrl.Response responseToAssert = AsociadoClausulasTempoBtnCtrl.getAsociadoClausulasTempo('169712');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener las clausulas temporarias desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoClausulasTempo);
	}

}