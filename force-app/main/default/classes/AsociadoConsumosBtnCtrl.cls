public class AsociadoConsumosBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoConsumos(String codigoDeAsociado, Integer currentPage) {
        codigoDeAsociado = codigoDeAsociado.replace('/', '-');
		WSAsociadoGetConsumos.Response wsResponse =  WSAsociadoGetConsumos.getAsociadoConsumosOrderByDateDesc(codigoDeAsociado, currentPage);

		if(!wsResponse.hasError){
			Pagination paginado = new Pagination(
				wsResponse.asociadoConsumos.links.prev,
				wsResponse.asociadoConsumos.links.next,
				wsResponse.asociadoConsumos.meta.current_page,
				1,
				wsResponse.asociadoConsumos.meta.last_page,
				wsResponse.asociadoConsumos.meta.total	
			);
			System.debug(wsResponse.asociadoConsumos.meta);
			System.debug(wsResponse.asociadoConsumos.links);
			return new Response(false, '', wsResponse.asociadoConsumos.data, paginado);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los consumos desde SaludSoft, asegúrese que el código de afiliado esté completo y sea válido', null, null);
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetConsumosResp.Data> asociadoConsumos;
		@AuraEnabled public Pagination paginado;

		//public Response(Boolean hasError, String message, List<WSAsociadoGetConsumosResp.Data> asociadoConsumos){
		public Response(Boolean hasError, String message, List<WSAsociadoGetConsumosResp.Data> asociadoConsumos, Pagination paginado){
			this.hasError = hasError;
			this.message = message;
			this.asociadoConsumos = asociadoConsumos;
			this.paginado = paginado;
		}
	}  
}