public class WSCaseReintegroRevertir  {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response revertirReintegro(String codigoReintegro, String body) {
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/' + codigoReintegro, 'PUT', 
								null, 
								body
		);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSCaseReintegroRevertirResp result;
        public override void processResponse(HttpResponse response) {
            result = WSCaseReintegroRevertirResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Object> data = (Map<String,Object>) body.get('data');
            message = data.get('message').toString();
        }

    }
}