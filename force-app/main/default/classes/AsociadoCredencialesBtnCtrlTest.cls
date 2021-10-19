@IsTest
public class AsociadoCredencialesBtnCtrlTest  {
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
			.withBody(WSAsociadoGetCredencialesMock.getFound())
			.addForAddress(WSAsociadoGetCredenciales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/140983');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetCredencialesMock.getError())
			.addForAddress(WSAsociadoGetCredenciales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/0');
	}
	
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoCredencialesSucess_returnAListOfCredenciales(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		AsociadoCredencialesBtnCtrl.Response responseToAssert = AsociadoCredencialesBtnCtrl.getAsociadoCredenciales('140983');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('69799/19', responseToAssert.asociadoCredenciales[0].codigo);
		System.assertEquals('14', responseToAssert.asociadoCredenciales[0].secuencia);
		System.assertEquals('2017-07-01', responseToAssert.asociadoCredenciales[0].fecha_vigencia);
		System.assertEquals('2844-12-01', responseToAssert.asociadoCredenciales[0].fecha_vencimiento);
		System.assertEquals(null, responseToAssert.asociadoCredenciales[0].fecha_baja);
		System.assertEquals('2017-06-05', responseToAssert.asociadoCredenciales[0].fecha_emision);
		System.assertEquals('2017-06-05', responseToAssert.asociadoCredenciales[0].fecha_generacion);
		System.assertEquals(null, responseToAssert.asociadoCredenciales[0].fecha_anulacion);
		System.assertEquals('2017-06-05', responseToAssert.asociadoCredenciales[0].fecha_entregada);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoCredencialesError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		AsociadoCredencialesBtnCtrl.Response responseToAssert = AsociadoCredencialesBtnCtrl.getAsociadoCredenciales('0');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener las credenciales desde SaludSoft, asegúrese que el Id de afiliado esté completo', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoCredenciales);
	}

}