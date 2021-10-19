global class ClausulaTempReintentoEnvioASSBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Fallo_en_SS__c, Fecha_de_fallo__c, CreatedById, Fecha_desde__c, Fecha_de_vigencia_hasta__c, ' +
				 'Codigo_Asociado__c, codigo_ACT_SS__c, Fecha_de_cierre_de_clausula__c ' +
            'FROM Asignacion_de_clausula_temporaria__c WHERE Fecha_de_fallo__c != null'
        );
    }
    global void execute(Database.BatchableContext bc, List<Asignacion_de_clausula_temporaria__c> records){
        List<Asignacion_de_clausula_temporaria__c> clausulas = new List<Asignacion_de_clausula_temporaria__c>();
        for (Asignacion_de_clausula_temporaria__c clausula : records) {
            clausulas.add(ClausulasTempTriggerHelper.updateClausula(clausula));
        }
        if(!clausulas.isEmpty()){
            update clausulas;
        }
        
    }    
    global void finish(Database.BatchableContext bc){
    }    
}