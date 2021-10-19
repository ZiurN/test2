public class ContentDocumentTriggerHelper {
	public static void avoidDeleteSentOpportunityFiles(Map<Id, ContentDocument> oldMapTrigger) {
		User usuario = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		
		for(ContentDocument cd : [
			SELECT Id, ( 
					SELECT LinkedEntityId 
					FROM ContentDocumentLinks 
					WHERE LinkedEntity.Type = 'Opportunity' AND LinkedEntity.RecordType.DeveloperName != 'Corporativo'
				)
				//(SELECT Enviado__c FROM ContentVersions WHERE Enviado__c = true)
			FROM ContentDocument 
			WHERE Id IN :oldMapTrigger.keyset()
		]) {
			//if(!cd.ContentDocumentLinks.isEmpty() && !cd.ContentVersions.isEmpty()) {
			if(!cd.ContentDocumentLinks.isEmpty() && usuario.Profile.Name != 'Administrador del sistema') {
				Trigger.oldMap.get(cd.Id).addError('No se pueden eliminar archivos de oportunidades');
			}

		}
	}

	public static void copyTheLastContentNoteToNotaFieldInLead(Id[] contentNoteIds) {
		Map<Id, Id> leadIdByContentNoteId = new Map<Id, Id>();
		Lead[] leadsToUpdate = new List<Lead>(); 

		for(ContentDocument cd : [
			SELECT Id, 
				(SELECT Id, LinkedEntityId FROM ContentDocumentLinks WHERE LinkedEntity.Type = 'Lead') 
			FROM ContentDocument
			WHERE Id IN :contentNoteIds
		]) {
			if(!cd.ContentDocumentLinks.isEmpty()) {
				leadIdByContentNoteId.put(cd.Id, cd.ContentDocumentLinks[0].LinkedEntityId);
			}
		}

		Lead[] leadsWithAttachedContentNotes = [
			SELECT Id, Nota__c, (SELECT id, TextPreview, FileType, CreatedDate FROM AttachedContentNotes ORDER BY CreatedDate DESC) 
			FROM Lead 
			WHERE Id IN :leadIdByContentNoteId.values()
		];
			
		System.debug('****leadsWithAttachedContentNotes: ' + leadsWithAttachedContentNotes);

		for(Lead cand : leadsWithAttachedContentNotes) {
			System.debug('****cand.AttachedContentNotes[0].Id: ' + cand.AttachedContentNotes[0].Id);
			System.debug('****cand.AttachedContentNotes[0].TextPreview: ' + cand.AttachedContentNotes[0].TextPreview);

			if(cand.AttachedContentNotes.size() == 1 && cand.Nota__c != null) {
				cand.Nota__c = null;

				leadsToUpdate.add(cand);
			}
			// si es distinto de null, la ultima nota adjunta es la que se esta eliminando
			else if(leadIdByContentNoteId.get(cand.AttachedContentNotes[0].Id) != null 
					&& cand.Nota__c != cand.AttachedContentNotes[1].TextPreview
			) {
				cand.Nota__c = cand.AttachedContentNotes[1].TextPreview;

				leadsToUpdate.add(cand);
			}

		}

		update leadsToUpdate;
	}

	public static void avoidDeleteSentSalesCaseFiles(Map<Id, ContentDocument> oldMapTrigger) {
		User usuario = [
            SELECT Id, Profile.Name 
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
        
		String[] RECORD_TYPES = new List<String>{
			'Solicitud_de_alta_familiar',
			'Solicitud_de_segmento',
			'Solicitud_de_cambio_de_plan',
			'Solicitud_de_baja',
			'Interfaz_financiera',
			'Solicitud_de_despegues',
			'Solicitud_de_datos_particulares'
		};
		Set<Id> caseIds = new Set<Id>();
		
		for(ContentDocument cd : [
			SELECT Id, ( 
					SELECT LinkedEntityId 
					FROM ContentDocumentLinks 
					WHERE LinkedEntity.Type = 'Case' AND LinkedEntity.RecordType.DeveloperName IN :RECORD_TYPES
				)
			FROM ContentDocument 
			WHERE Id IN :oldMapTrigger.keyset()
		]) {
			for(ContentDocumentLink cdl : cd.ContentDocumentLinks) {
				caseIds.add(cdl.LinkedEntityId);
			}
		}

		Case[] casesSentToSS = [
			SELECT Id 
			FROM Case 
			WHERE Id IN :caseIds 
				AND Nro_de_solicitud_SS__c != null
		];

		for(ContentDocument cd : [
			SELECT Id, (SELECT LinkedEntityId FROM ContentDocumentLinks WHERE LinkedEntityId IN :casesSentToSS)
			FROM ContentDocument 
			WHERE Id IN :oldMapTrigger.keyset()
		]) {
			
			if(!cd.ContentDocumentLinks.isEmpty() && usuario.Profile.Name != 'Administrador del sistema') {
				Trigger.oldMap.get(cd.Id).addError('No se pueden eliminar archivos si el caso ya fue enviado a Salud Soft');
			}
			
		}
	}
	
	public static void avoidDeletionOfSentFiles(List<ContentDocument> contentDocuments) {
		Map<Id, ContentDocument> cdById = new Map<Id, ContentDocument>();
		Set<Id> cdIds = new Set<Id>();
		List<String> titles = new List<String>();
		for(ContentDocument cd : contentDocuments) {
			titles.add(cd.Title);
			cdIds.add(cd.Id);
			cdById.put(cd.Id, cd);
		}

		List<ContentDocumentLink> cdls = [
			SELECT Id, ContentDocument.Title, LinkedEntityId, ContentDocumentId
			FROM ContentDocumentLink
			WHERE ContentDocumentId IN :cdIds
		];
		System.debug('****cdls: ' + cdls);

		Map<Id, ContentDocumentLink> cdlByLinkedEntityId = new Map<Id, ContentDocumentLink>();
		for(ContentDocumentLink cdl : cdls) {
			cdlByLinkedEntityId.put(cdl.LinkedEntityId, cdl);
		}

		List<Archivo_url__c> archivosUrls = [
			SELECT Id, Enviado__c, Name, Caso__c, Evento_Medico__c, Oportunidad__c
			FROM Archivo_url__c
			WHERE (Caso__c IN :cdlByLinkedEntityId.keyset()
					OR Evento_Medico__c IN :cdlByLinkedEntityId.keyset()
					OR Oportunidad__c IN :cdlByLinkedEntityId.keyset())
				AND Nombre_original__c IN :titles
		];

		System.debug('****archivosUrls: ' + archivosUrls);

		List<Archivo_url__c> cantDelete = new List<Archivo_url__c>();
		for(Archivo_url__c fileToDelete : archivosUrls) {
			if(fileToDelete.Enviado__c) {
				cantDelete.add(fileToDelete);
			}
		}

		System.debug('****cantDelete: ' + cantDelete);
		List<ContentDocument> cdToAddError = new List<ContentDocument>();
		for(Archivo_url__c file : cantDelete) {
			if(String.isNotBlank(file.Caso__c)) {
				cdToAddError.add(cdById.get(cdlByLinkedEntityId.get(file.Caso__c).ContentDocumentId));
			}
			else if(String.isNotBlank(file.Evento_Medico__c)) {
				cdToAddError.add(cdById.get(cdlByLinkedEntityId.get(file.Evento_Medico__c).ContentDocumentId));
			}
			else if(String.isNotBlank(file.Oportunidad__c)) {
				cdToAddError.add(cdById.get(cdlByLinkedEntityId.get(file.Oportunidad__c).ContentDocumentId));
			}
		}

		for(ContentDocument cd : cdToAddError) {
			cd.addError('No se puede eliminar el archivo, ya fue enviado a SaludSoft');
		}
	}
}