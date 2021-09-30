global class ScheduleBatchEmailAltaFamiliar implements Schedulable {
	/**
	 * @description Executes the scheduled Apex job. 
	 * @param sc contains the job ID
	 */ 
	global void execute(SchedulableContext sc) {
		Database.executeBatch(new BatchEmailAltaFamiliar(),5);
	}
}