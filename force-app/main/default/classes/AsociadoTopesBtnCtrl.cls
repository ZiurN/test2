public class AsociadoTopesBtnCtrl  {
	@AuraEnabled
	public static TopesResponse getAsociadoTopes(String asociadoId, Date fecha) {
		WSAsociadoGetTopes.Response wsResponse =  WSAsociadoGetTopes.getTopes(asociadoId, fecha);

		if(!wsResponse.hasError){
			return new TopesResponse(false, '', wsResponse.asociadoTopes.data);
		}
		else{
			return new TopesResponse(true, 'Hubo un error al intentar obtener los topes del afiliado desde SaludSoft', null);
		}
	}

	@AuraEnabled
	public static ConsumosDeTopeResponse getAsociadoConsumoDeTope(String asociadoId, Date fecha, String topeTipo, String topeId) {
		WSAsociadoGetConsumoDeTope.Response wsResponse =  WSAsociadoGetConsumoDeTope.getConsumoDeTope(asociadoId, fecha, topeTipo, topeId);

		if(!wsResponse.hasError){
			return new ConsumosDeTopeResponse(false, '', wsResponse.asociadoConsumoDeTope.data);
		}
		else{
			return new ConsumosDeTopeResponse(true, 'Hubo un error al intentar obtener los consumos del tope desde SaludSoft', null);
		}
	}

	public class TopesResponse {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetTopesResp.Data> asociadoTopes;

		public TopesResponse(Boolean hasError, String message, List<WSAsociadoGetTopesResp.Data> asociadoTopes){
			this.hasError = hasError;
			this.message = message;
			this.asociadoTopes = asociadoTopes;
		}
	}

	public class ConsumosDeTopeResponse {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetConsumoDeTopeResp.Data> asociadoConsumosDeTope;

		public ConsumosDeTopeResponse(Boolean hasError, String message, List<WSAsociadoGetConsumoDeTopeResp.Data> asociadoConsumosDeTope){
			this.hasError = hasError;
			this.message = message;
			this.asociadoConsumosDeTope = asociadoConsumosDeTope;
		}
	}  

}