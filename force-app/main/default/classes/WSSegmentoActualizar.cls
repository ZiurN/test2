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
//            Map<String,Object> data = (Map<String,Object>) body.get('data');
//            Map<String,Object> errors = (Map<String,Object>) data.get('errors');
//            String msg = '';
//
//            if(data.get('httpCode') == 500) {
//                msg = data.get('message').toString();
//            } else {
//                for(String key : errors.keySet()){
//                    List<Object> error = (List<Object>) errors.get(key);
//                    msg = msg +  error[0].toString() + '\n';
//                }
//
//            }
//            message = msg;
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}