public class WSLoteOrdenReintegro  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getOrdenReintegro(String lot_id) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/' + lot_id + '/ordenes-reintegros', 'GET', null);
		ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSLoteOrdenReintegroResp lote;
		public override void processResponse(HttpResponse response) {
			lote = WSLoteOrdenReintegroResp.parse(response.getBody());
		}

		public override void processError(HttpResponse response) {
			Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
			message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
		}
	}
}