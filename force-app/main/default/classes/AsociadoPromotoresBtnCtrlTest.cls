@IsTest
public class AsociadoPromotoresBtnCtrlTest  {
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
			.withBody(WSAsociadoGetPromotoresMock.getFound())
			.addForAddress(WSAsociadoGetPromotores.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/promotores/140978');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetPromotoresMock.getError())
			.addForAddress(WSAsociadoGetPromotores.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/promotores/0');
	}
	
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoPromotoresSucess_returnAListOfPromotores(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		AsociadoPromotoresBtnCtrl.Response responseToAssert = AsociadoPromotoresBtnCtrl.getAsociadoPromotores('140978');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('2002-09-01', responseToAssert.asociadoPromotores[0].fecha_inicio);
		System.assertEquals(null, responseToAssert.asociadoPromotores[0].fecha_fin);
		System.assertEquals('USUARIO', responseToAssert.asociadoPromotores[0].usuario);
		System.assertEquals('USUARIO', responseToAssert.asociadoPromotores[0].apellidos);
		System.assertEquals('USUARIO', responseToAssert.asociadoPromotores[0].nombres);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoPromotoresError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		AsociadoPromotoresBtnCtrl.Response responseToAssert = AsociadoPromotoresBtnCtrl.getAsociadoPromotores('191670');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los promotores desde SaludSoft, asegúrese que el Id de afiliado esté completo', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoPromotores);
	}

}