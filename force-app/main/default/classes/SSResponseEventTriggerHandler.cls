/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase auxiliar para manejar el trigger de eventos SSResponseEvent__e
@date			07/06/2022
------------------------------------------------------------------------------------------------------------------------*/
public without sharing class SSResponseEventTriggerHandler {
    public void handleFiredEvent (SSResponseEvent__e event) {
		System.debug('Event error: ' + event.isErrorEvent__c);
		System.debug('Event message: ' + event.message__c);
		System.debug('Event isCreation: ' + event.isCreationEvent__c);
		System.debug('Event Registro Id: ' + event.recordId__c);
	}
}