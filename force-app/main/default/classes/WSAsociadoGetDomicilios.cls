public class WSAsociadoGetDomicilios  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getAsociadoDomicilios(String idAsociado) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/domicilios/' + idAsociado, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public static Response getEmpresaDomicilios(Integer codEmpresa) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/empresas/' + codEmpresa + '/domicilios', 'GET', null);
		WSAuthToken.setAuth(ws);
		return (Response) ws.invoke(new Response());
	}

	public static Response getObraSocialDomicilios(Integer codOS) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/obras-sociales/domicilios/' + codOS, 'GET', null);
		WSAuthToken.setAuth(ws);
		return (Response) ws.invoke(new Response());
	}

	public static Response getEfectorDomicilios(Integer codEfector) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/efectores/domicilios/' + codEfector, 'GET', null);
		WSAuthToken.setAuth(ws);
		return (Response) ws.invoke(new Response());
	}

	public static Response getDelegacionDomicilios(Integer codDelegacion) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/delegaciones/consultar?filter[codigo]=' + codDelegacion, 'GET', null);
		WSAuthToken.setAuth(ws);
		return (Response) ws.invoke(new Response());
	}

	public class Response extends WSResult {
		public WSAsociadoGetDomiciliosResp asociadoDomicilios;
		public override void processResponse(HttpResponse response) {
			//asociadoDomicilios = (WSAsociadoGetDomiciliosResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetDomiciliosResp.class);
			asociadoDomicilios = WSAsociadoGetDomiciliosResp.parse(response.getBody());

		}
	}
}