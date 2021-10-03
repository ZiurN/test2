public class WSAsociadoGetFacturas  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoFacturas(String idAsociado) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/facturas/' + idAsociado, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetFacturasResp asociadoFacturas;
		public override void processResponse(HttpResponse response) {
			//asociadoFacturas = (WSAsociadoGetFacturasResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetFacturasResp.class);
			asociadoFacturas = WSAsociadoGetFacturasResp.parse(response.getBody());
		}
	}
}