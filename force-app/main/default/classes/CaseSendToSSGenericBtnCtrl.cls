/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase controladora del botón CaseSendToSSGenericBtn, usado para enviár solicitudes a SS.
@date			26/10/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ApexCRUDViolation, PMD.ExcessiveParameterList')
public without sharing class CaseSendToSSGenericBtnCtrl {
	/** Tipos de registro de solicitudes */
	private static Id solicitudAlta = XappiaHelper.getRecordType('Case', 'Solicitud_de_alta_familiar').Id;
	private static Id solicitudDespegue = XappiaHelper.getRecordType('Case', 'Solicitud_de_despegues').Id;
	private static Id solicitudDeBaja = XappiaHelper.getRecordType('Case', 'Solicitud_de_baja').Id;
	private static Id solicitudCambioSegmento = XappiaHelper.getRecordType('Case', 'Solicitud_de_segmento').Id;
	private static Id solicitudInterfazFinanciera = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
	private static Id solicitudCredencial = XappiaHelper.getRecordType('Case', 'Solicitud_de_nueva_credencial').Id;
	private static Id solicitudPlan = XappiaHelper.getRecordType('Case', 'Solicitud_de_cambio_de_plan').Id;
	private static Id solicitudDatosParticulares = XappiaHelper.getRecordType('Case', 'Solicitud_de_datos_particulares').Id;
	/** Status de los mensajes al front */
	private static final String SUCCESS = 'success';
	private static final String ERROR = 'error';
	private static final String WARNING = 'warning';
	private static final String INFO = 'info';
	/** Tipo de Servicio SS */
	private static final String SOLICITUDES_AFILIADOS = 'solicitudes-afiliados';
	/** Variables estáticas */
	private static Case caso;
	private static List<Nota_de_Auditoria__c> notas;
	private static User usuario = [SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c
									FROM User
									WHERE Id = :UserInfo.getUserId()];
	private static String userNick = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;
	private static List<ContentVersion> files = new List<ContentVersion>();
	private static Boolean isAttachmentResend;
	private static Parser parser;
	private static String body;
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para envíar la solicitud a SS desde la interfaz del usuario.
	@param			recordId - Id del caso.
	@param			isAttachmentResend - Indica si ahi que reenviar archivos.
					sean creadas.
	------------------------------------------------------------------------------------------------------------------------*/
	@AuraEnabled
	public static Response sendToSS(String recordId, Boolean isAttachmentResendFront) {
		isAttachmentResend = isAttachmentResendFront;
		if (isAttachmentResend) {
			caso = [SELECT id, RecordTypeId, Type FROM Case WHERE id = :recordId];
		} else {
			List<Case> casos = [SELECT id, RecordTypeId, Type FROM Case
					WHERE id = :recordId
						AND Estado_de_solicitud__c != 'TRANSFORMADA'
						AND Estado_de_solicitud__c != 'COMPLETA'];
			if (casos.size() > 0) {caso = casos[0];}
		}
		if (caso == null) return new Response(true, System.Label.Alerta_InvalidCaseClosed, WARNING, '{}');
		Set<Id> dLinks = new Set<Id>();
		for (ContentDocumentLink cDL : getContentDocumentLinks(recordId)) {
			dLinks.add(cDL.ContentDocumentId);
		}
		List<ContentVersion> generalFiles = [SELECT Id, VersionData, Title,Enviado__c, FileExtension, Description
												FROM ContentVersion
												WHERE ContentDocumentId IN :dLinks AND IsLatest = true];
		files = [SELECT Id, VersionData, Title, Enviado__c, FileExtension, Description
				FROM ContentVersion
				WHERE ContentDocumentId IN :dLinks
					AND IsLatest = true
					AND Enviado__c = false
				LIMIT 1];
		if(files.size() == 0 && isAttachmentResend) {
			return new Response(false, '', INFO, ''); // ??
		}
		if (generalFiles.isEmpty()
			&& caso.RecordtypeId != solicitudDatosParticulares
			&& caso.RecordtypeId != solicitudCredencial) {
			return new Response(true, System.Label.Alerta_NoEnviarSInAdjuntos, WARNING, '');
		}
		caso = getCaseInfo(recordId);
		notas = getNotas(recordId);
		if (caso.RecordTypeId == solicitudAlta) {return sendSolicitudAlta(recordId);}
		else if(caso.RecordTypeId == solicitudDespegue) {return sendSolicitudDespegue(recordId);}
		else if(caso.RecordTypeId == SolicitudDeBaja) {return sendSolicitudBaja(recordId);}
		else if(caso.RecordTypeId == solicitudCambioSegmento) {return sendSolicitudCambioSegmento(recordId);}
		else if(caso.RecordTypeId == solicitudInterfazFinanciera) {return sendInterfazFinanciera(recordId);}
		else if(caso.RecordTypeId == solicitudCredencial) {return sendSolicitudCambioCredencial(recordId);}
		else if(caso.RecordTypeId == solicitudPlan) {return sendSolicitudCambioPlan(recordId);}
		else if(caso.RecordTypeId == solicitudDatosParticulares) {return sendSolicitudDatosParticulares();}
		else {return new Response(true, System.Label.Alerta_CasoNoSolicitud, WARNING, '');}
	}
	/** Senders */
	private static Response sendSolicitudAlta (String recordId) {
		parser = new Parser(caso, userNick, files, notas, usuario);
		String body = parser.parseAltaBody();
		WSCaseEnviarASSHelper.Response resp = (WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, SOLICITUDES_AFILIADOS, 'alta-familiar');
		if(!resp.hasError) {
			processResponse(resp, caso, files, false, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, (resp.hasError) ? ERROR : SUCCESS , body);
	}
	private static Response sendSolicitudDespegue (String recordId) {
		List<Integrante_caso__c> integrantes = getIntegrantes(recordId);
		parser = new Parser(caso, userNick, files, notas, integrantes, usuario);
		String body = parser.parseDespegueBody();
		WSCaseEnviarASSHelper.Response resp = (WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, SOLICITUDES_AFILIADOS, 'despegue');
		if(!resp.hasError) {
			processResponse(resp, caso, files, false, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, (resp.hasError) ? ERROR : SUCCESS, body);
	}
	private static Response sendSolicitudBaja (String recordId) {
		if(caso.Type == 'Baja Parcial') {
			List<Integrante_caso__c> integrantes = getIntegrantes(recordId);
			Map<Id, Integrante_caso__c> integrantesById = new Map<Id, Integrante_caso__c>(integrantes);
			if(integrantes.isEmpty()) {
				return new Response(true, System.Label.Alerta_BajaParcialSinIntegrantes, WARNING, '');
			}
			notas = getNotas(integrantesById.keySet());
			parser = new Parser(caso, userNick, files, notas, integrantes, usuario);
			body = parser.parseBajaParcialBody();
		} else if(caso.Type == 'Baja Total') {
			parser = new Parser(caso, userNick, files, notas, usuario);
			body = parser.parseBajaTotalBody();
		} else {
			return new Response(true, System.Label.Alerta_CasoBajaTipoInvalido, WARNING, '');
		}
		WSCaseEnviarASSHelper.Response solicitudBaja = (WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, SOLICITUDES_AFILIADOS, 'baja');
		if(!solicitudBaja.hasError) {
			if(!isAttachmentResend) {
				List<WSSSGenericResponse.Notas> notasToProcess = new List<WSSSGenericResponse.Notas>();
				if(caso.Type == 'Baja Parcial') {
					List<Integrante_caso__c> integrantesToUpdate = new List<Integrante_caso__c>();
					String caseNroSolicitud = '';
					for(WSSSGenericResponse.Data data : solicitudBaja.result.data) {
						integrantesToUpdate.add(new Integrante_caso__c(Id = data.sf_id, Numero_de_solicitud__c = data.solafi_id, Estado_solicitud__c = data.estado_sol));
						caseNroSolicitud += data.solafi_id + ' - ';
						notasToProcess.addAll(data.notas);
					}
					if(String.isBlank(caso.Nro_de_solicitud_SS__c)) {
						caseNroSolicitud = caseNroSolicitud.left(caseNroSolicitud.length() - 3);
						caso.Nro_de_solicitud_SS__c = caseNroSolicitud;
					}
					caso.Status = 'En proceso';
					update caso;
					update integrantesToUpdate;
				} else {
					WSSSGenericResponse.Data data =  solicitudBaja.result.data.get(0);
					caso.Estado_de_solicitud__c = data.estado_sol;
					caso.Nro_de_solicitud_SS__c = data.solafi_id;
					notasToProcess.addAll(data.notas);
					caso.Status = 'En proceso';
					update caso;
				}
				processNotas(notasToProcess);
			}
			processFiles(files);
		}
		if(files.size() != 0 && !solicitudBaja.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(solicitudBaja.hasError, (solicitudBaja.hasError) ? solicitudBaja.message : solicitudBaja.result.message, (solicitudBaja.hasError) ? ERROR : SUCCESS, body);
	}
	private static Response sendSolicitudCambioSegmento (String recordId) {
		parser = new Parser(caso, userNick, files, notas, usuario);
		body = parser.parseCambioDeSegmentoBody();
		WSCaseEnviarASSHelper.Response resp = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, SOLICITUDES_AFILIADOS, 'cambio-segmento');
		if(!resp.hasError) {
			processResponse(resp, caso, files, true, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, (resp.hasError) ? ERROR : SUCCESS, body);
	}
	private static Response sendInterfazFinanciera (String recordId) {
		parser = new Parser(caso, userNick, files, notas, usuario);
		body = parser.parseInterfazFinanciera();
		WSCaseEnviarASSHelper.Response resp = (WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, SOLICITUDES_AFILIADOS, 'interfaz-financiera');
		if(!resp.hasError) {
			processResponse(resp, caso, files, true, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, (resp.hasError) ? ERROR : SUCCESS, body);
	}
	private static Response sendSolicitudCambioCredencial (String recordId) {
		Map<String, Object> simpleMap = new Map<String, Object> {
			'afi_codigo' => caso.Codigo_de_asociado__c
		};
		String body = JSON.serialize(simpleMap);
		WSCaseEnviarASSHelper.Response resp = (WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, SOLICITUDES_AFILIADOS, 'reemision-credencial');
		if(resp.hasError) {
			caso.Error__c = resp.message;
			caso.Status = 'En proceso';
			update caso;
		} else {
			caso.Error__c = '';
			caso.Estado_de_solicitud__c = 'TRANSFORMADA';
			caso.Status = 'En proceso';
			update caso;
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, (resp.hasError) ? ERROR : SUCCESS, body);
	}
	private static Response sendSolicitudCambioPlan (String recordId) {
		parser = new Parser(caso, userNick, files, notas, usuario);
		body = parser.parseCambioPlanBody();
		WSCaseEnviarASSHelper.Response resp = (WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, SOLICITUDES_AFILIADOS, 'cambio-plan');
		if(!resp.hasError) {
			processResponse(resp, caso, files, true, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, (resp.hasError) ? ERROR : SUCCESS, body);
	}
	private static Response sendSolicitudDatosParticulares () {
		parser = new Parser(caso, userNick, usuario);
		body = parser.parseDatosParticularesBody();
		WSCaseEnviarASSHelper.Response resp = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, SOLICITUDES_AFILIADOS, 'datos-particulares');
		if(!resp.hasError) {
			processResponse(resp, caso, files, true, isAttachmentResend);
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, (resp.hasError) ? ERROR : SUCCESS, body);
	}
	/** Processors */
	private static void processResponse (WSCaseEnviarASSHelper.Response resp,
										Case caso, List<ContentVersion> files,
										Boolean switchToInProgress,
										Boolean isAttachmentResend) {
		if(!isAttachmentResend) {
			WSSSGenericResponse.Data data =  resp.result.data.get(0);
			caso.Estado_de_solicitud__c = data.estado_sol;
			caso.Estado_DDJJ__c = data.estado_dj;
			caso.Nro_de_solicitud_SS__c = data.solafi_id;
			if(switchToInProgress) {
				caso.Status = 'En proceso';
			}
			Database.update(caso);
			processNotas(data.notas);
		}
		processFiles(files);
	}
	private static void processFiles (List<ContentVersion> files) {
		List<ContentVersion> filesToUpdate = new List<ContentVersion>();
		for(ContentVersion file : files) {
			ContentVersion updateVersion = new ContentVersion(Id = file.Id, Enviado__c = true);
			filesToUpdate.add(updateVersion);
		}
		Database.SaveResult[] results = Database.update(filesToUpdate, false);
	}
	private static void processNotas (List<WSSSGenericResponse.Notas> notasDeAuditoria) {
		List<Nota_de_Auditoria__c> notasAActualizar = new List<Nota_de_Auditoria__c>();
		for(WSSSGenericResponse.Notas nota : notasDeAuditoria) {
			notasAActualizar.add(new Nota_de_Auditoria__c(Id = nota.sf_id, Id_externo_solicitudes__c = nota.nota_id, Nota__c = nota.texto_nota));
		}
		Database.upsert(notasAActualizar, false);
	}
	/** Utils */
	private static  List<ContentDocumentLink> getContentDocumentLinks (String recordId) {
		List<EmailMessage> emailMessagesCase = [SELECT Id FROM EmailMessage WHERE ParentId = :recordId];
		return [SELECT ContentDocumentId, Id
				FROM ContentDocumentLink
				WHERE LinkedEntityId = :recordId
				OR LinkedEntityId IN :emailMessagesCase];
	}
	private static Case getCaseInfo (String recordId) {
		return [SELECT Account.Afi_Id_del_Titular__c,
					Account.Agencia_codigo__c,
					Account.Codigo_de_Afiliado__c,
					Account.CUIT__c,
					Agencia_destino__r.codigo_de_delegacion__c,
					Agrupacion1__c,
					Agrupacion3__c,
					Apellido__c,
					Aporte__c,
					Bebe_sin_DNI__c,
					Borrar_tarjeta_debito_o_cobro_por_CBU__c,
					Calle__c,
					CBU__c,
					Cdigo_debito_por_ACA__c,
					Codigo_de_asociado__c,
					Codigo_Empleador__c,
					Condicion_IVA__c,
					Cuil__c,
					CUIL_del_CBU__c,
					Cuit__c,
					CUIT_CUIL_Titular_CBU__c,
					Cuit_empleador__c,
					Delegacion__r.Codigo_de_delegacion__c,
					Deriva_aportes__c,
					Discapacidad__c,
					DNI__c,
					Dpto__c,
					Empleador__c,
					Empleador__r.Codigo_de_empresa__c,
					Empleador__r.Cuit__c,
					Empleador__r.Name,
					Envio_de_recibo__c,
					Estado_civil__c,
					Estado_DDJJ__c,
					Fecha_de_nacimiento__c,
					Fecha_de_vigencia__c,
					Id,
					Localidad__r.Loc_id__c,
					Medio_de_cobro__c,
					Motivo_de_baja__c,
					Nacionalidad__c,
					Nombre__c,
					Nro_de_solicitud_SS__c,
					Nuevo_segmento__c,
					Numero__c,
					Numero_CBU__c,
					Numero_CBU_cobro_de_cuota__c,
					Numero_de_tarjeta_de_credito__c,
					Obra_social2__r.Codigo_de_delegacion__c,
					Obra_social2__r.Codigo_de_obra_social__c,
					Piso__c,
					Plandespegue__c,
					Razon_social__c,
					RecordTypeId,
					Segmento_de_grupo_familiar__c,
					Sexo__c,
					SuppliedEmail,
					Tarjeta_de_credito__c,
					Telefono__c,
					Tipo__c,
					Tipo_CBU__c,
					Tipo_de_debito_por_ACA__c,
					Tipo_de_parentesco__c,
					Tipo_dni__c,
					Titular__r.Codigo_de_Afiliado__c,
					Type
				FROM Case WHERE Id =: recordId];
	}
	private static List<Nota_de_Auditoria__c> getNotas (String recordId) {
		return [SELECT id, Nota__c, CreatedBy.CommunityNickname
				FROM Nota_de_Auditoria__c
				WHERE APr_Id__c =:recordId
					AND (Id_externo_solicitudes__c = null
						OR Id_externo_solicitudes__c = '')];
	}
	private static List<Nota_de_Auditoria__c> getNotas (Set<Id> integrantesIds) {
		return [SELECT id, Integrante__c, Nota__c, CreatedBy.CommunityNickname
				FROM Nota_de_Auditoria__c
				WHERE Integrante__c
					IN : integrantesIds
					AND (Id_externo_solicitudes__c = null
						OR Id_externo_solicitudes__c = '')
				];
	}
	private static List<Integrante_caso__c> getIntegrantes (String recordId) {
		return [SELECT Apellido__c,
			Aportes__c,
			Cuit_empleador__c,
			CUIT_Sin_guiones__c,
			Discapacitado__c,
			Empleador__r.Codigo_de_empresa__c,
			Empleador__r.Cuit__c,
			Empleador__r.Name,
			Estado_Civil__c,
			Familiar__r.Codigo_de_Afiliado__c,
			Fecha_de_Nacimiento__c,
			Id,
			Indicador_de_aporte__c,
			Integrante_tipo_asociado__c,
			Motivo_de_baja__c,
			Nacionalidad__c,
			Nombre__c,
			Nro_de_documento__c,
			Numero_de_solicitud__c,
			Obra_social_actual__r.Codigo_de_obra_social__c,
			Razon_social__c,
			RecordTypeId,
			Sexo__c,
			Tipo_de_Documento__c,
			Tipo_de_relacion_con_titular__c
		FROM Integrante_caso__c
		WHERE Caso__c =: recordId];
	}
	public class Response Extends FrontResponse {
		@AuraEnabled public String generatedBody;
		public Response(Boolean hasError, String message, String status, String generatedBody) {
			this.hasError = hasError;
			this.auraMessage = new auraMessage(message, status);
			this.generatedBody = generatedBody;
		}
	}
}