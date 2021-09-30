public class LotePasajeAIFCtrl  {

	@AuraEnabled
    public static Response changeToIF(String id_lote) {
		User usuario = [SELECT CommunityNickname FROM User WHERE Id = :UserInfo.getUserId()];
		String apodo = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;
		Lote__c lote = [SELECT Id, Estado__c FROM Lote__c WHERE Id_lote_SS__c = :id_lote];
        WSLotePasajeAIF.Response wsResponse =  WSLotePasajeAIF.pasajeIF(id_lote,'{"usuario":"'+ apodo +'"}');

        if(!wsResponse.hasError){
			PageReference page = new PageReference(wsResponse.lote.data.lote.link_if);
			ContentVersion ver = new ContentVersion();
			try{
				ver.VersionData = page.getContentAsPDF();
			}
			catch(VisualforceException e){
				if(Test.isRunningTest()){
					ver.VersionData = Blob.valueOf('test blob');
				}
				System.debug(e.getMessage());
			}

			ver.Title = 'OrdenesDeReintegro' + wsResponse.lote.data.lote.lr_id;
			ver.PathOnClient = '/OrdenesDeReintegro' + wsResponse.lote.data.lote.lr_id + '.pdf';
			insert ver;
			ver = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = : ver.Id];
			ContentDocumentLink link = new ContentDocumentLink();
			link.ContentDocumentId = ver.ContentDocumentId;
			link.LinkedEntityId = lote.Id;
			link.ShareType = 'V';
			insert link;
			lote.Estado__c = wsResponse.lote.data.lote.estado;
			update lote;
            return new Response(false,
                    wsResponse.lote.message,
                    wsResponse.lote);
        }
        else{
            return new Response(true,
                    wsResponse.message,
                    null);
        }
    }

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public WSLotePasajeAIFResp lote;

        public Response(Boolean hasError, String message, WSLotePasajeAIFResp lote){
            this.hasError = hasError;
            this.message = message;
            this.lote = lote;
        }
    }
}