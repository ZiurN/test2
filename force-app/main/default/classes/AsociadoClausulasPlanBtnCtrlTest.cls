@IsTest
public class AsociadoClausulasPlanBtnCtrlTest  {
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
			.withBody(WSAsociadoGetClausulasPlanMock.getFound())
			.addForAddress(WSAsociadoGetClausulasPlan.SERVICE_CONFIG.URL__c + '/v1/salud/clausulas/plan/140983/7');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetClausulasPlanMock.getError())
			.addForAddress(WSAsociadoGetClausulasPlan.SERVICE_CONFIG.URL__c + '/v1/salud/clausulas/plan/0/0');
	}
	
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoClausulasPlanSucess_returnAListOfClausulasPlan(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		AsociadoClausulasPlanBtnCtrl.Response responseToAssert = AsociadoClausulasPlanBtnCtrl.getAsociadoClausulasPlan('140983', '7');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('BAS', responseToAssert.asociadoClausulasPlan[0].codigo);
		System.assertEquals('CUOTA BASICA', responseToAssert.asociadoClausulasPlan[0].nombre);
		System.assertEquals('Base', responseToAssert.asociadoClausulasPlan[0].caracteristica);
		System.assertEquals('V', responseToAssert.asociadoClausulasPlan[0].contratada);
		System.assertEquals('F', responseToAssert.asociadoClausulasPlan[0].informa);
		System.assertEquals('V', responseToAssert.asociadoClausulasPlan[0].bonificable);
		System.assertEquals('Permanente', responseToAssert.asociadoClausulasPlan[0].permanente);
		System.assertEquals('1900-01-01', responseToAssert.asociadoClausulasPlan[0].fecha_vigencia_desde);
		System.assertEquals(null, responseToAssert.asociadoClausulasPlan[0].fecha_vigencia_hasta);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoClausulasPlanError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		AsociadoClausulasPlanBtnCtrl.Response responseToAssert = AsociadoClausulasPlanBtnCtrl.getAsociadoClausulasPlan('140983', '7');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener las clausulas de plan desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoClausulasPlan);
	}

}