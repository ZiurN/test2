
trigger SSSegmentoResponseTrigger on SS_Segmento_Response__e (after insert) {
	for (SS_Segmento_Response__e event : Trigger.new) {
		System.debug('Event error: ' + event.error__c);
		System.debug('Event message: ' + event.Response_Error__c);
		System.debug('Event Segmento Id: ' + event.Id_Segmento__c);
	}
}