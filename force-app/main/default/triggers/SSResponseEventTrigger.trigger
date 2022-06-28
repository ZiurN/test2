trigger SSResponseEventTrigger on SSResponseEvent__e (after insert) {
	for (SSResponseEvent__e event : Trigger.new) {
		try {
			ConfigUtils.handleSSResponseEventFired(event);
		} catch (Exception e) {
			System.debug(e.getMessage());
		}
	}
}