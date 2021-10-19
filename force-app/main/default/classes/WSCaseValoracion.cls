public with sharing class WSCaseValoracion {
	@TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response getValoracion(String afiliadoCodigo, String periodo) {
        RestWS ws = new RestWS(
                SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/valoracion/'+afiliadoCodigo+'/'+periodo,
                'GET',
                null
        );
        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        //--------------- Para la respuesta que viene CON el EM -----------------
        public WSCaseValoracionResp result;
        //--------------- Para la respuesta que viene SIN el EM -----------------
//        public WSCasoEnviarASSResp result;
        //-----------------------------------------------------------------------
        public override void processResponse(HttpResponse response) {
            //--------------- Para la respuesta que viene CON el EM -----------------
            result = WSCaseValoracionResp.parse(response.getBody());
            //--------------- Para la respuesta que viene SIN el EM -----------------
//            result = WSCasoEnviarASSResp.parse(response.getBody());
            //-----------------------------------------------------------------------
        }

        public override void processError(HttpResponse response) {
            Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }
    }
}