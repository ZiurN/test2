/**
 * Created by xappia on 10/2/20.
 */

public class WSCaseAPAnular {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response anularCaso(String apId,String body) {
        System.debug(body);

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/anular/' + apId,
                'POST',
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
        public WSCasoEnviarASSResp result ;
        public override void processResponse(HttpResponse response) {
            //result = (WSCasoEnviarASSResp)
            //JSON.deserialize(response.getBody(), WSCasoEnviarASSResp.class);
            result = WSCasoEnviarASSResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}