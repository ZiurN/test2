public without sharing class SegmentoQueueable implements Queueable, Database.AllowsCallouts {
	List<Segmentos__c> segmentos;
	Map<Id, Segmentos__c> oldSegmentosMap;
	Boolean esActualizacion;
	public SegmentoQueueable(List<Segmentos__c> segmentosList, Boolean isUpdate) {
		segmentos = segmentosList;
		esActualizacion = isUpdate;
	}
	public SegmentoQueueable(List<Segmentos__c> segmentosList, Map<Id, Segmentos__c> oldSegmentosMap, Boolean isUpdate) {
		this.segmentos = segmentosList;
		this.oldSegmentosMap = oldSegmentosMap;
		this.esActualizacion = isUpdate;
	}
	public void execute(QueueableContext context) {
		if(!segmentos.isEmpty()) {
			Segmentos__c segmento = segmentos.remove(0);
			if(!esActualizacion) {
				createSegmento(segmento.Id);
			}
			else {
				actualizarSegmento(segmento.Semid__c, oldSegmentosMap);
			}
			if(!segmentos.isEmpty()){
				if (esActualizacion) {
					System.enqueueJob(new SegmentoQueueable(segmentos, oldSegmentosMap, esActualizacion));
				} else {
					System.enqueueJob(new SegmentoQueueable(segmentos, esActualizacion));
				}
			}
		}
	}
	private static void createSegmento(String segmentId) {
		List<Segmentos__c> segs = getSegmentoById(segmentId);
		Segmentos__c seg;
		if (segs.isEmpty()) return;
		else seg = segs[0];
		String rtIdEMI = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;
		Evento_Medico__c em = getEventoMedico(seg.Evento_Medico__c);
		String body = generateJSONFromCreate(seg);
		WSSegmentoEnviarASSHelper.Response resp = WSSegmentoEnviarASSHelper.enviarASS(body, 'eventos-medicos', 'eventos-medicos', seg.Evento_Medico__r.Nro_de_Evento_Medico_SS__c);
		if (!resp.hasError) {
			for (WSSSGenericResponse.Segmento segWs : resp.result.data[0].em.segmento) {
				if (segmentId == segWs.aca_nro_sf) {
					seg.Semid__c = segWs.sem_id;
					seg.Fecha_Inicio_real__c = segWs.fecha_real_desde != null
							? EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(segWs.fecha_real_desde)
							: null;
					seg.Fecha_Fin_real__c = segWs.fecha_real_hasta != null
							? EventoMedicoEnviarASSBtnCtrl.parseStringToDateTime(segWs.fecha_real_hasta)
							: null;
				}
			}
			if(seg.Evento_Medico__r.RecordTypeId == rtIdEMI) {
				attachPDF(resp.result.data[0].em, seg.Evento_Medico__c);
			}
			Database.SaveResult result = Database.update(seg);
			String errorMsg = '';
			if(!result.isSuccess()){
				errorMsg = '';
				for(Database.Error err : result.getErrors()){
					errorMsg = err.message + '\n';
				}
				seg.Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + errorMsg + '</p>';
				update seg;
			}
			else {
				seg.Error_en_SS__c = '';
				update seg;
				seg = getSegmentoById(segmentId)[0];
				updateEventoMedico(em, seg);
			}
		}
		else {
			seg = getSegmentoById(segmentId)[0];
			Database.DeleteResult result = Database.delete(seg, false);
			if(!result.isSuccess()){
				String errorMsg = '';
				for(Database.Error err : result.getErrors()){
					errorMsg = err.message + '\n';
				}
				seg.Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + errorMsg + '</p>';
				update seg;
			}
			sendNotificationToUser(segmentId, em.Id, seg.Name);
		}
	}
	private static void actualizarSegmento(String segmentoId, Map<Id, Segmentos__c> oldSegmentosMap) {
		String body;
		List<Segmentos__c> segList = getSegmentosBySemid(segmentoId);
		if(segList.isEmpty()) {
			return;
		}
		String rtIdEMI = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;
		Evento_Medico__c em = getEventoMedico(segList[0].Evento_Medico__c);
		body = generateJSONFromUpdate(segList[0]);
		WSSegmentoEnviarASSHelper.Response resp = WSSegmentoEnviarASSHelper.enviarASS(
			body,
			'eventos-medicos',
			'eventos-medicos',
			segList[0].Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
			segmentoId
		);
		if (!resp.hasError) {
			for(WSSSGenericResponse.Segmento wsSegmento : resp.result.data[0].em.segmento) {
				if(wsSegmento.sem_id == segList[0].Semid__c) {
					segList[0].Estado__c = wsSegmento.estado;
				}
			}
			if(segList[0].Evento_Medico__r.RecordTypeId == rtIdEMI) {
				attachPDF(resp.result.data[0].em, segList[0].Evento_Medico__c);
			}
			Database.SaveResult result = Database.update(segList[0]);
			String errorMsg = 'Segmento actualizado exitosamente';
			if(!result.isSuccess()){
				errorMsg = '';
				for(Database.Error err : result.getErrors()){
					errorMsg = err.message + '\n';
				}
				segList[0].Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + errorMsg + '</p>';
				update segList[0];
			}
			else {
				segList[0].Error_en_SS__c = '';
				update segList[0];
				segList = getSegmentosBySemid(segmentoId);
				updateEventoMedico(em, segList[0]);
			}
			WSSegmentoEnviarASSHelper.fireSSSegmentoResponseEvent(errorMsg, segmentoId, false, false);
		}
		else {
			Segmentos__c segToRevert = segList[0];
			if (oldSegmentosMap != null && oldSegmentosMap.containsKey(segList[0].Id)) {
				segToRevert = oldSegmentosMap.get(segList[0].Id).clone(true);
				segToRevert.Fecha_Inicio_real__c = segToRevert.Fecha_Inicio_real__c == null ? null : segToRevert.Fecha_Inicio_real__c;
				segToRevert.Fecha_Fin_real__c = segToRevert.Fecha_Fin_real__c == null ? null : segToRevert.Fecha_Fin_real__c;
			}
			segToRevert.Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + resp.message + '</p>';
			segToRevert.Revirtiendo_Segmento__c = true;
			update segToRevert;
		}
	}
	private static void attachPDF(WSSSGenericResponse.EventoMedico emWS, Id emIdSF) {
		String title = emWS.em_id;
		List<ContentDocumentLink> links = [SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, 
				ShareType, ContentDocument.FileType, ContentDocument.FileExtension
				FROM ContentDocumentLink
				WHERE LinkedEntityId =: emIdSF AND ContentDocument.Title =: title];
		if(String.isBlank(emWS.link_em)) {
			return;
		}
		if(!links.isEmpty()) {
			ContentVersion version = buildPDF(emWS.link_em, emWS.em_id, links[0].ContentDocumentId);
			insert version;
		} else {
			ContentVersion version = buildPDF(emWS.link_em, emWS.em_id, null);
			insert version;
			List<ContentVersion> versionsUpdated = [SELECT ContentDocumentId
													FROM ContentVersion
													WHERE Id = :version.Id];
			links.add(new ContentDocumentLink(
				LinkedEntityId = emIdSF,
				ShareType = 'V',
				ContentDocumentId = versionsUpdated[0].ContentDocumentId
			));
			Database.SaveResult[] resultLinks = Database.insert(links, false);
		}
	}
	private static ContentVersion buildPDF(String link, String idEm, String cdId){
		ContentVersion version = new ContentVersion();
		String formattedLink = link;
		PageReference pdf = new PageReference(formattedLink);
		Blob pdfBody;
		if(cdId != null) {
			version.ContentDocumentId = cdId;
		}
		version.PathOnClient = '/EM_' + idEm + '.pdf';
		version.origin = 'H';
		version.Title = idEm;
		try {
			pdfBody = pdf.getContentAsPDF();
		} catch (Exception e) {
			pdfBody = Blob.valueOf('No se pudo generar el archivo pdf');
			System.debug(e.getMessage());
		}
		version.VersionData = pdfBody;
		return version;
	}
	public static String generateJSONFromCreate(Segmentos__c segmento){
		String jsonS;
		User usuario = [SELECT CommunityNickname FROM User WHERE Id =: UserInfo.getUserId()];
		jsonS = JSON.serialize(
				new Map<String, Object> {
						'fecha_desde' => segmento.Fecha_Inicio_tentativa__c != null
								? segmento.Fecha_Inicio_tentativa__c.format('dd/MM/yyyy HH:mm:ss') : null,
						'fecha_hasta' => segmento.Fecha_Fin_tentativa__c != null
								? segmento.Fecha_Fin_tentativa__c.format('dd/MM/yyyy HH:mm:ss') : null,
						'numero_sf' => segmento.Id,
						'efector' => segmento.Evento_Medico__r.Efector_Solicitante__r.Codigo_de_efector__c,
						'usuario' => usuario.CommunityNickname.toUpperCase()
				});
		return jsonS;
	}
	public static String generateJSONFromUpdate(Segmentos__c segmento) {
		String jsonS;
		User usuario = [SELECT CommunityNickname FROM User WHERE Id =: UserInfo.getUserId()];
		jsonS = JSON.serialize(
				new Map<String, Object> {
						'fecha_desde' => segmento.Fecha_Inicio_real__c != null
								? segmento.Fecha_Inicio_real__c.format('dd/MM/yyyy HH:mm:ss') : null,
						'fecha_hasta' => segmento.Fecha_Fin_real__c != null
								? segmento.Fecha_Fin_real__c.format('dd/MM/yyyy HH:mm:ss') : null,
						'usuario' => usuario.CommunityNickname.toUpperCase(),
						'numero_sf' => segmento.Id

				});
		return jsonS;
	}
	/** Utils */
	private static List<Segmentos__c> getSegmentoById (String segmentId) {
		return [SELECT Semid__c,
					Name,
					Evento_Medico__r.Efector_Solicitante__r.Codigo_de_efector__c,
					Fecha_Inicio_tentativa__c,
					Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
					Fecha_Fin_tentativa__c,
					Evento_Medico__c,
					Evento_Medico__r.RecordTypeId,
					Numero_del_segmento__c,
					Fecha_Inicio_real__c,
					Fecha_Fin_real__c,
					Error_en_SS__c, Segmento_actual__c
				FROM Segmentos__c
				WHERE Id =: segmentId];
	}
	private static List<Segmentos__c> getSegmentosBySemid (String segmentId) {
		return [SELECT Semid__c,
					Fecha_Inicio_real__c,
					Fecha_Fin_real__c, Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
					Evento_Medico__r.Fecha_y_Hora_inicio_EMS__c,
					Evento_Medico__c,
					Evento_Medico__r.RecordTypeId,
					Numero_del_segmento__c,
					Error_en_SS__c,
					Segmento_actual__c,
					Fecha_Fin_tentativa__c
				FROM Segmentos__c
				WHERE Semid__c =: segmentId];
	}
	private static Evento_Medico__c getEventoMedico (String eventoMedicoId) {
		return [SELECT Id,
					Fecha_y_Hora_inicio_EMS__c,
					Fecha_y_hora_fin_ems__c,
					Forma_de_egreso__c
				FROM Evento_Medico__c
				WHERE Id =: eventoMedicoId];
	}
	private static void updateEventoMedico (Evento_Medico__c em, Segmentos__c seg) {
		if (seg.Fecha_Inicio_real__c != null
			&& seg.Numero_del_segmento__c == 1
			&& em.Fecha_y_Hora_inicio_EMS__c != seg.Fecha_Inicio_real__c
			&& String.isBlank(seg.Error_en_SS__c)) {
			em.Fecha_y_Hora_inicio_EMS__c = seg.Fecha_Inicio_real__c;
		}
		if (seg.Segmento_actual__c
			&& seg.Fecha_Fin_real__c == null
			&& seg.Fecha_Fin_tentativa__c != null
			&& String.isBlank(seg.Error_en_SS__c)) {
			em.Fecha_y_hora_fin_ems__c = seg.Fecha_Fin_tentativa__c;
		}
		if(seg.Segmento_actual__c
			&& seg.Fecha_Fin_real__c != null
			&& seg.Fecha_Fin_real__c >= em.Fecha_y_Hora_inicio_EMS__c
			&& String.isBlank(em.Forma_de_egreso__c)
			&& String.isBlank(seg.Error_en_SS__c)) {
			em.Fecha_y_hora_fin_ems__c = seg.Fecha_Fin_real__c;
		}
		update em;
	}
	@future
	private static void sendNotificationToUser (String segmentoId, String eventoMedicoId, String segName) {
		List<CustomNotificationType> segmentoBorradoNotifs = [SELECT Id
															FROM CustomNotificationType
															WHERE DeveloperName = 'Segmento_Borrado_en_SF'
															LIMIT 1];
		Set<String> usersSet = new Set<String>{UserInfo.getUserId()};
		String notificationId = String.valueOf(segmentoBorradoNotifs[0].Id);
		String targetId = eventoMedicoId;
		String title = 'Error al crear el Segmento ' + segName + ' en SaludSoft';
		String body = 'El segmento ' + segName + ' será borrado en Salesforce';
		XappiaHelper.sendCustomNotification(notificationId, targetId, title, body, usersSet);
	}
}