public class AsociadoClausulasPlanBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoClausulasPlan(String idAsociado, String modeloPlanCodigo) {
		WSAsociadoGetClausulasPlan.Response wsResponse =  WSAsociadoGetClausulasPlan.getAsociadoClausulasPlan(idAsociado, modeloPlanCodigo);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoClausulasPlan.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener las clausulas de plan desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetClausulasPlanResp.Data> asociadoClausulasPlan;

		public Response(Boolean hasError, String message, List<WSAsociadoGetClausulasPlanResp.Data> asociadoClausulasPlan){
			this.hasError = hasError;
			this.message = message;
			this.asociadoClausulasPlan = asociadoClausulasPlan;
		}
	}  
}