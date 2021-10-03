public without sharing class AlertaRechazarBtnCtrl {
	static final String[] ADMIN_PROFILES = new List<String>{'Administrador del sistema', 'Administrador de Servicio'};
	

	@AuraEnabled
    public static Response autoasignarMedico(String alertaId) {	
		Boolean isAssigned = Utils.autoasignarMedico(alertaId);

		return new Response(false, 'ok');
	}

    @AuraEnabled
    public static Response rechazarAlerta(String alertaId) {
        if(alertaId == null) {
            return new Response(true, 'El id externo está vacío');
        }

        List<Alerta__c> alertas = [
                SELECT Estado__c, Resolucion_de_alerta_auditor__c, Fecha_resolucion_de_Alerta__c, Prestacion__c,
                        Nivel_de_auditoria__c, Evento_Medico__c, Prestacion__r.Ap__r.Status, Funcion__c, Motivo_de_rechazo__c,
						Prestacion_de_reintegro__c
                FROM Alerta__c
                WHERE idalerta__c =: alertaId
        ];
		System.debug('****alertas: ' + alertas);
        List<Prestacion__c> prestaciones = [
                SELECT Id, Prestacion_CA__c, Ap__c, (
                        SELECT idalerta__c, Estado__c, Nivel_de_auditoria__c FROM Alertas__r
                )
                FROM Prestacion__c
                WHERE Id =: alertas[0].Prestacion__c
        ];
		System.debug('****prestaciones: ' + prestaciones);
		List<Prestacion_de_reintegro__c> prestacionesReintegros = [
			SELECT Id, Id_Externo__c, Caso__c, (
					SELECT idalerta__c, Estado__c, Nivel_de_auditoria__c FROM Alertas__r
			)
			FROM Prestacion_de_reintegro__c
			WHERE Id =: alertas[0].Prestacion_de_reintegro__c
		];
		System.debug('****prestacionesReintegros: ' + prestacionesReintegros);
		List<Case> casos = new List<Case>();
		if(!prestaciones.isEmpty()) {
			casos = [
				SELECT Nivel_de_derivacion__c, viene_de_front__c, Delegacion__r.Codigo_de_delegacion__c, Status,
					Medico_asignado__c, Usuario__c, Responsable_de_presupuesto__c, (
						SELECT Id FROM Notas_de_Auditorias__r
					)
				FROM Case
				WHERE Id =: prestaciones[0].Ap__c
			];
		}
		else if(!prestacionesReintegros.isEmpty()) {
			casos = [
				SELECT Nivel_de_derivacion__c, viene_de_front__c, Delegacion__r.Codigo_de_delegacion__c, Status,
					Medico_asignado__c, Usuario__c, Responsable_de_presupuesto__c, (
						SELECT Id FROM Notas_de_Auditorias__r
					)
				FROM Case
				WHERE Id =: prestacionesReintegros[0].Caso__c
			];
		}
		System.debug('****casos: ' + casos);
		User usuario = [
			SELECT Alias, CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c 
			FROM User 
			WHERE Id =: UserInfo.getUserId()
		];

		if(alertas[0].Motivo_de_rechazo__c == null) {
			return new Response(true, 'Debe completar el campo "Motivo de Rechazo"');
		}
		Response validacionNivelDeAuditoria = null;
		if(!prestaciones.isEmpty()) {
			validacionNivelDeAuditoria = validarNivelDeAuditoria(alertas[0], prestaciones[0].Alertas__r);
		}
		else if(!prestacionesReintegros.isEmpty()) {
			validacionNivelDeAuditoria = validarNivelDeAuditoria(alertas[0], prestacionesReintegros[0].Alertas__r);
		}

		if(validacionNivelDeAuditoria.hasError) {
			return validacionNivelDeAuditoria;
		}

		Boolean vieneDeFront = casos.isEmpty() ? false : casos[0].viene_de_front__c;
		Response validacionPerfil = validarPerfiles(usuario, alertas[0].Funcion__c, vieneDeFront, casos[0]);
		if(validacionPerfil.hasError) {
			return validacionPerfil;
		}

		String apodo = usuario.CommunityNickname.toUpperCase();
		String body = '{"username": "' + apodo + '","motivo": "' + alertas[0].Motivo_de_rechazo__c + '"}';
        
		System.debug('alertas ' + alertas[0]);
		if(alertas[0].Prestacion_de_Reintegro__c != null){
			body = '{"accion":"rechazar","usuario": "' + apodo + '","motivo": "' + alertas[0].Motivo_de_rechazo__c + '"}';
			System.debug('Aqui entro el rechazo');
				WSAlertaReintegroAutorizar.Response wsResponse = WSAlertaReintegroAutorizar.autorizarAlertaReintegro(alertaId, body);

				if(!wsResponse.hasError) {
					updatePrestacionesAndAlertsReintegro(wsResponse.result.data.reintegro, casos.get(0), prestacionesReintegros);
					return new Response(false, '');
				}
				else {
					return new Response(true, wsResponse.message);	
				}		
		}else{
			WSAlertaRechazar.Response wsResponse = WSAlertaRechazar.rechazarAlerta(alertaId,body);

			if(!wsResponse.hasError) {
				if (wsResponse.result.data.em == null) {
					if(!prestaciones.isEmpty()) {
						updateCasePrestAndAlerts(wsResponse.result.data.ap, casos, prestaciones);
					}
				}
				else {
					updateEM(wsResponse, alertas);
					if(!prestaciones.isEmpty()) {
						updateCasePrestAndAlerts(wsResponse.result.data.em.ap, casos, prestaciones);
					}
				}   
				return new Response(false, '');
			} else {
				return new Response(true, wsResponse.message);
			}
		}
     
    }

	private static void updateEM(WSAlertaRechazar.Response wsResponse, List<Alerta__c> alertas) {
		List<Segmentos__c> segmentosToUpdate = new List<Segmentos__c>();

		Evento_medico__c em = [
                SELECT Estado__c,
                (
					SELECT Semid__c, Estado__c FROM Segmentos__r
                )
                FROM Evento_medico__c
                WHERE Id =: alertas[0].Evento_Medico__c
        ];

        em.Estado__c = wsResponse.result.data.em.estado;

        System.debug('****em.Estado__c: ' + em.Estado__c);
        if (em.Estado__c == 'RECHAZADO') {
            //em.Forma_de_Egreso__c = 'RECH';
			for (WSAlertaAutorizarResp.Segmento segWs : wsResponse.result.data.em.segmento) {
                for (Segmentos__c segmento : em.Segmentos__r) {
                    if (segWs.sem_id == segmento.Semid__c) {
                        segmento.Estado__c = segWs.estado;
                        segmentosToUpdate.add(segmento);
                    }
                }
            }
        }

		Database.SaveResult resultEm = Database.update(em);
        System.debug('****resultEm: ' + resultEm);
        List<Database.SaveResult> resultsSegmentos = Database.update(segmentosToUpdate);
        System.debug('****segmentosToUpdate: ' + segmentosToUpdate);
	}

	private static void updatePrestacionesAndAlertsReintegro(
																WSAlertaReintegoResp.Reintegro reintegroWs, 
																Case reintegro,
																List<Prestacion_de_reintegro__c> prestaciones
	) {

		
		List<Alerta__c> alertasToUpdateList = new List<Alerta__c>();

		String nivel = reintegroWs.nivel;
		reintegro.Cambio_Manual__c = false;
		reintegro.Nivel_de_derivacion__c = nivel == 'N1' ? 'Nivel 1' 
				: nivel == 'N2' ? 'Nivel 2' 
				: nivel == 'N3' ? 'Nivel 3' 
				: null;

		for (WSAlertaReintegoResp.Prestaciones presWs : reintegroWS.prestaciones) {
			System.debug('idExterno ' + presWS.pca_id);
			System.debug('idExterno ' + prestaciones[0].Id_Externo__c);
            if (presWs.pca_id  == prestaciones[0].Id_Externo__c) {
                prestaciones[0].Estado__c = presWs.estado_prestacion;
                for (Alerta__c alerta : prestaciones[0].Alertas__r) {
                    for (WSAlertaReintegoResp.Alertas alertWs : presWs.alertas) {
						System.debug('idExterno alert ' + alertWs.aca_id);
						System.debug('idExterno alert ' + alerta.idalerta__c);
						
                        if (alerta.idalerta__c == alertWs.aca_id) {
							system.debug('estado ' + alertWs.estado_alerta);
                            alerta.Estado__c = alertWs.estado_alerta;
                            alerta.Resolucion_de_alerta_auditor__c = alertWs.auditor_resuelve;
                            alerta.Fecha_resolucion_de_Alerta__c = alertWs.fecha_resolucion != null
                                    ? Date.valueOf(alertWs.fecha_resolucion) : null;
                            alertasToUpdateList.add(alerta);
                        }
                    }
                }
            }

        }

		Database.SaveResult resultReintegro = Database.update(reintegro);
        System.debug('****resultReintegro: ' + resultReintegro);
        Database.SaveResult resultPrestacion = Database.update(prestaciones[0]);
        System.debug('****resultPrestacion: ' + resultPrestacion);
        List<Database.SaveResult> resultsAlert = Database.update(alertasToUpdateList);
        System.debug('****resultsAlert: ' + resultsAlert);
	}

	private static void updateCasePrestAndAlerts(WSAlertaAutorizarResp.Ap casoWS, List<Case> casos, List<Prestacion__c> prestaciones) {

		List<Alerta__c> alertasToUpdateList = new List<Alerta__c>();
		String nivel = casoWS.nivel;
		casos[0].Nivel_de_derivacion__c = nivel == 'N1' ? 'Nivel 1' 
				: nivel == 'N2' ? 'Nivel 2' 
				: nivel == 'N3' ? 'Nivel 3' 
				: null;


        for (WSAlertaAutorizarResp.Prestaciones presWs : casoWS.prestaciones) {
            if (presWs.pca_id == prestaciones[0].Prestacion_CA__c) {
                prestaciones[0].Estado__c = presWs.estado_prestacion;
                for (Alerta__c alerta : prestaciones[0].Alertas__r) {
                    for (WSAlertaAutorizarResp.Alertas alertWs : presWs.alertas) {
                        if (alerta.idalerta__c == alertWs.aca_id) {
                            alerta.Estado__c = alertWs.estado_alerta;
                            alerta.Resolucion_de_alerta_auditor__c = alertWs.auditor_resuelve;
                            alerta.Fecha_resolucion_de_Alerta__c = alertWs.fecha_resolucion != null
                                    ? Date.valueOf(alertWs.fecha_resolucion) : null;
                            alertasToUpdateList.add(alerta);
                        }
                    }
                }
            }
        }

		Database.SaveResult resultCasos = Database.update(casos[0]);
        Database.SaveResult resultPrestacion = Database.update(prestaciones[0]);
        List<Database.SaveResult> resultsAlert = Database.update(alertasToUpdateList);

		System.debug('****resultCasos: ' + resultCasos);
        System.debug('****resultPrestacion: ' + resultPrestacion);
        System.debug('****resultsAlert: ' + resultsAlert);
	}
	
	private static void updateCasePrestAndAlerts(WSAlertaAutorizarResp.Ap casoWS, List<Case> casos, List<Prestacion_de_reintegro__c> prestaciones) {
		if(!Test.isRunningTest()){
			Organization currentOrg = [
				SELECT 
					Id, 
					Name, 
					IsSandbox 
				FROM Organization 
				LIMIT 1
			];
			Lote__c lote;
			if(currentOrg.isSandbox){
				lote = [
					SELECT Id
					FROM Lote__c
					WHERE Name = 'LOTE-0004'
				];
			}else{
				lote = [
					SELECT Id
					FROM Lote__c
					WHERE Name = 'LOTE-0001'
				];
			}
			casos[0].Lote__c = lote.Id;
		}

		List<Alerta__c> alertasToUpdateList = new List<Alerta__c>();
		String nivel = casoWS.nivel;
		casos[0].Nivel_de_derivacion__c = nivel == 'N1' ? 'Nivel 1' 
				: nivel == 'N2' ? 'Nivel 2' 
				: nivel == 'N3' ? 'Nivel 3' 
				: null;
		
        for (WSAlertaAutorizarResp.Prestaciones presWs : casoWS.prestaciones) {
            if (presWs.pca_id == prestaciones[0].Id_Externo__c) {
                prestaciones[0].Estado__c = presWs.estado_prestacion;
			
                for (Alerta__c alerta : prestaciones[0].Alertas__r) {
                    for (WSAlertaAutorizarResp.Alertas alertWs : presWs.alertas) {
                        if (alerta.idalerta__c == alertWs.aca_id) {
                            alerta.Estado__c = alertWs.estado_alerta;
                            alerta.Resolucion_de_alerta_auditor__c = alertWs.auditor_resuelve;
                            alerta.Fecha_resolucion_de_Alerta__c = alertWs.fecha_resolucion != null
                                    ? Date.valueOf(alertWs.fecha_resolucion) : null;
                            alertasToUpdateList.add(alerta);
                        }
                    }
                }
            }
        }

		Database.SaveResult resultCasos = Database.update(casos[0]);
        Database.SaveResult resultPrestacion = Database.update(prestaciones[0]);
        List<Database.SaveResult> resultsAlert = Database.update(alertasToUpdateList);

		System.debug('****resultCasos: ' + resultCasos);
        System.debug('****resultPrestacion: ' + resultPrestacion);
        System.debug('****resultsAlert: ' + resultsAlert);
	}
	private static Response validarPerfiles(User usuario, String alertFcn, Boolean vieneDeFront, Case caso) {
		String perfil = usuario.Profile.Name;
		Boolean admin = ADMIN_PROFILES.contains(usuario.Profile.Name);
		Boolean perfilBack = perfil == 'Back Administrativo' || admin 
								|| perfil == 'Mesa de ayuda' || perfil == 'Reintegros' || perfil == 'Discapacidad'
								|| perfil == 'Back CT' || perfil == 'Coordinador de Mesa de Ayuda'; //FCION_BACK
		Boolean perfilFront = perfil == 'Front' || admin || perfil == 'CDC'
								|| ((perfil == 'Mesa de ayuda' || perfil == 'Coordinador de Mesa de Ayuda') && vieneDeFront) 
								|| perfil == 'Reintegros'; //FCION_FRONT
		Boolean perfilAM = perfil == 'Auditor Medico' || perfil == 'Coordinador de Mesa de Ayuda'
							|| admin || perfil == 'Reintegros'; //AM
		Boolean perfilAMNoAdmin = perfil == 'Auditor Medico' || perfil == 'Coordinador de Mesa de Ayuda'; //AM
		Boolean perfilTecni = perfil == 'Compras Tecnicas' || admin 
								|| perfil == 'Back CT'; //CPRAS_TECNI
		Boolean perfilDisca = perfil == 'Discapacidad' || admin; //FCION_DISCA
		Boolean perfilDiscaInter = perfil == 'Discapacidad Interdisciplinario' || admin; //FCION_ID
		Boolean perfilPresupuesto = perfil == 'Presupuesto' || admin; //FCION_PRESU
		
		if(!perfilFront && alertFcn == 'FCION_FRONT') {
			return new Response(true, 'No se permite rechazar alerta Front');
		} else if(!perfilBack && alertFcn == 'FCION_BACK') {
			return new Response(true, 'No se permite rechazar alerta Back');
		} else if(perfilBack && alertFcn == 'FCION_BACK' && !admin && String.isBlank(caso.Usuario__c)) {
			return new Response(true, 'Solo se pueden rechazar alertas Back si hay un responsable asignado al caso');
		} else if(!perfilAM && alertFcn == 'AM') {
			return new Response(true, 'No se permite rechazar alerta AM');
		} else if(perfilAMNoAdmin && alertFcn == 'AM' && caso.Medico_asignado__c != usuario.Id) {
			return new Response(true, 'Solo el medico asignado al caso puede rechazar alertas AM.');
		} else if(!perfilTecni && alertFcn == 'CPRAS_TECNI') {
			return new Response(true, 'No se permite rechazar alerta de Compras Tecnicas');
		} else if(perfilTecni && alertFcn == 'CPRAS_TECNI' && !admin && String.isBlank(caso.Responsable_de_presupuesto__c)) {
			return new Response(true, 'Solo se pueden rechazar alertas de Compras Tecnicas si hay un responsable asignado al caso');
		} else if(!perfilDisca && alertFcn == 'FCION_DISCA') {
			return new Response(true, 'No se permite rechazar alerta de Discapacidad');
		} else if(perfilDisca && alertFcn == 'FCION_DISCA' && !admin && String.isBlank(caso.Usuario__c)) {
			return new Response(true, 'Solo se pueden rechazar alertas de Discapacidad si hay un responsable asignado al caso');
		} else if(!perfilDiscaInter && alertFcn == 'FCION_ID') {
			return new Response(true, 'No se permite rechazar alerta ID');
		} else if(perfilDiscaInter && alertFcn == 'FCION_ID' && !admin && String.isBlank(caso.Usuario__c)) {
			return new Response(true, 'Solo se pueden rechazar alertas ID si hay un responsable asignado al caso');
		} else if(!perfilPresupuesto && alertFcn == 'FCION_PRESU') {
			return new Response(true, 'No se permite rechazar alerta de Presupuesto');
		} else if(perfilPresupuesto && alertFcn == 'FCION_PRESU' && !admin && String.isBlank(caso.Responsable_de_presupuesto__c)) {
			return new Response(true, 'Solo se pueden rechazar alertas de Presupuesto si hay un responsable asignado al caso');
		} else {
			Return validarColasYEquipo(usuario, caso);
		}

	}

	private static Response validarNivelDeAuditoria(Alerta__c alertaFromSf, List<Alerta__c> alertas) {
		Boolean hasLessNivelDeAuditoria = true;
		for(Alerta__c alerta : alertas) {
			if(alertaFromSf.Nivel_de_auditoria__c > alerta.Nivel_de_auditoria__c 
					&& (alerta.Estado__c == 'C1-----A' || alerta.Estado__c == 'C1-----G')
				) {
				hasLessNivelDeAuditoria = false;
			}
		}

		if(!hasLessNivelDeAuditoria) {
			return new Response(true, 'No se puede rechazar porque hay una alerta, con un nivel de auditoría menor, sin resolver aún');
		} else {
			return new Response(false, '');
		}
	}

	private static Response validarColasYEquipo(User usuario, Case caso) {
		Boolean isAdmin = ADMIN_PROFILES.contains(usuario.Profile.Name);
		
		if(caso.Status == 'CA-----N') {
			return new Response(true, 'No se puede rechazar porque el caso está anulado');
		}

		if(usuario.CommunityNickname == null) {
			return new Response(true, '- El apodo(CommunityNickname) del usuario está vacío.');
		}

		//if( !Utils.perteneceALaDelegacionCorrecta(caso, usuario) ) {	
			//return new Response(true, 'El usuario puede modificar casos de su delegación solamente');
		//}
		
		List<GroupMember> grupo = new List<GroupMember>();
		if(caso.Nivel_de_derivacion__c == 'Nivel 1') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Front' AND UserOrGroupId =: usuario.Id];
			
			if(grupo.isEmpty() && !isAdmin) {
				return new Response(true, '- El usuario no pertenece a Front');
			}
		} 
		else if(caso.Nivel_de_derivacion__c == 'Nivel 2') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Mesa_de_ayuda' AND UserOrGroupId =: usuario.Id];
			
			if(grupo.isEmpty() && !isAdmin) {
				return new Response(true, '- El usuario no pertenece a Mesa de Ayuda');
			}
		} 
		else if(caso.Nivel_de_derivacion__c == 'Nivel 3') {
			List<CaseTeamMember> equipo = [
				SELECT MemberId
				FROM CaseTeamMember
				WHERE ParentId =: caso.Id AND MemberId =: usuario.Id
			];
		
			if(equipo.isEmpty() && !isAdmin) {
				return new Response(true, '- El usuario no pertenece al equipo del caso');
			}
		}
		
		return new Response(false, 'ok');
	}

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message){
            this.hasError = hasError;
            this.message = message;
        }
    }
}