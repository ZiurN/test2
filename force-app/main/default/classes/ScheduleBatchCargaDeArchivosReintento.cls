global class ScheduleBatchCargaDeArchivosReintento implements Schedulable {

	global void execute(SchedulableContext sc) {
		Database.executeBatch(new ArchivosReintentoCargaBatch(),25);
	}
}