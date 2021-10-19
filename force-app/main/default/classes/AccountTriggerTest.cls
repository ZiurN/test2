@isTest 
private class AccountTriggerTest {

	@isTest
	private static void whenChangeEnvioDeRecibo_UpdateAdhesionFacturaElectronicaOnSS() {
		
		XHttpCalloutMock mock = new XHttpCalloutMock();
		mock.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		mock.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoFacturaElectronicaMock.getFound())
			.addForAddress(WSAsociadoFacturaElectronica.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/477443/factura-electronica');
		Test.setMock(HttpCalloutMock.class, mock);

		Account acc = Build.anAccountCuentapersonal().build();
		acc.Afi_Id__c = '477443';
		insert acc;

		Test.startTest();
		acc.Envio_de_recibo__c = 'Factura online';
		update acc;
		Test.stopTest();

		System.assertEquals(2, mock.callsMade);
		
	}

	@isTest
	private static void whenChangeEnvioDeRecibo_TryUpdateAdhesionFacturaElectronicaOnSSAndObtainAnError() {
		XHttpCalloutMock mock = new XHttpCalloutMock();
		mock.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		mock.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoFacturaElectronicaMock.getError())
			.addForAddress(WSAsociadoFacturaElectronica.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/477443/factura-electronica');
		Test.setMock(HttpCalloutMock.class, mock);

		Account acc = Build.anAccountCuentapersonal().build();
		acc.Afi_Id__c = '477443';
		insert acc;

		Test.startTest();
		acc.Envio_de_recibo__c = 'Factura papel';
		update acc;
		Test.stopTest();

		System.assertEquals(2, mock.callsMade);
	}

}