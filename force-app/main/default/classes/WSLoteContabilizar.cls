public class WSLoteContabilizar  {

	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response contabilizacion(String lot_id, String body){
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/'+lot_id+'/contabilizacion', 'POST', null,body);
		ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult{
		public WSLoteContabilizarResp lote;
		public override void processResponse(HttpResponse response) {
			lote = WSLoteContabilizarResp.parse(response.getBody());
		}

		public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
		}

	}
}