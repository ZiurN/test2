public without sharing class SegmentoAltaBtnCtrl {
    @AuraEnabled
    public static BasicResponse createSegmento(String segmentId) {
        Segmentos__c seg = [
                SELECT Semid__c, Evento_Medico__r.Efector_Solicitante__r.Codigo_de_efector__c, Fecha_Inicio_tentativa__c,
                        Evento_Medico__r.Nro_de_Evento_Medico_SS__c, Fecha_Fin_tentativa__c, Evento_Medico__c, 
						Evento_Medico__r.RecordTypeId
                FROM Segmentos__c
                WHERE Id =: segmentId
        ];
		String rtIdEMI = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;
		
        //---------------------------------------------------------------------
        String body = generateJSON(seg);
        System.debug('BODY SEGMENTO:  ' + body);
        //---------------------------------------------------------------------
        WSSegmentoAlta.Response resp = WSSegmentoAlta.crearSegmento(seg.Evento_Medico__r.Nro_de_Evento_Medico_SS__c, body);
        if (!resp.hasError) {
            for(WSSegmentoEliminarResp.Segmento segWs : resp.result.data.em.segmento) {
                if(segmentId == segWs.aca_nro_sf) {
                    seg.Semid__c = segWs.sem_id;
                    seg.Fecha_Inicio_real__c = segWs.fecha_real_desde != null
                            ? Datetime.parse(segWs.fecha_real_desde.replace('-', '/')) : null;
                    seg.Fecha_Fin_real__c = segWs.fecha_real_hasta != null
                            ? Datetime.parse(segWs.fecha_real_hasta.replace('-', '/')) : null;
                }
            }

			if(seg.Evento_Medico__r.RecordTypeId == rtIdEMI) {
				attachPDF(resp.result.data.em, seg.Evento_Medico__c);
			}

            Database.SaveResult result = Database.update(seg);
			System.debug('****result: ' + result);

            String errorMsg = 'Segmento creado exitosamente';
            if(!result.isSuccess()){
                errorMsg = '';
                for(Database.Error err : result.getErrors()){
                    errorMsg = err.message + '\n';
                }
            }

            return new BasicResponse(!result.isSuccess(), errorMsg);
        }

        return new BasicResponse(true, resp.message);

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

    public static String generateJSON(Segmentos__c segmento){
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

    //public class Response {
        //@AuraEnabled public Boolean hasError;
        //@AuraEnabled public String message;

        //public Response(Boolean hasError, String message){
            //this.hasError = hasError;
            //this.message = message;
        //}
    //}
}