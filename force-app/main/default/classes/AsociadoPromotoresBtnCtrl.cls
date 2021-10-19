public class AsociadoPromotoresBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoPromotores(String idAsociado) {
		WSAsociadoGetPromotores.Response wsResponse =  WSAsociadoGetPromotores.getAsociadoPromotores(idAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoPromotores.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los promotores desde SaludSoft, asegúrese que el Id de afiliado esté completo', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetPromotoresResp.Data> asociadoPromotores;

		public Response(Boolean hasError, String message, List<WSAsociadoGetPromotoresResp.Data> asociadoPromotores){
			this.hasError = hasError;
			this.message = message;
			this.asociadoPromotores = asociadoPromotores;
		}
	}  
}