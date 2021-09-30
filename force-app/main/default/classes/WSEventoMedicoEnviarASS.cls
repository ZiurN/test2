public class WSEventoMedicoEnviarASS  {
	@TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
 
    public static Response enviarEventoMedico(String body) {

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/seguimiento',
                'POST',
                null,
                body);
        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
        //-------------------------------------------------
        System.debug('body****: ' + ws.bodyParameter.value);
        //-------------------------------------------------
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public static Response enviarEventoMedicoInternacion(String body) {

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos',
                'POST',
                null,
                body);

        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
        //------------------------------------------------------
        System.debug('body****: ' + ws.bodyParameter.value);
        //------------------------------------------------------
        WSAuthToken.setAuth(ws);
        return (Response) ws.invoke(new Response());
    }

    public class Response extends WSResult {
        public WSEventoMedicoEnviarASSResp result;
        public override void processResponse(HttpResponse response) {
			result = WSEventoMedicoEnviarASSResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}