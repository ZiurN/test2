public class AsociadoAportesDeclaradosBtnCtrl {

	@AuraEnabled
	public static Response getAsociadoAportesDeclarados(String codigoDeAsociado) {
        codigoDeAsociado = codigoDeAsociado.replace('/', '-');
		WSAsociadoGetAportesDeclarados.Response wsResponse =  WSAsociadoGetAportesDeclarados.getAsociadoAportesDeclarados(codigoDeAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoAportesDeclarados.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los aportes declarados desde SaludSoft', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetAportesDeclaradosResp.Data> asociadoAportesDeclarados;

		public Response(Boolean hasError, String message, List<WSAsociadoGetAportesDeclaradosResp.Data> asociadoAportesDeclarados){
			this.hasError = hasError;
			this.message = message;
			this.asociadoAportesDeclarados = asociadoAportesDeclarados;
		}
	}  
}