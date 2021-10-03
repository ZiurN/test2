global class BatchIdExternoSucursales implements Database.Batchable<SObject>, Database.Stateful {
	
	global Integer recordsProcessed = 0;

	global BatchIdExternoSucursales() {
		
	}
	
	/**
	 * @description gets invoked when the batch job starts
	 * @param context contains the job ID
	 * @returns the record set as a QueryLocator object that will be batched for execution
	 */ 
	global Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator(
			'SELECT Id, Id_externo__c, Codigo__c, Empresa__r.Codigo_de_empresa__c ' + 
			'FROM Sucursal__c WHERE Id_externo__c = null'
		);
	}

	/**
	 * @description gets invoked when the batch job executes and operates on one batch of records. Contains or calls the main execution logic for the batch job.
	 * @param context contains the job ID
	 * @param scope contains the batch of records to process.
	 */ 
   	global void execute(Database.BatchableContext context, List<Sucursal__c> scope) {
		List<Sucursal__c> sucursalesToUpdate = new List<Sucursal__c>();
		for(Sucursal__c suc : scope) {
			if(String.isNotBlank(suc.Empresa__r.Codigo_de_empresa__c) && String.isNotBlank(suc.Codigo__c)) {
				suc.Id_externo__c = suc.Empresa__r.Codigo_de_empresa__c + '-' + suc.Codigo__c;
				
				sucursalesToUpdate.add(suc);
			}
			recordsProcessed = recordsProcessed + 1;
		}

		List<Database.SaveResult> results = Database.update(sucursalesToUpdate, false);
		System.debug('****resultsSucursales: ' + results);
	}
	
	/**
	 * @description gets invoked when the batch job finishes. Place any clean up code in this method.
	 * @param context contains the job ID
	 */ 
	global void finish(Database.BatchableContext context) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :context.getJobId()
		];
		System.debug(recordsProcessed + ' records processed');
		System.debug(job);
	}
}

//BatchIdExternoSucursales myBatchObject = new BatchIdExternoSucursales(); 
//Id batchId = Database.executeBatch(myBatchObject);