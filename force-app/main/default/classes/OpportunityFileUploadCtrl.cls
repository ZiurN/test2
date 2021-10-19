public without sharing class OpportunityFileUploadCtrl {

    @AuraEnabled
    public static Response changeFileName(String docId, String entityId, String file) {
		List<Id> docIds = new List<Id>();
		String titulo = file + '%';
		List<ContentVersion> versionsToDelete = [
			SELECT ContentDocumentId 
			FROM ContentVersion 
			WHERE Title LIKE :titulo AND ContentDocumentId != :docId AND IsLatest = true
			//WHERE Title = :file AND ContentDocumentId != :docId AND IsLatest = true
		];

		//for(ContentVersion version : versionsToDelete){
			//docIds.add(version.ContentDocumentId);			
		//}
		//List<ContentDocumentLink> linksToDelete = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :entityId AND ContentDocumentId IN :docIds];
		//List<ContentDocument> docsToDelete = [SELECT Id FROM ContentDocument WHERE Id IN :docIds];

		//delete linksToDelete;
		//delete docsToDelete;


        ContentVersion[] ver = [
			SELECT Title, Enviado__c, Titulo_original__c
			FROM ContentVersion 
			WHERE ContentDocumentId = :docId
		];

		if(!ver.isEmpty()) {
			System.debug('EL CV BEFORE: ' + ver[0]);
			//ver[0].Title = file;
			String title = versionsToDelete.isEmpty() ? file : file + '(' + (versionsToDelete.size() + 1) + ')';
			ver[0].Titulo_original__c = ver[0].Title;
			ver[0].Title = title;
			ver[0].Enviado__c = false;
			Database.SaveResult res = Database.update(ver[0]);
			System.debug('EL CV AFTER: ' + ver[0]);
			if(res.isSuccess()){
				return new Response(false,'Archivo guardado exitosamente');
			}
			return new Response(true,'Hubo un error al cargar el archivo');
		}
		return new Response(true,'No hay ningun archivo al cual modificar');
    }
	@AuraEnabled
	public static ResponseIntegrantes getIntegrantesFromOpp(Id oppId){
		List<Opportunity> integrantes = [
			SELECT Id, (SELECT Id, Nro_de_documento__c,Apellido__c,Nombre__c,Integrante_tipo_asociado__c,Aportes__c, Oportunidad__c,Tipo_de_relacion_con_titular__c, Edad__c,Indicador_de_aporte__c FROM Integrantes__r)
			FROM Opportunity
			WHERE Id = : oppId
			];
		return new ResponseIntegrantes(false,'',integrantes.get(0).Integrantes__r);
	}
    
    @AuraEnabled
    public static ResponseProfile getCreatorsProfile(Id userId){
        List<User> users = [
            SELECT Profile.Name
            FROM User
            WHERE Id = :userId
        ];
        if(users.isEmpty()){
            return new ResponseProfile(true,'Error al encontrar el usuario creador',null);
        }
        else{
            return new ResponseProfile(false,'',users[0].Profile.Name);
        }
    }

	@AuraEnabled
	public static ResponseFiles getFilesUploaded(Id oppId){
		List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :oppId];
		List<String> docs = new List<String>();
		for(ContentDocumentLink link : links){
			docs.add(link.ContentDocumentId);
		}
		List<ContentVersion> versions = [
			SELECT Id, Title
			FROM ContentVersion
			WHERE ContentDocumentId IN :docs AND IsLatest = true
		];
		List<String> filenames = new List<String>();
		for(ContentVersion ver : versions){
			filenames.add(ver.Title.substringBeforeLast('.'));
		}
		return new ResponseFiles(false,'',filenames);
	}
	@AuraEnabled
	public static ReponseVerifyDocumentUpload getDocumentDDJJ(Id oppId){
		String title = '%DDJJ%';
		List<Id> documentId = new List<Id>();
		for (ContentDocumentLink contentDocumentList :[
			SELECT ContentDocumentId	
			FROM ContentDocumentLink 
			WHERE LinkedEntityId =: oppId
		])
		{
			documentId.add(contentDocumentList.ContentDocumentId);
		}
		List<ContentDocument> documentDDJJ = [
			SELECT Title 
			FROM ContentDocument 
			WHERE Title LIKE: title AND Id IN: documentId 
		];
		Boolean contentDDJJ = documentDDJJ.size() >= 1;
		return new ReponseVerifyDocumentUpload(false, '', contentDDJJ);
	}

	@AuraEnabled
	public static ReponseVerifyDocumentUpload getDocumentSolicitudIngreso(Id oppId){
		String title = '%ingreso%';
		List<Id> documentId = new List<Id>();
		for (ContentDocumentLink contentDocumentList :[
			SELECT ContentDocumentId	
			FROM ContentDocumentLink 
			WHERE LinkedEntityId =: oppId
		])
		{
			documentId.add(contentDocumentList.ContentDocumentId);
		}
		List<ContentDocument> documentIngreso = [
			SELECT Title 
			FROM ContentDocument 
			WHERE Title LIKE: title AND Id IN: documentId 
		];
		Boolean contentIngreso = documentIngreso.size() >= 1;
		return new ReponseVerifyDocumentUpload(false, '', contentIngreso);
	
	}

	@AuraEnabled
	public static ResponseActivateFilesUpload getActivateFilesUpload(Id oppId){
		Opportunity op = [
			SELECT Activar_seleccionar_archivos__c, Tipo_de_Solicitud__c, CreatedById, OwnerId
			FROM Opportunity 
			WHERE Opportunity.Id =: oppId
		];
		User usr = [
			SELECT Name, Profile.Name 
			FROM User 
			WHERE Id =: op.OwnerId
		];

		if(usr.Profile.Name != 'FRONT'){
			return new ResponseActivateFilesUpload(false, '', op.Activar_seleccionar_archivos__c);
		}
		else if(usr.Profile.Name == 'FRONT'){
			return new ResponseActivateFilesUpload(false, '', true);
		}
		else {
			return new ResponseActivateFilesUpload(false,'',false);
		}
	}

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message){
            this.hasError = hasError;
            this.message = message;

        }
    }

	public class ResponseActivateFilesUpload {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
		@AuraEnabled public Boolean checkbox;

        public ResponseActivateFilesUpload(Boolean hasError, String message, Boolean activateFiles){
            this.hasError = hasError;
            this.message = message;
			this.checkbox = activateFiles;

        }
	}
	public class ResponseFiles {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
		@AuraEnabled public List<String> files;

        public ResponseFiles(Boolean hasError, String message, List<String> atts){
            this.hasError = hasError;
            this.message = message;
			this.files = atts;

        }
    }
	public class ReponseVerifyDocumentUpload {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public Boolean hasDocument;
		public ReponseVerifyDocumentUpload (Boolean hasError, String message, Boolean hasDocument){
			this.hasError = hasError;
			this.message = message;
			this.hasDocument = hasDocument;
		}
	}
	public class ResponseIntegrantes {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
		@AuraEnabled public List<Integrante__c> integrantes;

        public ResponseIntegrantes(Boolean hasError, String message, List<Integrante__c> ints){
            this.hasError = hasError;
            this.message = message;
			this.integrantes = ints;

        }
    }
    
    public class ResponseProfile {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public String profile;
        
        public ResponseProfile(Boolean hasError, String message, String prof){
            this.hasError = hasError;
            this.message = message;
            this.profile = prof;
        }
    }
}