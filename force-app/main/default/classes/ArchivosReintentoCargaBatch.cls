global class ArchivosReintentoCargaBatch implements Database.Batchable<SObject> , Database.AllowsCallouts {
	
	public Set<Id> setIdContentDocument = new Set<Id>();
	Map<Id,Case> mapIdsCasos = new Map<Id,Case>();
	Map<Id,Id> mapContentDocumentLinkedEntity = new Map <Id,Id>();
	Id solicitudAutorizacion = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
	Id solicitudReintegro = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
	global ArchivosReintentoCargaBatch() {
		
	}
	
	global ArchivosReintentoCargaBatch(List<String> nrosSolicitudesSS){
		if(nrosSolicitudesSS != null){
			List<Case> listCasos = [
				SELECT Id,Nro_de_solicitud_SS__c,RecordTypeId
				FROM Case
				WHERE Nro_de_solicitud_SS__c IN :nrosSolicitudesSS
			];
			if(!listCasos.isEmpty()){
				Set<Id> setIdCasos = new Set<Id>();
				this.mapIdsCasos = new Map<Id,Case>(listCasos);
				for(Case caso : listCasos){
					setIdCasos.add(caso.Id);
				}
				List<ContentDocumentLink> listLinks = [
					SELECT Id, LinkedEntityId,ContentDocumentId
					FROM ContentDocumentLink
					WHERE LinkedEntityId IN :setIdCasos
				];
				if(!listLinks.isEmpty()){
					for(ContentDocumentLink cdl : listLinks){
						setIdContentDocument.add(cdl.ContentDocumentId);
						this.mapContentDocumentLinkedEntity.put(cdl.ContentDocumentId,cdl.LinkedEntityId);
					}
				}
			}
		}else{
			this();
		}
	}

	global Database.QueryLocator start(Database.BatchableContext context) {
		string query = 	'SELECT Id,OwnerId, Usuario_error__c, Enviado__c, VersionData, ContentDocumentId, Description, Title, FileExtension, ' +
			'PathOnClient, Error_al_enviar__c, Id_reintento__c, Tipo_entidad_error__c, Fecha_de_error__c ' + 
			'FROM ContentVersion ' +
			'WHERE (Error_al_enviar__c != null OR Enviado__c = false) AND IsLatest = true AND LastModifiedDate = LAST_N_DAYS:7 ';
		if(!setIdContentDocument.isEmpty()){
			System.debug('ENTRO? ');
			query += 'AND ContentDocumentId IN :setIdContentDocument';
		}	
		return Database.getQueryLocator(query);
	}


   	global void execute(Database.BatchableContext context, List<ContentVersion> scope) {
		List<ContentVersion> versionsToUpdate = new List<ContentVersion>();
		WSAuthToken.Response token = null;

		Set<Id> setContentDocument = new Set<Id>();
		for(ContentVersion doc : scope){
			setContentDocument.add(doc.ContentDocumentId);	
		}
		System.debug('set Content Document ' + setContentDocument);
		List<ContentDocumentLink> lstContentDocumentLink = [
			SELECT Id, LinkedEntityId,ContentDocumentId
			FROM ContentDocumentLink
			WHERE ContentDocumentId IN :setContentDocument
		];
		
		System.debug('size ' + lstContentDocumentLink.size());
		Map<Id,String> mapLEIAndTipoTramite = new Map<Id,String>();
		Map<Id,Id> mapCDIAndLEI = new Map<Id,Id>();

		Set<Id> casesToRetrieve = new Set<Id>();
		Set<Id> emToRetrieve = new Set<Id>();
		Set<Id> segmentosToRetrieve = new Set<Id>();
		Set<Id> oppToRetrieve = new Set<Id>();

		Map<Id,String> mapIdCasoAndNameUser = new Map<Id,String>();
		Map<Id,String> mapIdEMAndNameUser = new Map<Id,String>();
		Map<Id,String> mapLEIAndNroSS = new Map<Id,String>();
		Map<Id,String> mapLEIAndCommunityName = new Map<Id,String>();

		for(ContentDocumentLink cdl : lstContentDocumentLink){
			
			String strObjPrefix = String.valueOf(cdl.LinkedEntityId).substring(0, 3);
        	if(strObjPrefix == Evento_medico__c.sObjectType.getDescribe().getKeyPrefix()){
				mapLEIAndTipoTramite.put(cdl.LinkedEntityId, 'evento_medico');
				emToRetrieve.add(cdl.LinkedEntityId);
			}else if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()){
				casesToRetrieve.add(cdl.LinkedEntityId);
			}else if(strObjPrefix == Segmentos__c.sObjectType.getDescribe().getKeyPrefix()){
				segmentosToRetrieve.add(cdl.LinkedEntityId);
			}else if(strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()){
				oppToRetrieve.add(cdl.LinkedEntityId);
			}
			
			
			if(strObjPrefix != User.sObjectType.getDescribe().getKeyPrefix()){
				mapCDIAndLEI.put(cdl.ContentDocumentId,cdl.LinkedEntityId);
			}
			
		}

		if(!oppToRetrieve.isEmpty()){
			List<Opportunity> lstOpp = [
				SELECT Id,Nro_de_solicitud__c,RecordTypeId,OwnerId
				FROM Opportunity
				WHERE Id IN :oppToRetrieve
			];
			if(!lstOpp.isEmpty()){
				Set<Id> idUsers = new Set<Id>();
				for(Opportunity opp : lstOpp){
					if(String.isNotBlank(opp.Nro_de_solicitud__c)){
						mapLEIAndNroSS.put(opp.Id,opp.Nro_de_solicitud__c);
						idUsers.add(opp.OwnerId);
						mapLEIAndTipoTramite.put(opp.Id,'solicitud');	
					}			
				}
				Map<Id,User> mapIdUser = new Map<Id,User>([
					SELECT Id,CommunityNickname
					FROM User
					WHERE Id IN :idUsers
				]);
				for(Opportunity opp : lstOpp){
					if(mapIdUser.containsKey(opp.OwnerId)){
						User user = mapIdUser.get(opp.OwnerId);
						mapLEIAndCommunityName.put(opp.Id,user.CommunityNickname.toUpperCase());
					}
				}
			}
		}
		if(!casesToRetrieve.isEmpty()){
			List<Case> lstCasos = [
				SELECT Id,RecordTypeId,OwnerId,Nro_de_solicitud_SS__c
				FROM Case
				WHERE Id IN :casesToRetrieve
			];
			if(!lstCasos.isEmpty()){
				Set<Id> idUsers = new Set<Id>();
				for(Case caso : lstCasos){
					if(String.isNotBlank(caso.Nro_de_solicitud_SS__c)){
						if(caso.RecordTypeId == solicitudReintegro || caso.RecordTypeId == solicitudAutorizacion){
							mapLEIAndNroSS.put(caso.Id,caso.Nro_de_solicitud_SS__c);
							idUsers.add(caso.OwnerId);
							string tipoTramite = 'autorizacion';
							if(caso.RecordTypeId == solicitudReintegro){
								tipoTramite = 'reintegro';
							}
							mapLEIAndTipoTramite.put(caso.Id,tipoTramite);	
						}
					}			
				}
				Map<Id,User> mapIdUser = new Map<Id,User>([
					SELECT Id,CommunityNickname
					FROM User
					WHERE Id IN :idUsers
				]);
				for(Case caso : lstCasos){
					if(mapIdUser.containsKey(caso.OwnerId)){
						User user = mapIdUser.get(caso.OwnerId);
						mapLEIAndCommunityName.put(caso.Id,user.CommunityNickname.toUpperCase());
					}
				}
			}
		}

		if(!emToRetrieve.isEmpty()){
			List<Evento_Medico__c> lstEM = [
				SELECT Id, OwnerId,Nro_de_Evento_Medico_SS__c
				FROM Evento_medico__c
				WHERE Id IN :emToRetrieve
			];
		
			Set<Id> idUsers = new Set<Id>();	
			for(Evento_medico__c em : lstEM){
				idUsers.add(em.OwnerId);
			}
			
			Map<Id,User> mapIdUser = new Map<Id,User>([
				SELECT Id,CommunityNickname
				FROM User
				WHERE Id IN :idUsers
			]);

			for(Evento_medico__c em : lstEM){
				if(String.isNotBlank(em.Nro_de_Evento_Medico_SS__c)){
					mapLEIAndNroSS.put(em.Id,em.Nro_de_Evento_Medico_SS__c);
					if(mapIdUser.containsKey(em.OwnerId)){
						User user = mapIdUser.get(em.OwnerId);
						mapLEIAndCommunityName.put(em.Id,user.CommunityNickname.toUpperCase());
					}
				}
			}
		}

		if(!segmentosToRetrieve.isEmpty()){
			List<Segmentos__c> lstSegmento = [
				SELECT Id,OwnerId,Semid__c
				FROM Segmentos__c
				WHERE Id IN :segmentosToRetrieve
			];

			Set<Id> idUsers = new Set<Id>();	
			for(Segmentos__c seg : lstSegmento){
				idUsers.add(seg.OwnerId);
			}
			
			Map<Id,User> mapIdUser = new Map<Id,User>([
				SELECT Id,CommunityNickname
				FROM User
				WHERE Id IN :idUsers
			]);

			for(Segmentos__c seg : lstSegmento){
				if(String.isNotBlank(seg.Semid__c)){
					mapLEIAndNroSS.put(seg.Id,seg.Semid__c);
					if(mapIdUser.containsKey(seg.OwnerId)){
						User user = mapIdUser.get(seg.OwnerId);
						mapLEIAndCommunityName.put(seg.Id,user.CommunityNickname.toUpperCase());
					}
				}
			}
		}
		System.debug('doc lista ' + scope.size());
		System.debug('entity ' + mapLEIAndTipoTramite);
		System.debug('cdi ' + mapCDIAndLEI);
		System.debug('comm name ' + mapLEIAndCommunityName);
		System.debug('id ss ' + mapLEIAndNroSS);

		for(ContentVersion doc : scope){

			if(!setIdContentDocument.isEmpty()){
				String tipoTramite = 'evento_medico';
				if(this.mapContentDocumentLinkedEntity.containsKey(doc.ContentDocumentId)){
					Id idLinkedEntity = this.mapContentDocumentLinkedEntity.get(doc.ContentDocumentId);
					if(this.mapIdsCasos.containsKey(idLinkedEntity)){
						Case caso = this.mapIdsCasos.get(idLinkedEntity);
						if(caso.RecordTypeId == solicitudAutorizacion){
							tipoTramite = 'autorizacion';
						}else if(caso.RecordTypeId == solicitudReintegro){
							tipoTramite = 'reintegro';
						}
					}
				}
			}
			if(mapLEIAndNroSS.containsKey(mapCDIAndLEI.get(doc.ContentDocumentId))){
			
				System.debug('file extension ' + doc.FileExtension);
				Map<String, Object> fileMap = new Map<String, Object>{
						'datos' => 'data:' + Utils.getTypeAndExtension(doc.FileExtension) + ';base64,' + EncodingUtil.base64Encode(doc.VersionData),
						'observaciones' => null,
						'descripcion' => doc.Description,
						'nombre' => (doc.Title + '.' + doc.FileExtension).toUpperCase()
					};
			
				System.debug('doc ' + doc);	
				
				Map<String, Object> bodyMap = new Map<String, Object>{
					'tipo_tramite' => doc.Tipo_entidad_error__c != null ?
						doc.Tipo_entidad_error__c : mapLEIAndTipoTramite.get(mapCDIAndLEI.get(doc.ContentDocumentId)),
					'id' => doc.Id_reintento__c != null ? 
						doc.Id_reintento__c : mapLEIAndNroSS.get(mapCDIAndLEI.get(doc.ContentDocumentId)),
					'usuario' => doc.Usuario_error__c != null ?
						doc.Usuario_error__c : mapLEIAndCommunityName.get(mapCDIAndLEI.get(doc.ContentDocumentId)), 
					'archivos' => new List<Object>{fileMap}
				};
			
				System.debug('file ' + fileMap);
				System.debug('body ' + bodyMap);
				WSArchivosCarga.Response resp = WSArchivosCarga.uploadFiles(JSON.serialize(bodyMap),token);
				if(resp.token != null){	
					token = resp.token;
				}  

				/*if(!resp.hasError){
					doc.Id_reintento__c = null;
					doc.Tipo_entidad_error__c = null;
					doc.Enviado__c = true;
					doc.Error_al_enviar__c = null;
					doc.Fecha_de_error__c = null;
					doc.Usuario_error__c = null;
				}
				else{
					doc.Error_al_enviar__c = resp.message;
					doc.Fecha_de_error__c = Datetime.now();
				}*/
			
				System.debug('resp ' + resp );
				System.debug('doc ' + doc);
				ContentVersion updateVersion = new ContentVersion(Id = doc.Id);
				//updateVersion.Id = doc.Id;
				/*updateVersion.VersionData = doc.VersionData;
				updateVersion.ContentDocumentId = doc.ContentDocumentId;
				updateVersion.Title = doc.Title;
				updateVersion.PathOnClient = doc.PathOnClient;
				updateVersion.Description = doc.Description;*/
				if(!resp.hasError){
					System.debug('Se envio correctamente');
					updateVersion.Id_reintento__c = null;
					updateVersion.Tipo_entidad_error__c = null;
					updateVersion.Enviado__c = true;
					updateVersion.Error_al_enviar__c = null;
					updateVersion.Fecha_de_error__c = null;
					updateVersion.Usuario_error__c = null;
					versionsToUpdate.add(updateVersion);
				}
				else{
					System.debug('error ' + resp.message);
					updateVersion.Id_reintento__c = doc.Id_reintento__c != null ? 
						doc.Id_reintento__c : mapLEIAndNroSS.get(mapCDIAndLEI.get(doc.ContentDocumentId));
					updateVersion.Tipo_entidad_error__c = doc.Tipo_entidad_error__c != null ?
						doc.Tipo_entidad_error__c : mapLEIAndTipoTramite.get(mapCDIAndLEI.get(doc.ContentDocumentId));
					updateVersion.Error_al_enviar__c = resp.message;
					updateVersion.Fecha_de_error__c = Datetime.now();
					updateVersion.Usuario_error__c = doc.Usuario_error__c != null ?
						doc.Usuario_error__c : mapLEIAndCommunityName.get(mapCDIAndLEI.get(doc.ContentDocumentId));
					versionsToUpdate.add(updateVersion);
				}	
			}
			WSAuthToken.manageTokenResponse(token);

		}
		update versionsToUpdate;
	}
	

	global void finish(Database.BatchableContext context) {
		
	}
}