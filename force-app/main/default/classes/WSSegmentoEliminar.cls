/**
 * Created by xappia on 18/2/20.
 */

public with sharing class WSSegmentoEliminar {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response eliminarSegmento(String emId,String segId,String body) {

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/' +emId + '/segmentos/' + segId ,
                'DELETE',
                null,
                body);

        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSSegmentoEliminarResp result ;
        public override void processResponse(HttpResponse response) {
            //result = (WSCasoEnviarASSResp)
            //JSON.deserialize(response.getBody(), WSCasoEnviarASSResp.class);
            result = WSSegmentoEliminarResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Object> data = (Map<String,Object>) body.get('data');
            message = data.get('message').toString();
        }

    }
}