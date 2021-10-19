public class AsociadoClausulasTempoBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoClausulasTempo(String idAsociado) {
		WSAsociadoGetClausulasTempo.Response wsResponse =  WSAsociadoGetClausulasTempo.getAsociadoClausulasTempo(idAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoClausulasTempo.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener las clausulas temporarias desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetClausulasTempoResp.Data> asociadoClausulasTempo;

		public Response(Boolean hasError, String message, List<WSAsociadoGetClausulasTempoResp.Data> asociadoClausulasTempo){
			this.hasError = hasError;
			this.message = message;
			this.asociadoClausulasTempo = asociadoClausulasTempo;
		}
	}  
}