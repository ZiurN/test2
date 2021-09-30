public class AsociadoEmpleosBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoEmpleos(String idAsociado) {
		WSAsociadoGetEmpleos.Response wsResponse =  WSAsociadoGetEmpleos.getAsociadoEmpleos(idAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoEmpleos.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los empleos desde SaludSoft, asegúrese que el Id de afiliado esté completo', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetEmpleosResp.Data> asociadoEmpleos;

		public Response(Boolean hasError, String message, List<WSAsociadoGetEmpleosResp.Data> asociadoEmpleos){
			this.hasError = hasError;
			this.message = message;
			this.asociadoEmpleos = asociadoEmpleos;
		}
	}  
}