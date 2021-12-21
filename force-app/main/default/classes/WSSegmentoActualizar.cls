public with sharing class WSSegmentoActualizar {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response actualizarSegmento(String emId, String segmentoId, String body) {

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/' + emId + '/segmentos/' + segmentoId,
                'PUT',
                null,
                body);

        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
        //------------------------------------------------------
        system.debug('body****: ' + ws.bodyParameter.value);
        //------------------------------------------------------
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSSegmentoEliminarResp result ;
        public override void processResponse(HttpResponse response) {
            result = WSSegmentoEliminarResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}