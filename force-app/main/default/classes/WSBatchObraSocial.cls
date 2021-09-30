public class WSBatchObraSocial {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    // Formato fecha AAAA-MM-DD
    public static Response getBatchObrasSociales(String fecha, Integer pageSize, Integer currentPage) {
        String filtro = pageSize > 0 ? '?pageSize=' + pageSize + '&page=' + currentPage : '';
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/batch/obras-sociales/' + fecha + filtro, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSBatchObraSocialResp obrasSociales;
        public override void processResponse(HttpResponse response) {
            obrasSociales = (WSBatchObraSocialResp)
                    JSON.deserialize(response.getBody(), WSBatchObraSocialResp.class);
        }
    }
}