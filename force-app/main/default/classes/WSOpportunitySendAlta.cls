public class WSOpportunitySendAlta  {
	@TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response sendAlta(String body) {
        System.debug(body);

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta',
                'POST',
                null,
                body
		);
		//-------------------------------Modificado solo para checkear algo en test----------
		//RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta/test',
                //'POST',
                //null,
                //body
		//);
		//-----------------------------------------------------------------------------------

        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		//------------------------------------------------------
        System.debug('****body: ' + ws.bodyParameter.value);
		//------------------------------------------------------
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSOpportunitySendAltaResp result;

        public override void processResponse(HttpResponse response) {
			result = WSOpportunitySendAltaResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }

}