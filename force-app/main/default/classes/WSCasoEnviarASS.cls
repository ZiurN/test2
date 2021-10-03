public class WSCasoEnviarASS  {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response enviarCaso(String body) {
        System.debug(body);

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones',
                'POST',
                null,
                body);

        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
        System.debug('****body: ' + ws.bodyParameter.value);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSCaseAPGenerarCentroResp result ;
        public override void processResponse(HttpResponse response) {
            //result = (WSCasoEnviarASSResp)
                    //JSON.deserialize(response.getBody(), WSCasoEnviarASSResp.class);
			result = WSCaseAPGenerarCentroResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Object> data = (Map<String,Object>) body.get('data');
            Map<String,Object> errors = (Map<String,Object>) data.get('errors');
            String msg = '';
            if(data.get('httpCode') == 500){
                message = errors.get('message').toString();
            }
            else{
                message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
            }


//            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}