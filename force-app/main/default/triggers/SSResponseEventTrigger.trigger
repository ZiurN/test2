trigger SSResponseEventTrigger on SS_Response_Event__e (after insert) {
	for (SS_Response_Event__e event : Trigger.new) {
		System.debug('Event error: ' + event.error__c);
		System.debug('Event message: ' + event.Response_Error__c);
		System.debug('Event Registro Id: ' + event.Id_Registro__c);
	}
}