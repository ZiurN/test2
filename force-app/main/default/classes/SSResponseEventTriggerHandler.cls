/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase auxiliar para manejar el trigger de eventos SS_Response_Event__e
@date			07/06/2022
------------------------------------------------------------------------------------------------------------------------*/
public without sharing class SSResponseEventTriggerHandler {
    public void handleFiredEvent (SS_Response_Event__e event) {
		System.debug('Event error: ' + event.error__c);
		System.debug('Event message: ' + event.Response_Error__c);
		System.debug('Event Registro Id: ' + event.Id_Registro__c);
	}
}