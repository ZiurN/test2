public class WSAsociadoGetDeuda {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response getAsociadoDeuda(Integer idComprobante,Date fecha,String token) {
		String fechaVenc = String.valueOf(fecha).substringBefore(' ');

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/deuda-actual/' +
				idComprobante + '/' + fechaVenc, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSAsociadoGetDeudaResp asociadoDeuda;
        public override void processResponse(HttpResponse response) {
            //asociadoDeuda = (WSAsociadoGetDeudaResp)
                    //JSON.deserialize(response.getBody(), WSAsociadoGetDeudaResp.class);
			asociadoDeuda = WSAsociadoGetDeudaResp.parse(response.getBody());
        }
    }
}