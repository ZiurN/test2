public class AsociadoConstanciaProvCtrl  {

	@AuraEnabled
	public static Response getConstanciaProvisoria(String case_id,String codigo_asociado){
		WSAsociadoConstanciaProv.Response wsResp = WSAsociadoConstanciaProv.getConstancia(codigo_asociado);
		if(wsResp.hasError){
			return new Response(true,wsResp.message);
		}

		PageReference ref = new PageReference(wsResp.constancia.data.link);
		Blob contentPDF;
		try{
			contentPDF =ref.getContentAsPDF();
		}
		catch(Exception e){
			System.debug(e);
			if(Test.isRunningTest()){
				contentPDF = Blob.valueOf('test');
			}
			else{
				return new Response(true,'Error al obtener el archivo .pdf');
			}
		}
		ContentDocumentLink[] link = [
			SELECT Id,ContentDocument.LatestPublishedVersion.Title,ContentDocumentId
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :case_id
			AND ContentDocument.LatestPublishedVersion.Title = 'ConstanciaProvisoria'
		]; 
		ContentVersion newVersion = new ContentVersion(); 
		if(!link.isEmpty()){
			newVersion.ContentDocumentId = link[0].ContentDocumentId;
		}
		newVersion.VersionData = contentPDF;
		newVersion.PathOnClient = '/ConstanciaProvisoria.pdf';
		newVersion.Title = 'ConstanciaProvisoria';
		insert newVersion;
		if(link.isEmpty()){
			newVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :newVersion.Id];
			ContentDocumentLink docLink = new ContentDocumentLink();
			docLink.LinkedEntityId = case_id;
			docLink.ShareType = 'V';
			docLink.ContentDocumentId = newVersion.ContentDocumentId;
			insert docLink;
		}
		return new Response(false, 'Constancia provisoria generada');
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