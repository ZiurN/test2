public class WSBatchTelefono  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	// Formato fecha AAAA-MM-DD
	public static Response getBatchTelefono(String fecha, Integer pageSize, Integer currentPage, Boolean migracionInicial) {
		String url = migracionInicial ? '/v1/salud/batch/asociados/telefonos-m/' : '/v1/salud/batch/asociados/telefonos/';
		String filtro = pageSize > 0 ? '?pageSize=' + pageSize + '&page=' + currentPage : '';
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + url + fecha + filtro, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSBatchTelefonoResp resp;
		public override void processResponse(HttpResponse response) {
			resp = (WSBatchTelefonoResp)
				JSON.deserialize(response.getBody(), WSBatchTelefonoResp.class);
		}
	}
}