public class ContentDocumentQueueable implements Queueable, Database.AllowsCallouts {
	List<ContentDocument> cds;

	public ContentDocumentQueueable(List<ContentDocument> contentDocuments) {
		cds = contentDocuments;
	}

	public void execute(QueueableContext context) {
		System.debug('****cds: ' + cds);
        if(!cds.isEmpty()) {
            ContentDocument cd = cds.remove(0);
            System.debug('****ContentDocument: ' + cd);
            List<Archivo_url__c> archivoUrls = [
                SELECT Id, Nombre_original__c, Caso__c, Evento_Medico__c, 
                    Oportunidad__c, Ruta_relativa__c, Enviado__c
                FROM Archivo_url__c
                WHERE Nombre_original__c =: cd.Title.toUpperCase()
            ];

            System.debug('****archivoUrls: ' + archivoUrls);
            if(archivoUrls.isEmpty()) {
                return;
            }

            Set<Id> entitiesIds = new Set<Id>();
            for(Archivo_url__c file : archivoUrls) {
                if(String.isNotBlank(file.Caso__c)) {
                    entitiesIds.add(file.Caso__c);
                }
                else if(String.isNotBlank(file.Evento_Medico__c)) {
                    entitiesIds.add(file.Evento_Medico__c);
                }
                else if(String.isNotBlank(file.Oportunidad__c)) {
                    entitiesIds.add(file.Oportunidad__c);
                }
            }

            Archivo_url__c archivoUrl = null;
            List<ContentDocumentLink> cdls = [
                SELECT Id, ContentDocument.Title, LinkedEntityId, ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId IN :entitiesIds
                    AND ContentDocument.Title =: cd.Title
            ];
            System.debug('****cdls: ' + cdls);

            Map<Id, ContentDocumentLink> cdlByLinkedEntityId = new Map<Id, ContentDocumentLink>();
            for(ContentDocumentLink cdl : cdls) {
                cdlByLinkedEntityId.put(cdl.LinkedEntityId, cdl);
            }

            for(Archivo_url__c file : archivoUrls) {
                if(String.isNotBlank(file.Caso__c) && cdlByLinkedEntityId.get(file.Caso__c) == null) {
                    archivoUrl = file;
                }
                else if(String.isNotBlank(file.Evento_Medico__c) && cdlByLinkedEntityId.get(file.Evento_Medico__c) == null) {
                    archivoUrl = file;
                }
                else if(String.isNotBlank(file.Oportunidad__c) && cdlByLinkedEntityId.get(file.Oportunidad__c) == null) {
                    archivoUrl = file;
                }
            }
            System.debug('****archivoUrl: ' + archivoUrl);

            if(archivoUrl != null) {
                AWS.Response resp = AWS.deleteFile(archivoUrl);
                System.debug('****resp: ' + resp);
                if(!resp.hasError) {
                    delete archivoUrl;
                }
            }           
        }

        if(!cds.isEmpty()){
            System.enqueueJob(new ContentDocumentQueueable(cds));
        }
    }
}