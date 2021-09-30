@IsTest
public class AsociadoCuentaCorrienteBtnCtrlTest {
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
			.withBody(WSAsociadoGetCuentaCorrienteMock.getFound())
			.addForAddress(WSAsociadoGetCuentaCorriente.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/473981');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetCuentaCorrienteMock.getError())
			.addForAddress(WSAsociadoGetCuentaCorriente.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/0');

		getEmptyListResponse = new XHttpCalloutMock();
		getEmptyListResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getEmptyListResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetCuentaCorrienteMock.getEmpty())
			.addForAddress(WSAsociadoGetCuentaCorriente.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/5');
	}
	
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoCuentaCorrienteSucess_returnAListOfCuentaCorriente(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		
		Test.startTest();
		AsociadoCuentaCorrienteBtnCtrl.Response responseToAssert = AsociadoCuentaCorrienteBtnCtrl.getAsociadoCuentaCorriente('473981');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('10/05/2019', responseToAssert.asociadoCuentaCorriente[0].comprobante);
		System.assertEquals('23162069', responseToAssert.asociadoCuentaCorriente[0].id);
		System.assertEquals('1', responseToAssert.asociadoCuentaCorriente[0].cuota);
		System.assertEquals('130.86', responseToAssert.asociadoCuentaCorriente[0].importe);
		System.assertEquals('B', responseToAssert.asociadoCuentaCorriente[0].letra);
		System.assertEquals('51', responseToAssert.asociadoCuentaCorriente[0].movimiento);
		System.assertEquals('01566119', responseToAssert.asociadoCuentaCorriente[0].numero);
		System.assertEquals('130.86', responseToAssert.asociadoCuentaCorriente[0].saldo);
		System.assertEquals('0022', responseToAssert.asociadoCuentaCorriente[0].sucursal);
		System.assertEquals('FA', responseToAssert.asociadoCuentaCorriente[0].tipo);
		System.assertEquals('10/06/2019', responseToAssert.asociadoCuentaCorriente[0].vencimiento);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoCuentaCorrienteError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;

		Test.startTest();
		AsociadoCuentaCorrienteBtnCtrl.Response responseToAssert = AsociadoCuentaCorrienteBtnCtrl.getAsociadoCuentaCorriente('0');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener las cuentas corrientes desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoCuentaCorriente);
	}

}