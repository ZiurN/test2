public class AsociadoHistoricoBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoHistorico(String idAsociado) {
		WSAsociadoGetHistorico.Response wsResponse =  WSAsociadoGetHistorico.getAsociadoHistorico(idAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoHistorico.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener el histórico del afiliado desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetHistoricoResp.Data> asociadoHistorico;

		public Response(Boolean hasError, String message, List<WSAsociadoGetHistoricoResp.Data> asociadoHistorico){
			this.hasError = hasError;
			this.message = message;
			this.asociadoHistorico = asociadoHistorico;
		}
	}  
}