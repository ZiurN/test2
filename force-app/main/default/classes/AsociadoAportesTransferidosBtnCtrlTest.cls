@IsTest
public class AsociadoAportesTransferidosBtnCtrlTest  {
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoAportesTransferidosSucess_returnAListOfAportesTransferidos(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		AsociadoAportesTransferidosBtnCtrl.Response responseToAssert = AsociadoAportesTransferidosBtnCtrl.getAsociadoAportesTransferidos('70107-14');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('2002-12-01', responseToAssert.asociadoAportesTransferidos[0].periodo);
		System.assertEquals('33533717999', responseToAssert.asociadoAportesTransferidos[0].cuit);
		System.assertEquals('600055', responseToAssert.asociadoAportesTransferidos[0].empleador);
		System.assertEquals('COOP. AGROP. DE ARMSTRONG LTDA.', responseToAssert.asociadoAportesTransferidos[0].nombre_empleador);
		System.assertEquals('640008', responseToAssert.asociadoAportesTransferidos[0].cod_ooss);
		System.assertEquals('O.S.P.ACA', responseToAssert.asociadoAportesTransferidos[0].nombre_ooss);
		System.assertEquals('MAN', responseToAssert.asociadoAportesTransferidos[0].origen_aporte);
		System.assertEquals('504.33', responseToAssert.asociadoAportesTransferidos[0].aporte);
		System.assertEquals('0', responseToAssert.asociadoAportesTransferidos[0].aporte_reconocido);
		System.assertEquals('0', responseToAssert.asociadoAportesTransferidos[0].aporte_derivado);
		System.assertEquals('0', responseToAssert.asociadoAportesTransferidos[0].subsidio);
		System.assertEquals('0', responseToAssert.asociadoAportesTransferidos[0].secuencia);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoAportesTransferidosError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		AsociadoAportesTransferidosBtnCtrl.Response responseToAssert = AsociadoAportesTransferidosBtnCtrl.getAsociadoAportesTransferidos('70107-14');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los aportes transferidos desde SaludSoft,asegúrese que el código de afiliado esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoAportesTransferidos);
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
			.withBody(WSAsociadoGetAportesTransferidosMock.getFound())
			.addForAddress(WSAsociadoGetAportesTransferidos.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-transferidos/70107-14');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetAportesTransferidosMock.getError())
			.addForAddress(WSAsociadoGetAportesTransferidos.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-transferidos/');
	}
}