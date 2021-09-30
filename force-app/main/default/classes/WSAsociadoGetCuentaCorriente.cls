public class WSAsociadoGetCuentaCorriente  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoCuentaCorriente(String idAsociado) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/' + idAsociado, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetCuentaCorrienteResp asociadoCuentaCorriente;
		public override void processResponse(HttpResponse response) {
			//asociadoCuentaCorriente = (WSAsociadoGetCuentaCorrienteResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetCuentaCorrienteResp.class);
			asociadoCuentaCorriente = WSAsociadoGetCuentaCorrienteResp.parse(response.getBody());
		}
	}
}