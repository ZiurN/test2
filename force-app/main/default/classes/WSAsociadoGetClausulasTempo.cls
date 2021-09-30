public class WSAsociadoGetClausulasTempo  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoClausulasTempo(String idAsociado) {
			
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/clausulas/temporarias/' + idAsociado, 'GET', null);

		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetClausulasTempoResp asociadoClausulasTempo;
		public override void processResponse(HttpResponse response) {
			//asociadoClausulasTempo = (WSAsociadoGetClausulasTempoResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetClausulasTempoResp.class);
			asociadoClausulasTempo = WSAsociadoGetClausulasTempoResp.parse(response.getBody());
		}
	}
}