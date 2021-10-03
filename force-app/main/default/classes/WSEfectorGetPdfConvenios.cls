public class WSEfectorGetPdfConvenios {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getPdfConvenios(String codEfector) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/prestadores/' + codEfector + '/convenios', 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSEfectorGetPdfConveniosResp  result;
		public override void processResponse(HttpResponse response) {
			result = WSEfectorGetPdfConveniosResp.parse(response.getBody());
		}

		public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Object> data = (Map<String,Object>) body.get('data');
			if(data.get('message') != null){
				message = data.get('message').toString();
			}
        }
	}


}