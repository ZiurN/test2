global class ReintegroReintentoReasignacionBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
	
	global ReintegroReintentoReasignacionBatch() {
		
	}
	

	global Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator('SELECT Id, Lote__c, Error_reasignacion__c, Fecha_error_reasignacion__c, Usuario_error_reasignar__c, Nro_AP__c, Codigo_reintegro_SS__c FROM Case WHERE Error_reasignacion__c != null');
	}


   	global void execute(Database.BatchableContext context, List<Case> scope) {
		//List<Id> lotesId = new List<Id>();
		//for(Case caso : scope){
			//lotesId.add(caso.Lote__c);
		//}

		//Map<Id,Lote__c> lotesMap = new Map<Id,Lote__c>([SELECT Id_lote_SS__c FROM Lote__c WHERE Id IN :lotesId]);
		
		for(Case caso : scope){
			CaseTriggerHelper.reasignarLote(caso,caso.Usuario_error_reasignar__c);
		}

		if(!scope.isEmpty()){
			update scope;
		}
	}

	global void finish(Database.BatchableContext context) {
		
	}
}