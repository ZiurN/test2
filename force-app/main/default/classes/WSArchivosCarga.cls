public class WSArchivosCarga  {
	@TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response uploadFiles(String body, WSAuthToken.Response tokenR) {
        RestWS ws = new RestWS(
                SERVICE_CONFIG.URL__c + '/v1/salud/archivos',
                'POST',
                null,
                body
        );
        System.debug('****body: ' + body);
        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		Response res;
		if(tokenR == null){
			WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
			res = (Response) ws.invoke(new Response());
			
			if(!res.hasError){
				res.token = tokenResp;
			}
		}
		else{
			ws.request.setHeader('Authorization', 'Bearer ' + tokenR.token.access_token);
			res = (Response) ws.invoke(new Response());
		}
		return res;
    }

    public class Response extends WSResult {
        public WSArchivosCargaResp result;
		public WSAuthToken.Response token;

        public override void processResponse(HttpResponse response) {
            result = WSArchivosCargaResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }
    }
}