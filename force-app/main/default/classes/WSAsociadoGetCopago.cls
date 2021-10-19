public class WSAsociadoGetCopago  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoCopago(String idAsociado) {
			
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/' + idAsociado + '/pdf-copago', 'GET', null);

		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetCopagoResp asociadoCopago;
		public override void processResponse(HttpResponse response) {
			asociadoCopago = WSAsociadoGetCopagoResp.parse(response.getBody());
		}

	}
}