public class AsociadoCredencialesBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoCredenciales(String idAsociado) {
		WSAsociadoGetCredenciales.Response wsResponse =  WSAsociadoGetCredenciales.getAsociadoCredenciales(idAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoCredenciales.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener las credenciales desde SaludSoft, asegúrese que el Id de afiliado esté completo', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetCredencialesResp.Data> asociadoCredenciales;

		public Response(Boolean hasError, String message, List<WSAsociadoGetCredencialesResp.Data> asociadoCredenciales){
			this.hasError = hasError;
			this.message = message;
			this.asociadoCredenciales = asociadoCredenciales;
		}
	}  
}