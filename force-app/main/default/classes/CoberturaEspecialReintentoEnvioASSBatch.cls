global class CoberturaEspecialReintentoEnvioASSBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
	
	global CoberturaEspecialReintentoEnvioASSBatch() {
		
	}
	
	/**
	 * @description gets invoked when the batch job starts
	 * @param context contains the job ID
	 * @returns the record set as a QueryLocator object that will be batched for execution
	 */ 
	global Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator(
			'SELECT Id, Error_en_SS__c, Fecha_de_error_en_SS__c, CreatedById, CreatedBy.CommunityNickname ' +
			'FROM Cobertura_Especial__c ' + 
			'WHERE Fecha_de_error_en_SS__c != null'
		);
	}

	/**
	 * @description gets invoked when the batch job executes and operates on one batch of records. Contains or calls the main execution logic for the batch job.
	 * @param context contains the job ID
	 * @param scope contains the batch of records to process.
	 */ 
   	global void execute(Database.BatchableContext context, List<Cobertura_Especial__c> scope) {
		CoberturaEspecialTriggerHelper.reintentoEnvio(scope);	
	}
	
	/**
	 * @description gets invoked when the batch job finishes. Place any clean up code in this method.
	 * @param context contains the job ID
	 */ 
	global void finish(Database.BatchableContext context) {
		
	}
}