public class WSEmpresaConveniosPorAporte {

    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response getConveniosAportes(String codigoEmpresa) {
        String filter = !String.isBlank(codigoEmpresa) ? '?filter[codigo_empresa]=' + codigoEmpresa : '';
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios-aportes' + filter, 'GET', null);
        System.debug(filter);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }
    
    public class Response extends WSResult {
        public WSEmpresaConveniosPorAporteResp  conveniosPorAporte;
        public override void processResponse(HttpResponse response) {
            //conveniosPorAporte = (WSEmpresaConveniosPorAporteResp)
                    //JSON.deserialize(response.getBody(), WSEmpresaConveniosPorAporteResp.class);
			conveniosPorAporte = WSEmpresaConveniosPorAporteResp.parse(response.getBody());
        }
    }
}