/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase para realizar el envío a SS de la información de los segmentos en SF.
@date			21/12/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ExcessiveParameterList')
public with sharing class WSSegmentoEnviarASSHelper {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG = ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	public static Map<String,Webservice_endpoint__mdt> ENDPOINTS;
	public static Response enviarASS (String body,
										String serviceType,
										String service,
										String eventoMedicoID) {
		return enviarASS(body, serviceType, service, eventoMedicoID, null);
	}
	public static Response enviarASS (String body,
										String serviceType,
										String service,
										String eventoMedicoID,
										String segmentoId) {
		System.debug('BODY SOLICITUD: ');System.debug(body);
		ENDPOINTS = ConfigUtils.getEndpointsByTipo(serviceType);
		String url = SERVICE_CONFIG.URL__c + ENDPOINTS.get(service).Endpoint__c + '/' + eventoMedicoID + '/segmentos';
		String method = 'POST';
		if (!String.isBlank(segmentoId)) {
			url += '/' + segmentoId;
			method = 'PUT';
		}
		System.debug(url);
		RestWS ws = new RestWS(url, method, null, body);
		ws.request.setHeader('Accept','application/json"');
		ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		if (ws.hasError) fireSSSegmentoResponseEvent(ws.errorMessage, segmentoId);
		Response res = (Response) ws.invoke(new Response(segmentoId));
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	public static void fireSSSegmentoResponseEvent (String message, String segmentoId) {
		SS_Segmento_Response__e errorEvent =  new SS_Segmento_Response__e(
			error__c = true,
			Response_Error__c = message,
			Id_Segmento__c = segmentoId
		);
		List<Database.SaveResult> results = EventBus.publish(new List<SS_Segmento_Response__e>{errorEvent});
	}
	public class Response extends WSResult {
		public WSSSGenericResponse result;
		public String segmentoId;
		public Response (String segmentoId) {
			this.segmentoId = segmentoId;
		}
		public override void processResponse(HttpResponse response) {
			System.debug('BODY Respuesta OK: ');System.debug(response.getBody());
			result = setResponse(response.getBody());
		}
		public override void processError(HttpResponse response) {
			System.debug('BODY Respuesta Error: ');System.debug(response.getBody());
			result = setResponse(response.getBody());
			this.message = result.processMessage();
			WSSegmentoEnviarASSHelper.fireSSSegmentoResponseEvent(this.message, this.segmentoId);
		}
		private WSSSGenericResponse setResponse (String body) {
			WSSSGenericResponse.Response tmp_result;
			try {
				tmp_result = (WSSSGenericResponse.Response) JSON.deserializeStrict(body, WSSSGenericResponse.Response.class);
				return new WSSSGenericResponse(tmp_result);
			} catch (Exception e) {
				System.debug(e.getMessage());
				return WSSSGenericResponse.parse(response.getBody());
			}
		}
	}
}
