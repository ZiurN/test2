public class WSAsociadoGetValoraciones  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getAsociadoValoraciones(String asociadoId, String period) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/' + asociadoId + '/' + period, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAsociadoGetValoracionesResp  asociadoValoraciones;
		public override void processResponse(HttpResponse response) {
			//asociadoValoraciones = (WSAsociadoGetValoracionesResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetValoracionesResp.class);
			asociadoValoraciones = WSAsociadoGetValoracionesResp.parse(response.getBody());
		}
	}
}