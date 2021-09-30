global class BatchEmailAltaFamiliar implements Database.Batchable<SObject> {
	@TestVisible static Integer emailLimits;
	global BatchEmailAltaFamiliar() {
		
	}
	
	/**
	 * @description gets invoked when the batch job starts
	 * @param context contains the job ID
	 * @returns the record set as a QueryLocator object that will be batched for execution
	 */ 
	global Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator(
			'SELECT Id, Informacion_completa__c, Informacion_al_asociado__c, Bebe_nacido_en_sistema__c, ' + 
				'CreatedDate, Correo_electronico_responsable__c, Correo_asociado__c' + 
			' FROM Case ' +
			' WHERE Bebe_nacido_en_sistema__c = true' +
			' AND Informacion_completa__c = false'
		);
	}

	/**
	 * @description gets invoked when the batch job executes and operates on one batch of records. Contains or calls the main execution logic for the batch job.
	 * @param context contains the job ID
	 * @param scope contains the batch of records to process.
	 */ 
   	global void execute(Database.BatchableContext context, List<Case> scope) {
		List<Case> notificar15Dias = new List<Case>();
		List<Case> notificar30Dias = new List<Case>();
		for(Case caso : scope){
			if(caso.Bebe_nacido_en_sistema__c && !caso.Informacion_completa__c){
				Integer diferenciaFechas = caso.CreatedDate.date().daysBetween(Date.today());
				
				if( caso.CreatedDate.date() != Date.today() && 
					Math.mod( diferenciaFechas, 15) == 0
				){
					notificar15Dias.add(caso);
					if( Math.mod( diferenciaFechas, 30) == 0){
						notificar30Dias.add(caso);
					}
				}
			}
		}
		if(!notificar15Dias.isEmpty()){
			for(Case casoNotificarResponsable : notificar15Dias){
				EmailUtils.sendMailWithTemplate(
					new List<String>{casoNotificarResponsable.Correo_electronico_responsable__c},
					casoNotificarResponsable.Id,
					'Alerta_cada_15_dias_nacimiento'
				);
				BatchEmailAltaFamiliar.emailLimits = Limits.getEmailInvocations();
			}
		}
		if(!notificar30Dias.isEmpty()){
			for(Case casoNotificarSocio : notificar30Dias){
				EmailUtils.sendMailWithTemplate(
					new List<String>{casoNotificarSocio.Correo_asociado__c},
					casoNotificarSocio.Id,
					'Alerta_cada_30_dias_nacimiento'
				);
			}
			BatchEmailAltaFamiliar.emailLimits = Limits.getEmailInvocations();
		}
	}
	
	/**
	 * @description gets invoked when the batch job finishes. Place any clean up code in this method.
	 * @param context contains the job ID
	 */ 
	global void finish(Database.BatchableContext context) {
		
	}
}