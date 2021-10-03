trigger DomicilioTrigger on Domicilio__c (before update, before insert, before delete, after undelete) {
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            WSDatosAfiliados.updateDomiciliosDetailsToWS(Trigger.new, Trigger.oldMap);
        } else if(Trigger.isInsert) {
            WSDatosAfiliados.updateDomiciliosDetailsToWS(Trigger.new, Trigger.oldMap);
        } else if(Trigger.isDelete) {
            WSDatosAfiliados.deleteDomiciliosDetailsToWS(Trigger.old);
        }
    } else if(Trigger.isAfter) {
        if(Trigger.isUndelete) {
            WSDatosAfiliados.updateDomiciliosDetailsToWS(Trigger.new, Trigger.oldMap);
        }
    }
}