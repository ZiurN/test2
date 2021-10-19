public class WSLotePasajeAIF  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response pasajeIF(String lot_id, String body){
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/'+lot_id+'/pasaje-if', 'POST', null,body);
		ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult{
		public WSLotePasajeAIFResp lote;
		public override void processResponse(HttpResponse response) {
			lote = WSLotePasajeAIFResp.parse(response.getBody());
		}

		public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
			Map<String,Object> data = (Map<String,Object>) body.get('data');
			message = (String) data.get('message');
            //message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
		}

	
	}
}