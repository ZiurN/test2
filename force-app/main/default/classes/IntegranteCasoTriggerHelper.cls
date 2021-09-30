public class IntegranteCasoTriggerHelper {
    public static void integrantesConCambioDeEstado(Set<Id> cambioTransformada,Set<Id> cambioCompleta, Set<Id> cambioIncompleta){
        System.debug(cambioTransformada);
        
        if(!cambioTransformada.isEmpty()){
            List<Case> casos = [
                SELECT Id, Status,Estado_de_solicitud__c,Motivo_de_cierre_solicitudes__c, (SELECT Id, Estado_solicitud__c FROM Integrantes__r)
                FROM Case
                WHERE Id IN :cambioTransformada
            ];
            for(Case caso : casos){
                Boolean todosIntegrantesTransformados = true;
                for(Integrante_caso__c integrante : caso.Integrantes__r){
                    todosIntegrantesTransformados = todosIntegrantesTransformados && integrante.Estado_solicitud__c == 'TRANSFORMADA';
                }
                if(todosIntegrantesTransformados){
                	caso.Estado_de_solicitud__c = 'TRANSFORMADA';
                    caso.Motivo_de_cierre_solicitudes__c = 'Baja procesada';
                    caso.Status = 'Cerrado';
                }
            }
            update casos;
        }
        
        if(!cambioCompleta.isEmpty()){
            List<Case> casos = [
                SELECT Id,Estado_de_solicitud__c, (SELECT Id, Estado_solicitud__c FROM Integrantes__r)
                FROM Case
                WHERE Id IN :cambioCompleta
            ];
            for(Case caso : casos){
                Boolean contieneIntegranteIncompleto = false;
                for(Integrante_caso__c integrante : caso.Integrantes__r){
                    contieneIntegranteIncompleto = contieneIntegranteIncompleto || integrante.Estado_solicitud__c == 'Incompleta';
                }
                if(!contieneIntegranteIncompleto){
                	caso.Estado_de_solicitud__c = 'COMPLETA';
                }
            }
            update casos;
        }
        
        if(!cambioIncompleta.isEmpty()){
            List<Case> casos = [
                SELECT Id, Estado_de_solicitud__c
                FROM Case
                WHERE Id IN :cambioIncompleta
            ];
            for(Case caso : casos){
                caso.Estado_de_solicitud__c = 'INCOMPLETA';
            }
            update casos;
        }
    }

    public static void eliminarIntegrantesQueNoTienenCasosEnviadosASS(List<Integrante_caso__c> integrantes) {
        Map<Integrante_caso__c, ID> casesByIntegrantes = new Map<Integrante_caso__c, ID>();
        for(Integrante_caso__c integrante : integrantes){
            casesByIntegrantes.put(integrante, integrante.Caso__c);
        }

        Map<ID, Case> casesById = new Map<ID, Case>(
            [
                SELECT Id, Nro_de_solicitud_SS__c
                FROM Case
                WHERE ID IN :casesByIntegrantes.values()
            ]
        );
        
        for(Integrante_caso__c integrante : casesByIntegrantes.keySet()){
            if(String.isNotBlank(casesById.get(casesByIntegrantes.get(integrante)).Nro_de_solicitud_SS__c)) {
                integrante.addError('No se puede eliminar porque el caso ya fue enviado a Salud Soft');
            }
        }
    }
}