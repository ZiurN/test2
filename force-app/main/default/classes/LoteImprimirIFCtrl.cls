public class LoteImprimirIFCtrl  {
	@AuraEnabled
    public static Response sendLoteToSS(String id_lote) {
        WSLoteImprimirIF.Response wsResponse =  WSLoteImprimirIF.imprimirIF(id_lote);

        if(!wsResponse.hasError){
            return new Response(false,
                    '',
                    wsResponse.lote.data.lote.link_preliq);
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
        @AuraEnabled public String lote;

        public Response(Boolean hasError, String message, String lote){
            this.hasError = hasError;
            this.message = message;
            this.lote = lote;
        }
    }
}