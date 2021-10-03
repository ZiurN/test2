public class AsociadoAlertasBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoAlertas(String asociadoId) {
		WSAsociadoGetAlertas.Response wsResponse =  WSAsociadoGetAlertas.getAsociadoAlertas(asociadoId);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoAlertas.data.alertas, wsResponse.asociadoAlertas.data.checks);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener las alertas desde SaludSoft', null, null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
        @AuraEnabled public List<WSAsociadoGetAlertasResp.Alertas> asociadoAlertas;
		@AuraEnabled public List<WSAsociadoGetAlertasResp.Checks> asociadoChecks;

		public Response(Boolean hasError, String message, List<WSAsociadoGetAlertasResp.Alertas> asociadoAlertas, List<WSAsociadoGetAlertasResp.Checks> asociadoChecks){
			this.hasError = hasError;
			this.message = message;
            this.asociadoAlertas = asociadoAlertas;
			this.asociadoChecks = asociadoChecks;
		}
	} 
}