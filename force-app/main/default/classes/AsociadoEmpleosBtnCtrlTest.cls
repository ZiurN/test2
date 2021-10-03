@IsTest
public class AsociadoEmpleosBtnCtrlTest  {
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
			.withBody(WSAsociadoGetEmpleosMock.getFound())
			.addForAddress(WSAsociadoGetEmpleos.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/empleos/458495');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetEmpleosMock.getError())
			.addForAddress(WSAsociadoGetEmpleos.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/empleos/0');
	}
	
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoEmpleosSucess_returnAListOfEmpleos(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		AsociadoEmpleosBtnCtrl.Response responseToAssert = AsociadoEmpleosBtnCtrl.getAsociadoEmpleos('458495');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('2016-08-01', responseToAssert.asociadoEmpleos[0].fecha_inicio);
		System.assertEquals(null, responseToAssert.asociadoEmpleos[0].fecha_fin);
		System.assertEquals('600011', responseToAssert.asociadoEmpleos[0].codigo);
		System.assertEquals('ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA', responseToAssert.asociadoEmpleos[0].descripcion);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoEmpleosError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		AsociadoEmpleosBtnCtrl.Response responseToAssert = AsociadoEmpleosBtnCtrl.getAsociadoEmpleos('458495');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los empleos desde SaludSoft, asegúrese que el Id de afiliado esté completo', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoEmpleos);
	}

}