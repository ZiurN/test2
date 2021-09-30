public class WSAsociadoGetCuponDePago {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response generateCupon(String body,String token) {

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/cupones',
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
        public WSAsociadoGetCuponDePagoResp linkDePago ;
        public override void processResponse(HttpResponse response) {
            //linkDePago = (WSAsociadoGetCuponDePagoResp)
                    //JSON.deserialize(response.getBody(), WSAsociadoGetCuponDePagoResp.class);
			linkDePago = WSAsociadoGetCuponDePagoResp.parse(response.getBody());
        }
    }
}