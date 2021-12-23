@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class ContentDocumentTriggerHelper {
	private static User usuario = [SELECT Id, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
	private static Boolean userIsAdmin = usuario.Profile.Name != 'Administrador del sistema' || usuario.Profile.Name != 'System Administrator';
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para evitar borrado de CD relacionados a Oportunidades ya enviados a SS.
	@param			oldMapTrigger - Mapa de los CD a borrar por su Id.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void avoidDeleteSentOpportunityFiles(Map<Id, ContentDocument> oldMapTrigger) {
		for(ContentDocument cd : [SELECT Id, (
									SELECT LinkedEntityId
									FROM ContentDocumentLinks
									WHERE LinkedEntity.Type = 'Opportunity'
										AND LinkedEntity.RecordType.DeveloperName != 'Corporativo'
									)
								FROM ContentDocument
								WHERE Id IN :oldMapTrigger.keyset()]) {
			if(!cd.ContentDocumentLinks.isEmpty() && userIsAdmin) {
				oldMapTrigger.get(cd.Id).addError(System.Label.Alerta_ArchivoDeOportunidad);
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@descriptio
	@param			contentNoteIds -
	------------------------------------------------------------------------------------------------------------------------*/
	public static void copyTheLastContentNoteToNotaFieldInLead(Id[] contentNoteIds) {
		Map<Id, Id> leadIdByContentNoteId = new Map<Id, Id>();
		Lead[] leadsToUpdate = new List<Lead>();
		for(ContentDocument cd : [SELECT Id,
									(SELECT Id, LinkedEntityId
									FROM ContentDocumentLinks
									WHERE LinkedEntity.Type = 'Lead')
								FROM ContentDocument
								WHERE Id IN :contentNoteIds]) {
			if(!cd.ContentDocumentLinks.isEmpty()) {
				leadIdByContentNoteId.put(cd.Id, cd.ContentDocumentLinks[0].LinkedEntityId);
			}
		}
		Lead[] leadsWithAttachedContentNotes = [SELECT Id,
													Nota__c,
													(SELECT
														id,
														TextPreview,
														FileType,
														CreatedDate
													FROM AttachedContentNotes
													ORDER BY CreatedDate DESC)
												FROM Lead
												WHERE Id IN :leadIdByContentNoteId.values()];
		for(Lead cand : leadsWithAttachedContentNotes) {
			if(cand.AttachedContentNotes.size() == 1 && cand.Nota__c != null) {
				cand.Nota__c = null;
				leadsToUpdate.add(cand);
			}
			// si es distinto de null, la ultima nota adjunta es la que se esta eliminando
			else if(leadIdByContentNoteId.get(cand.AttachedContentNotes[0].Id) != null
					&& cand.Nota__c != cand.AttachedContentNotes[1].TextPreview) {
				cand.Nota__c = cand.AttachedContentNotes[1].TextPreview;
				leadsToUpdate.add(cand);
			}
		}
		update leadsToUpdate;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para evitar borrar archivos asociados a los casos en la lista de RT.
	@param			oldMapTrigger - Mapa de los CD a borrar por su Id.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void avoidDeleteSentSalesCaseFiles(Map<Id, ContentDocument> oldMapTrigger) {
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
		List<ContentDocument> contentDocuments = [SELECT Id,
														(
														SELECT LinkedEntityId
														FROM ContentDocumentLinks
														WHERE LinkedEntity.Type = 'Case'
															AND LinkedEntity.RecordType.DeveloperName IN :RECORD_TYPES
													)
												FROM ContentDocument
												WHERE Id IN :oldMapTrigger.keyset()];
		Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId = new Map<Id, List<ContentDocumentLink>>();
		for(ContentDocument cd : contentDocuments) {
			contentDocumentLinksByContentDocumentId.put(cd.Id, ContentDocumentLinks);
			for(ContentDocumentLink cdl : cd.ContentDocumentLinks) {
				caseIds.add(cdl.LinkedEntityId);
			}
		}
		Map<Id, List<ContentDocumentLink>> filteredCDLinksByContentDocumentId = filteredContentDocuments(contentDocumentLinksByContentDocumentId, caseIds);
		for (Id contentDocumentId : filteredCDLinksByContentDocumentId.keySet()) {
			if (filteredCDLinksByContentDocumentId.get(contentDocumentId).isEmpty() && userIsAdmin) {
				Trigger.oldMap.get(cd.Id).addError(System.Label.Alerta_ArchivoEnviadoASS);
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para evitar borrar archivos asociados a los casos en la lista de RT.
	@param			oldMapTrigger - Mapa de los CD a borrar por su Id.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void avoidDeletionOfSentFiles(List<ContentDocument> contentDocuments) {
		Map<Id, ContentDocument> cdById = new Map<Id, ContentDocument>();
		Set<Id> cdIds = new Set<Id>();
		List<String> titles = new List<String>();
		for(ContentDocument cd : contentDocuments) {
			titles.add(cd.Title);
			cdIds.add(cd.Id);
			cdById.put(cd.Id, cd);
		}
		List<ContentDocumentLink> cdls = [SELECT Id,
											ContentDocument.Title,
											LinkedEntityId,
											ContentDocumentId
										FROM ContentDocumentLink
										WHERE ContentDocumentId IN :cdIds];
		Map<Id, ContentDocumentLink> cdlByLinkedEntityId = new Map<Id, ContentDocumentLink>();
		for(ContentDocumentLink cdl : cdls) {
			cdlByLinkedEntityId.put(cdl.LinkedEntityId, cdl);
		}
		List<Archivo_url__c> archivosUrls = [SELECT Id,
												Enviado__c,
												Name,
												Caso__c,
												Evento_Medico__c,
												Oportunidad__c
											FROM Archivo_url__c
											WHERE (Caso__c IN :cdlByLinkedEntityId.keyset()
													OR Evento_Medico__c IN :cdlByLinkedEntityId.keyset()
													OR Oportunidad__c IN :cdlByLinkedEntityId.keyset())
												AND Nombre_original__c IN :titles];
		List<Archivo_url__c> cantDelete = new List<Archivo_url__c>();
		for(Archivo_url__c fileToDelete : archivosUrls) {
			if(fileToDelete.Enviado__c) {
				cantDelete.add(fileToDelete);
			}
		}
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
			cd.addError(System.Label.Alerta_ArchivoEnviadoASS2);
		}
	}
	/** Utils */
	private static Map<Id, List<ContentDocumentLink>> filteredContentDocuments (Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId,
																				Set<Id> caseIds) {
		Map<Id, List<ContentDocumentLink>> filteredMap = new Map<Id, List<ContentDocumentLink>>();
		for (Id contentDocId : contentDocumentLinksByContentDocumentId.keySet()) {
			filteredMap.put(contentDocId, new List<ContentDocumentLink>());
			List<ContentDocumentLink> cDLinkList = contentDocumentLinksByContentDocumentId.get(contentDocId);
			if (cDLinkList != null && !cDLinkList.isEmpty()) {
				for (ContentDocumentLink cdLink : cDLinkList) {
					if (caseIds.containsKey(cdLink.LinkedEntityId)) {
						filteredMap.get(contentDocId).add(cdLink);
					}
				}
			}
		}
		return filteredMap;
	}
}