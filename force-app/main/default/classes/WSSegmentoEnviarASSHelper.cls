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
		Boolean isCreating = true;
		if (!String.isBlank(segmentoId)) {
			url += '/' + segmentoId;
			method = 'PUT';
			isCreating = false;
		}
		System.debug(url);
		RestWS ws = new RestWS(url, method, null, body);
		ws.request.setHeader('Accept','application/json"');
		ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		if (ws.hasError) fireSSSegmentoResponseEvent(ws.errorMessage, segmentoId, isCreating);
		Response res = (Response) ws.invoke(new Response(segmentoId, isCreating));
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	public static void fireSSSegmentoResponseEvent (String message, String segmentoId, Boolean isCreating) {
		SS_Segmento_Response__e errorEvent =  new SS_Segmento_Response__e(
			isDelete__c = isCreating,
			error__c = true,
			Response_Error__c = message,
			Id_Segmento__c = !String.isBlank(segmentoId) ? segmentoId : 'NoID'
		);
		List<Database.SaveResult> results = EventBus.publish(new List<SS_Segmento_Response__e>{errorEvent});
		for (Database.SaveResult result : results) {
			if (!result.isSuccess()) {
				for (Database.Error err : result.getErrors()) {
					System.debug(err.fields);
					System.debug(err.message);
				}
			}
		}
	}
	public class Response extends WSResult {
		public WSSSGenericResponse result;
		public String segmentoId;
		public String eventoMedicoID;
		public Boolean isCreating;
		public Response (String segmentoId, Boolean isCreating) {
			this.segmentoId = segmentoId;
			this.isCreating = isCreating;
			this.eventoMedicoID = eventoMedicoID;
		}
		public override void processResponse(HttpResponse response) {
			System.debug('BODY Respuesta OK: ');System.debug(response.getBody());
			result = setResponse(response.getBody());
		}
		public override void processError(HttpResponse response) {
			System.debug('BODY Respuesta Error: ');System.debug(response.getBody());
			result = setResponse(response.getBody());
			this.message = result.processMessage();
			WSSegmentoEnviarASSHelper.fireSSSegmentoResponseEvent(this.message, this.segmentoId, this.isCreating);
		}
		private WSSSGenericResponse setResponse (String body) {
			WSSSGenericResponse.Response tmp_result;
			try {
				tmp_result = (WSSSGenericResponse.Response) JSON.deserialize(body, WSSSGenericResponse.Response.class);
				return new WSSSGenericResponse(tmp_result);
			} catch (Exception e) {
				System.debug(e.getMessage());
				return WSSSGenericResponse.parse(response.getBody());
			}
		}
	}
}
