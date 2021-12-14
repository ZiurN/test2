public class EventoMedicoTriggerHelper {

	public static void validateFormaDeEgreso(Map<Id, Evento_medico__c> newMap, Map<Id, Evento_medico__c> oldMap) {
		Id rtSeguimiento = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_seguimiento').Id;
		Id rtInternacion = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;

		List<Evento_medico__c> eventos = [
            SELECT Id, Fecha_y_hora_fin_ems__c, RecordTypeId, Forma_de_egreso__c, 
				(SELECT Id, Fecha__c FROM Casos__r WHERE Status != 'CA-----N'),
				(SELECT Id, Estado__c FROM Segmentos__r WHERE Fecha_Inicio_real__c = null OR Fecha_Fin_real__c = null)
            FROM Evento_medico__c
            WHERE Id IN :newMap.keySet()
        ];

        for(Evento_medico__c em : eventos) {
			Evento_medico__c oldEm = oldMap.get(em.Id);

            if(newMap.get(em.Id).Forma_de_egreso__c != oldEm.Forma_de_egreso__c) {
				
				if(newMap.get(em.Id).Forma_de_egreso__c != null && !em.Segmentos__r.isEmpty()) {
					newMap.get(em.Id).Forma_de_egreso__c.addError(
						'Debe cerrar todos los segmentos antes de completar este campo'
					);
				}

				if(em.RecordTypeId == rtSeguimiento) {
					for(Case caso : em.Casos__r) {
						if(em.Fecha_y_hora_fin_ems__c.date() <= caso.Fecha__c) {
							newMap.get(em.Id).Forma_de_egreso__c.addError(
								'Fecha de cierre del evento menor o igual a la fecha del caso'
							);
						}
					}
				}
					    
            }
        }
	}

	public static void assignDelegacionFromUser(Map<Id, List<Evento_medico__c>> userIdEMsMap) {
		List<Evento_medico__c> emToUpdateList = new List<Evento_medico__c>();
        Map<String, List<Evento_medico__c>> codDelegacionEMsMap = new Map<String, List<Evento_medico__c>>();
        for (User usuario : [
                SELECT Codigo_delegacion__c
                FROM User
                WHERE Id IN :userIdEMsMap.keySet()
        ]) {
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

		System.debug('****codDelegacionEMsMap ' + codDelegacionEMsMap);
        for(Account delegacion : [
                SELECT Id, Codigo_de_delegacion__c
                FROM Account
                WHERE Codigo_de_delegacion__c IN :codDelegacionEMsMap.keySet()
        ]) {
            for (Evento_medico__c em : codDelegacionEMsMap.get(delegacion.Codigo_de_delegacion__c)) {
                em.Delegacion__c = delegacion.Id;
                emToUpdateList.add(em);
            }
        }

        if (!emToUpdateList.isEmpty()) {
			System.debug('****emToUpdateList ' + emToUpdateList);
			update emToUpdateList;
        }
    }

	@future(callout = true)
	public static void sendToSS(Id[] emIds) {
		Id rtSeguimiento = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		Id rtInternacion = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
		Evento_medico__c[] eventos = EventoMedicoEnviarASSBtnCtrl.getEventosMedicos(emIds);
		//[
			//SELECT Id, Asociado__r.Codigo_de_Afiliado__c, Asociado__c, Fecha_y_Hora_inicio_EMS__c, Tipo__c, Diagnostico__c,
                    //Fecha_de_Vencimiento_Certificado__c, Diferido__c, Motivo__c, Diagnostico__r.Codigo_del_Diagnostico__c,
                    //Sin_complicaciones__c, Consultorio__c, Consultorio__r.Secuencia__c, Consultorio__r.Codigo_externo__c,
                    //Descripcion__c, Delegacion__r.Codigo_de_delegacion__c, Observaciones__c, Mail__c, Domicilio_Entrega__c,
                    //Via_Entrega__c, Ap_Anestesia__c, AP_presupuesto__c, Importe_presupuesto__c, RecordTypeId, Delegacion__c,
                    //Efector_Solicitante__r.Codigo_de_efector__c, Responsable__r.Codigo_de_efector__c, Recupero__c,
                    //Domicilio__c, AP_material__c, Prestador__r.Codigo_de_efector__c, Subtipo__c, Codigo_Nomenclador__r.Codigo__c,
					//Prestador__c, Efector_Solicitante__c, Nro_de_Evento_Medico_SS__c, Forma_de_egreso__c, OwnerId, 
					//Otro_domicilio__c, EMS__r.Nro_de_Evento_Medico_SS__c, RecordType.DeveloperName, Resultado__c
            //FROM Evento_medico__c
			//WHERE Id IN :emIds
		//];
		User usuario = [SELECT CommunityNickname, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];

		if(String.isNotBlank(usuario.CommunityNickname)) {
			String nick = usuario.CommunityNickname.toUpperCase();
			String body; 

			for(Evento_medico__c em : eventos) {
				if(em.RecordTypeId == rtSeguimiento) {
					body = EventoMedicoEnviarASSBtnCtrl.generateJSONEMS(em, nick);
					WSEventoMedicoEnviarASS.enviarEventoMedico(body);
				}
				else if(em.RecordTypeId == rtInternacion) {
					body = EventoMedicoEnviarASSBtnCtrl.generateJSONEMI(em, nick);
					WSEventoMedicoEnviarASS.enviarEventoMedicoInternacion(body);
				}
			}
			
		}
	}

	public static void validateDeletion(Map<Id, Evento_medico__c> oldMap) {
		User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		Boolean isAdmin = currentUser.Profile.Name == 'Administrador del sistema' || currentUser.Profile.Name == 'System Administrator';
		for (Evento_medico__c em : oldMap.values()) {
			if(!isAdmin) {
				em.addError('No tiene permitido eliminar Eventos Medicos');
			}
		}
	}

}