public class WSBatchAsociado  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	// Formato fecha DD-MM-AAAA
	public static Response getBatchAsociado(String fecha, Integer pageSize, Integer currentPage) {
		String filtro = pageSize > 0 ? '?pageSize=' + pageSize + '&page=' + currentPage : '';
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/batch/afiliados/' + fecha + filtro, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSBatchAsociadoResp asociado;
		public override void processResponse(HttpResponse response) {
			//asociado = (WSBatchAsociadoResp)
				//JSON.deserialize(response.getBody(), WSBatchAsociadoResp.class);
			asociado = WSBatchAsociadoResp.parse(response.getBody());
		}
	}
}