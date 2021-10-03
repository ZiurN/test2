public class WSAsociadoGetAportesDeclarados  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getAsociadoAportesDeclarados(String codigoDeAsociado) {
		String pageSize = '?pageSize=12';
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-declarados/' + codigoDeAsociado + pageSize, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAsociadoGetAportesDeclaradosResp asociadoAportesDeclarados;
		public override void processResponse(HttpResponse response) {
			//asociadoAportesDeclarados = (WSAsociadoGetAportesDeclaradosResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetAportesDeclaradosResp.class);
			asociadoAportesDeclarados = WSAsociadoGetAportesDeclaradosResp.parse(response.getBody());
		}
	}
}