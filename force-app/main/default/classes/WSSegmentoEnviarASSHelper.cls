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
	private static String segmentoId;
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
		segmentoId = segmentoId;
		System.debug('BODY SOLICITUD: ');System.debug(body);
		ENDPOINTS = ConfigUtils.getEndpointsByTipo(serviceType);
		String url = SERVICE_CONFIG.URL__c + ENDPOINTS.get(service).Endpoint__c + '/' + eventoMedicoID + '/segmentos';
		if (!String.isBlank(segmentoId)) url += '/' + segmentoId;
		System.debug(url);
		RestWS ws = new RestWS(url, 'POST', null, body);
		ws.request.setHeader('Accept','application/json"');
		ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	public class Response extends WSResult {
		public WSSSGenericResponse result;
		public override void processResponse(HttpResponse response) {
			System.debug('BODY Respuesta: ');System.debug(response.getBody());
			result = WSSSGenericResponse.parse(response.getBody());
		}
		public override void processError(HttpResponse response) {
			System.debug('BODY Respuesta: ');System.debug(response.getBody());
			result = WSSSGenericResponse.parse(response.getBody());
			this.message = result.processMessage();
			SS_Segmento_Response__e errorEvent =  new SS_Segmento_Response__e(
				error__c = true,
				Response_Error__c = this.message,
				Id_Segmento__c = segmentoId
			);
			List<Database.SaveResult> results = EventBus.publish(new List<SS_Segmento_Response__e>{errorEvent});
		}
	}
}
