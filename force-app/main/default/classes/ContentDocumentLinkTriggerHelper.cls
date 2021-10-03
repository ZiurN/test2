public class ContentDocumentLinkTriggerHelper {
	public static Boolean canDelete = false;

	public static void avoidTwoFilesWithTheSameNameInCaseAndEM(List<ContentDocumentLink> cdlList) {
		System.debug('avoidTwoFilesWithTheSameNameInCaseAndEM');
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
		System.debug('****cdlList: ' + cdlList);

		/*for(Opportunity opp : [
			SELECT Id 
			FROM Opportunity 
			WHERE Id IN :opportunityIds AND RecordType.DeveloperName != 'Corporativo'
		]) {
			setEntitiesIds.add(opp.Id);
		}*/
		
		// Si no, rompe en el SELECT
		if(setEntitiesIds.isEmpty() && opportunityIds.isEmpty()) {
			return;
		}

		System.debug('setEntitiesIds: ' + setEntitiesIds);

		map<Id, ContentDocument> mapDocuments = new map<Id, ContentDocument>([
			SELECT Id, Title, FileExtension 
			FROM ContentDocument 
			WHERE Id IN :setDocumentIds
		]);
        System.debug('****mapDocuments: ' + mapDocuments);

        Map<Id, set<String>> mapRecordIdFilenames = new Map<Id, set<String>>();
		Map<Id, Set<Id>> entitiesIdsByContentDocumentId = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> cdsByEntityId = new Map<Id, Set<Id>>();
		//OPORTUNIDADES-----------------
		if(!opportunityIds.isEmpty()){
			for (ContentDocumentLink cdl : [
					SELECT Id, ContentDocumentId, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension 
					FROM ContentDocumentLink 
					WHERE LinkedEntityId IN :opportunityIds AND ContentDocumentId NOT IN :setDocumentIds
			]) {
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
			System.debug('****mapRecordIdFilenames: ' + mapRecordIdFilenames);
			System.debug('****entitiesIdsByContentDocumentId: ' + entitiesIdsByContentDocumentId);
			System.debug('****cdsByEntityId: ' + cdsByEntityId);

			Map<Id, ContentVersion> contentVersionByContentDocument = new Map<Id, ContentVersion>();
			for (ContentVersion cv : [
					SELECT Id, ContentDocumentId, Titulo_original__c
					FROM ContentVersion
					WHERE ContentDocumentId IN :entitiesIdsByContentDocumentId.keySet()
				]) {
				//System.debug('cv.Titulo_original__c: ' + cv.Titulo_original__c.toUpperCase());
				contentVersionByContentDocument.put(cv.ContentDocumentId, cv);
			}
			System.debug('****contentVersionByContentDocument: ' + contentVersionByContentDocument);

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
			System.debug('****filesNamesByEntityId: ' + filesNamesByEntityId);
			
			for(ContentDocumentLink cdl : cdlList) {
				System.debug('cdl.LinkedEntityId: ' + cdl.LinkedEntityId);
				ContentDocument objCntDoc = mapDocuments.get(cdl.ContentDocumentId);

				if(objCntDoc != null && !String.isBlank(objCntDoc.Title)) {
					set<String> setExistingFilenames = mapRecordIdFilenames.get(cdl.LinkedEntityId);
					Set<String> setTitulosOriginales = filesNamesByEntityId.get(cdl.LinkedEntityId);
					System.debug('****setExistingFilenames ' + setExistingFilenames);
					System.debug('****setTitulosOriginales ' + setTitulosOriginales);
					if ((setExistingFilenames != null && setExistingFilenames.contains(objCntDoc.Title.toUpperCase())) 
							|| (setTitulosOriginales != null && setTitulosOriginales.contains(objCntDoc.Title.toUpperCase()))) {
						cdl.addError('Ya existe un archivo, adjunto a este registro, con el mismo nombre');
					} 
				} 
			}
		}	
		
		//CASO Y EVENTO MEDICO
		if(!setEntitiesIds.isEmpty()){
			for (ContentDocumentLink cdl : [
				SELECT Id, ContentDocumentId, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension 
				FROM ContentDocumentLink 
				WHERE LinkedEntityId IN :setEntitiesIds AND ContentDocumentId NOT IN :setDocumentIds
			]) {
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
			System.debug('****mapRecordIdFilenames: ' + mapRecordIdFilenames);
			System.debug('****entitiesIdsByContentDocumentId: ' + entitiesIdsByContentDocumentId);
			System.debug('****cdsByEntityId: ' + cdsByEntityId);

			Map<Id, ContentVersion> contentVersionByContentDocument = new Map<Id, ContentVersion>();
			for (ContentVersion cv : [
					SELECT Id, ContentDocumentId, Titulo_original__c
					FROM ContentVersion
					WHERE ContentDocumentId IN :entitiesIdsByContentDocumentId.keySet()
				]) {
				//System.debug('cv.Titulo_original__c: ' + cv.Titulo_original__c.toUpperCase());
				contentVersionByContentDocument.put(cv.ContentDocumentId, cv);
			}
			System.debug('****contentVersionByContentDocument: ' + contentVersionByContentDocument);

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
			System.debug('****filesNamesByEntityId: ' + filesNamesByEntityId);
			
			for(ContentDocumentLink cdl : cdlList) {
				System.debug('cdl.LinkedEntityId: ' + cdl.LinkedEntityId);
				ContentDocument objCntDoc = mapDocuments.get(cdl.ContentDocumentId);

				if(objCntDoc != null && !String.isBlank(objCntDoc.Title)) {
					set<String> setExistingFilenames = mapRecordIdFilenames.get(cdl.LinkedEntityId);
					Set<String> setTitulosOriginales = filesNamesByEntityId.get(cdl.LinkedEntityId);
					System.debug('****setExistingFilenames ' + setExistingFilenames);
					System.debug('****setTitulosOriginales ' + setTitulosOriginales);
					if ((setExistingFilenames != null && setExistingFilenames.contains(objCntDoc.Title.toUpperCase())) 
							|| (setTitulosOriginales != null && setTitulosOriginales.contains(objCntDoc.Title.toUpperCase()))) {
						cdl.addError('Ya existe un archivo, adjunto a este registro, con el mismo nombre');
					} 
				} 
			}
		}
	}

	public static void avoidFilesLargerThan3MbInCaseAndEM(List<ContentDocumentLink> cdlList) {
		Set<Id> cdIdsFromCaseEMAndOpp = new Set<Id>();
		
		for(ContentDocumentLink cdl : cdlList) {
			String strObjPrefix = String.valueOf(cdl.LinkedEntityId).substring(0, 3);
            
			if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix() 
				|| strObjPrefix == Evento_medico__c.sObjectType.getDescribe().getKeyPrefix()
				|| strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()
			) {
				// System.debug(cdl);
				// System.debug(cdl.LinkedEntityId);
				// System.debug(cdl.ContentDocument.ContentSize);
				cdIdsFromCaseEMAndOpp.add(cdl.ContentDocumentId);	
			}
		}

		ContentDocument[] cdsFromCaseAndEMLargerThan3Mb = [
			SELECT Id, ContentSize
			FROM ContentDocument
			WHERE Id IN :cdIdsFromCaseEMAndOpp AND ContentSize > 3145728 
		];

		for(ContentDocumentLink cdl : cdlList) {
			for(ContentDocument cd : cdsFromCaseAndEMLargerThan3Mb) {
				System.debug(cd.ContentSize);
				if(cd.Id == cdl.ContentDocumentId) {
					cdl.addError('El tamaño del archivo no debe superar los 3mb.');
				}
			}
		}
	}

	public static void avoidDeleteSentOpportunityFiles(
		Map<Id, ContentDocumentLink> triggerOldMap, 
		List<Id> opportunityContentDocumentIds
	) {
		//for(ContentVersion cv: [
								//SELECT Id, Enviado__c, ContentDocumentId 
								//FROM ContentVersion 
								//WHERE ContentDocumentId IN :opportunityDocumentLinksByDocumentIds.keySet() 
									//AND Enviado__c = true]
		//) {
			//for(ContentDocumentLink cdl : opportunityDocumentLinksByDocumentIds.get(cv.ContentDocumentId)) {
				//triggerOldMap.get(cdl.Id).addError('No se puede eliminar un archivo que ya ha sido enviado');
			//}
		//}
//-------------------------------------------------------------------------------------------------------------------------
		Map<Id, ContentDocumentLink[]> opportunityDocumentLinksByDocumentIds = new Map<Id, ContentDocumentLink[]>();

		for(ContentDocumentLink cdl : [
			SELECT Id, LinkedEntityId, ContentDocumentId, LinkedEntity.Type, LinkedEntity.RecordType.DeveloperName
			FROM ContentDocumentLink 
			WHERE ContentDocumentId IN :opportunityContentDocumentIds 
		]) {
			//String strObjPrefix = String.isBlank(cdl.LinkedEntityId) ? null : String.valueOf(cdl.LinkedEntityId).substring(0, 3);
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

		User usuario = [
			SELECT Id, Profile.Name
			FROM User 
			WHERE Id = :UserInfo.getUserId()
		];
		
		Boolean isAdministrator = (usuario.Profile.Name == 'Administrador del sistema') || (usuario.Profile.Name == 'System Administrator');

		if(!isAdministrator  && !canDelete) {
			for(Id cdId : opportunityDocumentLinksByDocumentIds.keySet()) {
				for(ContentDocumentLink cdl : opportunityDocumentLinksByDocumentIds.get(cdId)) {
					triggerOldMap.get(cdl.Id)?.addError('No se pueden eliminar archivos de oportunidades');
				}
			}
		}
	}

	public static void avoidDeleteSentCaseFiles(
		Map<Id, ContentDocumentLink> triggerOldMap, 
		List<Id> caseContentDocumentIds
	) {
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
		ContentDocumentLink[] caseDocumentLinks = [
			SELECT Id, LinkedEntityId, ContentDocumentId, LinkedEntity.Type, LinkedEntity.RecordType.DeveloperName
			FROM ContentDocumentLink 
			WHERE ContentDocumentId IN :caseContentDocumentIds 
		];

		for(ContentDocumentLink cdl : caseDocumentLinks) {
			caseIds.add(cdl.LinkedEntityId);
		}

		Case[] casesSentToSS = [
			SELECT Id 
			FROM Case 
			WHERE Id IN :caseIds 
				AND Nro_de_solicitud_SS__c != null
				AND RecordType.DeveloperName IN :RECORD_TYPES
		];

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

		User usuario = [
			SELECT Id, Profile.Name 
			FROM User 
			WHERE Id = :UserInfo.getUserId()
		];
		
		if(usuario.Profile.Name != 'Administrador del sistema') {
			for(Id cdId : caseDocumentLinksByDocumentIds.keySet()) {
				for(ContentDocumentLink cdl : caseDocumentLinksByDocumentIds.get(cdId)) {
					triggerOldMap.get(cdl.Id)?.addError('No se pueden eliminar archivos si el caso ya fue enviado a Salud Soft');
				}
			}
		}
	}

	//Sobreescribir documento en oportunidades con el nuevo firmado
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

		/*Map<Id, ContentDocument> documentsDDJJ = new Map<Id, ContentDocument>(
			[SELECT Id, Title 
			FROM ContentDocument 
			WHERE Title =: System.Label.PDFIngresoYDDJJ]
		);*/

		Set<Id> idsNewDocuments = new Set<Id>(new Map<Id, ContentDocumentLink>(newDocuments).keySet());

		if(!idsNewDocuments.isEmpty()){
			cdLinksToProcess = [
				SELECT Id, LinkedEntityId, ContentDocumentId, LinkedEntity.Type, LinkedEntity.RecordType.DeveloperName, ContentDocument.Title 
				FROM ContentDocumentLink 
				WHERE /*ContentDocumentId IN : documentsDDJJ.keySet()
				AND*/ Id IN : idsNewDocuments
			];
		}

		if(!cdLinksToProcess.isEmpty()){
			for (ContentDocumentLink newDocument : cdLinksToProcess) {
				if(/*newDocument.ContentDocument.Title == System.Label.PDFIngresoYDDJJ
				&& */newDocument.LinkedEntity.Type == 'dsfs__DocuSign_Status__c'){
					statusIds.add(newDocument.LinkedEntityId);
					cdLinkByStatus.put(newDocument.LinkedEntityId, newDocument);
				}
			}
			if(!statusIds.isEmpty()){
					//GET DOCUSIGN STATUS DATA
				statusDocuSign = [
					SELECT Id, dsfs__Opportunity__c, dsfs__Envelope_Status__c, dsfs__Completed_Date_Time__c
					FROM dsfs__DocuSign_Status__c
					WHERE Id IN: statusIds
				];

				//GET OPPORTUNITIES DATA

				for (dsfs__DocuSign_Status__c status : statusDocuSign) {
					if(status.dsfs__Opportunity__c != null){
						opportunitiesIds.add(status.dsfs__Opportunity__c);
						statusToProcessByOpportunities.put(status.dsfs__Opportunity__c, status);
					}
				}

				if(!opportunitiesIds.isEmpty()){
					Map<Id, Opportunity> opportunities = new Map<Id, Opportunity>([
						SELECT Id, Name
						FROM Opportunity
						WHERE Id IN: opportunitiesIds
					]);
		
					cdLinkOpportunities = [
						SELECT Id, ContentDocument.Title, ContentDocumentId, LinkedEntityId 
						FROM ContentDocumentLink 
						WHERE LinkedEntityId IN: opportunitiesIds
					];
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
							cdLinkOpportunityNew.ContentDocumentId = cdLinkByStatus.get(statusToProcessByOpportunities.get(cdLink.LinkedEntityId).Id).ContentDocumentId;
							cdLinkOpportunityNew.LinkedEntityId = cdLink.LinkedEntityId; // you can use objectId,GroupId etc
							cdLinkOpportunityNew.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
							cdLinkOpportunityNew.Visibility = 'AllUsers';
	
							cdLinksToInsert.add(cdLinkOpportunityNew);
						}
					}
					else if(!opportunities.isEmpty()){
						for(Opportunity opp : opportunities.values()){
							ContentDocumentLink cdLinkOpportunityNew = new ContentDocumentLink();
							cdLinkOpportunityNew.ContentDocumentId = cdLinkByStatus.get(statusToProcessByOpportunities.get(opp.Id).Id).ContentDocumentId;
							cdLinkOpportunityNew.LinkedEntityId = opp.Id; // you can use objectId,GroupId etc
							cdLinkOpportunityNew.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
							cdLinkOpportunityNew.Visibility = 'AllUsers';
	
							cdLinksToInsert.add(cdLinkOpportunityNew);
						}  
					}
					else{
						return;
					}
				}	
				insert cdLinksToInsert;
			}
			else{
				return;
			}
		}
        else{
			return;
		}

        
    }

	//Cancelacion s3
	/*@Future(callout=true)
	public static void sendToAWSFuture(Id[] cdlsIds) {
		sendToAWSNotFuture(cdlsIds);
	}

	public static void sendToAWSNotFuture(Id[] cdlsIds) {
		System.debug('sendToAWSFuture');
		Archivo_url__c[] urlsToInsert = new List<Archivo_url__c>();
		List<Archivo_url__c> fileInSf = new List<Archivo_url__c>();
		Map<Id, ContentVersion> cvByContentDocumentId = new Map<Id, ContentVersion>(); 

		List<ContentDocumentLink> cdls = [
			SELECT Id, ContentDocumentId, LinkedEntityId, ContentDocument.Title
			FROM ContentDocumentLink
			WHERE Id IN :cdlsIds
		];

		Set<Id> cdIds = new Set<Id>();
		Set<Id> entitiesIds = new Set<Id>();
		Map<Id, List<String>> documentsTitlesByEntityId = new Map<Id, List<String>>();
		for(ContentDocumentLink cdl : cdls) {
			cdIds.add(cdl.ContentDocumentId);
			entitiesIds.add(cdl.LinkedEntityId);

			if (!documentsTitlesByEntityId.containsKey(cdl.LinkedEntityId)) {
				documentsTitlesByEntityId.put(cdl.LinkedEntityId, new List<String>());
			}
            documentsTitlesByEntityId.get(cdl.LinkedEntityId).add(cdl.ContentDocument.Title);
		}
		System.debug('****documentsTitlesByEntityId: ' + documentsTitlesByEntityId);
		System.debug('****entitiesIds: ' + entitiesIds);
		ContentVersion[] cvs = [
			SELECT Id, FileExtension, VersionData, FileType, Title, ContentDocumentId, Titulo_original__c
			FROM ContentVersion 
			WHERE ContentDocumentId IN :cdIds
		];
		System.debug('****cvs: ' + cvs);
		for(ContentVersion cv : cvs) {
			cvByContentDocumentId.put(cv.ContentDocumentId, cv);
		}
		
		// ContentDocumentLink[] cdl = [
		// 	SELECT Id, LinkedEntityId
		// 	FROM ContentDocumentLink
		// 	WHERE ContentDocumentId = :cv.ContentDocumentId
		// ];
		Map<Id, ContentDocument> cdsMap = new Map<Id, ContentDocument>([
			SELECT Id, ( 
				SELECT LinkedEntityId 
				FROM ContentDocumentLinks 
				WHERE LinkedEntity.Type IN ('Opportunity', 'Case', 'Evento_Medico__c')
			)
			//(SELECT Enviado__c FROM ContentVersions WHERE Enviado__c = true)
			FROM ContentDocument
			WHERE Id IN :cvByContentDocumentId.keySet()
		]);
		// System.debug(cdl);

		List<Archivo_url__c> urlsInSf = [
			SELECT Id, Name, Caso__c, Evento_Medico__c, Oportunidad__c, Ruta_relativa__c
			FROM Archivo_url__c
			WHERE (
				Caso__c IN :entitiesIds
					OR Evento_Medico__c IN :entitiesIds
					OR Oportunidad__c IN :entitiesIds
			)
		];

		Map<Id, List<Archivo_url__c>> filesByEntityId = new Map<Id, List<Archivo_url__c>>();
		for(Archivo_url__c file : urlsInSf) {
			Id id = null;
			if(String.isNotBlank(file.Caso__c)) {
				id = file.Caso__c;
			}
			else if(String.isNotBlank(file.Evento_Medico__c)) {
				id = file.Evento_Medico__c;
			}
			else if(String.isNotBlank(file.Oportunidad__c)) {
				id = file.Oportunidad__c;
			}

			if (!filesByEntityId.containsKey(id)) {
				filesByEntityId.put(id, new List<Archivo_url__c>());
			}
            filesByEntityId.get(id).add(file);
		}
		for(ContentVersion cv : cvByContentDocumentId.values()) {
			ContentDocument cd = cdsMap.get(cv.ContentDocumentId);

			if(cd != null && !cd.ContentDocumentLinks.isEmpty()) {
				String folder = cdsMap.get(cv.ContentDocumentId).ContentDocumentLinks[0].LinkedEntityId + '/';
				System.debug('****folder: ' + folder);
				AWS.Response resp = AWS.putFile(cv, folder, cdsMap.get(cv.ContentDocumentId).ContentDocumentLinks[0].LinkedEntityId);
				System.debug('****THE RESPONSE MF: ' + resp);

				if(!resp.hasError) {
					Archivo_url__c url = new Archivo_url__c();
					String encodedTitle = Utils.getStringAlphanumericOnly(cv.Title).replaceAll(' ', '_') + '.' + cv.FileExtension;
					String strObjPrefix = String.valueOf(cd.ContentDocumentLinks[0].LinkedEntityId).substring(0, 3);

					List<Archivo_url__c> filesInSf = filesByEntityId.get(cd.ContentDocumentLinks[0].LinkedEntityId);
					if(filesInSf != null) {
						for(Archivo_url__c file : filesInSf) {
							if(file.Name == encodedTitle.toUpperCase()) {
								fileInSf.add(file);
							}
						}
					}

					url.Nombre_original__c = cv.Title;
					if(encodedTitle.toUpperCase().length() >= 65) {
						url.Name = encodedTitle.toUpperCase().substring(0, 65) + System.now().format('MMddmmss');
					}
					else {
						url.Name = encodedTitle.toUpperCase();
					}
					System.debug('***EL TITULO: ' +  url.Name);
					url.Link__c = resp.url;
					url.Ruta_relativa__c = resp.relativeLocation;

					if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()) {
						url.Caso__c = cd.ContentDocumentLinks[0].LinkedEntityId;
					}
					else if(strObjPrefix == Evento_medico__c.sObjectType.getDescribe().getKeyPrefix()) {
						url.Evento_Medico__c = cd.ContentDocumentLinks[0].LinkedEntityId;
					}
					else if(strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()) {
						url.Oportunidad__c = cd.ContentDocumentLinks[0].LinkedEntityId;
					}

					urlsToInsert.add(url);
				}
			}
		}
		if(!fileInSf.isEmpty()) {
			System.debug('****Voy a borrar fileInSF: ' + fileInSf);
			delete fileInSf;
		}

		System.debug('****urlsToInsert: ' + urlsToInsert);
		insert urlsToInsert;

		List<Archivo_url__c> archivosToDelete = new List<Archivo_url__c>();
		for(Archivo_url__c file : urlsInSf) {
			Id id = null;
			if(String.isNotBlank(file.Caso__c)) {
				id = file.Caso__c;
			}
			else if(String.isNotBlank(file.Evento_Medico__c)) {
				id = file.Evento_Medico__c;
			}
			else if(String.isNotBlank(file.Oportunidad__c)) {
				id = file.Oportunidad__c;
			}

			if(!documentsTitlesByEntityId.get(id).contains(file.Name)) {
				archivosToDelete.add(file);
			}
		}

		Boolean respHasError = false;
		for(Archivo_url__c file : archivosToDelete) {
			AWS.Response resp = AWS.deleteFile(file);
			System.debug('****resp: ' + resp);
			respHasError |= resp.hasError;
		}

		System.debug('****archivosToDelete: ' + archivosToDelete);
		System.debug('****respHasError: ' + respHasError);
		if(!respHasError) {
			delete archivosToDelete;
		}
	}*/
}