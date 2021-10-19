public class WSBatchDomicilio  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	// Formato fecha AAAA-MM-DD
	public static Response getBatchDomicilio(String fecha, Integer pageSize, Integer currentPage) {
		String filtro = pageSize > 0 ? '?pageSize=' + pageSize + '&page=' + currentPage : '';
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/batch/asociados/domicilios/' + fecha + filtro, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSBatchDomicilioResp resp;
		public override void processResponse(HttpResponse response) {
			resp = (WSBatchDomicilioResp)
				JSON.deserialize(response.getBody(), WSBatchDomicilioResp.class);
		}
	}
}