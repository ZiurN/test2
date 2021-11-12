public with sharing class WSCaseEnviarASSHelper {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG = ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	public static Map<String,Webservice_endpoint__mdt> ENDPOINTS;
	public static Response enviarASS (String body, String serviceType, String service) {
		System.debug('BODY SOLICITUD: ');System.debug(body);
		ENDPOINTS = ConfigUtils.getEndpointsByTipo(serviceType);
		String url = SERVICE_CONFIG.URL__c + ENDPOINTS.get(service).Endpoint__c;
		RestWS ws = new RestWS(url, 'POST', null, body);
		ws.request.setHeader('Accept','application/json"');
		ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	public class Response extends WSResult {
		public WSCaseEnviarASSGenericResponse result;
		public override void processResponse(HttpResponse response) {
			System.debug('BODY Respuesta: ');System.debug(response.getBody());
			result = WSCaseEnviarASSGenericResponse.parse(response.getBody());
		}
		public override void processError(HttpResponse response) {
			System.debug('BODY Respuesta: ');System.debug(response.getBody());
			result = WSCaseEnviarASSGenericResponse.parse(response.getBody());
			this.message = result.processMessage();
		}
	}
}