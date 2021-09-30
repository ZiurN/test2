public class WSEfectorPresentaciones {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response getEfectorPresentaciones(String codEfector) {
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/efectores/presentaciones/' + codEfector, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSEfectorPresentacionesResp  presentaciones;
        public override void processResponse(HttpResponse response) {
            //presentaciones = (WSEfectorPresentacionesResp)
                    //JSON.deserialize(response.getBody(), WSEfectorPresentacionesResp.class);
			presentaciones = WSEfectorPresentacionesResp.parse(response.getBody());
        }
    }
}