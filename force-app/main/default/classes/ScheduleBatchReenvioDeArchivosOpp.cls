global class ScheduleBatchReenvioDeArchivosOpp implements Schedulable {
	/**
	 * @description Executes the scheduled Apex job. 
	 * @param sc contains the job ID
	 */ 
	global void execute(SchedulableContext sc) {
		Database.executeBatch(new OpportunityResendAttachmentsBatch());
	}
}