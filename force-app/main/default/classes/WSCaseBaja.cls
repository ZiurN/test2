public without sharing class WSCaseBaja {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response darDeBajaCaso(String body) {
        System.debug(body);

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/extranet/sf/casos',
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
        public WSCaseBajaResp result ;
        public override void processResponse(HttpResponse response) {
            //result = (WSCasoEnviarASSResp)
                    //JSON.deserialize(response.getBody(), WSCasoEnviarASSResp.class);
			result = WSCaseBajaResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            //Map<String,Object> data = (Map<String,Object>) body.get('data');
            //Map<String,Object> errors = (Map<String,Object>) data.get('errors');
            //String msg = '';
			//System.debug('####body' + body);
            //if(data.get('httpCode') == 500){
				//System.debug('entro al if');
				//System.debug('entro al if');
                //message = errors.get('message').toString();
            //}
            //else{
				//System.debug('entro al else');
                //message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
            //}

            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}