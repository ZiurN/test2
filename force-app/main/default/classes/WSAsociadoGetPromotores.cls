public class WSAsociadoGetPromotores  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoPromotores(String idAsociado) {
			
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/promotores/' + idAsociado, 'GET', null);

		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetPromotoresResp asociadoPromotores;
		public override void processResponse(HttpResponse response) {
			//asociadoPromotores = (WSAsociadoGetPromotoresResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetPromotoresResp.class);
			asociadoPromotores = WSAsociadoGetPromotoresResp.parse(response.getBody());
		}
	}
}