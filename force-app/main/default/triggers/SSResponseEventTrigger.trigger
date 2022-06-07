trigger SSResponseEventTrigger on SS_Response_Event__e (after insert) {
	for (SS_Response_Event__e event : Trigger.new) {
		ConfigUtils.HandleSSResponseEventFired(event);
	}
}