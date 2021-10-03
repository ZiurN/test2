public with sharing class ClausulaTempNotificationCtrl {
    @AuraEnabled
    public static Boolean hasAttachments(Id id) {

        List<ContentDocumentLink> dbLinks = [
                SELECT LinkedEntityId,ContentDocumentId,ContentDocument.LatestPublishedVersionId
                FROM ContentDocumentLink
                WHERE LinkedEntityId =: id
        ];

        return !dbLinks.isEmpty();
    }

    @AuraEnabled
    public static Response hasAttachmentsErrorMsg(Id id){
        
		if(!hasAttachments(id)) {
            return new Response(true, 'Recuerde adjuntar el Certificado de Embarazo');
        }
        return new Response(false, 'ok');
    }

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message) {
            this.hasError = hasError;
            this.message = message;
        }
	}
}