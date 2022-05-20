/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase para Enviar información a SaludSoft.
@date			06/05/2022
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ExcessiveParameterList')
public with sharing class WSEnviarASSHelper {
	private static Map<String,Webservice_endpoint__mdt> ENDPOINTS;
	public static Response enviarASS (SSRequest SSRequest) {
		System.debug('BODY SOLICITUD: '); System.debug(SSRequest.body);
		ENDPOINTS = ConfigUtils.getEndpointsByTipo(SSRequest.serviceType);
		String url = WSAuthToken.SERVICE_CONFIG.URL__c + ENDPOINTS.get(SSRequest.service).Endpoint__c;
		if (!String.isBlank(SSRequest.extraParams)) url += '/' + SSRequest.extraParams;
		RestWS ws = new RestWS(url, SSRequest.method, null, SSRequest.body);
		ws.request.setHeader('Accept','application/json"');
		ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	public static WSSSGenericResponse processResponse (HttpResponse response) {
		System.debug('BODY Respuesta: '); System.debug(response.getBody());
		return WSSSGenericResponse.parse(response.getBody());
	}
	public class Response extends WSResult {
		public WSSSGenericResponse result;
		public override void processResponse(HttpResponse response) {
			result = WSEnviarASSHelper.processResponse(response);
		}
		public override void processError(HttpResponse response) {
			result = WSEnviarASSHelper.processResponse(response);
			this.message = result.processMessage();
		}
	}
	public class SSRequest {
		public String body {get; set;}
		public String serviceType {get; set;}
		public String service {get; set;}
		public String method {get; set;}
		public String extraParams {get; set;}
		public SSRequest (String body, String serviceType, String service, String method, String extraParams) {
			this.body = body;
			this.serviceType = serviceType;
			this.service = service;
			this.method = method;
			this.extraParams = extraParams;
		}
	}
}