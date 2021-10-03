public class WSAsociadoGetAportesTransferidos  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getAsociadoAportesTransferidos(String codigoDeAsociado) {

		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/aportes-transferidos/' + codigoDeAsociado, 'GET', null);

		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAsociadoGetAportesTransferidosResp asociadoAportesTransferidos;
		public override void processResponse(HttpResponse response) {
			//asociadoAportesTransferidos = (WSAsociadoGetAportesTransferidosResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetAportesTransferidosResp.class);
			asociadoAportesTransferidos = WSAsociadoGetAportesTransferidosResp.parse(response.getBody());
		}
	}
}