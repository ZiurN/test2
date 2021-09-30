public class WSAsociadoGetDatosAdicionales  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoDatosAdicionales(String idAsociado) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-adicionales/' + idAsociado, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	//------------------------------------------------------------------------------
	public static Response getEmpresaDatosAdicionales(Integer codEmpresa) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/empresas/' + codEmpresa + '/datos-adicionales', 'GET', null);
		WSAuthToken.setAuth(ws);
		return (Response) ws.invoke(new Response());
	}

	public static Response getEfectorDatosAdicionales(Integer codEfector) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/efectores/datos-adicionales/' + codEfector, 'GET', null);
		WSAuthToken.setAuth(ws);
		return (Response) ws.invoke(new Response());
	}
	//------------------------------------------------------------------------------

	public class Response extends WSResult {
		public WSAsociadoGetDatosAdicionalesResp asociadoDatosAdicionales;
		public override void processResponse(HttpResponse response) {
			//asociadoDatosAdicionales = (WSAsociadoGetDatosAdicionalesResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetDatosAdicionalesResp.class);
			asociadoDatosAdicionales = WSAsociadoGetDatosAdicionalesResp.parse(response.getBody());
		}
	}
}