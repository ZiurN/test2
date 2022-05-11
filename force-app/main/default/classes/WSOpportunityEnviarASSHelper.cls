/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase para realizar los llamados a SS relacionados a las oportunidades.
@date			09/05/2022
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class WSOpportunityEnviarASSHelper extends WSEnviarASSHelper{
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método principal donde se realiza el llamado a SS y se entrega la respuesta obtenida.
	@date			09/05/2022
	------------------------------------------------------------------------------------------------------------------------*/
	public override Object enviarASS (String body, String serviceType, String service, String method, String extraParams) {
		System.debug('BODY SOLICITUD: '); System.debug(body);
		Map<String,Webservice_endpoint__mdt> ENDPOINTS = ConfigUtils.getEndpointsByTipo(serviceType);
		String url = getWSConfig().URL__c + ENDPOINTS.get(service).Endpoint__c;
		if (!String.isBlank(extraParams)) url += '/' + extraParams;
		RestWS ws = new RestWS(url, method, null, body);
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
			result = WSOpportunityEnviarASSHelper.processResponse(response);
			this.message = String.isBlank(result.message) ? this.message : result.message;
		}
		public override void processError(HttpResponse response) {
			result = WSOpportunityEnviarASSHelper.processResponse(response);
			this.message = result.processMessage();
		}
	}
}