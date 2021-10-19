public class WSEfectorGetDetallesPresentacion  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getEfectorDetallesPresentacion(String idComprobante) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presentaciones/comprobantes/' + idComprobante, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSEfectorGetDetallesPresentacionResp  efectorDetallesPresentacion;
		public override void processResponse(HttpResponse response) {
			//efectorDetallesPresentacion = (WSEfectorGetDetallesPresentacionResp)
				//JSON.deserialize(response.getBody(), WSEfectorGetDetallesPresentacionResp.class);
			efectorDetallesPresentacion = WSEfectorGetDetallesPresentacionResp.parse(response.getBody());
		}
	}
}