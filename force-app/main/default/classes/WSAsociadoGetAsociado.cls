public class WSAsociadoGetAsociado  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getAsociado(String idAsociado) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/consultar-afiliado/afi_id/' + idAsociado, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public Map<String, Object> asociadoApiRespValuesByasociadoApiRespFields;
		public override void processResponse(HttpResponse response) {

			String JsonString = response.getBody();

			Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(JsonString);
			List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
			List<Object> myMapObjects = (List<Object>) meta.get('data');
			for (Object obj : myMapObjects) {
				myMaps.add((Map<String, Object>)obj);
			}

			asociadoApiRespValuesByasociadoApiRespFields = myMaps[0];
		}
	}
}