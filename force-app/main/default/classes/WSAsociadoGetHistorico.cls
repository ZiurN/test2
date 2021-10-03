public class WSAsociadoGetHistorico  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoHistorico(String idAsociado) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/historico/' + idAsociado, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetHistoricoResp asociadoHistorico;
		public override void processResponse(HttpResponse response) {
			//asociadoHistorico = (WSAsociadoGetHistoricoResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetHistoricoResp.class);
			asociadoHistorico = WSAsociadoGetHistoricoResp.parse(response.getBody());
		}
	}
}