public class WSCaseAPRevertirOrden  {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response revertirOrden(String codigo_ap,String body) {
        RestWS ws = new RestWS(
			SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/revertir/' + codigo_ap,
			'POST',
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
        public WSCasoEnviarASSResp caseRes;
        public override void processResponse(HttpResponse response) {
            caseRes = WSCasoEnviarASSResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}