public class AsociadoValoracionesBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoValorizaciones(String asociadoId, String month, String year) {
        String period = month + '-' + year;
		WSAsociadoGetValoraciones.Response wsResponse =  WSAsociadoGetValoraciones.getAsociadoValoraciones(asociadoId, period);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoValoraciones.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener las valorizaciones desde SaludSoft', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetValoracionesResp.Data> asociadoValoraciones;

		public Response(Boolean hasError, String message, List<WSAsociadoGetValoracionesResp.Data> asociadoValoraciones){
			this.hasError = hasError;
			this.message = message;
			this.asociadoValoraciones = asociadoValoraciones;
		}
	}  
}