@isTest
private class AccountTriggerTest {
	private static String AFILIADO_URL = ConfigUtils.getEndpointsByTipo('afiliado').get('afiliado').Endpoint__c;
	private static String FACTURA_ELECTRONICA_URL = AFILIADO_URL + '/477443/factura-electronica';
	@isTest
	private static void whenChangeEnvioDeRecibo_UpdateAdhesionFacturaElectronicaOnSS () {
		XHttpCalloutMock mock = new XHttpCalloutMock();
		TestUtils.setMockResponse(mock, FACTURA_ELECTRONICA_URL, AfiliadoEndpointsMockResponses.getAsociacionFacturaElectronicaOK());
		Test.setMock(HttpCalloutMock.class, mock);
		Account acc = Build.anAccountCuentapersonal().build();
		acc.Afi_Id__c = '477443';
		insert acc;
		Test.startTest();
		acc.Envio_de_recibo__c = 'Factura online';
		update acc;
		Test.stopTest();
		System.assertEquals(2, mock.callsMade, 'Debieron ocurrir dos llamados al mock');
	}
	@isTest
	private static void whenChangeEnvioDeRecibo_TryUpdateAdhesionFacturaElectronicaOnSSAndObtainAnError () {
		XHttpCalloutMock mock = new XHttpCalloutMock();
		TestUtils.setMockResponse(mock, FACTURA_ELECTRONICA_URL, AfiliadoEndpointsMockResponses.getAsociacionFacturaElectronicaError() , 400, 'Not found');
		Test.setMock(HttpCalloutMock.class, mock);
		Account acc = Build.anAccountCuentapersonal().build();
		acc.Afi_Id__c = '477443';
		insert acc;
		Test.startTest();
		acc.Envio_de_recibo__c = 'Factura papel';
		update acc;
		Test.stopTest();
		System.assertEquals(2, mock.callsMade, 'Debieron ocurrir dos llamados al mock');
	}
}