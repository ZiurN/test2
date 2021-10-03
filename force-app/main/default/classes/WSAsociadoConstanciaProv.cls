public class WSAsociadoConstanciaProv  {

	@TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getConstancia(String codigo_asociado) {


        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/constancia-provisoria/' + codigo_asociado,
                'GET',
                null);

        System.debug('****body: ' + ws.bodyParameter.value);
        WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }


    public class Response extends WSResult {
        public WSAsociadoConstanciaProvResp constancia ;
        public override void processResponse(HttpResponse response) {
            constancia = WSAsociadoConstanciaProvResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
		    Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}