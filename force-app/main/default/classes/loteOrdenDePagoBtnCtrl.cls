public with sharing class loteOrdenDePagoBtnCtrl {
	@AuraEnabled
	public static Response getOrdenesDePago(String id_lote) {
		WSLoteOrdenDePago.Response wsResponse =  WSLoteOrdenDePago.getOrdenesDePago(id_lote);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.loteOrdenDePago.data);
		}
		else{
			return new Response(true, 'El lote solicitado es inválido.', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSLoteOrdenDePagoResp.data> ordenesDePago;

		public Response(Boolean hasError, String message, List<WSLoteOrdenDePagoResp.data> ordenesDePago){
			this.hasError = hasError;
			this.message = message;
			this.ordenesDePago = ordenesDePago;
            system.debug('this.ordenesDePago');
            system.debug(this.ordenesDePago);
		}
	}  
}