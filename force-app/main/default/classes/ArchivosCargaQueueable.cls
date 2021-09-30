public class ArchivosCargaQueueable implements Queueable, Database.AllowsCallouts {

	public String entityId;
	public List<Id> documents;
	public String entityType;
	public String username;

	public ArchivosCargaQueueable(String entId, String entType, String nickname, List<Id> docs){
		entityId = entId;
		entityType = entType;
		username = nickname;
		documents = docs;
	}

	public void execute(QueueableContext context) {
		if(!documents.isEmpty()){
			Id docId = documents.remove(0);
			ContentVersion doc = [
			SELECT FileExtension,FileType, Title, Description, VersionData, Id_reintento__c,Tipo_entidad_error__c,Enviado__c,Error_al_enviar__c,Usuario_error__c
			FROM ContentVersion
			WHERE Id = :docId
			];
			String title = Utils.getStringAlphanumericOnly(doc.Title);

			if(title.length() > 44) {
				title = title.substring(0, 44);
			}
			
			Map<String, Object> fileMap = new Map<String, Object>{
					'datos' => 'data:' + Utils.getTypeAndExtension(doc.FileExtension) + ';base64,' + EncodingUtil.base64Encode(doc.VersionData),
					'observaciones' => null,
    				'descripcion' => doc.Description,
					'nombre' => title.contains('.' + doc.FileExtension) 
									? title.toUpperCase() : (title + '.' + doc.FileExtension).toUpperCase()
				};
			Map<String, Object> bodyMap = new Map<String, Object>{
				'tipo_tramite' => entityType,
				'id' => entityId,
				'usuario' => username,
				'archivos' => new List<Object>{fileMap}
			};

			System.debug('****body: ' + bodyMap);

			WSArchivosCarga.Response resp = WSArchivosCarga.uploadFiles(JSON.serialize(bodyMap),null);  
			System.debug('***resp ' + resp);
			ContentVersion updateVersion = new ContentVersion(Id = doc.Id);
			//updateVersion.VersionData = doc.VersionData;
			//updateVersion.ContentDocumentId = doc.ContentDocumentId;
			//updateVersion.Title = doc.Title;
			//updateVersion.PathOnClient = doc.PathOnClient;
			//updateVersion.Description = doc.Description;
			if(!resp.hasError){
				updateVersion.Id_reintento__c = null;
				updateVersion.Tipo_entidad_error__c = null;
				updateVersion.Enviado__c = true;
				updateVersion.Error_al_enviar__c = null;
				updateVersion.Fecha_de_error__c = null;
				updateVersion.Usuario_error__c = null;
				//insert updateVersion;
			}
			else{
				updateVersion.Id_reintento__c = entityId;
				updateVersion.Tipo_entidad_error__c = entityType;
				updateVersion.Error_al_enviar__c = resp.message;
				updateVersion.Fecha_de_error__c = Datetime.now();
				updateVersion.Usuario_error__c = username;
				//insert updateVersion;
			}

			Database.SaveResult resultCV = Database.update(updateVersion);
			System.debug('***resultCV: ' + resultCV);

			if(!documents.isEmpty() && !Test.isRunningTest()){
				System.enqueueJob(new ArchivosCargaQueueable(entityId,entityType,username,documents));
			}
		}

	}
}