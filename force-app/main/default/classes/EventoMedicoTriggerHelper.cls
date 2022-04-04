public without sharing class EventoMedicoTriggerHelper {
	public static String rTSeguimientoID = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_seguimiento').Id;
	public static String rtInternacionID = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;
	public static void validateFormaDeEgreso(Map<Id, Evento_medico__c> newMap, Map<Id, Evento_medico__c> oldMap) {
		List<Evento_medico__c> eventos = [SELECT Id, Fecha_y_hora_fin_ems__c, RecordTypeId, Forma_de_egreso__c,
											(SELECT Id, Fecha__c FROM Casos__r WHERE Status != 'CA-----N'),
											(SELECT Id, Estado__c FROM Segmentos__r WHERE Fecha_Inicio_real__c = null OR Fecha_Fin_real__c = null)
										FROM Evento_medico__c
										WHERE Id IN :newMap.keySet()];
        for (Evento_medico__c em : eventos) {
			Evento_medico__c oldEm = oldMap.get(em.Id);
            if(newMap.get(em.Id).Forma_de_egreso__c != oldEm.Forma_de_egreso__c) {
				if(newMap.get(em.Id).Forma_de_egreso__c != null && !em.Segmentos__r.isEmpty()) {
					newMap.get(em.Id).Forma_de_egreso__c.addError(System.Label.Alerta_Trigger_EM_FaltanSegmentos);
				}
				if (em.RecordTypeId == rTSeguimientoID) {
					for (Case caso : em.Casos__r) {
						if (em.Fecha_y_hora_fin_ems__c.date() < caso.Fecha__c) {
							newMap.get(em.Id).Forma_de_egreso__c.addError(System.Label.Alerta_Trigger_EM_FechaCierreMenorAFechaCaso);
						}
					}
				}
            }
        }
	}
	public static void assignDelegacionFromUser(Map<Id, List<Evento_medico__c>> userIdEMsMap) {
		List<Evento_medico__c> emToUpdateList = new List<Evento_medico__c>();
        Map<String, List<Evento_medico__c>> codDelegacionEMsMap = new Map<String, List<Evento_medico__c>>();
        for (User usuario : [SELECT Codigo_delegacion__c
							FROM User
							WHERE Id IN :userIdEMsMap.keySet()]) {
            if (usuario.Codigo_delegacion__c != null) {
                List<Evento_medico__c> emsFromUserMap = userIdEMsMap.get(usuario.Id);
                if (codDelegacionEMsMap.containsKey(usuario.Codigo_delegacion__c)) {
                    List<Evento_medico__c> emsFromDelegacionMap = codDelegacionEMsMap.get(usuario.Codigo_delegacion__c);
                    emsFromDelegacionMap.addAll(emsFromUserMap);
                    codDelegacionEMsMap.put(usuario.Codigo_delegacion__c, emsFromDelegacionMap);
                } else {
                    codDelegacionEMsMap.put(usuario.Codigo_delegacion__c, emsFromUserMap);
                }
            }
        }
        for(Account delegacion : [SELECT Id, Codigo_de_delegacion__c
									FROM Account
									WHERE Codigo_de_delegacion__c IN :codDelegacionEMsMap.keySet()]) {
            for (Evento_medico__c em : codDelegacionEMsMap.get(delegacion.Codigo_de_delegacion__c)) {
                em.Delegacion__c = delegacion.Id;
                emToUpdateList.add(em);
            }
        }
        if (!emToUpdateList.isEmpty()) {
			update emToUpdateList;
        }
    }
	@future(callout = true)
	public static void sendToSS(Id[] emIds) {
		Id rtSeguimiento = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		Id rtInternacion = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
		Evento_medico__c[] eventos = EventoMedicoEnviarASSBtnCtrl.getEventosMedicos(emIds);
		User usuario = [SELECT CommunityNickname, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		if(String.isNotBlank(usuario.CommunityNickname)) {
			String nick = usuario.CommunityNickname.toUpperCase();
			for(Evento_medico__c em : eventos) {
				EventoMedicoEnviarASSParser parser = new EventoMedicoEnviarASSParser(em, nick);
				String body = parser.parseCargarEventoMedicoSS();
				if (em.RecordTypeId == rTSeguimientoID) {
					WSEventoMedicoEnviarASSHelper.enviarEventoMedico(body, 'eventos-medicos', 'seguimiento');
				} else if (em.RecordTypeId == rTInternacionID) {
					WSEventoMedicoEnviarASSHelper.enviarEventoMedico(body, 'eventos-medicos', 'eventos-medicos');
				}
			}
		}
	}
	public static void validateDeletion(Map<Id, Evento_medico__c> oldMap) {
		User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		Boolean isAdmin = currentUser.Profile.Name == 'Administrador del sistema' || currentUser.Profile.Name == 'System Administrator';
		for (Evento_medico__c em : oldMap.values()) {
			if(!isAdmin) {
				em.addError(System.Label.Alerta_Trigger_EM_CantDeleteEM);
			}
		}
	}
}