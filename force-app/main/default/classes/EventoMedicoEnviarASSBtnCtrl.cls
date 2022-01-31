public without sharing class EventoMedicoEnviarASSBtnCtrl {
	private static String rTSeguimientoID = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
	private static String rTInternacionID = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
	@AuraEnabled
	public static Boolean hasAttachments(Id idEm) {
		List<ContentDocumentLink> dbLinks = [SELECT
												LinkedEntityId,
												ContentDocumentId,
												ContentDocument.LatestPublishedVersionId
											FROM ContentDocumentLink
											WHERE LinkedEntityId =: idEm];
		return !dbLinks.isEmpty();
	}
	@AuraEnabled
	public static Response sendEventoMedicoToSS(Id idEm) {
		Evento_medico__c em = new Evento_medico__c();
		Evento_medico__c emFromSF = getEventosMedicos(new List<Id>{idEm})[0];
		User usuario = [SELECT CommunityNickname, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		Response validationOwner = validateOwner(emFromSF, usuario);
		if(!hasAttachments(idEm)) {
			return new Response(false, System.Label.Alerta_NoEnviarSInAdjuntos);
		}
		if(validationOwner.message != 'OK') {
			return validationOwner;
		}
		Boolean hasError = true;
		WSEventoMedicoEnviarASSHelper.Response wsResp;
		String nick = usuario.CommunityNickname.toUpperCase();
		EventoMedicoEnviarASSParser parser = new EventoMedicoEnviarASSParser(emFromSF, nick);
		String body = parser.parseCargarEventoMedicoSS();
		if (emFromSF.RecordTypeId == rTSeguimientoID) {
			wsResp = WSEventoMedicoEnviarASSHelper.enviarEventoMedico(body, 'eventos-medicos', 'seguimiento');
		} else if (emFromSF.RecordTypeId == rTInternacionID) {
			wsResp = WSEventoMedicoEnviarASSHelper.enviarEventoMedico(body, 'eventos-medicos', 'eventos-medicos');
		}
		if(wsResp.hasError) {
			return new Response(true, wsResp.message);
		} else {
			hasError = false;
		}
		if(!hasError) {
			List<String> idContentVersionList = new List<String>();
			List<ContentDocumentLink> linksList = [SELECT
													LinkedEntityId,
													ContentDocumentId,
													ContentDocument.LatestPublishedVersionId,
													ContentDocument.Title, ShareType,
													ContentDocument.FileType,
													ContentDocument.FileExtension
												FROM ContentDocumentLink
												WHERE LinkedEntityId =: emFromSF.Id];
			for(ContentDocumentLink cdl : linksList) {
				idContentVersionList.add(cdl.ContentDocument.LatestPublishedVersionId);
			}
			List<ContentVersion> cvList = [SELECT Id FROM ContentVersion WHERE Id IN :idContentVersionList AND Enviado__c = false];
			List<Id> docIds = new List<Id>();
			for(ContentVersion cv : cvList){
				docIds.add(cv.Id);
			}
			updateEMAndCreateSegmentCasePrestAndAlerts(emFromSF, wsResp);
			System.enqueueJob(new ArchivosCargaQueueable(wsResp.result.data.em.em_id,'evento_medico',usuario.CommunityNickname.toUpperCase(),docIds));
		}
		return new Response(wsResp.hasError, 'OK');
	}
	public static Evento_medico__c[] getEventosMedicos(Id[] idEm) {
		return [SELECT Id, Asociado__r.Codigo_de_Afiliado__c, Asociado__c, Fecha_y_Hora_inicio_EMS__c, Tipo__c, Diagnostico__c,
						Fecha_de_Vencimiento_Certificado__c, Diferido__c, Motivo__c, Diagnostico__r.Codigo_del_Diagnostico__c,
						Sin_complicaciones__c, Consultorio__c, Consultorio__r.Secuencia__c, Consultorio__r.Codigo_externo__c,
						Descripcion__c, Delegacion__r.Codigo_de_delegacion__c, Observaciones__c, Mail__c, Domicilio_Entrega__c,
						Via_Entrega__c, Ap_Anestesia__c, AP_presupuesto__c, Importe_presupuesto__c, RecordTypeId, Delegacion__c,
						Efector_Solicitante__r.Codigo_de_efector__c, Responsable__r.Codigo_de_efector__c, Recupero__c,
						Domicilio__c, AP_material__c, Prestador__r.Codigo_de_efector__c, Subtipo__c, Codigo_Nomenclador__r.Codigo__c,
						Prestador__c, Efector_Solicitante__c, Nro_de_Evento_Medico_SS__c, Forma_de_egreso__c, OwnerId,
						Otro_domicilio__c, EMS__r.Nro_de_Evento_Medico_SS__c, RecordType.DeveloperName, Resultado__c, Suspendido__c,
						(SELECT Id FROM Segmentos__r)
				FROM Evento_medico__c
				WHERE Id IN :idEm];
	}
	private static Response validateOwner(Evento_medico__c em, User usuario) {
		List<String> profileNames = new List<String>{'Administrador del sistema', 'CDC', 'System Administrator'};
		Boolean isOwner = profileNames.contains(usuario.Profile.Name) || em.OwnerId == usuario.Id;
		if(!isOwner) {
			return new Response(false, System.Label.Alerta_NoAuth_UsuarioNoPropietario);
		}
		return new Response(false, 'Ok');
	}
	private static void updateEMAndCreateSegmentCasePrestAndAlerts (Evento_medico__c emFromSF, WSEventoMedicoEnviarASSHelper.Response wsResp) {
		Segmentos__c[] segmentosToUpdate = new List<Segmentos__c>();
		for(WSEventoMedicoEnviarASSResp.Segmento segWs : wsResp.result.data.em.segmento) {
			Segmentos__c segmento = new Segmentos__c();
			if(emFromSF.Segmentos__r.isEmpty()) {
				segmento.Creado_Automaticamente__c = true;
			}
			segmento.Evento_Medico__c = emFromSF.Id;
			segmento.Semid__c = segWs.sem_id;
			segmento.Estado__c = segWs.estado;
			segmento.Fecha_Inicio_tentativa__c = segWs.fecha_desde_tentativa != null
					? EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(segWs.fecha_desde_tentativa)
					: null;
			segmento.Fecha_Fin_tentativa__c = segWs.fecha_hasta_tentativa != null
					? EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(segWs.fecha_hasta_tentativa)
					: null;
			segmento.Fecha_Inicio_real__c = segWs.fecha_real_desde != null
					? EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(segWs.fecha_real_desde)
					: null;
			segmento.Fecha_Fin_real__c = segWs.fecha_real_hasta != null
					? EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(segWs.fecha_real_hasta)
					: null;
			segmento.Solicitante__c = segWs.nom_solicitante;
			emFromSF.Fecha_y_Hora_Fin_EMS__c = segWs.fecha_real_hasta != null ? EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(segWs.fecha_real_hasta) :
			segWs.fecha_hasta_tentativa != null ?  EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(segWs.fecha_hasta_tentativa) : null;
			segmentosToUpdate.add(segmento);
		}
		emFromSF.Cambio_Manual__c = false;
		emFromSF.Fecha_y_Hora_inicio_EMS__c = String.isNotBlank(wsResp.result.data.em.fecha_inicio)
				? EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(wsResp.result.data.em.fecha_inicio)
				: null;
		emFromSF.Nro_de_Evento_Medico_SS__c = wsResp.result.data.em.em_id;
		emFromSF.Estado__c = wsResp.result.data.em.estado;
		emFromSF.Existente_en_SS__c = true;
		emFromSF.Emitido__c = wsResp.result.data.em.emitido;
		emFromSF.Recupero__c = wsResp.result.data.em.recupero;
		emFromSF.Diferido__c = wsResp.result.data.em.diferido == 'V'
				? 'Si' : wsResp.result.data.em.diferido == 'F'
						? 'No' : null;
		emFromSF.Suspendido__c = wsResp.result.data.em.suspendido == 'V'
				? 'Si' : wsResp.result.data.em.suspendido == 'F'
						? 'No' : null;
		emFromSF.Fecha_de_Vencimiento_Certificado__c =  wsResp.result.data.em.fec_vto_certif != null
				? Date.valueOf(wsResp.result.data.em.fec_vto_certif) : null;
		emFromSF.Motivo__c = wsResp.result.data.em.cod_motivo;
		emFromSF.Descripcion_motivo__c = wsResp.result.data.em.nom_motivo;
		emFromSF.Mail__c = wsResp.result.data.em.mail;
		emFromSF.Sin_complicaciones__c = wsResp.result.data.em.complicaciones == 'CON COMPLICACIONES'
				? '1' : wsResp.result.data.em.complicaciones == 'SIN COMPLICACIONES'
					? '0' : null;
		emFromSF.Via_Entrega__c = wsResp.result.data.em.via_entrega;
		emFromSF.Regla_aplicada__c = wsResp.result.data.em.cod_regla;
		emFromSF.Descripcion__c = wsResp.result.data.em.descr_em;
		emFromSF.Observaciones__c = wsResp.result.data.em.obs_em;
		emFromSF.AP_material__c = wsResp.result.data.em.check_mat == 'V' ? true : false;
		emFromSF.AP_presupuesto__c = wsResp.result.data.em.check_presu == 'V' ? true : false;
		emFromSF.Importe_presupuesto__c = wsResp.result.data.em.importe_presu != null
				? Decimal.valueOf(wsResp.result.data.em.importe_presu) : null;
		Database.SaveResult resultEm = Database.update(emFromSF);
		Database.UpsertResult[] resultSegmento = Database.upsert(segmentosToUpdate, Segmentos__c.Fields.Semid__c);
		List<Case> casesToUpsert = new List<Case>();
		List<Alerta__c> alertasToUpsert = new List<Alerta__c>();
		List<Prestacion__c> prestacionesToUpsert = new List<Prestacion__c>();
		Map<String, Nomenclador_de_Prestacion__c> nomencladoresToUpsert = new Map<String, Nomenclador_de_Prestacion__c>();
		Map<String, Medicamento__c> medicamentosToUpsert = new Map<String, Medicamento__c>();
		Map<String, Grupo_de_Prestaciones__c> gruposToUpsert = new Map<String, Grupo_de_Prestaciones__c>();
		for(WSEventoMedicoEnviarASSResp.Ap apWs : wsResp.result.data.em.ap) {
			Case caseToUpdate = new Case();
			caseToUpdate.Status = apWs.estado;
			if(apWs.ap_material == 'V' || apWs.ap_presupuesto == 'V' || apWs.ap_anestesia == 'V') {
				caseToUpdate.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
				if(apWs.ap_material == 'V') {
					caseToUpdate.Sub_tipo__c = 'Material';
				} else if(apWs.ap_presupuesto == 'V') {
					caseToUpdate.Sub_tipo__c = 'Presupuesto';
				}
			}
			else if(apWs.tipo_ap_sf == 'MEDICAMENTO') {
				caseToUpdate.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
			}
			else if(emFromSF.RecordTypeId == rTSeguimientoID) {
				caseToUpdate.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
				caseToUpdate.Sub_tipo__c = emFromSF.Subtipo__c;
				caseToUpdate.Status = wsResp.result.data.em.estado == 'AUTORIZADO' ? 'CA-----E' : apWs.estado;
			} else if (emFromSF.RecordTypeId == rTInternacionID) {
				caseToUpdate.RecordTypeId = XappiaHelper.getRecordType('Case', 'Internacion').Id;
				caseToUpdate.Sub_tipo__c = emFromSF.Subtipo__c;
			}
			caseToUpdate.Cambio_Manual__c = false;
			caseToUpdate.Importe_presupuesto__c = apWs.imp_presu != null ? Decimal.valueOf(apWs.imp_presu) : null;
			caseToUpdate.Categorizacion_SS__c = apWs.clasificacion;
			caseToUpdate.AccountId = emFromSF.Asociado__c;
			caseToUpdate.Nro_AP__c = apWs.apr_id;
			caseToUpdate.Fecha__c = apWs.fecha != null ?
					Date.valueOf(apWs.fecha) : null;
			caseToUpdate.Fecha_probable__c = apWs.fecha_probable != null ?
					Date.valueOf(apWs.fecha_probable) : null;
			caseToUpdate.Fecha_prescripcion__c = apWs.fecha_prescripcion != null ?
					Date.valueOf(apWs.fecha_prescripcion) : null;
			caseToUpdate.Evento_Medico__c = emFromSF.Id;
			caseToUpdate.Observaciones__c = apWs.observaciones;
			caseToUpdate.Mail__c = apWs.mail;
			caseToUpdate.Otros_Mail__c = apWs.otros_mail;
			caseToUpdate.Urgente__c = apWs.urgente;
			caseToUpdate.Type = apWs.tipo_ap_sf;
			caseToUpdate.Nivel_de_derivacion__c = apWs.nivel == 'N1'
					? 'Nivel 1' : apWs.nivel == 'N2'
					? 'Nivel 2' : apWs.nivel == 'N3'
					? 'Nivel 3' : null;
			caseToUpdate.Diagnostico__c = emFromSF.Diagnostico__c;
			caseToUpdate.Delegacion__c = emFromSF.Delegacion__c;
			caseToUpdate.Prescriptor__c = emFromSF.Efector_Solicitante__c;
			caseToUpdate.Prestador__c = emFromSF.Prestador__c;
			caseToUpdate.Consultorio__c = emFromSF.Consultorio__c;
			caseToUpdate.Tiempo_SLA__c = apWs.sla;
			if(String.isNotBlank(apWs.celula)) {
				caseToUpdate.Celula__c = apWs.celula;
			}
			casesToUpsert.add(caseToUpdate);
			for(WSEventoMedicoEnviarASSResp.Prestaciones prestWS : apWs.prestaciones){
				Prestacion__c prestToUpdate = new Prestacion__c();
				prestToUpdate.Cambio_automatico__c = true;
				prestToUpdate.Ap__r = new Case(Nro_AP__c = apWs.apr_id);
				prestToUpdate.Estado__c = prestWS.estado_prestacion;
				prestToUpdate.Prestacion_CA__c = prestWS.pca_id;
				prestToUpdate.Texto_aclarativo_alerta__c = prestWS.texto_aclarativo;
				prestToUpdate.Alerta__c = prestWS.alerta;
				prestToUpdate.Cantidad__c = Decimal.valueOf(prestWS.cantidad);
				prestToUpdate.Contexto__c = prestWS.contexto;
				prestToUpdate.Nombre_de_Prestacion__c = prestWS.nombre_prestacion;
				prestToUpdate.Tipo__c = prestWS.tipo_prestacion;
				prestToUpdate.Texto_aclarativo_alerta__c = prestWS.texto_aclarativo;
				if(String.isNotBlank(prestWS.prestacion)) {
					switch on prestWS.tipo_prestacion {
						when 'N' {
							prestToUpdate.Prestacion__r = new Nomenclador_de_Prestacion__c(Codigo__c = prestWS.prestacion);
							if (!nomencladoresToUpsert.containsKey(prestWS.prestacion)) {
								Nomenclador_de_Prestacion__c nomenclador = new Nomenclador_de_Prestacion__c (
									Codigo__c = prestWS.prestacion,
									Estado__c = 'A'
								);
								nomencladoresToUpsert.put(prestWS.prestacion, nomenclador);
							}
						}
						when 'M' {
							prestToUpdate.Medicamento__r = new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion);
							if (!medicamentosToUpsert.containsKey(prestWS.prestacion)) {
								Medicamento__c medicamento = new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion);
								medicamentosToUpsert.put(prestWS.prestacion, medicamento);
							}
						}
						when 'G' {
							prestToUpdate.Grupo_de_Prestaciones__r = new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion);
							if (!gruposToUpsert.containsKey(prestWS.prestacion)) {
								Grupo_de_Prestaciones__c grupo = new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion);
								gruposToUpsert.put(prestWS.prestacion, grupo);
							}
						}
					}
				}
				prestacionesToUpsert.add(prestToUpdate);
				for(WSEventoMedicoEnviarASSResp.Alertas alertWs : prestWS.alertas){
					Alerta__c alertPres = new Alerta__c();
					alertPres.Prestacion__r = new Prestacion__c(Prestacion_CA__c = prestWS.pca_id);
					alertPres.Evento_Medico__c = emFromSF.Id;
					alertPres.idalerta__c = alertWs.aca_id;
					alertPres.Control__c = alertWs.control;
					alertPres.Funcion__c = alertWs.funcion;
					alertPres.Texto_aclarativo__c = alertWs.texto_aclarativo;
					alertPres.Nivel_de_auditoria__c = alertWs.nivel_auditoria != null
							? Integer.valueOf(alertWs.nivel_auditoria) : null;
					alertPres.Fecha_de_generacion_de_Alerta__c = alertWs.fecha_generacion != null ?
							Date.valueOf(alertWs.fecha_generacion.substringBefore(' ')) :
							null;
					alertPres.Lectura_de_alerta_auditor__c = alertWs.auditor_lee;
					alertPres.Resolucion_de_alerta_auditor__c = alertWs.auditor_resuelve;
					alertPres.Fecha_resolucion_de_Alerta__c = alertWs.fecha_resolucion != null ?
							Date.valueOf(alertWs.fecha_resolucion.substringBefore(' ')) :
							null;
					alertPres.Estado__c = alertWs.estado_alerta;
					alertasToUpsert.add(alertPres);
				}
			}
		}
		Database.UpsertResult[] resultCasos = Database.upsert(casesToUpsert, Case.Fields.Nro_AP__c, false);
		Database.UpsertResult[] resultNomencladores = Database.upsert(nomencladoresToUpsert.values(), Nomenclador_de_Prestacion__c.Codigo__c, false);
	   	Database.UpsertResult[] resultMedicamentos = Database.upsert(medicamentosToUpsert.values(), Medicamento__c.Codigo_medicamento__c, false);
		Database.UpsertResult[] resultGrupos = Database.upsert(gruposToUpsert.values(), Grupo_de_Prestaciones__c.Codigo__c, false);
		Database.UpsertResult[] resultPrests = Database.upsert(prestacionesToUpsert, Prestacion__c.Fields.Prestacion_CA__c, false);
		Database.UpsertResult[] resultAlerts = Database.upsert(alertasToUpsert, Alerta__c.Fields.idalerta__c, false);
	}
	public static DateTime parseStringToDateTime(String dateString){
		List<String> fechaSplitGuionMedio = dateString.split('-');
		List<String> yearSplit = fechaSplitGuionMedio.get(2).split(' ');
		List<String> horaMinuto = yearSplit.get(1).split(':');
		string dia = fechaSplitGuionMedio.get(0);
		string mes = fechaSplitGuionMedio.get(1);
		string year = yearSplit.get(0);
		string hora = horaMinuto.get(0);
		string minuto = horaMinuto.get(1);
		Datetime retorno = Datetime.newInstance(Integer.valueOf(year),Integer.valueOf(mes),Integer.valueOf(dia), Integer.valueOf(hora), Integer.valueOf(minuto), 00);
		return retorno;
	}
	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		public Response(Boolean hasError, String message) {
			this.hasError = hasError;
			this.message = message;
		}
	}
}