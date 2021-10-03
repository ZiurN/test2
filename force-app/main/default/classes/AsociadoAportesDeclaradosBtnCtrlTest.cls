@IsTest
public class AsociadoAportesDeclaradosBtnCtrlTest  {
	
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoAportesDeclaradosSucess_returnAListOfAportesDeclarados(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		AsociadoAportesDeclaradosBtnCtrl.Response responseToAssert = AsociadoAportesDeclaradosBtnCtrl.getAsociadoAportesDeclarados('69799-19');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('2018-12-01', responseToAssert.asociadoAportesDeclarados[0].periodo);
		System.assertEquals('30604958640', responseToAssert.asociadoAportesDeclarados[0].cuit);
		System.assertEquals('600011', responseToAssert.asociadoAportesDeclarados[0].empleador);
		System.assertEquals('ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA', responseToAssert.asociadoAportesDeclarados[0].nombre);//
		System.assertEquals('101604', responseToAssert.asociadoAportesDeclarados[0].obra_social);
		System.assertEquals('640008', responseToAssert.asociadoAportesDeclarados[0].codigo_obra_social);
		System.assertEquals('O.S.P.ACA', responseToAssert.asociadoAportesDeclarados[0].nombre_obra_social);
		System.assertEquals('EST', responseToAssert.asociadoAportesDeclarados[0].origen_aporte);
		System.assertEquals('0', responseToAssert.asociadoAportesDeclarados[0].remuneracion);
		System.assertEquals('3850.52', responseToAssert.asociadoAportesDeclarados[0].aporte);
		System.assertEquals(null, responseToAssert.asociadoAportesDeclarados[0].aporte_reconocido);
		System.assertEquals('3657.99', responseToAssert.asociadoAportesDeclarados[0].aporte_derivado);
		System.assertEquals('0', responseToAssert.asociadoAportesDeclarados[0].secuencia);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoAportesDeclaradosError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		AsociadoAportesDeclaradosBtnCtrl.Response responseToAssert = AsociadoAportesDeclaradosBtnCtrl.getAsociadoAportesDeclarados('69799-19');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los aportes declarados desde SaludSoft', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoAportesDeclarados);
	}

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
			.withBody(WSAsociadoGetAportesDeclaradosMock.getFound())
			.addForAddress(WSAsociadoGetAportesDeclarados.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-declarados/69799-19');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetAportesDeclaradosMock.getError())
			.addForAddress(WSAsociadoGetAportesDeclarados.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-declarados/697');
	}
}