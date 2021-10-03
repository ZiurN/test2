trigger EventoMedicoTrigger on Evento_medico__c (before update, after insert, after update, before delete) {
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
			EventoMedicoTriggerHelper.validateFormaDeEgreso(Trigger.newMap, Trigger.oldMap);
        }

        if(Trigger.isDelete) {
            EventoMedicoTriggerHelper.validateDeletion(Trigger.oldMap);
        }
    }

	if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            Map<Id, List<Evento_medico__c>> userIdEMsMap = new Map<Id, List<Evento_medico__c>>();
            
			for (Evento_medico__c em : Trigger.new) {
                if (userIdEMsMap.containsKey(em.OwnerId)) {
                    List<Evento_medico__c> casesFromMap = userIdEMsMap.get(em.OwnerId);

                    casesFromMap.add(new Evento_medico__c(Id = em.Id));
                    userIdEMsMap.put(em.OwnerId, casesFromMap);
                } else {
                    userIdEMsMap.put(em.OwnerId, new List<Evento_medico__c>{new Evento_medico__c(Id = em.Id)});
                }
            }

            if (!userIdEMsMap.isEmpty()) {
                EventoMedicoTriggerHelper.assignDelegacionFromUser(userIdEMsMap);
            }
        }

		if(Trigger.isUpdate) { 
			Id[] emsToSendToSS = new List<Id>();

			for(Evento_medico__c em : Trigger.new) {
				Evento_medico__c oldEm = Trigger.oldMap.get(em.Id);

				if(String.isNotBlank(em.Nro_de_Evento_Medico_SS__c) 
                    && (
                        em.Forma_de_egreso__c != oldEm.Forma_de_egreso__c
                        || em.Resultado__c != oldEm.Resultado__c
                        || em.Diagnostico__c != oldEm.Diagnostico__c
                        || em.Suspendido__c != oldEM.Suspendido__c
                    )
				) {
					emsToSendToSS.add(em.Id);
				}
			}

            if(!emsToSendToSS.isEmpty()) {
				EventoMedicoTriggerHelper.sendToSS(emsToSendToSS);
			}
		}
    }
}