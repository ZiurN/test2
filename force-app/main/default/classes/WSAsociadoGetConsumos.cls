public class WSAsociadoGetConsumos  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getAsociadoConsumosOrderByDateDesc(String codigoDeAsociado, Integer currentPage) {
		String filtro = '?sortBy=fecha_prestacion&sortOrder=desc&pageSize=50&page=' + String.valueOf(currentPage); 
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/consumos/' + codigoDeAsociado + filtro, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAsociadoGetConsumosResp asociadoConsumos;
		public override void processResponse(HttpResponse response) {
			//asociadoConsumos = (WSAsociadoGetConsumosResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetConsumosResp.class);
			asociadoConsumos = WSAsociadoGetConsumosResp.parse(response.getBody());
        
		}
	}
}