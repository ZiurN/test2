public with sharing class WSAlertaAutorizar {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response autorizarAlerta(String alertaId, String body) {
        RestWS ws = new RestWS(
                SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/alerta/autorizar/' + alertaId,
                'POST',
                null,
                body
        );
        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        //--------------- Para la respuesta que viene CON el EM -----------------
        public WSAlertaAutorizarResp result;
        //--------------- Para la respuesta que viene SIN el EM -----------------
//        public WSCasoEnviarASSResp result;
        //-----------------------------------------------------------------------

        public override void processResponse(HttpResponse response) {
            //--------------- Para la respuesta que viene CON el EM -----------------
            result = WSAlertaAutorizarResp.parse(response.getBody());
            //--------------- Para la respuesta que viene SIN el EM -----------------
//            result = WSCasoEnviarASSResp.parse(response.getBody());
            //-----------------------------------------------------------------------

        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }
    }
}