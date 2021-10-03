public class LoteContabilizacionCtrl  {

	@AuraEnabled
    public static Response contabilizacion(String id_lote,String accion) {

		if(String.isBlank(id_lote)){
			return new Response(true, 'El lote no existe en SS');
		}

		Lote__c lote = [SELECT Id, Estado__c FROM Lote__c WHERE Id_lote_SS__c = :id_lote];

		if(lote.Estado__c != 'C' && accion == 'CONTABILIZAR'){
			return new Response(true, 'El lote debe estar cerrado para poder contabilizarlo');
		}

		if(lote.Estado__c != 'O' && accion == 'ANULAR'){
			return new Response(true, 'El lote debe estar contabilizado para poder anularlo');
		}

		User usuario = [SELECT Id,CommunityNickname FROM User WHERE Id = :UserInfo.getUserId()];
		String apodo = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;

		String body = '{"accion":"'+ accion +'","usuario":"'+ apodo +'"}';
        System.debug(body);
		WSLoteContabilizar.Response wsResponse =  WSLoteContabilizar.contabilizacion(id_lote,body);

        if(!wsResponse.hasError){
			lote.Estado__c = wsResponse.lote.data.lote.estado;
			lote.Bloqueo__c = false;
			if(accion == 'CONTABILIZAR'){
				lote.Orden_generada__c = true;
			}
			else{
				lote.Orden_generada__c = false;
			}
			System.debug(lote);
			update lote;
            return new Response(false,
                    wsResponse.lote.message);
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