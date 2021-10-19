public class WSAsociadoGetCredenciales  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoCredenciales(String idAsociado) {
			
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/' + idAsociado, 'GET', null);

		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetCredencialesResp asociadoCredenciales;
		public override void processResponse(HttpResponse response) {
			//asociadoCredenciales = (WSAsociadoGetCredencialesResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetCredencialesResp.class);
			asociadoCredenciales = WSAsociadoGetCredencialesResp.parse(response.getBody());
		}
	}
}