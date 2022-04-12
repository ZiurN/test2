/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase controladora del botón caseEnviarASSBtn, usado para enviar Autorizaciones AP a SS.
@date			02/11/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ApexCRUDViolation, PMD.ExcessiveParameterList, PMD.AvoidDeeplyNestedIfStmts')
public without sharing class CasoEnviarASSBtnCtrl {
	private static final String[] ADMIN_PROFILES = new List<String> {'Administrador del sistema',
																	'System Administrator',
																	'Administrador de Servicio',
																	'CDC'};
	/** Status de los mensajes al front */
	private static final String SUCCESS = 'success';
	private static final String ERROR = 'error';
	private static final String WARNING = 'warning';
	private static final String INFO = 'info';
	/** Tipo de Servicio SS */
	private static final String AUTORIZACION = 'autorizaciones';
	private static final String REINTEGROS = 'reintegros';
	/** Variables estáticas */
	private static Case caseFromSF;
	private static User usuario;
	private static String userNick;
	private static CasoEnviarASSParser parser;
	private static String body;
	private static String caseType;
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll
	@description	Método para verificar si existen archivos adjuntos en el caso.
	@param			caseId - Id del caso.
	@param			emId - Id del evento médico.
	@return         Boolean - Indica si hay o no archivos en el caso.
	------------------------------------------------------------------------------------------------------------------------*/
	@AuraEnabled
	public static Boolean hasAttachments (String caseId) {
		return hasAttachments(caseId, '');
	}
	@AuraEnabled
	public static Boolean hasAttachments (String caseId, String emId) {
		List<ContentDocumentLink> dbLinks = getContentDocumentLinks(caseId, emId);
		return !dbLinks.isEmpty();
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll
	@description	Método para enviar la info del caso AP a SS desde la interfaz del usuario.
	@param			caseToSend - Id del caso.
	@return         Response - Un objeto de respuesta al front.
	------------------------------------------------------------------------------------------------------------------------*/
	@AuraEnabled
	public static Response sendCaseToSS (Id caseToSend) {
		caseType = 'AP';
		caseFromSF = getCase(caseToSend);
		usuario = getUsuario();
		Response validation = validations();
		if(validation.auraMessage.message != 'ok') {
			return validation;
		}
		Segmentos__c[] segmentos = [SELECT Id, Estado__c
									FROM Segmentos__c
									WHERE Evento_Medico__c = :caseFromSF.Evento_Medico__c
										AND Segmento_actual__c = true];
		return sendAPToSS(segmentos);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Método para enviar la info del caso deReintegro a SS desde la interfaz del usuario.
	@param			caseToSend - Id del caso.
	@return         Response - Un objeto de respuesta al front.
	------------------------------------------------------------------------------------------------------------------------*/
	@AuraEnabled
	public static Response sendReintegroToSS (Id caseToSend) {
		caseType = 'Reintegro';
		caseFromSF = getCase(caseToSend);
		usuario = getUsuario();
		Response validation = validations();
		if(validation.auraMessage.message != 'ok') {
			return validation;
		}
		parser =  new CasoEnviarASSParser(caseFromSF, userNick);
		body = parser.parseReintegroBody();
		WSCaseEnviarASSHelper.Response resp = WSCaseEnviarASSHelper.enviarASS(body, REINTEGROS, 'reintegros');
		Response response;
		if (!resp.hasError) {
			response = updateReintegro(resp.result.data[0].reintegro);
			if (response.hasError) {
				return response;
			}
			sendFiles (resp.result.data[0].reintegro.rei_id);
		} else {
			response = new Response (resp.hasError, resp.message, resp.hasError ? ERROR : SUCCESS);
		}
		return response;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll
	@description	Método para enviar la info del caso AP a SS.
	@param			caseFromSF - Caso para enviar a SS.
	@param			segmentos - Conjunto de segmentos.
	@return         Response - Un objeto de respuesta al front.
	------------------------------------------------------------------------------------------------------------------------*/
	private static Response sendAPToSS (Segmentos__c[] segmentos) {
		Response response;
		List<Prestacion__c> prestaciones = getPrestaciones(caseFromSF.Id);
		parser = new CasoEnviarASSParser (caseFromSF, prestaciones, userNick);
		body = parser.parseAutorizacionAPBody();
		WSCaseEnviarASSHelper.Response wsResp = WSCaseEnviarASSHelper.enviarASS(body, AUTORIZACION, 'autorizaciones');
		Boolean updateSucc = true;
		if (wsResp.hasError) {
			return new Response(wsResp.hasError, wsResp.message, (wsResp.hasError ? ERROR : SUCCESS));
		}
		List<Response> tempResponses = new List<Response>();
		for(WSSSGenericResponse.Ap wsCaso : wsResp.result.data[0].ap) {
			Response tempResponse;
			if(wsCaso.nro_sf == caseFromSF.Id){
				tempResponse = updateAPCase(wsCaso, segmentos);
				sendFiles(wsCaso.apr_id);
			}
			else {
				tempResponse = createAPCase(wsCaso);
			}
			tempResponses.add(tempResponse);
		}
		if (tempResponses.size() > 0 && tempResponses.size() == 1) {
			response = tempResponses[0];
		} else if (tempResponses.size() > 1) {
			Boolean hasError = false;
			String msg = '';
			for (Response tempResponse : tempResponses){
				hasError = hasError || tempResponse.hasError;
				if (hasError) {
					msg += tempResponse.auraMessage.message + '\n';
				}
			}
			response = new Response(hasError, hasError ? msg : 'Ok', hasError ? ERROR : SUCCESS);
		}
		return response;
	}
	private static Response updateAPCase (WSSSGenericResponse.Ap ap, Segmentos__c[] segmentos) {
		List<Prestacion__c> prestaciones = getPrestaciones (caseFromSF.Id);
		Map<String,Prestacion__c> prestacionesMap = new Map<String,Prestacion__c>();
		Map<String,Prestacion__c> medicamentosMap = new Map<String,Prestacion__c>();
		Map<String,Prestacion__c> grupoPresMap = new Map<String,Prestacion__c>();
		Evento_medico__c em;
		Segmentos__c segToUpdate;
		for(Prestacion__c prest : prestaciones) {
			switch on prest.Tipo__c{
				when 'M'{
					medicamentosMap.put(prest.Medicamento__r.Codigo_medicamento__c,prest);
				}
				when 'N'{
					prestacionesMap.put(prest.Prestacion__r.Codigo__c,prest);
				}
				when 'G'{
					grupoPresMap.put(prest.Prestacion__r.Codigo__c,prest);
				}
			}
		}
		caseFromSF.Cambio_Manual__c = false;
		caseFromSF.Nro_AP__c = ap.apr_id;
		caseFromSF.Status = ap.estado;
		caseFromSF.Nivel_de_derivacion__c = ap.nivel;
		caseFromSF.Categorizacion_SS__c = ap.clasificacion;
		caseFromSF.Type = ap.tipo_ap_sf;
		caseFromSF.Tiempo_SLA__c = ap.sla;
		if(String.isNotBlank(ap.celula)) {
			caseFromSF.Celula__c = ap.celula;
		}
		Database.SaveResult result = Database.update(caseFromSF);
		String msg = '';
		Boolean hasError = false;
		if(!result.isSuccess()){
			for(Database.Error err : result.getErrors()){
				msg = msg + err.getMessage() + '\n';
				hasError = hasError || !result.isSuccess();
			}
		}
		List<Prestacion__c> prestacionesToUpdate = new List<Prestacion__c>();
		List<Alerta__c> alertasToUpsert = new List<Alerta__c>();
		Map<String, Nomenclador_de_Prestacion__c> nomencladoresToUpsert = new Map<String, Nomenclador_de_Prestacion__c>();
		Map<String, Medicamento__c> medicamentosToUpsert = new Map<String, Medicamento__c>();
		Map<String, Grupo_de_Prestaciones__c> gruposToUpsert = new Map<String, Grupo_de_Prestaciones__c>();
		for(WSSSGenericResponse.Prestaciones prestWS : ap.prestaciones){
			Prestacion__c prestToUpdate;
			switch on prestWS.tipo_prestacion{
				when 'M'{
					prestToUpdate = medicamentosMap.get(prestWS.prestacion);
				}
				when 'N'{
					prestToUpdate = prestacionesMap.get(prestWS.prestacion);
				}
				when 'G'{
					prestToUpdate = grupoPresMap.get(prestWS.prestacion);
				}
			}
			if(prestToUpdate == null){
				prestToUpdate = new Prestacion__c();
				prestToUpdate.Cantidad__c = Decimal.valueOf(prestWS.cantidad);
				prestToUpdate.Ap__c = caseFromSF.Id;
				prestToUpdate.Tipo__c = prestWS.tipo_prestacion;
				prestToUpdate.Observaciones__c = prestWS.texto_aclarativo;
				switch on prestWS.tipo_prestacion{
					when 'N'{
						prestToUpdate.Prestacion__r = new Nomenclador_de_Prestacion__c(Codigo__c = prestWS.prestacion);
						if (!nomencladoresToUpsert.containsKey(prestWS.prestacion)) {
							Nomenclador_de_Prestacion__c nomenclador =
								new Nomenclador_de_Prestacion__c(Codigo__c = prestWS.prestacion);
							nomencladoresToUpsert.put(prestWS.prestacion, nomenclador);
						}
					}
					when 'M'{
						prestToUpdate.Medicamento__r = new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion);
						if (!medicamentosToUpsert.containsKey(prestWS.prestacion)) {
							Medicamento__c medicamento =
								new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion);
							medicamentosToUpsert.put(prestWS.prestacion, medicamento);
						}
					}
					when 'G'{
						prestToUpdate.Grupo_de_Prestaciones__r = new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion);
						if (!gruposToUpsert.containsKey(prestWS.prestacion)) {
							Grupo_de_Prestaciones__c grupo =
								new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion);
							gruposToUpsert.put(prestWS.prestacion, grupo);
						}
					}
				}
			}
			prestToUpdate.Contexto__c = prestWs.contexto;
			prestToUpdate.Cambio_automatico__c = true;
			prestToUpdate.Estado__c = prestWS.estado_prestacion;
			prestToUpdate.Prestacion_CA__c = prestWS.pca_id;
			prestToUpdate.Texto_aclarativo_alerta__c = prestWS.texto_aclarativo;
			prestToUpdate.Alerta__c = prestWS.alerta;
			prestToUpdate.Nombre_de_Prestacion__c = prestWS.nombre_prestacion;
			prestToUpdate.Importe_plan_sys__c = prestWS.importe_plan_sys != null
													? Decimal.valueOf(prestWS.importe_plan_sys) : null;
			prestToUpdate.Importe_plan_auditor__c = prestWS.importe_plan_aud != null
														? Decimal.valueOf(prestWS.importe_plan_aud) : null;
			prestToUpdate.Importe_convenio_sys__c = prestWS.importe_convenio_sys != null
														? Decimal.valueOf(prestWS.importe_convenio_sys) : null;
			prestToUpdate.Importe_convenio_auditor__c = prestWS.importe_convenio_aud != null
														? Decimal.valueOf(prestWS.importe_convenio_aud) : null;
			prestToUpdate.Importe_cargo_al_socio_sys__c = prestWS.importe_cargo_al_socio_sys!= null
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_sys) : null;
			prestToUpdate.Importe_cargo_al_socio_auditor__c = prestWS.importe_cargo_al_socio_aud!= null
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_aud) : null;
			prestacionesToUpdate.add(prestToUpdate);
			for(WSSSGenericResponse.Alertas alert : prestWS.alertas){
				Alerta__c alertPres = new Alerta__c();
				alertPres.Prestacion__r = new Prestacion__c(Prestacion_CA__c = prestWS.pca_id);
				alertPres.Control__c = alert.control;
				alertPres.Funcion__c = alert.funcion;
				alertPres.Texto_aclarativo__c = alert.texto_aclarativo;
				alertPres.Nivel_de_auditoria__c = alert.nivel_auditoria == null ? null : Decimal.valueOf(alert.nivel_auditoria);
				alertPres.Fecha_de_generacion_de_Alerta__c = alert.fecha_generacion != null ?
						Date.valueOf(alert.fecha_generacion.substringBefore(' ')) :
						null;
				alertPres.Lectura_de_alerta_auditor__c = alert.auditor_lee;
				alertPres.Resolucion_de_alerta_auditor__c = alert.auditor_resuelve;
				alertPres.Fecha_resolucion_de_Alerta__c = alert.fecha_resolucion != null ?
						Date.valueOf(alert.fecha_resolucion.substringBefore(' ')) :
						null;
				alertPres.idalerta__c = alert.aca_id;
				alertPres.Estado__c = alert.estado_alerta;
				if(ap.evento_medico != null) {
					alertPres.Evento_Medico__r = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = ap.evento_medico);
				}
				alertasToUpsert.add(alertPres);
			}
		}
		if(String.isNotBlank(caseFromSF.Evento_Medico__c)
			&& ap.estado_em == 'AUTORIZADO'
			&& caseFromSF.Evento_Medico__r.Estado__c != 'AUTORIZADO'
		) {
			em = new Evento_medico__c();
			em.Cambio_Manual__c = false;
			em.Id = caseFromSF.Evento_Medico__c;
			em.Estado__c = ap.estado_em;
			if(!segmentos.isEmpty()) {
				segToUpdate = segmentos[0];
				segToUpdate.Estado__c = ap.estado_em;
			}
		}
		Database.UpsertResult[] resultNomencladores = Database.upsert(nomencladoresToUpsert.values(),
				Nomenclador_de_Prestacion__c.Codigo__c, false);
		Database.UpsertResult[] resultMedicamentos = Database.upsert(medicamentosToUpsert.values(),
				Medicamento__c.Codigo_medicamento__c, false);
		Database.UpsertResult[] resultGrupos = Database.upsert(gruposToUpsert.values(),
				Grupo_de_Prestaciones__c.Codigo__c, false);
		Database.UpsertResult[] resultPrests = Database.upsert(prestacionesToUpdate, false);
		for(Database.UpsertResult res : resultPrests){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
					hasError = hasError || !result.isSuccess();
				}
			}
		}
		Database.UpsertResult[] resultAlerts = Database.upsert(alertasToUpsert, Alerta__c.idalerta__c,false);
		for(Database.UpsertResult res : resultAlerts){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
					hasError = hasError || !result.isSuccess();
				}
			}
		}
		if(em != null) {
			Database.SaveResult resultEm = Database.update(em);
		}
		if(segToUpdate != null) {
			Database.SaveResult resultSegmento = Database.update(segToUpdate);
		}
		return new Response(hasError, hasError ? msg : 'Ok', hasError ? ERROR : SUCCESS);
	}
	private static Response createAPCase (WSSSGenericResponse.Ap ap) {
		Map<String,Prestacion__c> prestacionesMap = new Map<String,Prestacion__c>();
		Map<String,Prestacion__c> medicamentosMap = new Map<String,Prestacion__c>();
		Map<String,Prestacion__c> grupoPresMap = new Map<String,Prestacion__c>();
		Case caseToSF = new Case();
		if(ap.ap_material == 'V') {
			caseToSF.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
			caseToSF.Sub_tipo__c = 'Material';
		}
		else if(ap.ap_presupuesto == 'V') {
			caseToSF.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
			caseToSF.Sub_tipo__c = 'Presupuesto';
		}
		caseToSF.Cambio_Manual__c = false;
		caseToSF.Nro_AP__c = ap.apr_id;
		caseToSF.Status = ap.estado;
		caseToSF.Nivel_de_derivacion__c = ap.nivel;
		caseToSF.Categorizacion_SS__c = ap.clasificacion;
		caseToSF.Type = ap.tipo_ap_sf;
		caseToSF.ParentId = caseFromSF.Id;
		caseToSF.Fecha_probable__c = Date.valueOf(ap.fecha_probable);
		caseToSF.Fecha__c = Date.valueOf(ap.fecha);
		caseToSF.Mail__c = ap.mail;
		caseToSF.Observaciones__c = ap.observaciones;
		caseToSF.Otros_Mail__c = ap.otros_mail;
		caseToSF.Delegacion__c = caseFromSF.Delegacion__c;
		caseToSF.Prescriptor__c = caseFromSF.Prescriptor__c;
		caseToSF.Fecha_prescripcion__c = caseFromSF.Fecha_prescripcion__c;
		caseToSF.Evento_Medico__c = caseFromSF.Evento_Medico__c;
		caseToSF.Tiempo_SLA__c = ap.sla;
		caseToSF.AccountId = caseFromSF.AccountId;
		caseToSF.Diagnostico__r = ap.diagnostico != null ? new Diagnostico__c(Codigo_del_Diagnostico__c = ap.diagnostico) : null;
		if(String.isNotBlank(ap.celula)) {
			caseToSF.Celula__c = ap.celula;
		}
		String msg = '';
		Boolean hasError = false;
		Database.SaveResult result = Database.insert(caseToSF);
		if(!result.isSuccess()){
			for(Database.Error err : result.getErrors()){
				msg = msg + err.getMessage() + '\n';
				hasError = !result.isSuccess();
			}
		}
		List<Prestacion__c> prestacionesToUpdate = new List<Prestacion__c>();
		List<Alerta__c> alertasToUpsert = new List<Alerta__c>();
		Map<String, Nomenclador_de_Prestacion__c> nomencladoresToUpsert = new Map<String, Nomenclador_de_Prestacion__c>();
		Map<String, Medicamento__c> medicamentosToUpsert = new Map<String, Medicamento__c>();
		Map<String, Grupo_de_Prestaciones__c> gruposToUpsert = new Map<String, Grupo_de_Prestaciones__c>();
		for(WSSSGenericResponse.Prestaciones prestWS : ap.prestaciones){
			Prestacion__c prestToUpdate = new Prestacion__c();
			prestToUpdate.Cambio_automatico__c = true;
			prestToUpdate.Cantidad__c = Decimal.valueOf(prestWS.cantidad);
			prestToUpdate.Tipo__c = prestWS.tipo_prestacion;
			prestToUpdate.Ap__r = new Case(Nro_Ap__c = ap.apr_id);
			prestToUpdate.Observaciones__c = prestWS.texto_aclarativo;
			switch on prestWS.tipo_prestacion{
				when 'N'{
					prestToUpdate.Prestacion__r = new Nomenclador_de_Prestacion__c(Codigo__c = prestWS.prestacion);
					if (!nomencladoresToUpsert.containsKey(prestWS.prestacion)) {
						Nomenclador_de_Prestacion__c nomenclador =
							new Nomenclador_de_Prestacion__c(Codigo__c = prestWS.prestacion);
						nomencladoresToUpsert.put(prestWS.prestacion, nomenclador);
					}
				}
				when 'M'{
					prestToUpdate.Medicamento__r = new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion);
					if (!medicamentosToUpsert.containsKey(prestWS.prestacion)) {
						Medicamento__c medicamento =
							new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion);
						medicamentosToUpsert.put(prestWS.prestacion, medicamento);
					}
				}
				when 'G'{
					prestToUpdate.Grupo_de_Prestaciones__r = new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion);
					if (!gruposToUpsert.containsKey(prestWS.prestacion)) {
						Grupo_de_Prestaciones__c grupo =
							new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion);
						gruposToUpsert.put(prestWS.prestacion, grupo);
					}
				}
			}
			prestToUpdate.Estado__c = prestWS.estado_prestacion;
			prestToUpdate.Prestacion_CA__c = prestWS.pca_id;
			prestToUpdate.Texto_aclarativo_alerta__c = prestWS.texto_aclarativo;
			prestToUpdate.Alerta__c = prestWS.alerta;
			prestToUpdate.Nombre_de_Prestacion__c = prestWS.nombre_prestacion;
			prestToUpdate.Importe_plan_sys__c = prestWS.importe_plan_sys != null
													? Decimal.valueOf(prestWS.importe_plan_sys) : null;
			prestToUpdate.Importe_plan_auditor__c = prestWS.importe_plan_aud != null
														? Decimal.valueOf(prestWS.importe_plan_aud) : null;
			prestToUpdate.Importe_convenio_sys__c = prestWS.importe_convenio_sys != null
														? Decimal.valueOf(prestWS.importe_convenio_sys) : null;
			prestToUpdate.Importe_convenio_auditor__c = prestWS.importe_convenio_aud != null
														? Decimal.valueOf(prestWS.importe_convenio_aud) : null;
			prestToUpdate.Importe_cargo_al_socio_sys__c = prestWS.importe_cargo_al_socio_sys!= null
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_sys) : null;
			prestToUpdate.Importe_cargo_al_socio_auditor__c = prestWS.importe_cargo_al_socio_aud!= null
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_aud) : null;
			prestacionesToUpdate.add(prestToUpdate);
			for(WSSSGenericResponse.Alertas alert : prestWS.alertas){
				Alerta__c alertPres = new Alerta__c();
				alertPres.Prestacion__r = new Prestacion__c(Prestacion_CA__c = prestWS.pca_id);
				alertPres.Control__c = alert.control;
				alertPres.Funcion__c = alert.funcion;
				alertPres.Texto_aclarativo__c = alert.texto_aclarativo;
				alertPres.Nivel_de_auditoria__c = alert.nivel_auditoria == null ? null : Decimal.valueOf(alert.nivel_auditoria);
				alertPres.Fecha_de_generacion_de_Alerta__c = alert.fecha_generacion != null ?
						Date.valueOf(alert.fecha_generacion.substringBefore(' ')) :
						null;
				alertPres.Lectura_de_alerta_auditor__c = alert.auditor_lee;
				alertPres.Resolucion_de_alerta_auditor__c = alert.auditor_resuelve;
				alertPres.Fecha_resolucion_de_Alerta__c = alert.fecha_resolucion != null ?
						Date.valueOf(alert.fecha_resolucion.substringBefore(' ')) :
						null;
				alertPres.idalerta__c = alert.aca_id;
				alertPres.Estado__c = alert.estado_alerta;
				if(ap.evento_medico != null) {
					alertPres.Evento_Medico__r = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = ap.evento_medico);
				}
				alertasToUpsert.add(alertPres);
			}
		}
		Database.UpsertResult[] resultNomencladores = Database.upsert(nomencladoresToUpsert.values(),
				Nomenclador_de_Prestacion__c.Codigo__c, false);
		Database.UpsertResult[] resultMedicamentos = Database.upsert(medicamentosToUpsert.values(),
				Medicamento__c.Codigo_medicamento__c, false);
		Database.UpsertResult[] resultGrupos = Database.upsert(gruposToUpsert.values(),
				Grupo_de_Prestaciones__c.Codigo__c, false);
		Database.SaveResult[] resultPrests = Database.insert(prestacionesToUpdate,false);
		for(Database.SaveResult res : resultPrests){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
					hasError = hasError || !result.isSuccess();
				}
			}
		}
		Database.UpsertResult[] resultAlerts = Database.upsert(alertasToUpsert, Alerta__c.idalerta__c,false);
		for(Database.UpsertResult res : resultAlerts){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
					hasError = hasError || !result.isSuccess();
				}
			}
		}
		return new Response(hasError, hasError ? msg : 'Ok', hasError ? ERROR : SUCCESS);
	}
	private static Response updateReintegro (WSSSGenericResponse.Reintegro reintegroWS) {
		String nivel = reintegroWS.nivel;
		caseFromSF.Cambio_Manual__c = false;
		caseFromSF.Nivel_de_derivacion__c = nivel == 'N1' ? 'Nivel 1'
												: nivel == 'N2' ? 'Nivel 2'
													: nivel == 'N3' ? 'Nivel 3'
														: null;
		caseFromSF.Celula__c = reintegroWS.celula;
		caseFromSF.Tiempo_SLA__c = reintegroWS.sla;
		caseFromSF.Codigo_reintegro_SS__c = reintegroWS.rei_id;
		caseFromSF.Existente_SS__c = true;
		caseFromSF.Nro_comprobante__c = reintegroWS.nro_comprobante;
		caseFromSF.Fecha_comprobante__c = Date.valueOf(reintegroWS.fecha_comprobante);
		caseFromSF.Status = Utils.translateStateReintegroToAP(reintegroWS.vda_drv_estado);
		List<Prestacion_de_reintegro__c> prestacionesToUpsert = new List<Prestacion_de_reintegro__c>();
		List<Alerta__c> alertasToUpsert = new List<Alerta__c>();
		for(WSSSGenericResponse.Prestaciones prestWS : reintegroWS.prestaciones) {
			Prestacion_de_reintegro__c pres = new Prestacion_de_reintegro__c();
			pres.Id = prestWS.nro_sf;
			pres.Caso__c = caseFromSF.Id;
			pres.Id_Externo__c = prestWS.pca_id;
			pres.Estado__c = prestWS.estado_prestacion;
			pres.Importe_cargo_al_socio_auditor__c = prestWS.importe_cargo_al_socio_aud != null
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_aud) : null;
			pres.Importe_cargo_al_socio_sys__c = prestWS.importe_cargo_al_socio_sys != null
													? Decimal.valueOf(prestWS.importe_cargo_al_socio_sys) : null;
			pres.Importe_Reintegro_auditor__c = prestWS.importe_rein_aud != null
													? Decimal.valueOf(prestWS.importe_rein_aud) : null;
			pres.Importe_Reintegro_sys__c = prestWS.importe_rein_sys != null
												? Decimal.valueOf(prestWS.importe_rein_sys) : null;
			prestacionesToUpsert.add(pres);
			for(WSSSGenericResponse.Alertas alert : prestWS.alertas) {
				Alerta__c alertPres = new Alerta__c();
				alertPres.Prestacion_de_reintegro__r = new Prestacion_de_reintegro__c(Id_Externo__c = prestWS.pca_id);
				alertPres.Control__c = alert.control;
				alertPres.Funcion__c = alert.funcion;
				alertPres.Texto_aclarativo__c = alert.texto_aclarativo;
				alertPres.Nivel_de_auditoria__c = alert.nivel_auditoria == null ? null : Decimal.valueOf(alert.nivel_auditoria);
				alertPres.Fecha_de_generacion_de_Alerta__c = alert.fecha_generacion != null ?
						Date.valueOf(alert.fecha_generacion.substringBefore(' ')) :
						null;
				alertPres.Lectura_de_alerta_auditor__c = alert.auditor_lee;
				alertPres.Resolucion_de_alerta_auditor__c = alert.auditor_resuelve;
				alertPres.Fecha_resolucion_de_Alerta__c = alert.fecha_resolucion != null ?
						Date.valueOf(alert.fecha_resolucion.substringBefore(' ')) :
						null;
				alertPres.idalerta__c = alert.aca_id;
				alertPres.Estado__c = alert.estado_alerta;
				if(reintegroWS.em_em_id != null) {
					alertPres.Evento_Medico__r = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = reintegroWS.em_em_id);
				}
				alertasToUpsert.add(alertPres);
			}
		}
		if(reintegroWS.link_rein != null) {
			attachPDF(reintegroWS);
		}
		String msg = '';
		Boolean hasError = false;
		Database.SaveResult resReintegro = Database.update(caseFromSF);
		if(!resReintegro.isSuccess()){
			for(Database.Error err : resReintegro.getErrors()){
				msg = msg + err.getMessage() + '\n';
				hasError = hasError || !resReintegro.isSuccess();
			}
		}
		List<Database.SaveResult> resPrestaciones = Database.update(prestacionesToUpsert);
		for(Database.SaveResult res : resPrestaciones){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
					hasError = hasError || !res.isSuccess();
				}
			}
		}
		List<Database.UpsertResult> resAlertas = Database.upsert(alertasToUpsert,
				Alerta__c.Fields.idalerta__c);
		for(Database.UpsertResult res : resAlertas){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
					hasError = hasError || !res.isSuccess();
				}
			}
		}
		return new Response(hasError, hasError ? msg : 'Ok', hasError ? ERROR : SUCCESS);
	}
	private static Response validations () {
		String strObjPrefix = String.valueOf(caseFromSF.OwnerId).substring(0, 3);
		Boolean isUserInqueue = false;
		if(strObjPrefix == Group.sObjectType.getDescribe().getKeyPrefix()){
			Group cola = [SELECT Id FROM Group WHERE Type = 'Queue' AND Id = :caseFromSF.OwnerId];
			if (cola != null) {
				List<GroupMember> gms = [SELECT Id,UserOrGroupId FROM GroupMember WHERE GroupId = :cola.Id];
				for(GroupMember gm : gms){
					if(gm.UserOrGroupId == usuario.Id){
						isUserInqueue = true;
						break;
					}
				}
			}
		}
		Boolean propietario = ADMIN_PROFILES.contains(usuario.Profile.Name) || (isUserInqueue ? isUserInqueue : caseFromSF.OwnerId == usuario.Id);
		if (caseFromSF.Nivel_de_derivacion__c == null && !propietario) {
			return new Response(true, System.Label.Alerta_NoAuth_UsuarioNoPropietario, WARNING);
		}
		if(!hasAttachments(caseFromSF.Id) && caseType == 'Reintegro') {
			return new Response(false, System.Label.Alerta_NoEnviarSInAdjuntos, WARNING);
		}else {
			return new Response(false, 'ok', SUCCESS);
		}
	}
	private static void sendFiles (String wsResponseId) {
		List<String> idContentVersionList = new List<String>();
		List<ContentDocumentLink> linksList = getContentDocumentLinks(caseFromSf.Id, '');
		for (ContentDocumentLink cdl : linksList) {
			idContentVersionList.add(cdl.ContentDocument.LatestPublishedVersionId);
		}
		List<ContentVersion> cvList = [SELECT Id FROM ContentVersion WHERE Id IN :idContentVersionList AND Enviado__c = false];
		List<Id> docsList = new List<Id>();
		for (ContentVersion cv : cvList) {
			docsList.add(cv.Id);
		}
		System.enqueueJob(new ArchivosCargaQueueable(wsResponseId, caseType == 'Reintegro' ? caseType.toLowerCase() : 'autorizacion', userNick, docsList));
	}
	/** Utils */
	private static List<ContentDocumentLink> getContentDocumentLinks (String caseId, String eventoMedicoId) {
		List<EmailMessage> emailMessagesCase = [SELECT Id FROM EmailMessage WHERE ParentId = :caseId];
		String CDLinksQuery = 'SELECT LinkedEntityId,' +
							'ContentDocumentId,' +
							'ContentDocument.LatestPublishedVersionId,' +
							'ContentDocument.Title,' +
							'ShareType,' +
							'ContentDocument.FileType,' +
							'ContentDocument.FileExtension ' +
						'FROM ContentDocumentLink ' +
						'WHERE LinkedEntityId =: caseId ';
		String CDLinksQueryEmailCondition = 'OR LinkedEntityId IN :emailMessagesCase';
		if (!String.isBlank(eventoMedicoId)) {
			CDLinksQuery += 'OR LinkedEntityId =: eventoMedicoId ';
		}
		CDLinksQuery += CDLinksQueryEmailCondition;
		List<ContentDocumentLink> contentDocsLinksFromQuery = new List<ContentDocumentLink>();
		Database.QueryLocatorIterator iterator = Database.getQueryLocator(CDLinksQuery).iterator();
		while (iterator .hasNext()) {
			ContentDocumentLink CDLink = (ContentDocumentLink) iterator.next();
			contentDocsLinksFromQuery.add(CDLink);
		}
		return contentDocsLinksFromQuery;
	}
	private static Case getCase (String caseId) {
		String queryInit = 'SELECT Id, ' +
								'Fecha__c, ' +
								'Fecha_probable__c, ' +
								'Delegacion__r.Codigo_de_delegacion__c, ' +
								'Consultorio__r.Secuencia__c, ' +
								'Account.Codigo_de_Afiliado__c, ' +
								'Fecha_prescripcion__c, ' +
								'Diagnostico__r.Codigo_del_Diagnostico__c, ' +
								'Prestador__r.Codigo_de_efector__c, ' +
								'Consultorio__r.Codigo_externo__c, ' +
								'Observaciones__c, ' +
								'Mail__c, ' +
								'Otros_Mail__c, ' +
								'Evento_Medico__r.Nro_de_Evento_Medico_SS__c, ' +
								'AP_Material__c, ' +
								'AP_Presupuesto__c, ' +
								'Prescriptor__r.Codigo_de_efector__c, ' +
								'Status, ' +
								'Nro_AP__c, ' +
								'Categorizacion_SS__c, ' +
								'Nivel_de_derivacion__c, ' +
								'Importe_presupuesto__c, ' +
								'Cobro_indebido__c, ' +
								'Efector_realizador__r.Codigo_de_efector__c, ' +
								'Razon_social__c, ' +
								'Lote__r.Id_lote_SS__c, ' +
								'CUIT__c, ' +
								'Importe_reintegro__c, ' +
								'OwnerId, ' +
								'Tipo_de_Comprobante__c, ' +
								'Evento_Medico__c, ' +
								'Codigo_reintegro_SS__c, ' +
								'Orden_de_Compra__r.forma_de_Pago__c, ' +
								'Orden_de_Compra__r.Estado_OC__c, ' +
								'Evento_Medico__r.Estado__c, ' +
								'Fecha_comprobante__c, ' +
								'Nro_comprobante__c, ' +
								'Urgente__c';
		String queryEnd = ' FROM Case WHERE Id = : caseId ';
		String queryPrestacionesSubQuery = '(SELECT Id, ' +
												'Cantidad__c, ' +
												'Importe_total__c, ' +
												'Importe_a_pagar__c, ' +
												'Fecha_de_realizacion__c, ' +
												'Contexto__c, ' +
												'Pieza_dental__c, ' +
												'Caras__c, ' +
												'RecordTypeId, ' +
												'Observaciones__c, ' +
												'Alerta__c, ' +
												'Medicamento__r.Codigo_medicamento__c, ' +
												'Prestacion_odonto__r.Codigo__c, ' +
												'Prestacional__r.Codigo__c, ' +
												'Fecha_de_dispensa__c, ' +
												'HD__c ' +
											'FROM Prestaciones_de_reintegros__r)';
		String finalQuery = queryInit;
		if (caseType == 'Reintegro') {
			finalQuery += ', ' + queryPrestacionesSubQuery;
		}
		finalQuery += queryEnd;
		List<Case> casesFromQuery = new List<Case>();
		Database.QueryLocatorIterator iterator = Database.getQueryLocator(finalQuery).iterator();
		while (iterator .hasNext()) {
			Case caseFromQuery = (Case) iterator.next();
			casesFromQuery.add(caseFromQuery);
		}
		if (casesFromQuery.size() > 0) {return casesFromQuery[0];}
		else {return null;}
	}
	private static User getUsuario () {
		User userToReturn = [SELECT CommunityNickname,
								Profile.Name,
								UserRole.DeveloperName,
								Codigo_delegacion__c
							FROM User
							WHERE Id = :UserInfo.getUserId()];
		userNick = userToReturn.CommunityNickname != null ? userToReturn.CommunityNickname.toUpperCase() : null;
		return userToReturn;
	}
	private static List<Prestacion__c> getPrestaciones (String caseId) {
		return [SELECT Id,
					Alerta__c,
					Cantidad__c,
					Nombre_de_Prestacion__c,
					Prestacion__r.Tipo_Nomenclador__c,
					Prestacion__r.Codigo__c,
					Prestacion__r.Contexto__c,
					Prestacion_CA__c,
					Observaciones__c,
					Contexto__c,
					Tipo__c,
					Grupo_de_Prestaciones__r.Codigo__c,
					Medicamento__r.Codigo_medicamento__c,
					Importe_cargo_al_socio_auditor__c,
					Importe_convenio_auditor__c,
					Importe_plan_auditor__c
				FROM Prestacion__c
				WHERE Ap__c = :caseId];
	}
	private static void attachPDF(WSSSGenericResponse.Reintegro reintegroWS) {
		List<ContentDocumentLink> links = [SELECT LinkedEntityId,
											ContentDocumentId,
											ContentDocument.LatestPublishedVersionId,
											ContentDocument.Title,
											ShareType,
											ContentDocument.FileType,
											ContentDocument.FileExtension
										FROM ContentDocumentLink
										WHERE LinkedEntityId =: caseFromSF.Id
											AND ContentDocument.Title =: reintegroWS.rei_id];
		if (String.isBlank(reintegroWS.link_rein)) {
			return;
		}
		if (!links.isEmpty()) {
			ContentVersion version = buildPDF(reintegroWS.link_rein, reintegroWS.rei_id, links[0].ContentDocumentId);
			insert version;
		} else {
			ContentVersion version = buildPDF(reintegroWS.link_rein, reintegroWS.rei_id, null);
			insert version;
			List<ContentVersion> versionsUpdated = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: version.Id];
			links.add(new ContentDocumentLink(
				LinkedEntityId = caseFromSF.Id,
				ShareType = 'V',
				ContentDocumentId = versionsUpdated[0].ContentDocumentId
			));
			Database.SaveResult[] resultLinks = Database.insert(links, false);
		}
	}
	private static ContentVersion buildPDF(String link, String idRein, String cdId){
		ContentVersion version = new ContentVersion();
		String formattedLink = link;
		PageReference pdf = new PageReference(formattedLink);
		Blob pdfBody;
		if(cdId != null) {
			version.ContentDocumentId = cdId;
		}
		version.PathOnClient = '/REIN_' + idRein + '.pdf';
		version.origin = 'H';
		version.Title = idRein;
		try {
			pdfBody = pdf.getContentAsPDF();
		} catch (Exception e) {
			pdfBody = Blob.valueOf('No se pudo generar el archivo pdf');
			System.debug(e.getMessage());
		}
		version.VersionData = pdfBody;
		return version;
	}
	public class Response Extends FrontResponse {
		public Response(Boolean hasError, String message, String status) {
			this.hasError = hasError;
			this.auraMessage = new auraMessage(message, status);
		}
	}
}