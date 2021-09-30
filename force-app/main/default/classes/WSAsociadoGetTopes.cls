public class WSAsociadoGetTopes  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getTopes(String asociadoId, Date fecha) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/topes/' + asociadoId + '/' + String.valueOf(fecha), 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAsociadoGetTopesResp asociadoTopes;
		public override void processResponse(HttpResponse response) {
			//asociadoTopes = (WSAsociadoGetTopesResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetTopesResp.class);
			asociadoTopes = WSAsociadoGetTopesResp.parse(response.getBody());
		}
	}
}