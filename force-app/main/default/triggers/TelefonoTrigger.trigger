trigger TelefonoTrigger on Telefono__c (before update, before insert, before delete, after undelete) {
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            for(Telefono__c tel :  Trigger.new){
                Telefono__c oldTel = Trigger.oldMap.get(tel.Id);
                if(tel.Telefono__c != oldTel.Telefono__c){
                    if(!TelefonoHelper.isValidPhone(tel.Telefono__c)){
                        tel.addError('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx');
                    }
                }
            }
            WSDatosAfiliados.updateTelefonosDetailsToWS(Trigger.new, Trigger.oldMap);
        } else if(Trigger.isInsert) {
            for(Telefono__c tel :  Trigger.new){
                if(!String.isBlank(tel.Telefono__c)){
                    if(!TelefonoHelper.isValidPhone(tel.Telefono__c)){
                        tel.addError('Debe ingresar solo números, sin guiones y sin prefijo 0 ni 15. Ej:341xxxxxxx');
                    }
                }
            }
            WSDatosAfiliados.updateTelefonosDetailsToWS(Trigger.new, Trigger.oldMap);
        } else if(Trigger.isDelete) {
            WSDatosAfiliados.deleteTelefonosDetailsToWS(Trigger.old);
        }

    } else if(Trigger.isAfter) {
        if(Trigger.isUndelete) {
            WSDatosAfiliados.updateTelefonosDetailsToWS(Trigger.new, Trigger.oldMap);
        }
    }
}