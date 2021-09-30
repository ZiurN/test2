public class WSAfiliadoGetInfo  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getAsociado(String tipo,String dni) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/afiliados/' + tipo + '/' + dni, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAfiliadoGetInfoResp info;
		public override void processResponse(HttpResponse response) {

			info = WSAfiliadoGetInfoResp.parse(response.getBody());
		}
 
		public override void processError(HttpResponse response) {
		}

	}
}