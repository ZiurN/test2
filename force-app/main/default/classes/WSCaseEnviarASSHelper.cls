public with sharing class WSCaseEnviarASSHelper {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG = ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	public static Map<String,Webservice_endpoint__mdt> ENDPOINTS;
	public static Response enviarASS (String body, String serviceType, String service) {
		return enviarASS(body, serviceType, service, null);
	}
	public static Response enviarASS (String body, String serviceType, String service, String extraParams) {
		System.debug('BODY SOLICITUD: '); System.debug(body);
		ENDPOINTS = ConfigUtils.getEndpointsByTipo(serviceType);
		String url = SERVICE_CONFIG.URL__c + ENDPOINTS.get(service).Endpoint__c;
		if (!String.isBlank(extraParams)) url += '/' + extraParams;
		RestWS ws = new RestWS(url, 'POST', null, body);
		ws.request.setHeader('Accept','application/json"');
		ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	private static WSSSGenericResponse processResponse (HttpResponse response) {
		System.debug('BODY Respuesta: '); System.debug(response.getBody());
		return WSSSGenericResponse.parse(response.getBody());
	}
	public class Response extends WSResult {
		public WSSSGenericResponse result;
		public override void processResponse(HttpResponse response) {
			result = WSCaseEnviarASSHelper.processResponse(response);
		}
		public override void processError(HttpResponse response) {
			result = WSCaseEnviarASSHelper.processResponse(response);
			this.message = result.processMessage();
		}
	}
}