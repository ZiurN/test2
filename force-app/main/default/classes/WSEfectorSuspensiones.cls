public class WSEfectorSuspensiones {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response getEfectorSuspensiones(String codEfector) {
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/efectores/suspensiones/' + codEfector, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSEfectorSuspensionesResp  suspensiones;
        public override void processResponse(HttpResponse response) {
            //suspensiones = (WSEfectorSuspensionesResp)
                    //JSON.deserialize(response.getBody(), WSEfectorSuspensionesResp.class);
			suspensiones = WSEfectorSuspensionesResp.parse(response.getBody());
        }
    }
}