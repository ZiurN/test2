public class AsociadoGetCopagoCtrl  {

	@AuraEnabled
	public static Response getAsociadoCopago(String idAsociado) {
	System.debug(idAsociado);
		WSAsociadoGetCopago.Response wsResponse =  WSAsociadoGetCopago.getAsociadoCopago(idAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoCopago);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener el copago del afiliado desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public WSAsociadoGetCopagoResp asociadoCopago;

		public Response(Boolean hasError, String message, WSAsociadoGetCopagoResp asociadoCopago){
			this.hasError = hasError;
			this.message = message;
			this.asociadoCopago = asociadoCopago;
		}
	}  
}