public class WSAsociadoGetEmpleos  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoEmpleos(String idAsociado) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/empleos/' + idAsociado, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetEmpleosResp asociadoEmpleos;
		public override void processResponse(HttpResponse response) {
			//asociadoEmpleos = (WSAsociadoGetEmpleosResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetEmpleosResp.class);
			asociadoEmpleos = WSAsociadoGetEmpleosResp.parse(response.getBody());
		}
	}
}