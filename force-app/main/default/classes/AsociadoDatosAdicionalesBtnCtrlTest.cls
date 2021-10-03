@IsTest
public class AsociadoDatosAdicionalesBtnCtrlTest  {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmptyListResponse;
	static XHttpCalloutMock getResponseFoundEmpresa;
	static XHttpCalloutMock getErrorResponseEmpresa;
	static XHttpCalloutMock getResponseFoundEfector;
	static XHttpCalloutMock getErrorResponseEfector;

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
			.withBody(WSAsociadoGetDatosAdicionalesMock.getFound())
			.addForAddress(WSAsociadoGetDatosAdicionales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-adicionales/458495');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDatosAdicionalesMock.getError())
			.addForAddress(WSAsociadoGetDatosAdicionales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-adicionales/0');

		//Empresa
		getResponseFoundEmpresa = new XHttpCalloutMock();
		getResponseFoundEmpresa.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundEmpresa.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetDatosAdicionalesMock.getFoundEmpresa())
			.addForAddress(WSAsociadoGetDatosAdicionales.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/601043/datos-adicionales');

		getErrorResponseEmpresa = new XHttpCalloutMock();
		getErrorResponseEmpresa.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseEmpresa.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDatosAdicionalesMock.getError())
			.addForAddress(WSAsociadoGetDatosAdicionales.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/0/datos-adicionales');

		//Efector
		getResponseFoundEfector = new XHttpCalloutMock();
		getResponseFoundEfector.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundEfector.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetDatosAdicionalesMock.getFoundEfector())
			.addForAddress(WSAsociadoGetDatosAdicionales.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/datos-adicionales/536787');

		getErrorResponseEfector = new XHttpCalloutMock();
		getErrorResponseEfector.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseEfector.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDatosAdicionalesMock.getError())
			.addForAddress(WSAsociadoGetDatosAdicionales.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/datos-adicionales/0');
	}
	
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoDatosAdicionalesSucess_returnAListOfDatosAdicionales(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		AsociadoDatosAdicionalesBtnCtrl.Response responseToAssert = AsociadoDatosAdicionalesBtnCtrl.getAsociadoDatosAdicionales('458495');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('SC', responseToAssert.asociadoDatosAdicionales[0].codigo);
		System.assertEquals('SOCIO DE COOPERATIVA', responseToAssert.asociadoDatosAdicionales[0].nombre);
		System.assertEquals('F', responseToAssert.asociadoDatosAdicionales[0].valor);
		System.assertEquals(null, responseToAssert.asociadoDatosAdicionales[0].observaciones);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoDatosAdicionalesError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		AsociadoDatosAdicionalesBtnCtrl.Response responseToAssert = AsociadoDatosAdicionalesBtnCtrl.getAsociadoDatosAdicionales('0');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los datos adicionales desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoDatosAdicionales);
	}

	//Empresa
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSEmpresaDatosAdicionalesSucess_returnAListOfDatosAdicionales(){
		Test.setMock(HttpCalloutMock.class, getResponseFoundEmpresa);
		
		Test.startTest();
		AsociadoDatosAdicionalesBtnCtrl.Response responseToAssert = AsociadoDatosAdicionalesBtnCtrl.getEmpresaDatosAdicionales(601043);
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('AG_E', responseToAssert.asociadoDatosAdicionales[0].tipo_dato_adicional);
		System.assertEquals('AGENCIA A LA QUE PERTENECE UNA EMPRESA', responseToAssert.asociadoDatosAdicionales[0].descripcion_dato_adicional);
		System.assertEquals('650070', responseToAssert.asociadoDatosAdicionales[0].valor);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSEmpresaDatosAdicionalesError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponseEmpresa);
		
		Test.startTest();
		AsociadoDatosAdicionalesBtnCtrl.Response responseToAssert = AsociadoDatosAdicionalesBtnCtrl.getEmpresaDatosAdicionales(0);
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los datos adicionales desde SaludSoft, asegúrese que el código de empresa esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoDatosAdicionales);
	}
	//Efector
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSEfectorDatosAdicionalesSucess_returnAListOfDatosAdicionales(){
		Test.setMock(HttpCalloutMock.class, getResponseFoundEfector);
		
		Test.startTest();
		AsociadoDatosAdicionalesBtnCtrl.Response responseToAssert = AsociadoDatosAdicionalesBtnCtrl.getEfectorDatosAdicionales(536787);
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('UACT', responseToAssert.asociadoDatosAdicionales[0].tipo_dato_adicional);
		System.assertEquals(null, responseToAssert.asociadoDatosAdicionales[0].descripcion_dato_adicional);
		System.assertEquals('09/05/2018', responseToAssert.asociadoDatosAdicionales[0].valor);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSEfectorDatosAdicionalesError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponseEfector);
		
		Test.startTest();
		AsociadoDatosAdicionalesBtnCtrl.Response responseToAssert = AsociadoDatosAdicionalesBtnCtrl.getEfectorDatosAdicionales(0);
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los datos adicionales desde SaludSoft, asegúrese que el código de efector esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoDatosAdicionales);
	}
}