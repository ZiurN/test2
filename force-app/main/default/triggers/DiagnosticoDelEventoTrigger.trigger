trigger DiagnosticoDelEventoTrigger on Diagnostico_del_Evento__c (after insert) {
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            List<Diagnostico_del_Evento__c> diagnosticosToSendToSS = new List<Diagnostico_del_Evento__c>();
            for(Diagnostico_del_Evento__c diagnostico : Trigger.new) {
                diagnosticosToSendToSS.add(diagnostico);
            }
            System.enqueueJob(new DiagnosticoDelEventoQueueable(diagnosticosToSendToSS));
        }
    }
}