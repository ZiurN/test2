public class LoteOrdenReintegroBtnCtrl {
	@AuraEnabled
	public static Response getOrdenReintegro(String lot_id) {
		WSLoteOrdenReintegro.Response wsResponse =  WSLoteOrdenReintegro.getOrdenReintegro(lot_id);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.lote.data);
		}
		else{
			return new Response(true, 'El lote solicitado es inválido.', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSLoteOrdenReintegroResp.data> lote;

		public Response(Boolean hasError, String message, List<WSLoteOrdenReintegroResp.data> lote){
			this.hasError = hasError;
			this.message = message;
			this.lote = lote;
            system.debug('this.lote');
            system.debug(this.lote);
		}
	}
}