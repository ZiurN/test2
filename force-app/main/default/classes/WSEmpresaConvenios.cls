public with sharing class WSEmpresaConvenios {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response getConvenios(String codigoEmpresa) {
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios/' + codigoEmpresa, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSEmpresaConveniosResp  convenios;
        public override void processResponse(HttpResponse response) {
            convenios = WSEmpresaConveniosResp.parse(response.getBody());
//                    JSON.deserialize(response.getBody(), WSEmpresaConveniosResp.class);
        }
    }
}