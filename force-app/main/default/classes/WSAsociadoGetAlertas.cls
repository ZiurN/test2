public class WSAsociadoGetAlertas  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getAsociadoAlertas(String idAsociado) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/alertas/' + idAsociado, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAsociadoGetAlertasResp  asociadoAlertas;
		public override void processResponse(HttpResponse response) {
			//asociadoAlertas = (WSAsociadoGetAlertasResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetAlertasResp.class);
			asociadoAlertas = WSAsociadoGetAlertasResp.parse(response.getBody());
		}
	}
}