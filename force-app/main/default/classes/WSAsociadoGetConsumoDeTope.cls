public class WSAsociadoGetConsumoDeTope  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getConsumoDeTope(String asociadoId, Date fecha, String topeTipo, String topeId) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/topes/consumo/' 
			+ asociadoId + '/' + String.valueOf(fecha) + '/' + topeTipo + '/' + topeId, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAsociadoGetConsumoDeTopeResp asociadoConsumoDeTope;
		public override void processResponse(HttpResponse response) {
			//asociadoConsumoDeTope = (WSAsociadoGetConsumoDeTopeResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetConsumoDeTopeResp.class);
			asociadoConsumoDeTope = WSAsociadoGetConsumoDeTopeResp.parse(response.getBody());
		}
	}
}