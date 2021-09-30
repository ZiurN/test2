public without sharing class SegmentoQueueable implements Queueable, Database.AllowsCallouts {
	List<Segmentos__c> segmentos;
    Boolean esActualizacion;

	public SegmentoQueueable(List<Segmentos__c> segmentosList, Boolean isUpdate) {
		segmentos = segmentosList;
        esActualizacion = isUpdate;
	}

	public void execute(QueueableContext context) {
        System.debug('segmentos: ' + segmentos);
		if(!segmentos.isEmpty()) {
            Segmentos__c segmento = segmentos.remove(0);
            if(!esActualizacion) {
                System.debug('****crearSegmento');
                createSegmento(segmento.Id);
            }
            else {
                System.debug('****actualizarSegmento');
                actualizarSegmento(segmento.Semid__c);
            }

			if(!segmentos.isEmpty()){
				System.enqueueJob(new SegmentoQueueable(segmentos, esActualizacion));
			}
		}
	}

    private static void createSegmento(String segmentId) {
        Segmentos__c seg = [
                SELECT Semid__c, Evento_Medico__r.Efector_Solicitante__r.Codigo_de_efector__c, Fecha_Inicio_tentativa__c,
                        Evento_Medico__r.Nro_de_Evento_Medico_SS__c, Fecha_Fin_tentativa__c, Evento_Medico__c, 
						Evento_Medico__r.RecordTypeId, Numero_del_segmento__c, Fecha_Inicio_real__c, Fecha_Fin_real__c, 
                        Error_en_SS__c, Segmento_actual__c
                FROM Segmentos__c
                WHERE Id =: segmentId
        ];
		String rtIdEMI = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;

		System.debug('****seg: ' + seg);

		Evento_Medico__c em = [
			SELECT Id, Fecha_y_Hora_inicio_EMS__c, Fecha_y_hora_fin_ems__c, Forma_de_egreso__c  
			FROM Evento_Medico__c
			WHERE Id =: seg.Evento_Medico__c
		];
		System.debug('****em: ' + em);
		
        //---------------------------------------------------------------------
        String body = generateJSONFromCreate(seg);
        System.debug('BODY SEGMENTO:  ' + body);
        //---------------------------------------------------------------------
        WSSegmentoAlta.Response resp = WSSegmentoAlta.crearSegmento(seg.Evento_Medico__r.Nro_de_Evento_Medico_SS__c, body);
        if (!resp.hasError) {
            for(WSSegmentoEliminarResp.Segmento segWs : resp.result.data.em.segmento) {
                if(segmentId == segWs.aca_nro_sf) {
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
				attachPDF(resp.result.data.em, seg.Evento_Medico__c);
			}

            Database.SaveResult result = Database.update(seg);
			System.debug('****result: ' + result);

            String errorMsg = '';
            if(!result.isSuccess()){
                errorMsg = '';
                for(Database.Error err : result.getErrors()){
                    errorMsg = err.message + '\n';
                }
                seg.Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + errorMsg + '</p>';
                update seg;
                System.debug('error! ' + errorMsg);
            }
            else {
                seg.Error_en_SS__c = '';
                update seg;
                System.debug('No hay error');
            }
            // return new BasicResponse(!result.isSuccess(), errorMsg);
        }
        else {
            seg.Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + resp.message + '</p>';
            update seg;
            System.debug('error! ' + resp.message);
        }

        seg = [
                SELECT Semid__c, Evento_Medico__r.Efector_Solicitante__r.Codigo_de_efector__c, Fecha_Inicio_tentativa__c,
                        Evento_Medico__r.Nro_de_Evento_Medico_SS__c, Fecha_Fin_tentativa__c, Evento_Medico__c, 
						Evento_Medico__r.RecordTypeId, Numero_del_segmento__c, Fecha_Inicio_real__c, Fecha_Fin_real__c, 
                        Error_en_SS__c, Segmento_actual__c
                FROM Segmentos__c
                WHERE Id =: segmentId
        ];

        System.debug('****em BEFORE: ' + em);

        if(seg.Fecha_Inicio_real__c != null && seg.Numero_del_segmento__c == 1 && em.Fecha_y_Hora_inicio_EMS__c != seg.Fecha_Inicio_real__c
            && String.isBlank(seg.Error_en_SS__c
        )) {
            em.Fecha_y_Hora_inicio_EMS__c = seg.Fecha_Inicio_real__c;
            System.debug('****em IN 1ST IF: ' + em);
        }
        if(seg.Segmento_actual__c && seg.Fecha_Fin_real__c == null && seg.Fecha_Fin_tentativa__c != null && String.isBlank(seg.Error_en_SS__c)
        ) {
            em.Fecha_y_hora_fin_ems__c = seg.Fecha_Fin_tentativa__c;
            System.debug('****em IN 2ND IF: ' + em);
        }
        if(seg.Segmento_actual__c && seg.Fecha_Fin_real__c != null && seg.Fecha_Fin_real__c >= em.Fecha_y_Hora_inicio_EMS__c
            && String.isBlank(em.Forma_de_egreso__c) && String.isBlank(seg.Error_en_SS__c)
        ) {
            em.Fecha_y_hora_fin_ems__c = seg.Fecha_Fin_real__c;
            System.debug('****em IN 3RD IF: ' + em);
        }

        System.debug('****em AFTER: ' + em);
        update em;
        // return new BasicResponse(true, resp.message);
    }

    private static void actualizarSegmento(String segmentoId) {
        String body;
        List<Segmentos__c> segList = [
                SELECT Semid__c, Fecha_Inicio_real__c, Fecha_Fin_real__c, Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
                    Evento_Medico__r.Fecha_y_Hora_inicio_EMS__c, Evento_Medico__c, Evento_Medico__r.RecordTypeId, 
                    Numero_del_segmento__c, Error_en_SS__c, Segmento_actual__c, Fecha_Fin_tentativa__c
                FROM Segmentos__c
                WHERE Semid__c =: segmentoId
        ];
        if(segList.isEmpty()) {
            return;
        }
		String rtIdEMI = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;

		System.debug('****segList[0]: ' + segList[0]);

		Evento_Medico__c em = [
			SELECT Id, Fecha_y_Hora_inicio_EMS__c, Fecha_y_hora_fin_ems__c, Forma_de_egreso__c  
			FROM Evento_Medico__c
			WHERE Id =: segList[0].Evento_Medico__c
		];
		System.debug('****em: ' + em);

        body = generateJSONFromUpdate(segList[0]);
        WSSegmentoActualizar.Response resp = WSSegmentoActualizar.actualizarSegmento(
                segList[0].Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
                segmentoId,
                body
        );

        if (!resp.hasError) {
            for(WSSegmentoEliminarResp.Segmento wsSegmento : resp.result.data.em.segmento) {
                if(wsSegmento.sem_id == segList[0].Semid__c) {
                    segList[0].Estado__c = wsSegmento.estado;
                }
            }

			if(segList[0].Evento_Medico__r.RecordTypeId == rtIdEMI) {
				attachPDF(resp.result.data.em, segList[0].Evento_Medico__c);
			}

            Database.SaveResult  result = Database.update(segList[0]);
            String errorMsg = 'Segmento actualizado exitosamente';
            if(!result.isSuccess()){
                errorMsg = '';
                for(Database.Error err : result.getErrors()){
                    errorMsg = err.message + '\n';
                }
                segList[0].Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + errorMsg + '</p>';
                update segList[0];
                System.debug('error! ' + errorMsg);
            }
            else {
                segList[0].Error_en_SS__c = '';
                update segList[0];
                System.debug('No hay error');
            }
            // return new BasicResponse(!result.isSuccess(), errorMsg);
        }
        else {
            segList[0].Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + resp.message + '</p>';
            update segList[0];
            System.debug('error! ' + segList[0].Error_en_SS__c);
        }
        // return new BasicResponse(true, resp.message);

        segList = [
            SELECT Semid__c, Fecha_Inicio_real__c, Fecha_Fin_real__c, Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
                    Evento_Medico__r.Fecha_y_Hora_inicio_EMS__c, Evento_Medico__c, Evento_Medico__r.RecordTypeId, 
                    Numero_del_segmento__c, Error_en_SS__c, Segmento_actual__c, Fecha_Fin_tentativa__c
            FROM Segmentos__c
            WHERE Semid__c =: segmentoId
        ];

        System.debug('****em BEFORE: ' + em);

        if(segList[0].Fecha_Inicio_real__c != null && segList[0].Numero_del_segmento__c == 1 && em.Fecha_y_Hora_inicio_EMS__c != segList[0].Fecha_Inicio_real__c
            && String.isBlank(segList[0].Error_en_SS__c)
        ) {
            em.Fecha_y_Hora_inicio_EMS__c = segList[0].Fecha_Inicio_real__c;
            System.debug('****em IN 1ST IF: ' + em);
        }
        if(segList[0].Segmento_actual__c && segList[0].Fecha_Fin_real__c == null && segList[0].Fecha_Fin_tentativa__c != null && String.isBlank(segList[0].Error_en_SS__c)
        ) {
            em.Fecha_y_hora_fin_ems__c = segList[0].Fecha_Fin_tentativa__c;
            System.debug('****em IN 2ND IF: ' + em);
        }
        if(segList[0].Segmento_actual__c && segList[0].Fecha_Fin_real__c != null && segList[0].Fecha_Fin_real__c >= em.Fecha_y_Hora_inicio_EMS__c
            && String.isBlank(em.Forma_de_egreso__c) && String.isBlank(segList[0].Error_en_SS__c)
        ) {
            em.Fecha_y_hora_fin_ems__c = segList[0].Fecha_Fin_real__c;
            System.debug('****em IN 3RD IF: ' + em);
        }

        System.debug('****em AFTER: ' + em);
        update em;
    }

    private static void attachPDF(WSSegmentoEliminarResp.Em emWS, Id emIdSF) {
		String title = emWS.em_id;
		List<ContentDocumentLink> links = [
                SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, 
				ShareType, ContentDocument.FileType, ContentDocument.FileExtension
                FROM ContentDocumentLink
                WHERE LinkedEntityId =: emIdSF AND ContentDocument.Title =: title
        ];

		if(String.isBlank(emWS.link_em)) {
			return;
		}

		if(!links.isEmpty()) {
			
			ContentVersion version = buildPDF(emWS.link_em, emWS.em_id, links[0].ContentDocumentId);
			insert version;

		} else {
			ContentVersion version = buildPDF(emWS.link_em, emWS.em_id, null);
			insert version;
		
			List<ContentVersion> versionsUpdated = [
					SELECT ContentDocumentId
					FROM ContentVersion
					WHERE Id = :version.Id
			];

			links.add(new ContentDocumentLink(
				LinkedEntityId = emIdSF,
				ShareType = 'V',
				ContentDocumentId = versionsUpdated[0].ContentDocumentId
			));

			Database.SaveResult[] resultLinks = Database.insert(links, false);
			System.debug('****resultCDL: ' + resultLinks);
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
        System.debug(segmento.Evento_Medico__r.Efector_Solicitante__r.Codigo_de_efector__c);
		
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
}