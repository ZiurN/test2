@IsTest
public class AsociadoImportFacturasBtnCtrlTest  {
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
			.withBody(WSAsociadoGetFacturasMock.getFound())
			.addForAddress(WSAsociadoGetFacturas.SERVICE_CONFIG.URL__c + '/v1/salud/facturas/446378');

		getEmptyListResponse = new XHttpCalloutMock();
		getEmptyListResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getEmptyListResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetFacturasMock.getEmpty())
			.addForAddress(WSAsociadoGetFacturas.SERVICE_CONFIG.URL__c + '/v1/salud/facturas/5');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetFacturasMock.getError())
			.addForAddress(WSAsociadoGetFacturas.SERVICE_CONFIG.URL__c + '/v1/salud/facturas/0');
	}
	
	@IsTest 
	public static void whenTheResponseOfTheWSIsAnEmptyList_ShowTheCorrespondingMessage() {
		Test.setMock(HttpCalloutMock.class, getEmptyListResponse);
		Account acc = new Account(Name = 'Test Facturas');
		insert acc;

		Test.startTest();
		AsociadoImportFacturasBtnCtrl.Response responseToAssert = AsociadoImportFacturasBtnCtrl.getAsociadoFacturasAndImportIntoSF('5', acc.Id);
		Test.stopTest();
		
		System.assertEquals('No se encontraron facturas para este afiliado en SaludSoft', responseToAssert.message);
	}

	@IsTest 
	public static void theCuentasCorrientesAreUpsertedCorrectlyInSF(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		
		Test.startTest();
		AsociadoImportFacturasBtnCtrl.Response responseToAssert = AsociadoImportFacturasBtnCtrl.getAsociadoFacturasAndImportIntoSF('446378', acc.Id);
		Test.stopTest();

		List<Factura__c> facturasList = [ 
			SELECT Cuenta_personal__c, Letra__c, Importe__c, Fecha_de_Emision__c, Fecha_de_Vencimiento__c, Name
			FROM Factura__c 
			WHERE Cuenta_personal__c = :acc.Id AND Name = '811748' 
		];
		
		System.assert(!responseToAssert.hasError);
		System.assertEquals('811748', facturasList[0].Name);
		System.assertEquals(date.newInstance(2019, 06, 21), facturasList[0].Fecha_de_Emision__c);
		System.assertEquals(date.newInstance(2019, 07, 10), facturasList[0].Fecha_de_Vencimiento__c);
		System.assertEquals(10207.72, facturasList[0].Importe__c);
		System.assertEquals('B', facturasList[0].Letra__c);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoFacturasError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		
		Test.startTest();
		AsociadoImportFacturasBtnCtrl.Response responseToAssert = AsociadoImportFacturasBtnCtrl.getAsociadoFacturasAndImportIntoSF('0', acc.Id);
		Test.stopTest();

		System.assert(responseToAssert.hasError);
		System.assertEquals('Hubo un error al intentar obtener las facturas desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', responseToAssert.message);
		//System.assertEquals(null, responseToAssert.asociadoFacturas);
	}

}