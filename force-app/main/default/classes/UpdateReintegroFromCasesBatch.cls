global without sharing class UpdateReintegroFromCasesBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id, Importe_Reintegro_auditor__c,Cantidad__c,Importe_Reintegro_sys__c, Caso__c,Caso__r.Reintegro_Total__c ' +
            'FROM Prestacion_de_reintegro__c ' +
            'WHERE Caso__R.Reintegro_Total__c = 0';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Prestacion_de_reintegro__c> scope){
        // process each batch of records
        if(!scope.isEmpty()){
            map<Id,Prestacion_de_reintegro__c> mapIdPrest = new Map<Id,Prestacion_de_reintegro__c>(scope);
            PrestacionReintegroTriggerHelper.updateReintegroTotalFieldInCasesAssociate(mapIdPrest);
        }
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    
}