/**-----------------------------------------------------------------------------------------------------------------------
@author			Matias Molly.
@description	Clase auxiliar para el trigger de Content Document Links.
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ApexCRUDViolation, PMD.AvoidDeeplyNestedIfStmts')
public without sharing class ContentDocumentLinkTriggerHelper {
	public static Boolean canDelete = false;
	private static User usuario = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
	/** Para Email-to-Case */
	private static Map<Id, List<ContentDocumentLink>> cDLinksByParentCaseId = new Map<Id, List<ContentDocumentLink>>();
	private static List<ContentDocumentLink> newDocuments;
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Molly.
	@description	Método para validar que los archivos no se encuentren con nombres duplicados en casos, eventos médidos y
					oportunidades.
	@param			cdlList - Lista de archivos a validar.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void avoidTwoFilesWithTheSameNameInCaseAndEM(List<ContentDocumentLink> cdlList) {
        Set<Id> setDocumentIds = new set<Id>();
        set<Id> setEntitiesIds = new set<Id>();
		set<Id> opportunityIds = new set<Id>();
        for(ContentDocumentLink cdl : cdlList) {
			String strObjPrefix = String.valueOf(cdl.LinkedEntityId).substring(0, 3);
            if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()
				|| strObjPrefix == Evento_medico__c.sObjectType.getDescribe().getKeyPrefix()
			) {
                setDocumentIds.add(cdl.ContentDocumentId);
                setEntitiesIds.add(cdl.LinkedEntityId);
            }
			else if(strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()) {
                setDocumentIds.add(cdl.ContentDocumentId);
                opportunityIds.add(cdl.LinkedEntityId);
            }
        }
		if(setEntitiesIds.isEmpty() && opportunityIds.isEmpty()) {
			return;
		}
		Map<Id, ContentDocument> mapDocuments = new Map<Id, ContentDocument>([
			SELECT Id, Title, FileExtension
			FROM ContentDocument
			WHERE Id IN :setDocumentIds
		]);
        Map<Id, set<String>> mapRecordIdFilenames = new Map<Id, set<String>>();
		Map<Id, Set<Id>> entitiesIdsByContentDocumentId = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> cdsByEntityId = new Map<Id, Set<Id>>();
		if(!opportunityIds.isEmpty()){
			for (ContentDocumentLink cdl : getContentDocumentLinks(opportunityIds, setDocumentIds)) {
				if (!mapRecordIdFilenames.containsKey(cdl.LinkedEntityId)) {
					mapRecordIdFilenames.put(cdl.LinkedEntityId, new set<String>());
				}
				mapRecordIdFilenames.get(cdl.LinkedEntityId).add(cdl.ContentDocument.Title.toUpperCase());

				if (!entitiesIdsByContentDocumentId.containsKey(cdl.ContentDocumentId)) {
					entitiesIdsByContentDocumentId.put(cdl.ContentDocumentId, new Set<Id>());
				}
				entitiesIdsByContentDocumentId.get(cdl.ContentDocumentId).add(cdl.LinkedEntityId);

				if (!cdsByEntityId.containsKey(cdl.LinkedEntityId)) {
					cdsByEntityId.put(cdl.LinkedEntityId, new Set<Id>());
				}
				cdsByEntityId.get(cdl.LinkedEntityId).add(cdl.ContentDocumentId);
			}
			Map<Id, ContentVersion> contentVersionByContentDocument = new Map<Id, ContentVersion>();
			for (ContentVersion cv : getContentVersion(entitiesIdsByContentDocumentId.keySet())) {
				contentVersionByContentDocument.put(cv.ContentDocumentId, cv);
			}
			Map<Id, Set<String>> filesNamesByEntityId = new Map<Id, Set<String>>();
			for(Id entityId : cdsByEntityId.keySet()) {
				for(Id cdId : cdsByEntityId.get(entityId)) {
					if (!filesNamesByEntityId.containsKey(entityId)) {
						filesNamesByEntityId.put(entityId, new Set<String>());
					}
					if(contentVersionByContentDocument.get(cdId).Titulo_original__c != null) {
						filesNamesByEntityId.get(entityId).add(
							contentVersionByContentDocument.get(cdId).Titulo_original__c.toUpperCase()
						);
					}
				}
			}
			for(ContentDocumentLink cdl : cdlList) {
				ContentDocument objCntDoc = mapDocuments.get(cdl.ContentDocumentId);
				if(objCntDoc != null && !String.isBlank(objCntDoc.Title)) {
					set<String> setExistingFilenames = mapRecordIdFilenames.get(cdl.LinkedEntityId);
					Set<String> setTitulosOriginales = filesNamesByEntityId.get(cdl.LinkedEntityId);
					if ((setExistingFilenames != null && setExistingFilenames.contains(objCntDoc.Title.toUpperCase()))
							|| (setTitulosOriginales != null && setTitulosOriginales.contains(objCntDoc.Title.toUpperCase()))) {
						cdl.addError(System.Label.Alerta_YaExisteArchivoMismoNombre);
					}
				}
			}
		}
		if(!setEntitiesIds.isEmpty()){
			for (ContentDocumentLink cdl : getContentDocumentLinks(setEntitiesIds, setDocumentIds)) {
				if (!mapRecordIdFilenames.containsKey(cdl.LinkedEntityId)) {
					mapRecordIdFilenames.put(cdl.LinkedEntityId, new set<String>());
				}
				mapRecordIdFilenames.get(cdl.LinkedEntityId).add(cdl.ContentDocument.Title.toUpperCase());
				if (!entitiesIdsByContentDocumentId.containsKey(cdl.ContentDocumentId)) {
					entitiesIdsByContentDocumentId.put(cdl.ContentDocumentId, new Set<Id>());
				}
				entitiesIdsByContentDocumentId.get(cdl.ContentDocumentId).add(cdl.LinkedEntityId);
				if (!cdsByEntityId.containsKey(cdl.LinkedEntityId)) {
					cdsByEntityId.put(cdl.LinkedEntityId, new Set<Id>());
				}
				cdsByEntityId.get(cdl.LinkedEntityId).add(cdl.ContentDocumentId);
			}
			Map<Id, ContentVersion> contentVersionByContentDocument = new Map<Id, ContentVersion>();
			for (ContentVersion cv : getContentVersion(entitiesIdsByContentDocumentId.keySet())) {
				contentVersionByContentDocument.put(cv.ContentDocumentId, cv);
			}
			Map<Id, Set<String>> filesNamesByEntityId = new Map<Id, Set<String>>();
			for(Id entityId : cdsByEntityId.keySet()) {
				for(Id cdId : cdsByEntityId.get(entityId)) {
					if (!filesNamesByEntityId.containsKey(entityId)) {
						filesNamesByEntityId.put(entityId, new Set<String>());
					}
					if(contentVersionByContentDocument.get(cdId).Titulo_original__c != null) {
						filesNamesByEntityId.get(entityId).add(
							contentVersionByContentDocument.get(cdId).Titulo_original__c.toUpperCase()
						);
					}
				}
			}
			for(ContentDocumentLink cdl : cdlList) {
				ContentDocument objCntDoc = mapDocuments.get(cdl.ContentDocumentId);
				if(objCntDoc != null && !String.isBlank(objCntDoc.Title)) {
					set<String> setExistingFilenames = mapRecordIdFilenames.get(cdl.LinkedEntityId);
					Set<String> setTitulosOriginales = filesNamesByEntityId.get(cdl.LinkedEntityId);
					if ((setExistingFilenames != null && setExistingFilenames.contains(objCntDoc.Title.toUpperCase()))
							|| (setTitulosOriginales != null && setTitulosOriginales.contains(objCntDoc.Title.toUpperCase()))) {
						cdl.addError(System.Label.Alerta_YaExisteArchivoMismoNombre);
					}
				}
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Molly.
	@description	Método para validar que los archivos no sean mas grandes de 3MB.
	@param			cdlList - Lista de archivos a validar.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void avoidFilesLargerThan3MbInCaseAndEM(List<ContentDocumentLink> cdlList) {
		Set<Id> cdIdsFromCaseEMAndOpp = new Set<Id>();
		for(ContentDocumentLink cdl : cdlList) {
			String strObjPrefix = String.valueOf(cdl.LinkedEntityId).substring(0, 3);
			if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()
				|| strObjPrefix == Evento_medico__c.sObjectType.getDescribe().getKeyPrefix()
				|| strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()
			) {
				cdIdsFromCaseEMAndOpp.add(cdl.ContentDocumentId);
			}
		}
		ContentDocument[] cdsFromCaseAndEMLargerThan3Mb = [SELECT Id, ContentSize
															FROM ContentDocument
															WHERE Id IN :cdIdsFromCaseEMAndOpp
																AND ContentSize > 3145728];
		for(ContentDocumentLink cdl : cdlList) {
			for(ContentDocument cd : cdsFromCaseAndEMLargerThan3Mb) {
				if(cd.Id == cdl.ContentDocumentId) {
					cdl.addError(System.Label.Alerta_ArchivoMayor3MB);
				}
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Molly.
	@description	Método para evitar borrar archivos asociados a oportunidades.
	@param			triggerOldMap - Mapa por Id de las versiones antiguas de los archivos a validar.
	@param			opportunityContentDocumentIds - Ids de los archivos a validar.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void avoidDeleteSentOpportunityFiles(Map<Id, ContentDocumentLink> triggerOldMap,
														List<Id> opportunityContentDocumentIds) {
		Map<Id, ContentDocumentLink[]> opportunityDocumentLinksByDocumentIds = new Map<Id, ContentDocumentLink[]>();
		for(ContentDocumentLink cdl : getContentDocumentLinks(opportunityContentDocumentIds)) {
			if(cdl.LinkedEntity.RecordType.DeveloperName != 'Corporativo') {
				if(!opportunityDocumentLinksByDocumentIds.containsKey(cdl.ContentDocumentId)) {
					opportunityDocumentLinksByDocumentIds.put(cdl.ContentDocumentId, new List<ContentDocumentLink>{cdl});
				}
				else {
					ContentDocumentLink[] cdlFromMap = opportunityDocumentLinksByDocumentIds.get(cdl.ContentDocumentId);
					cdlFromMap.add(cdl);
					opportunityDocumentLinksByDocumentIds.put(cdl.ContentDocumentId, cdlFromMap);
				}
			}
		}
		Boolean isAdministrator = (usuario.Profile.Name == 'Administrador del sistema') || (usuario.Profile.Name == 'System Administrator');
		if(!isAdministrator && !canDelete) {
			for(Id cdId : opportunityDocumentLinksByDocumentIds.keySet()) {
				for(ContentDocumentLink cdl : opportunityDocumentLinksByDocumentIds.get(cdId)) {
					triggerOldMap.get(cdl.Id)?.addError(System.Label.Alerta_ArchivoDeOportunidad);
				}
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Molly.
	@description	Método para evitar borrar archivos si ya fueron enviados a SS.
	@param			triggerOldMap - Mapa por Id de las versiones antiguas de los archivos a validar.
	@param			caseContentDocumentIds - Ids de los archivos a validar.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void avoidDeleteSentCaseFiles(Map<Id, ContentDocumentLink> triggerOldMap,
												List<Id> caseContentDocumentIds) {
		String[] RECORD_TYPES = new List<String>{
			'Solicitud_de_alta_familiar',
			'Solicitud_de_segmento',
			'Solicitud_de_cambio_de_plan',
			'Solicitud_de_baja',
			'Interfaz_financiera',
			'Solicitud_de_despegues',
			'Solicitud_de_datos_particulares'
		};
		Map<Id, ContentDocumentLink[]> caseDocumentLinksByDocumentIds = new Map<Id, ContentDocumentLink[]>();
		Id[] caseIds = new List<Id>();
		ContentDocumentLink[] caseDocumentLinks = getContentDocumentLinks(caseContentDocumentIds);
		for(ContentDocumentLink cdl : caseDocumentLinks) {
			caseIds.add(cdl.LinkedEntityId);
		}
		Case[] casesSentToSS = [SELECT Id FROM Case
								WHERE Id IN :caseIds
									AND Nro_de_solicitud_SS__c != null
									AND RecordType.DeveloperName IN :RECORD_TYPES];
		ContentDocumentLink[] documentLinksFromCasesSentToSS = [
			SELECT Id, LinkedEntityId, ContentDocumentId, LinkedEntity.Type, LinkedEntity.RecordType.DeveloperName
			FROM ContentDocumentLink
			WHERE ContentDocumentId IN :caseContentDocumentIds AND LinkedEntityId IN :casesSentToSS
		];
		for(ContentDocumentLink cdl : documentLinksFromCasesSentToSS) {
			if(!caseDocumentLinksByDocumentIds.containsKey(cdl.ContentDocumentId)) {
				caseDocumentLinksByDocumentIds.put(cdl.ContentDocumentId, new List<ContentDocumentLink>{cdl});
			}
			else {
				ContentDocumentLink[] cdlFromMap = caseDocumentLinksByDocumentIds.get(cdl.ContentDocumentId);
				cdlFromMap.add(cdl);
				caseDocumentLinksByDocumentIds.put(cdl.ContentDocumentId, cdlFromMap);
			}

		}
		if(usuario.Profile.Name != 'Administrador del sistema') {
			for(Id cdId : caseDocumentLinksByDocumentIds.keySet()) {
				for(ContentDocumentLink cdl : caseDocumentLinksByDocumentIds.get(cdId)) {
					triggerOldMap.get(cdl.Id)?.addError(System.Label.Alerta_ArchivoEnviadoASS);
				}
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Molly.
	@description	Método para sobreescribir archivos en las oportunidades.
	@param			newDocuments - Lista de los documentos nuevos.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void overwriteOpportunityWithNewFile(List<ContentDocumentLink> newDocuments) {
        List<ContentDocumentLink> cdLinksToDelete = new List<ContentDocumentLink>();
		List<ContentDocumentLink> cdLinkOpportunities = new List<ContentDocumentLink>();
        Set<Id> opportunitiesIds = new Set<Id>();
		List<Opportunity> opportunitiesToInsertDocument = new List<Opportunity>();
        Set<Id> statusIds = new Set<Id>();
		List<dsfs__DocuSign_Status__c> statusDocuSign = new List<dsfs__DocuSign_Status__c>();
		List<ContentDocumentLink> cdLinksToInsert = new List<ContentDocumentLink>();
		Map<Id, ContentDocumentLink> cdLinkByStatus = new Map<Id, ContentDocumentLink>();
		Map<Id, dsfs__DocuSign_Status__c> statusToProcessByOpportunities = new Map<Id, dsfs__DocuSign_Status__c>();
		List<ContentDocumentLink> cdLinksToProcess = new List<ContentDocumentLink>();
		Set<Id> idsNewDocuments = new Set<Id>(new Map<Id, ContentDocumentLink>(newDocuments).keySet());
		if(!idsNewDocuments.isEmpty()){
			cdLinksToProcess = [SELECT Id, LinkedEntityId, ContentDocumentId, LinkedEntity.Type, LinkedEntity.RecordType.DeveloperName, ContentDocument.Title
									FROM ContentDocumentLink
									WHERE Id IN : idsNewDocuments];
		}
		if(!cdLinksToProcess.isEmpty()){
			for (ContentDocumentLink newDocument : cdLinksToProcess) {
				if(newDocument.LinkedEntity.Type == 'dsfs__DocuSign_Status__c'){
					statusIds.add(newDocument.LinkedEntityId);
					cdLinkByStatus.put(newDocument.LinkedEntityId, newDocument);
				}
			}
			if(!statusIds.isEmpty()){
				statusDocuSign = [SELECT Id, dsfs__Opportunity__c, dsfs__Envelope_Status__c, dsfs__Completed_Date_Time__c
									FROM dsfs__DocuSign_Status__c
									WHERE Id IN: statusIds];
				for (dsfs__DocuSign_Status__c status : statusDocuSign) {
					if(status.dsfs__Opportunity__c != null){
						opportunitiesIds.add(status.dsfs__Opportunity__c);
						statusToProcessByOpportunities.put(status.dsfs__Opportunity__c, status);
					}
				}
				if(!opportunitiesIds.isEmpty()){
					Map<Id, Opportunity> opportunities = new Map<Id, Opportunity>([SELECT Id, Name
																					FROM Opportunity
																					WHERE Id IN: opportunitiesIds]);
					cdLinkOpportunities = [SELECT Id, ContentDocument.Title, ContentDocumentId, LinkedEntityId
											FROM ContentDocumentLink
											WHERE LinkedEntityId IN: opportunitiesIds];
					for(ContentDocumentLink cd : cdLinkOpportunities){
						if((cd.ContentDocument.Title == cdLinkByStatus.get(statusToProcessByOpportunities.get(cd.LinkedEntityId).Id).ContentDocument.Title)
						&& (opportunities.containsKey(cd.LinkedEntityId))){
							cdLinksToDelete.add(cd);
							opportunities.remove(cd.LinkedEntityId);
						}
					}
					if(!cdLinksToDelete.isEmpty()){
						delete cdLinksToDelete;
						for(ContentDocumentLink cdLink : cdLinksToDelete){
							ContentDocumentLink cdLinkOpportunityNew = new ContentDocumentLink();
							setCDLinkToAdd(cdLinkOpportunityNew, cdLinkByStatus.get(statusToProcessByOpportunities.get(cdLink.LinkedEntityId).Id).ContentDocumentId, cdLink.LinkedEntityId);
							cdLinksToInsert.add(cdLinkOpportunityNew);
						}
					}
					else if(!opportunities.isEmpty()){
						for(Opportunity opp : opportunities.values()){
							ContentDocumentLink cdLinkOpportunityNew = new ContentDocumentLink();
							setCDLinkToAdd(cdLinkOpportunityNew, cdLinkByStatus.get(statusToProcessByOpportunities.get(opp.Id).Id).ContentDocumentId, opp.Id);
							cdLinksToInsert.add(cdLinkOpportunityNew);
						}
					}
					else{
						return;
					}
				}
				insert cdLinksToInsert;
			}
		}
    }
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para cambiar la entidad a la que se asocia el CDLink para que se asocie al caso en aquellos creados
					vía Email-to-Case.
	@param			newDocumentsFromTrigger - Lista de los documentos nuevos.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void modifyLinkedEntityForEmailToCaseCases (List<ContentDocumentLink> newDocumentsFromTrigger) {
		cDLinksByParentCaseId = new Map<Id, List<ContentDocumentLink>>();
		newDocuments = newDocumentsFromTrigger;
		setCDLinksToEdit(false);
		if (!cDLinksByParentCaseId.isEmpty()) {
			Map<Id,Case> casesById = new Map<Id, Case>([SELECT OwnerId FROM Case WHERE Id IN: cDLinksByParentCaseId.keySet()]);
			List<ContentDocumentLink> cdLinksToDelete = new List<ContentDocumentLink>();
			List<ContentDocumentLink> cdLinksToInsert = new List<ContentDocumentLink>();
			for (Id caseId : casesById.keySet()) {
				for (ContentDocumentLink cDLink : cDLinksByParentCaseId.get(caseId)) {
					String sobjectType = cDLink.LinkedEntityId.getSObjectType().getDescribe().getName();
					if (sobjectType == 'EmailMessage') {
						ContentDocumentLink cdLinkToCase = new ContentDocumentLink(
							LinkedEntityId = caseId,
							ContentDocumentId = cDLink.contentDocumentId
						);
						cdLinksToInsert.add(cdLinkToCase);
						cdLinksToDelete.add(cDLink);
					}
				}
			}
			insert cdLinksToInsert;
			delete cdLinksToDelete;
			newDocuments = cdLinksToInsert;
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para el archivo a la libreria de edición, de forma que este pueda ser editado por la cola Front
	@param			newDocumentsFromTrigger - Lista de los documentos nuevos.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void modifyParentIdFromCDocumentsForEmailToCaseCases (List<ContentDocumentLink> newDocumentsFromTrigger) {
		cDLinksByParentCaseId = new Map<Id, List<ContentDocumentLink>>();
		newDocuments = newDocumentsFromTrigger;
		setCDLinksToEdit(true);
		if (!cDLinksByParentCaseId.isEmpty()) {
			Map<Id,Case> casesById = new Map<Id, Case>([SELECT OwnerId FROM Case WHERE Id IN: cDLinksByParentCaseId.keySet()]);
			Set<Id> caseIdByContentDocumentId = new Set<Id>();
			for (Id caseId : casesById.keySet()) {
				for (ContentDocumentLink cDLink : cDLinksByParentCaseId.get(caseId)) {
					caseIdByContentDocumentId.add(cDLink.contentDocumentId);
				}
			}
			ContentWorkspace frontPGLibrary = [SELECT Id, DeveloperName FROM ContentWorkspace WHERE DeveloperName = 'Front_PG_Library'];
			List<ContentDocument> cDocs = [SELECT ParentId FROM ContentDocument WHERE Id IN: caseIdByContentDocumentId];
			List<ContentWorkspaceDoc> cwDocsToInsert =  new List<ContentWorkspaceDoc>();
			for (ContentDocument cDoc : cDocs) {
				cDoc.ParentId = frontPGLibrary.Id;
				ContentWorkspaceDoc cwDoc = new ContentWorkspaceDoc(
					ContentWorkspaceId = frontPGLibrary.Id,
					ContentDocumentId = cDoc.Id
				);
				cwDocsToInsert.add(cwDoc);
			}
			insert cwDocsToInsert;
			update cDocs;
		}
    }
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para procesar los CDlinks una vez insertados por el usuario PlatInt.
	@param			oldMapTrigger - Mapa de los CD a borrar por su Id.
	------------------------------------------------------------------------------------------------------------------------*/
	@future
	public static void fireCDLinksInsertedEvent (Set<String> LinkedEntitiesIds) {
		List<CDLinks_Inserted__e> eventsToFire = new List<CDLinks_Inserted__e>();
		for (String linkedEntityId : linkedEntitiesIds) {
			CDLinks_Inserted__e event = new CDLinks_Inserted__e (
				Linked_Entity__c = linkedEntityId
			);
			eventsToFire.add(event);
		}
		List<Database.SaveResult> results = EventBus.publish(eventsToFire);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para procesar los CDlinks una vez insertados por el usuario PlatInt.
	@param			oldMapTrigger - Mapa de los CD a borrar por su Id.
	------------------------------------------------------------------------------------------------------------------------*/
	@future
	public static void processAfterInsertEvent (Set<String> LinkedEntitiesIds) {
		List<ContentDocumentLink> cdLinksToProcess = [SELECT Id,
														ContentDocumentId,
														LinkedEntityId,
														ContentDocument.Title,
														ContentDocument.FileExtension
													FROM ContentDocumentLink
													WHERE LinkedEntityId IN: LinkedEntitiesIds];
		if (!cdLinksToProcess.isEmpty()) {
			modifyLinkedEntityForEmailToCaseCases(cdLinksToProcess);
			modifyParentIdFromCDocumentsForEmailToCaseCases(newDocuments);
		}
	}
	/** Utils */
	private static List<ContentDocumentLink> getContentDocumentLinks (Set<Id> LinkedEntityIds, Set<Id> ContentDocumentIds) {
		return [SELECT Id,
					ContentDocumentId,
					LinkedEntityId,
					ContentDocument.Title,
					ContentDocument.FileExtension
			FROM ContentDocumentLink
			WHERE LinkedEntityId IN :LinkedEntityIds
				AND ContentDocumentId
				NOT IN :ContentDocumentIds];
	}
	private static List<ContentDocumentLink> getContentDocumentLinks (List<Id> ContentDocumentIds) {
		return [SELECT Id,
					LinkedEntityId,
					ContentDocumentId,
					LinkedEntity.Type,
					LinkedEntity.RecordType.DeveloperName
				FROM ContentDocumentLink
				WHERE ContentDocumentId IN :ContentDocumentIds];
	}
	private static List<ContentVersion> getContentVersion (Set<Id> ContentDocumentIds) {
		return [SELECT Id,
					ContentDocumentId,
					Titulo_original__c
				FROM ContentVersion
				WHERE ContentDocumentId IN :ContentDocumentIds];
	}
	private static void setCDLinkToAdd (ContentDocumentLink cDLinkToAdd, String contentDocumentId, String linkedEntityId) {
		cDLinkToAdd.ContentDocumentId = contentDocumentId;
		cDLinkToAdd.LinkedEntityId = linkedEntityId; // you can use objectId,GroupId etc
		cDLinkToAdd.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
		cDLinkToAdd.Visibility = 'AllUsers';
	}
	private static void setCDLinksToEdit (Boolean isAfter) {
		Map<Id, List<ContentDocumentLink>> cDLinksFromEmailToCaseByLinkedEntityIds = new Map<Id, List<ContentDocumentLink>>();
		List<Id> cDocsIds = new List<Id>();
		for (ContentDocumentLink cdl : newDocuments) {
			cDocsIds.add(cdl.ContentDocumentId);
		}
		Map<Id, ContentDocument> cDocsToCheckById = new Map<Id, ContentDocument>([SELECT Owner.Alias FROM ContentDocument WHERE Id IN: cDocsIds]);
		Map<Id,ContentDocumentLink> cdLinksToCheckById = new Map<Id,ContentDocumentLink>(getContentDocumentLinks(new List<Id>(cDocsToCheckById.keySet())));
		Map<Id, List<Id>> linkedEntitiesIdsByCDocId = new Map<Id, List<Id>>();
		if (!cdLinksToCheckById.isEmpty()) {
			for (ContentDocumentLink cdl : cdLinksToCheckById.values()) {
				if (linkedEntitiesIdsByCDocId.containsKey(cdl.contentDocumentId)) {
					linkedEntitiesIdsByCDocId.get(cdl.contentDocumentId).add(cdl.LinkedEntityId);
				} else {
					linkedEntitiesIdsByCDocId.put(cdl.contentDocumentId, new List<Id>{cdl.LinkedEntityId});
				}
			}
		}
		for (ContentDocumentLink cdl : newDocuments) {
			String sobjectType = cdl.LinkedEntityId.getSObjectType().getDescribe().getName();
			Boolean cDLinkedToCase = false;
			if (linkedEntitiesIdsByCDocId.containsKey(cdl.contentDocumentId)) {
				for (Id linkedEntityId : linkedEntitiesIdsByCDocId.get(cdl.contentDocumentId)) {
					String linkedEntityType = linkedEntityId.getSObjectType().getDescribe().getName();
					if (linkedEntityType == 'Case') cDLinkedToCase = true;
				}
			}
			List<Id> EmailMessagesIds = new List<Id>();
			if (cDocsToCheckById.get(cdl.ContentDocumentId).Owner.Alias == 'platint' && sobjectType == 'EmailMessage' && !isAfter && !cDLinkedToCase) {
				if (!cDLinksFromEmailToCaseByLinkedEntityIds.containsKey(cdl.LinkedEntityId)) {
					cDLinksFromEmailToCaseByLinkedEntityIds.put(cdl.LinkedEntityId, new List<ContentDocumentLink>{cdl});
				} else {
					cDLinksFromEmailToCaseByLinkedEntityIds.get(cdl.LinkedEntityId).add(cdl);
				}
			} else if (cDocsToCheckById.get(cdl.ContentDocumentId).Owner.Alias == 'platint' && sobjectType == 'Case' && isAfter) {
				if (!cDLinksByParentCaseId.containsKey(cdl.LinkedEntityId)) {
					cDLinksByParentCaseId.put(cdl.LinkedEntityId, new List<ContentDocumentLink>{cdl});
				} else {
					cDLinksByParentCaseId.get(cdl.LinkedEntityId).add(cdl);
				}
			}
		}
		if (!isAfter) {
			List<EmailMessage> emails = [SELECT ParentId FROM EmailMessage WHERE Id IN: cDLinksFromEmailToCaseByLinkedEntityIds.keySet()];
			for (EmailMessage email : emails) {
				String sobjectType = email.ParentId.getSObjectType().getDescribe().getName();
				if (sobjectType == 'Case' && !cDLinksByParentCaseId.containsKey(email.ParentId)) {
					cDLinksByParentCaseId.put(email.ParentId, new List<ContentDocumentLink>(cDLinksFromEmailToCaseByLinkedEntityIds.get(email.Id)));
				} else if (cDLinksByParentCaseId.containsKey(email.ParentId)) {
					cDLinksByParentCaseId.get(email.ParentId).addAll(cDLinksFromEmailToCaseByLinkedEntityIds.get(email.Id));
				}
			}
		}
	}
}