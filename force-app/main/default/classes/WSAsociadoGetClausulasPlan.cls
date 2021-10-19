public class WSAsociadoGetClausulasPlan  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoClausulasPlan(String idAsociado, String modeloPlanCodigo) {
			
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/clausulas/plan/' + IdAsociado + '/' + modeloPlanCodigo, 'GET', null);

		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetClausulasPlanResp asociadoClausulasPlan;
		public override void processResponse(HttpResponse response) {
			//asociadoClausulasPlan = (WSAsociadoGetClausulasPlanResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetClausulasPlanResp.class);
			asociadoClausulasPlan = WSAsociadoGetClausulasPlanResp.parse(response.getBody());
		}
	}
}