@IsTest
public class AsociadoValoracionesBtnCtrlTest  {
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoValoracionesSucess_returnAListOfValoraciones(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		AsociadoValoracionesBtnCtrl.Response responseToAssert = AsociadoValoracionesBtnCtrl.getAsociadoValorizaciones('131153', '04', '2019');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals('', responseToAssert.message); 
		System.assertEquals(4, responseToAssert.asociadoValoraciones.size());

		System.assertEquals('2460.33', responseToAssert.asociadoValoraciones[0].Importe);
		System.assertEquals('BAS', responseToAssert.asociadoValoraciones[0].Tcc_Codigo);
		System.assertEquals('Cuota Basica', responseToAssert.asociadoValoraciones[0].Nombre_Clausula);
		System.assertEquals('1', responseToAssert.asociadoValoraciones[0].Cantidad);
		System.assertEquals('1', responseToAssert.asociadoValoraciones[0].Coeficiente);
		System.assertEquals('1', responseToAssert.asociadoValoraciones[0].Coeficiente_General);
		System.assertEquals('', responseToAssert.asociadoValoraciones[0].Cga_codigo);
		System.assertEquals('', responseToAssert.asociadoValoraciones[0].Nombre_Cat_Grupal);
		System.assertEquals('PERSONA', responseToAssert.asociadoValoraciones[0].Rcg_codigo);
		System.assertEquals('Persona', responseToAssert.asociadoValoraciones[0].Nombre_Regla_Adic);
	}

	@IsTest
	private static void whenTheWSIsConsume_GetValoracionesErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		AsociadoValoracionesBtnCtrl.Response responseToAssert = AsociadoValoracionesBtnCtrl.getAsociadoValorizaciones('131153', '04', '2019');
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('Hubo un error al intentar obtener las valorizaciones desde SaludSoft', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoValoraciones);
	}

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
			.withBody(WSAsociadoGetValoracionesMock.getFound())
			.addForAddress(WSAsociadoGetValoraciones.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/131153/04-2019');
		
		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetValoracionesMock.getError())
			.addForAddress(WSAsociadoGetValoraciones.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/131153/04-2019');
	}
}