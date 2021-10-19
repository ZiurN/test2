public class AsociadoAportesTransferidosBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoAportesTransferidos(String codigoDeAsociado) {
        codigoDeAsociado = codigoDeAsociado.replace('/', '-');
		WSAsociadoGetAportesTransferidos.Response wsResponse =  WSAsociadoGetAportesTransferidos.getAsociadoAportesTransferidos(codigoDeAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoAportesTransferidos.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los aportes transferidos desde SaludSoft,asegúrese que el código de afiliado esté completo y sea válido', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetAportesTransferidosResp.Data> asociadoAportesTransferidos;

		public Response(Boolean hasError, String message, List<WSAsociadoGetAportesTransferidosResp.Data> asociadoAportesTransferidos){
			this.hasError = hasError;
			this.message = message;
			this.asociadoAportesTransferidos = asociadoAportesTransferidos;
		}
	}  
}