/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase de pruebas para la clase encolable AsyncValidateChangesInAcountInSS
@date			07/06/2022
------------------------------------------------------------------------------------------------------------------------*/
@isTest
public without sharing class AsyncValidateChangesInAcountInSSTest {
	private static String DATOS_SF_URL = ConfigUtils.getEndpointsByTipo('afiliado').get('datos-sf').Endpoint__c;
	private static Account testAccount = Build.anAccountCuentaPersonal().withPersonEmail('testemail2@test.com').withAfiId('123456').build();
	private static Account testPreviewAccount;
	private static XHttpCalloutMock getDatosSFResponse = new XHttpCalloutMock('afiliado', 'datos-sf');
	private static MockProvider mockProvider = new MockProvider();
    private static SSResponseEventTriggerHandler ssResponseHandlerMock =
		(SSResponseEventTriggerHandler) TestUtils.createClassMock(SSResponseEventTriggerHandler.class, mockProvider);
	static {
		ConfigUtils.eventHandler = ssResponseHandlerMock;
		insert testAccount;
		testPreviewAccount = testAccount;
		testPreviewAccount.PersonEmail = 'testemail1@test.com';
	}
	@isTest
	private static void ifCallOutHaveErrorMessage_JustFireEvent () {
		String expectedMessage = 'Se ejecutó el proceso.';
		TestUtils.setMockResponse(getDatosSFResponse, DATOS_SF_URL, AfiliadoEndpointsMockResponses.getDatosSFResponseOk());
		Test.setMock(HttpCalloutMock.class, getDatosSFResponse);
		Test.startTest();
        System.enqueueJob(new AsyncValidateChangesInAcountInSS(testAccount, testPreviewAccount));
        Test.stopTest();
		validateEventFired(testPreviewAccount.Id, expectedMessage, false);
		testAccount = [SELECT PersonEmail FROM Account WHERE Id =: testAccount.Id];
		System.assertEquals('testemail2@test.com', testAccount.PersonEmail, 'El correo no debe haber cambiado');
	}
	@isTest
	private static void ifCallOutHaveNotErrorMessage_RevertAccountVersionAndFireEvent () {
		String expectedMessage = 'No se pudieron replicar los datos.';
		TestUtils.setMockResponse(getDatosSFResponse, DATOS_SF_URL, AfiliadoEndpointsMockResponses.getDatosSFResponseError(), 400, 'Not found');
		Test.setMock(HttpCalloutMock.class, getDatosSFResponse);
		Test.startTest();
        System.enqueueJob(new AsyncValidateChangesInAcountInSS(testAccount, testPreviewAccount));
        Test.stopTest();
		validateEventFired(testPreviewAccount.Id, expectedMessage, true);
		testAccount = [SELECT PersonEmail FROM Account WHERE Id =: testAccount.Id];
		System.assertEquals('testemail1@test.com', testAccount.PersonEmail, 'El correo debe haber cambiado');
	}
	/** Utils */
	private static void validateEventFired (String recordId, String message, Boolean isErrorEvent) {
		System.assertEquals(1, mockProvider.timesEventWasFired, 'El evento se debío disparar una vez');
		System.assert(mockProvider.lastEventFiredRegistry != null, 'Debe existir un registro del evento disparado');
		System.assert(!mockProvider.lastEventFiredRegistry.event.isDelete__c, 'El valor debe ser false');
		System.assertEquals(isErrorEvent, mockProvider.lastEventFiredRegistry.event.error__c, 'El valor no coincide');
		System.assertEquals(message, mockProvider.lastEventFiredRegistry.event.Response_Error__c, 'El mensaje no coincide');
		System.assertEquals(recordId, mockProvider.lastEventFiredRegistry.event.Id_Registro__c, 'El Id no coincide');
	}
}