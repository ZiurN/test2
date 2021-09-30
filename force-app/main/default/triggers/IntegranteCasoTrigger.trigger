trigger IntegranteCasoTrigger on Integrante_caso__c (after update, before delete) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            Set<Id> casosCambioDeEstadoTransformado = new Set<Id>();
            Set<Id> casosCambioDeEstadoCompleto = new Set<Id>();
			Set<Id> casosCambioDeEstadoIncompleto = new Set<Id>();
            
            for(Integrante_caso__c integrante : Trigger.new){
                
                if(integrante.Estado_solicitud__c != Trigger.oldMap.get(integrante.Id).Estado_solicitud__c){
                    switch on integrante.Estado_solicitud__c{
                        when 'Incompleta'{
                            casosCambioDeEstadoIncompleto.add(integrante.Caso__c);
                        }
                        when 'Completa'{
                            casosCambioDeEstadoCompleto.add(integrante.Caso__c);
                        }
                        when 'Transformada'{
                            casosCambioDeEstadoTransformado.add(integrante.Caso__c);
                        }
                    }
                }
            }
            IntegranteCasoTriggerHelper.integrantesConCambioDeEstado(casosCambioDeEstadoTransformado,casosCambioDeEstadoCompleto,casosCambioDeEstadoIncompleto);
        }
    } 
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            IntegranteCasoTriggerHelper.eliminarIntegrantesQueNoTienenCasosEnviadosASS(Trigger.old);
        }
    }
}