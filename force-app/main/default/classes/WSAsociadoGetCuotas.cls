public class WSAsociadoGetCuotas {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getAsociadoCuotas(String idAsociado) {
		String pageSize = '?pageSize=12';
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/cuotas/' + idAsociado + pageSize, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAsociadoGetCuotasResp  asociadoCuotas;
		public override void processResponse(HttpResponse response) {
			//asociadoCuotas = (WSAsociadoGetCuotasResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetCuotasResp.class);
			asociadoCuotas = WSAsociadoGetCuotasResp.parse(response.getBody());
		}
	}
}