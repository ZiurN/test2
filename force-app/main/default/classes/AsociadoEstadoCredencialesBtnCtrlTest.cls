@isTest 
private class AsociadoEstadoCredencialesBtnCtrlTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmptyListResponse;
	static XHttpCalloutMock getDetalleResponseFound;
	static XHttpCalloutMock getDetalleErrorResponse;
	static XHttpCalloutMock getCargaResponseFound;
	static XHttpCalloutMock getCargaErrorResponse;

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
			.withBody(WSAsociadoEstadoCredencialesMock.getFound())
			.addForAddress(WSAsociadoEstadoCredenciales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/estados/88501-19');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoEstadoCredencialesMock.getFound())
			.addForAddress(WSAsociadoEstadoCredenciales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/estados/1234');

		getDetalleResponseFound = new XHttpCalloutMock();
		getDetalleResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getDetalleResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoCredencialDetalleMock.getFound())
			.addForAddress(
					WSAsociadoEstadoCredenciales.SERVICE_CONFIG.URL__c + 
					'/v1/salud/afiliado/credenciales/estados/88501-19/detalle/167607213'
			);

		getDetalleErrorResponse = new XHttpCalloutMock();
		getDetalleErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getDetalleErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoEstadoCredencialesMock.getError())
			.addForAddress(
					WSAsociadoEstadoCredenciales.SERVICE_CONFIG.URL__c + 
					'/v1/salud/afiliado/credenciales/estados/88501-19/detalle/0'
			);

		getCargaResponseFound = new XHttpCalloutMock();
		getCargaResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getCargaResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoCargaCredencialMock.getFound())
			.addForAddress(
					WSAsociadoEstadoCredenciales.SERVICE_CONFIG.URL__c + 
					'/v1/salud/afiliado/credenciales/carga-entrega'
			);

		getCargaErrorResponse = new XHttpCalloutMock();
		getCargaErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getCargaErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoCargaCredencialMock.getError())
			.addForAddress(
					WSAsociadoEstadoCredenciales.SERVICE_CONFIG.URL__c + 
					'/v1/salud/afiliado/credenciales/carga-entrega'
			);

	}
	
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoEstadoCredencialesSucess_returnAListOfEstadoCredenciales(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		AsociadoEstadoCredencialesBtnCtrl.Response responseToAssert = 
				AsociadoEstadoCredencialesBtnCtrl.getEstadoCredenciales('88501/19');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('88501/19', responseToAssert.data[0].codigo);
		System.assertEquals('TORRES GUSTAVO FABIAN', responseToAssert.data[0].apellido_nombre);
		System.assertEquals('5', responseToAssert.data[0].secuencia);
		System.assertEquals('2014-09-01', responseToAssert.data[0].fecha_emision);
		System.assertEquals('2014-09-01', responseToAssert.data[0].fecha_vigencia);
		System.assertEquals('2019-04-09', responseToAssert.data[0].fecha_baja);
		System.assertEquals('2019-04-09', responseToAssert.data[0].fecha_anulacion);
		System.assertEquals('167607213', responseToAssert.data[0].id_oca);
		System.assertEquals('Entregado Ag', responseToAssert.data[0].estado);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoEstadoCredencialesError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		AsociadoEstadoCredencialesBtnCtrl.Response responseToAssert = 
				AsociadoEstadoCredencialesBtnCtrl.getEstadoCredenciales('1234');
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('Hubo un error al intentar obtener el estado de las credenciales desde SS', responseToAssert.message);
		System.assertEquals(null, responseToAssert.data);
	}

	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeGetEstadoCredencialesDetalleSucess_returnAListOfEstadoCredenciales(){
		Test.setMock(HttpCalloutMock.class, getDetalleResponseFound);
		
		Test.startTest();
		AsociadoEstadoCredencialesBtnCtrl.ResponseDetalle responseToAssert = 
				AsociadoEstadoCredencialesBtnCtrl.getEstadoCredencialesDetalle('88501/19', '167607213');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals(DateTime.parse('02/05/2018 15:40'), responseToAssert.data[0].fecha);
		System.assertEquals('Entregada', responseToAssert.data[0].descripcion);
		System.assertEquals('Enviada a Digitalizadora', responseToAssert.data[0].estado);
		System.assertEquals('Entregada', responseToAssert.data[0].motivo);
		System.assertEquals('650792_AG. CNEL. DOMINGUEZ-MARICEL VIVIANA POLLACCHI', responseToAssert.data[0].nombre);
		System.assertEquals('6143735', responseToAssert.data[0].rendicion);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeGetEstadoCredencialesDetalleError_returnErrorMessage() {
		Test.setMock(HttpCalloutMock.class, getDetalleErrorResponse);
		
		Test.startTest();
		AsociadoEstadoCredencialesBtnCtrl.ResponseDetalle responseToAssert = 
				AsociadoEstadoCredencialesBtnCtrl.getEstadoCredencialesDetalle('88501/19', '0');
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('Hubo un error al intentar obtener el detalle desde SS', responseToAssert.message);
		System.assertEquals(null, responseToAssert.data);
	}

	@IsTest 
	public static void whenTheBtnIsClickedInTheView_cargaCredencialSucess(){
		Test.setMock(HttpCalloutMock.class, getCargaResponseFound);

		Test.startTest();
		AsociadoEstadoCredencialesBtnCtrl.ResponseCarga resp = 
			AsociadoEstadoCredencialesBtnCtrl.cargaCredencial('88501/19', '167607213');
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
		
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_cargaCredencialError() {
		Test.setMock(HttpCalloutMock.class, getCargaErrorResponse);
		
		Test.startTest();
		AsociadoEstadoCredencialesBtnCtrl.ResponseCarga resp = 
			AsociadoEstadoCredencialesBtnCtrl.cargaCredencial('88501/19', '167607213');
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('id oca es inválido.\n', resp.message);
	}

	@IsTest 
	public static void whenTheBtnIsClickedInTheViewAndCodigoOrOcaIdIsEmpty_showTheCorrectMsg() {
		Test.startTest();
		AsociadoEstadoCredencialesBtnCtrl.ResponseCarga resp = 
			AsociadoEstadoCredencialesBtnCtrl.cargaCredencial('88501/19', '');
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals('El id de Oca y el Código deben estar completos.', resp.message);
	}

}