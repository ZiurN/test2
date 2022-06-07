/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase de pruebas para la el trigger SSResponseEventTrigger
@date			07/06/2022
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.AvoidHardcodingId')
@isTest
public without sharing class SSResponseEventTriggerTest {
	private static MockProvider mockProvider = new MockProvider();
    private static SSResponseEventTriggerHandler ssResponseHandlerMock =
		(SSResponseEventTriggerHandler) TestUtils.createClassMock(SSResponseEventTriggerHandler.class, mockProvider);
	static {
		ConfigUtils.eventHandler = ssResponseHandlerMock;
	}
	@isTest
	private static void testAfterInsertTrigger () {
		String message = 'Test message';
		String recordId = '0051U0000043d1AQAQ';
		Test.startTest();
		ConfigUtils.fireSSResponseEvent(message, recordId, false, true);
		Test.stopTest();
		System.assertEquals(1, mockProvider.timesEventWasFired, 'El evento se debío disparar una vez');
		System.assert(mockProvider.lastEventFiredRegistry != null, 'Debe existir un registro del evento disparado');
		System.assert(mockProvider.lastEventFiredRegistry.event.error__c, 'El valor debe ser true');
		System.assert(!mockProvider.lastEventFiredRegistry.event.isDelete__c, 'El valor debe ser false');
		System.assertEquals(message, mockProvider.lastEventFiredRegistry.event.Response_Error__c, 'El mensaje no coincide');
		System.assertEquals(recordId, mockProvider.lastEventFiredRegistry.event.Id_Registro__c, 'El Id no coincide');
	}
}
