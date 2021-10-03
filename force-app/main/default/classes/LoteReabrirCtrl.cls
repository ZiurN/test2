public class LoteReabrirCtrl  {
	@AuraEnabled
    public static Response reopenLote(String id_lote) {

		if(String.isBlank(id_lote)){
			return new Response(true, 'El lote no existe en SS');
		}

		Lote__c lote = [SELECT Id, Estado__c FROM Lote__c WHERE Id_lote_SS__c = :id_lote];

		if(lote.Estado__c != 'C'){
			return new Response(true, 'El lote debe estar cerrado para poder reabrirlo');
		}

		User usuario = [SELECT Id,CommunityNickname FROM User WHERE Id = :UserInfo.getUserId()];
		String apodo = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;

		String body = '{"accion":"REABRIR","usuario":"'+ apodo +'"}';
        System.debug(body);
		WSLoteReabrir.Response wsResponse =  WSLoteReabrir.reabrirLote(id_lote,body);

        if(!wsResponse.hasError){
			lote.Estado__c = 'A';
			lote.Bloqueo__c = false;
			update lote;
            return new Response(false,
                    'Se reabrió el lote con éxito.');
        }
		return new Response(true,
                    wsResponse.message);
        
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