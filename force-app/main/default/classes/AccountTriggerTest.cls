@isTest
private class AccountTriggerTest {
	private static String AFILIADO_URL = ConfigUtils.getEndpointsByTipo('afiliado').get('afiliado').Endpoint__c;
	private static String DATOS_SF_URL = ConfigUtils.getEndpointsByTipo('afiliado').get('datos-sf').Endpoint__c;
	private static String FACTURA_ELECTRONICA_URL = AFILIADO_URL + '/477443/factura-electronica';
	private static Account testAccount = Build.anAccountCuentaPersonal().withPersonEmail('testemail1@test.com').withAfiId('123456').build();
	private static Account testAccount2 = Build.anAccountCuentaPersonal().withPersonEmail(null).withAfiId('1234567').build();
	private static XHttpCalloutMock facturaElectronicaMock = new XHttpCalloutMock();
	private static XHttpCalloutMock getDatosSFResponse = new XHttpCalloutMock('afiliado', 'datos-sf');
	private static MockProvider mockProvider = new MockProvider();
    private static SSResponseEventTriggerHandler ssResponseHandlerMock =
		(SSResponseEventTriggerHandler) TestUtils.createClassMock(SSResponseEventTriggerHandler.class, mockProvider);
	static {
		ConfigUtils.eventHandler = ssResponseHandlerMock;
		insert new List<Account>{testAccount, testAccount2};
	}
	/**-----------------------------------------------------------------------
		Validaciones para generación de Fáctura Electrónica.
	------------------------------------------------------------------------*/
		@isTest
		private static void whenChangeEnvioDeRecibo_UpdateAdhesionFacturaElectronicaOnSS () {
			TestUtils.setMockResponse(facturaElectronicaMock, FACTURA_ELECTRONICA_URL, AfiliadoEndpointsMockResponses.getAsociacionFacturaElectronicaOK());
			Test.setMock(HttpCalloutMock.class, facturaElectronicaMock);
			Account acc = Build.anAccountCuentapersonal().build();
			acc.Afi_Id__c = '477443';
			insert acc;
			Test.startTest();
			acc.Envio_de_recibo__c = 'Factura online';
			update acc;
			Test.stopTest();
			System.assertEquals(2, facturaElectronicaMock.callsMade, 'Debieron ocurrir dos llamados al mock');
		}
		@isTest
		private static void whenChangeEnvioDeRecibo_TryUpdateAdhesionFacturaElectronicaOnSSAndObtainAnError () {
			TestUtils.setMockResponse(facturaElectronicaMock, FACTURA_ELECTRONICA_URL, AfiliadoEndpointsMockResponses.getAsociacionFacturaElectronicaError() , 400, 'Not found');
			Test.setMock(HttpCalloutMock.class, facturaElectronicaMock);
			Account acc = Build.anAccountCuentapersonal().build();
			acc.Afi_Id__c = '477443';
			insert acc;
			Test.startTest();
			acc.Envio_de_recibo__c = 'Factura papel';
			update acc;
			Test.stopTest();
			System.assertEquals(2, facturaElectronicaMock.callsMade, 'Debieron ocurrir dos llamados al mock');
		}
	/**-----------------------------------------------------------------------
		Validaciones para envío de datos a Validar en SS.
	------------------------------------------------------------------------*/
		@isTest
		private static void ssValidation_IfEmailIsValidated_DoNothingAndFireSSResponseEvent () {
			String expectedMessage = 'Se ejecutó el proceso.';
			TestUtils.setMockResponse(getDatosSFResponse, DATOS_SF_URL, AfiliadoEndpointsMockResponses.getDatosSFResponseOk());
			Test.setMock(HttpCalloutMock.class, getDatosSFResponse);
			testAccount.PersonEmail = 'testemail2@test.com';
			Test.startTest();
			update testAccount;
			Test.stopTest();
			validateEventFired(testAccount.Id, expectedMessage, false);
			testAccount = [SELECT PersonEmail FROM Account WHERE Id =: testAccount.Id];
			System.assertEquals('testemail2@test.com', testAccount.PersonEmail, 'El correo no debe haber cambiado');
		}
		@isTest
		private static void ssValidation_IfEmailIsNotValidated_RevertAccountUpdateAndFireSSResponseEvent () {
			String expectedMessage = 'No se pudieron replicar los datos.';
			TestUtils.setMockResponse(getDatosSFResponse, DATOS_SF_URL, AfiliadoEndpointsMockResponses.getDatosSFResponseError(), 400, 'Not found');
			Test.setMock(HttpCalloutMock.class, getDatosSFResponse);
			testAccount.PersonEmail = 'testemail2@test.com';
			Test.startTest();
			update testAccount;
			Test.stopTest();
			validateEventFired(testAccount.Id, expectedMessage, true);
			testAccount = [SELECT PersonEmail FROM Account WHERE Id =: testAccount.Id];
			System.assertEquals('testemail1@test.com', testAccount.PersonEmail, 'El correo debe haber cambiado');
		}
		@isTest
		private static void ssValidation_IfPreviewEmailIsEmptyANDIfEmailIsNotValidated_RevertAccountUpdateAndFireSSResponseEvent () {
			String expectedMessage = 'No se pudieron replicar los datos.';
			TestUtils.setMockResponse(getDatosSFResponse, DATOS_SF_URL, AfiliadoEndpointsMockResponses.getDatosSFResponseError(), 400, 'Not found');
			Test.setMock(HttpCalloutMock.class, getDatosSFResponse);
			testAccount2.PersonEmail = 'testemail2@test.com';
			Test.startTest();
			update testAccount2;
			Test.stopTest();
			validateEventFired(testAccount2.Id, expectedMessage, true);
			testAccount2 = [SELECT PersonEmail FROM Account WHERE Id =: testAccount2.Id];
			System.assert(String.isBlank(testAccount2.PersonEmail), 'El correo debe haber cambiado');
			System.assertEquals(null, testAccount2.PersonEmail, 'El correo debe ser nulo');
		}
	/** Utils */
	private static void validateEventFired (String recordId, String message, Boolean isErrorEvent) {
		System.assertEquals(1, mockProvider.timesEventWasFired, 'El evento se debío disparar una vez');
		System.assert(mockProvider.lastEventFiredRegistry != null, 'Debe existir un registro del evento disparado');
		System.assert(!mockProvider.lastEventFiredRegistry.event.isCreationEvent__c, 'El valor debe ser false');
		System.assertEquals(isErrorEvent, mockProvider.lastEventFiredRegistry.event.isErrorEvent__c, 'El valor no coincide');
		System.assertEquals(message, mockProvider.lastEventFiredRegistry.event.message__c, 'El mensaje no coincide');
		System.assertEquals(recordId, mockProvider.lastEventFiredRegistry.event.recordId__c, 'El Id no coincide');
	}
}