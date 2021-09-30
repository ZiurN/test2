public class AsociadoCuotasBtnCtrl {
	@AuraEnabled
	public static Response getAsociadoCuotas(String idAsociado) {
		WSAsociadoGetCuotas.Response wsResponse =  WSAsociadoGetCuotas.getAsociadoCuotas(idAsociado);

		if(!wsResponse.hasError){
			List<WSAsociadoGetCuotasResp.Data> filterList = new List<WSAsociadoGetCuotasResp.Data>();
			for(WSAsociadoGetCuotasResp.Data cuota : wsResponse.asociadoCuotas.data) {
				List<String> fechaList = cuota.periodo.split('-');
				cuota.periodo = fechaList[1] + '/' + fechaList[0]; 
				filterList.add(cuota);
			} 
			return new Response(false, '', filterList);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener las cuotas desde SaludSoft', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
        @AuraEnabled public List<WSAsociadoGetCuotasResp.Data> asociadoCuotas;

		public Response(Boolean hasError, String message, List<WSAsociadoGetCuotasResp.Data> asociadoCuotas){
			this.hasError = hasError;
			this.message = message;
            this.asociadoCuotas = asociadoCuotas;
		}
	} 
}