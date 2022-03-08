@SuppressWarnings('PMD.ApexCRUDViolation, PMD.ExcessiveParameterList')
public without sharing class AlertaAutorizarBtnCtrl {
	static final String[] ADMIN_PROFILES = new List<String>{'Administrador del sistema', 'Administrador de Servicio', 'System Administrator'};
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll
	@company		Xappia
	@description	Asigna el médico a la alerta.
	@param			alertaId - Id de la alerta.
	@return			Devuelve un objeto Response para el front.
	------------------------------------------------------------------------------------------------------------------------*/
	@AuraEnabled
	public static Response autoasignarMedico(String alertaId) {
		Boolean isAssigned = Utils.autoasignarMedico(alertaId);
		return new Response(false, 'Ok');
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll
	@company		Xappia
	@description	Método que realiza las validaciones y envía la alerta a SS.
	@param			alertaId - Id de la alerta.
	@return			Devuelve un objeto Response para el front.
	------------------------------------------------------------------------------------------------------------------------*/
	@AuraEnabled
	public static Response autorizarAlerta(String alertaId) {
		if(alertaId == null) {
			return new Response(true, System.Label.Alerta_NoAuth_NoId);
		}
		String caseRT;
		List<Case> casos = new List<Case>();
		List<Alerta__c> alertas = [SELECT Estado__c,
										Resolucion_de_alerta_auditor__c,
										Fecha_resolucion_de_Alerta__c,
										Prestacion__c,
										Nivel_de_auditoria__c,
										Evento_Medico__c,
										Prestacion__r.Ap__r.Status,
										Funcion__c,
										Prestacion_de_reintegro__c
								FROM Alerta__c
								WHERE idalerta__c =: alertaId];
		List<Prestacion__c> prestaciones = [SELECT Id,
												Prestacion_CA__c,
												Ap__c,
												(SELECT idalerta__c,
													Estado__c,
													Nivel_de_auditoria__c
												FROM Alertas__r)
											FROM Prestacion__c
											WHERE Id =: alertas[0].Prestacion__c];
		List<Prestacion_de_reintegro__c> prestacionesRein = [SELECT Id,
																Id_Externo__c,
																Caso__c,
																(SELECT
																	idalerta__c,
																	Estado__c,
																	Nivel_de_auditoria__c
																FROM Alertas__r)
															FROM Prestacion_de_reintegro__c
															WHERE Id =: alertas[0].Prestacion_de_reintegro__c];
		if (prestaciones.size() > 0) {
			caseRT = 'AP';
			casos = returnCases(prestaciones[0].Ap__c);
			Response validacionNivelDeAuditoria = validarNivelDeAuditoria(alertas[0], prestaciones[0].Alertas__r);
			if(validacionNivelDeAuditoria.hasError) {
				return validacionNivelDeAuditoria;
			}
		} else if (prestacionesRein.size() > 0) {
			caseRT = 'Reintegro';
			casos = returnCases(prestacionesRein[0].Caso__c);
			Response validacionNivelDeAuditoria = validarNivelDeAuditoria(alertas[0], prestacionesRein[0].Alertas__r);
			if(validacionNivelDeAuditoria.hasError) {
				return validacionNivelDeAuditoria;
			}
		}
		if (alertas[0].Prestacion__r.Ap__r.Status == 'CA-----N') {
			return new Response(true, 'No se puede autorizar porque el caso está anulado');
		}
		User usuario = [SELECT Alias,
							CommunityNickname,
							Profile.Name,
							UserRole.DeveloperName,
							Codigo_delegacion__c
						FROM User
						WHERE Id =: UserInfo.getUserId()];
		String apodo = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;
		Boolean vieneDeFront = casos.isEmpty() ? false : casos[0].viene_de_front__c;
		Response validacionPerfil = validarPerfiles(usuario, alertas[0].Funcion__c, vieneDeFront, casos[0]);
		if(validacionPerfil.hasError) {
			return validacionPerfil;
		}
		if(caseRT == 'AP') {
			return handleResponseAP(alertaId, apodo, casos, prestaciones, alertas);
		} else if(caseRT == 'Reintegro') {
			return handleResponseReintegro(alertaId, apodo, casos, prestacionesRein, alertas);
		}
		return new Response(true, 'Ha ocurrido un error');
	}
	/** Métodos de Validación */
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
			return new Response(true, System.Label.Alerta_NoAuth_AuditoriaMenor);
		} else {
			return new Response(false, 'Ok');
		}
	}
	private static Response validarPerfiles(User usuario, String alertFcn, Boolean vieneDeFront, Case caso) {
		String perfil = usuario.Profile.Name;
		Boolean admin = ADMIN_PROFILES.contains(usuario.Profile.Name);
		Boolean FCION_BACK = admin || perfil == 'Back Administrativo'
								|| perfil == 'Mesa de ayuda'
								|| perfil == 'Reintegros'
								|| perfil == 'Discapacidad'
								|| perfil == 'Back CT'
								|| perfil == 'Coordinador de Mesa de Ayuda';
		Boolean FCION_FRONT = admin || perfil == 'Front'
								|| perfil == 'CDC'
								|| ((perfil == 'Mesa de ayuda' || perfil == 'Coordinador de Mesa de Ayuda') && vieneDeFront)
								|| perfil == 'Reintegros';
		Boolean AM = admin || perfil == 'Auditor Medico'
						|| perfil == 'Coordinador de Mesa de Ayuda'
						||  perfil == 'Reintegros';
		Boolean AMNoAdmin = perfil == 'Auditor Medico' || perfil == 'Coordinador de Mesa de Ayuda';
		Boolean CPRAS_TECNI = admin || perfil == 'Compras Tecnicas'
								|| perfil == 'Back CT'
								|| perfil == 'Discapacidad';
		Boolean FCION_DISCA = admin || perfil == 'Discapacidad';
		Boolean FCION_ID = admin  || perfil == 'Discapacidad Interdisciplinario';
		Boolean FCION_PRESU = admin  || perfil == 'Presupuesto';
		Boolean perfilMesa = perfil == 'Mesa de ayuda' || perfil == 'Coordinador de Mesa de Ayuda' || admin;
		if(!FCION_FRONT && alertFcn == 'FCION_FRONT') return new Response(true, System.Label.Alerta_NoAuth_AlertFront);
		else if(!FCION_BACK && alertFcn == 'FCION_BACK') return new Response(true, System.Label.Alerta_NoAuth_AlertBack);
		else if(FCION_BACK && alertFcn == 'FCION_BACK' && !admin && String.isBlank(caso.Usuario__c)) {
			return new Response(true, System.Label.Alerta_AuthBackIfResponsableAsignado);
		}
		else if(!AM && alertFcn == 'AM') return new Response(true, System.Label.Alerta_NoAuth_AlertAM);
		else if(AMNoAdmin && alertFcn == 'AM' && caso.Medico_asignado__c != usuario.Id) {
			return new Response(true, System.Label.Alerta_NoAuth_JustAsingMedAM);
		}
		else if(!CPRAS_TECNI && alertFcn == 'CPRAS_TECNI') return new Response(true, System.Label.Alerta_NoAuth_CPRAS_TECNI);
		else if(CPRAS_TECNI && alertFcn == 'CPRAS_TECNI' && !admin && String.isBlank(caso.Responsable_de_presupuesto__c)) {
			return new Response(true, System.Label.Alerta_NoAuth_CPRAS_TECNI_Responsable);
		}
		else if(!FCION_DISCA && alertFcn == 'FCION_DISCA') return new Response(true, System.Label.Alerta_NoAuth_AlertDiscapacidad);
		else if(FCION_DISCA && alertFcn == 'FCION_DISCA' && !admin && String.isBlank(caso.Usuario__c)) return new Response(true, System.Label.Alerta_AuthDiscapacidadIfResponsableAsignado);
		else if(!FCION_ID && alertFcn == 'FCION_ID') return new Response(true, System.Label.Alerta_NoAuth_AlertID);
		else if(FCION_ID && alertFcn == 'FCION_ID' && !admin && String.isBlank(caso.Usuario__c)) return new Response(true, System.Label.Alerta_AuthIDIfResponsableAsignado);
		else if(!FCION_PRESU && alertFcn == 'FCION_PRESU') return new Response(true, System.Label.Alerta_NoAuth_AlertPresupuesto);
		else if(FCION_PRESU && alertFcn == 'FCION_PRESU' && !admin && String.isBlank(caso.Responsable_de_presupuesto__c)) {
			return new Response(true, System.Label.Alerta_NoAuth_FCION_PRESU_Responsable);
		} else {
			return validarColasYEquipo(usuario, caso);
		}
	}
	private static Response validarColasYEquipo(User usuario, Case caso) {
		Boolean isAdmin = ADMIN_PROFILES.contains(usuario.Profile.Name);
		if(usuario.CommunityNickname == null) {
			return new Response(true, System.Label.Alerta_NoAuth_ApodoCMVacio);
		}
		List<GroupMember> grupo = new List<GroupMember>();
		if(caso.Nivel_de_derivacion__c == 'Nivel 1') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Front' AND UserOrGroupId =: usuario.Id];
			if(grupo.isEmpty() && !isAdmin) {
				return new Response(true, System.Label.Alerta_NoAuth_UsuarioNoFront);
			}
		}
		else if(caso.Nivel_de_derivacion__c == 'Nivel 2') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Mesa_de_ayuda' AND UserOrGroupId =: usuario.Id];
			if(grupo.isEmpty() && !isAdmin) {
				return new Response(true, System.Label.Alerta_NoAuth_UsuarioNoMesaAyuda);
			}
		}
		else if(caso.Nivel_de_derivacion__c == 'Nivel 3') {
			List<CaseTeamMember> equipo = [SELECT MemberId FROM CaseTeamMember WHERE ParentId =: caso.Id AND MemberId =: usuario.Id];
			if(equipo.isEmpty() && !isAdmin) {
				return new Response(true, System.Label.Alerta_NoAuth_UsuarioNoEquipoCaso);
			}
		}
		return new Response(false, 'Ok');
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll
	@company		Xappia
	@description	Método que envía las alertas de reintegro a SS y maneja la respuesta.
	@param			alertaId - Id de la alerta.
	@param			apodo - Alias SF del usuario.
	@param			casos - Lista de casos.isEmpty()
	@param			prestacionesRein - Lista de la prestaciones de reintegro.
	@param			alertas - Lista de las alertas asociadas.
	@return			Devuelve un objeto Response para el front.
	------------------------------------------------------------------------------------------------------------------------*/
	private static Response handleResponseReintegro(String alertaId,
													String apodo,
													List<Case> casos,
													List<Prestacion_de_reintegro__c> prestacionesRein,
													List<Alerta__c> alertas) {
		String body = '{"accion":"autorizar","usuario": "' + apodo + '"}';
		WSAlertaReintegroAutorizar.Response wsResponse = WSAlertaReintegroAutorizar.autorizarAlertaReintegro(alertaId, body);
		if(!wsResponse.hasError) {
			updatePrestacionesAndAlertsReintegro(wsResponse.result.data.reintegro, prestacionesRein, casos[0]);
			return new Response(false, '');
		}
		return new Response(true, wsResponse.message);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll
	@company		Xappia
	@description	Método que envía las alertas AP a SS y maneja la respuesta.
	@param			alertaId - Id de la alerta.
	@param			apodo - Alias SF del usuario.
	@param			casos - Lista de casos.isEmpty()
	@param			prestacionesRein - Lista de la prestaciones.
	@param			alertas - Lista de las alertas asociadas.
	@return			Devuelve un objeto Response para el front.
	------------------------------------------------------------------------------------------------------------------------*/
	private static Response handleResponseAP(String alertaId,
												String apodo,
												List<Case> casos,
												List<Prestacion__c> prestaciones,
												List<Alerta__c> alertas) {
		WSAlertaAutorizar.Response wsResponse = WSAlertaAutorizar.autorizarAlerta(alertaId, '{"username": "' + apodo + '"}');
		if(!wsResponse.hasError) {
			if (wsResponse.result.data.em == null) {
				updateCasePrestAndAlerts(wsResponse.result.data.ap, casos, prestaciones);
			} else {
				updateEM(wsResponse, alertas);
				updateCasePrestAndAlerts(wsResponse.result.data.em.ap, casos, prestaciones);
			}
			return new Response(false, 'Ok');
		} else {
			return new Response(true, wsResponse.message);
		}
	}
	/** Métodos para actualizar los registros */
	private static void updateEM(WSAlertaAutorizar.Response wsResponse, List<Alerta__c> alertas) {
		List<Segmentos__c> segmentosToUpdate = new List<Segmentos__c>();
		List<Evento_medico__c> em = [SELECT Estado__c,
										(SELECT Semid__c,
											Estado__c
										FROM Segmentos__r)
									FROM Evento_medico__c
									WHERE Id =: alertas[0].Evento_Medico__c];
		if(!em.isEmpty()){
			em[0].Estado__c = wsResponse.result.data.em.estado;
			if (em[0].Estado__c == 'Autorizado') {
				for (WSAlertaAutorizarResp.Segmento segWs : wsResponse.result.data.em.segmento) {
					for (Segmentos__c segmento : em[0].Segmentos__r) {
						if (segWs.sem_id == segmento.Semid__c) {
							segmento.Estado__c = segWs.estado;
							segmentosToUpdate.add(segmento);
						}
					}
				}
			}
			Database.SaveResult resultEm = Database.update(em[0]);
			List<Database.SaveResult> resultsSegmentos = Database.update(segmentosToUpdate);
		}
	}
	private static void updateCasePrestAndAlerts(WSAlertaAutorizarResp.Ap casoWS, List<Case> casos, List<Prestacion__c> prestaciones) {
		List<Alerta__c> alertasToUpdateList = new List<Alerta__c>();
		String nivel = casoWS.nivel;
		casos[0].Cambio_Manual__c = false;
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
	}
	private static void updatePrestacionesAndAlertsReintegro(WSAlertaReintegoResp.Reintegro reintegroWs,
																List<Prestacion_de_reintegro__c> prestaciones,
																Case reintegro) {
		List<Alerta__c> alertasToUpdateList = new List<Alerta__c>();
		String nivel = reintegroWs.nivel;
		reintegro.Cambio_Manual__c = false;
		reintegro.Nivel_de_derivacion__c = nivel == 'N1' ? 'Nivel 1'
				: nivel == 'N2' ? 'Nivel 2'
				: nivel == 'N3' ? 'Nivel 3'
				: null;
		for (WSAlertaReintegoResp.Prestaciones presWs : reintegroWS.prestaciones) {
			if (presWs.pca_id  == prestaciones[0].Id_Externo__c) {
				prestaciones[0].Estado__c = presWs.estado_prestacion;
				for (Alerta__c alerta : prestaciones[0].Alertas__r) {
					for (WSAlertaReintegoResp.Alertas alertWs : presWs.alertas) {
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
		Database.SaveResult resultReintegro = Database.update(reintegro);
		Database.SaveResult resultPrestacion = Database.update(prestaciones[0]);
		List<Database.SaveResult> resultsAlert = Database.update(alertasToUpdateList);
	}
	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		public Response(Boolean hasError, String message){
			this.hasError = hasError;
			this.message = message;
		}
	}
	/** Utils */
	private static List<Case> returnCases (String caseId) {
		return [SELECT Nivel_de_derivacion__c,
						viene_de_front__c,
						Delegacion__r.Codigo_de_delegacion__c,
						Medico_asignado__c,
						Usuario__c,
						Responsable_de_presupuesto__c
					FROM Case
					WHERE Id =: caseId];
	}
}