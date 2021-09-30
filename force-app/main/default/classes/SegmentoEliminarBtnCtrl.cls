public without sharing class SegmentoEliminarBtnCtrl {
    @AuraEnabled
    public static Response deleteSegmento(String segmentId) {

        if(segmentId == null) {
            return new Response(true, 'El id externo está vacío');
        }

        List<Segmentos__c> segmentList = [
                SELECT Semid__c, Evento_Medico__r.Nro_de_Evento_Medico_SS__c, Creado_Automaticamente__c,
                        Segmento_actual__c, Evento_Medico__c, Evento_Medico__r.RecordTypeId
                FROM Segmentos__c
                WHERE Semid__c =: segmentId
        ];
		String rtIdEMI = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;
//        if (seg.Creado_Automaticamente__c || !seg.Segmento_actual__c) {
//            String message = '';
//            if(seg.Creado_Automaticamente__c) {
//                message += '- No se puede eliminar porque fue creado automáticamente con el evento médico\n';
//            }
//            if(!seg.Segmento_actual__c) {
//                message += '- No se puede eliminar porque no es el segmento actual\n';
//            }
//            return new Response(true, message);
//        }
		User usuario = [SELECT CommunityNickname, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
		String body = JSON.serialize(new Map<String, Object> {'usuario' => usuario.CommunityNickname.toUpperCase()});
		System.debug('****body' + body);
		
        WSSegmentoEliminar.Response resp = WSSegmentoEliminar.eliminarSegmento(
                segmentList[0].Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
                segmentId,
                body
        );
        if (!resp.hasError) {
			
			if(segmentList[0].Evento_Medico__r.RecordTypeId == rtIdEMI) {
				attachPDF(resp.result.data.em, segmentList[0].Evento_Medico__c);
			}

            Database.DeleteResult result = Database.delete(segmentList[0]);
            String errorMsg = 'Segmento eliminado exitosamente';
            if(!result.isSuccess()){
                errorMsg = '';
                for(Database.Error err : result.getErrors()){
                    errorMsg = err.message + '\n';
                }
            }

            return new Response(!result.isSuccess(), errorMsg);
        }

        return new Response(true, resp.message);

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

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message){
            this.hasError = hasError;
            this.message = message;
        }
    }
}