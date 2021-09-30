public class WSEmpresaGetPlanConvenios  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getEmpresaPlanConvenios(Integer planId) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios/planes-permitidos/' + planId, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSEmpresaGetPlanConveniosResp empresaPlanConvenios;
		public override void processResponse(HttpResponse response) {
			//empresaPlanConvenios = (WSEmpresaGetPlanConveniosResp)
				//JSON.deserialize(response.getBody(), WSEmpresaGetPlanConveniosResp.class);
			empresaPlanConvenios = WSEmpresaGetPlanConveniosResp.parse(response.getBody());
		}
	}
}