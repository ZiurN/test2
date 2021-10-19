global class LoteReintentoEnvioASSBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Fallo_en_SS__c, Fecha_de_fallo__c, CreatedBy.CommunityNickname,CreatedById FROM Lote__c ' + 
            'WHERE Fallo_en_SS__c != null'
        );
    }
    global void execute(Database.BatchableContext bc, List<Lote__c> records){
        LoteTriggerHelper.reintentoEnvio(records);
    }    
    global void finish(Database.BatchableContext bc){
    }    
}