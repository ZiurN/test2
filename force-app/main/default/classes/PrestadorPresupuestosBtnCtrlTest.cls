@IsTest
public class PrestadorPresupuestosBtnCtrlTest  {
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
			.withBody(WSPrestadorGetPresupuestosMock.getFound())
			.addForAddress(WSPrestadorGetPresupuestos.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presupuestos/700076');

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
			.addForAddress(WSAsociadoGetAportesTransferidos.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presupuestos/0');
	}
	
	@IsTest
	private static void whenTheBtnIsClickedInTheView_consumeWSAPrestadorPresupuestosSuccess_returnAListOfPresupuestos(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		PrestadorPresupuestosBtnCtrl.Response responseToAssert = PrestadorPresupuestosBtnCtrl.getPrestadorPresupuesto(700076);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals('', responseToAssert.message);
		System.assertEquals(3, responseToAssert.prestadorPresupuestos.size());
		System.assertEquals('2019-01-31', responseToAssert.prestadorPresupuestos[0].fecha);
		System.assertEquals('700076_p_20190131.pdf', responseToAssert.prestadorPresupuestos[0].nombre_arch);
		System.assertEquals('Presup. Discectomia y Artrodesis Instrumentada af 39573-10', responseToAssert.prestadorPresupuestos[0].descripcion);
		System.assertEquals('https://acaiasnew.acasalud.com.ar/dd_convenios/700076_p_20190131.pdf', responseToAssert.prestadorPresupuestos[0].p_link);
	}

	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAPrestadorPresupuestosError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		PrestadorPresupuestosBtnCtrl.Response responseToAssert = PrestadorPresupuestosBtnCtrl.getPrestadorPresupuesto(0);
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los presupuestos desde SaludSoft, asegúrese que el código de efector esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.prestadorPresupuestos);
	}
}