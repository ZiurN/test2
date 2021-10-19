public class PrestadorPresupuestosBtnCtrl  {
	@AuraEnabled
	public static Response getPrestadorPresupuesto(Integer codEfector) {
		WSPrestadorGetPresupuestos.Response wsResponse =  WSPrestadorGetPresupuestos.getPrestadorPresupuesto(codEfector);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.prestadorPresupuestos.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los presupuestos desde SaludSoft, asegúrese que el código de efector esté completo y sea válido', null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSPrestadorGetPresupuestosResp.Data> prestadorPresupuestos;

		public Response(Boolean hasError, String message, List<WSPrestadorGetPresupuestosResp.Data> prestadorPresupuestos){
			this.hasError = hasError;
			this.message = message;
			this.prestadorPresupuestos = prestadorPresupuestos;
		}
	}  
}