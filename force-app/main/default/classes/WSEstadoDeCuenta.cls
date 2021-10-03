public with sharing class WSEstadoDeCuenta {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
 
    public static Response getEstado(String afi) {

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/semaforo/' + afi,
                'GET',
                null);
        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
        
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }


    public class Response extends WSResult {
        public WSEstadoDeCuentaResp result;
        public override void processResponse(HttpResponse response) {
			result = WSEstadoDeCuentaResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
			message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}