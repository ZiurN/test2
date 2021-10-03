public class WSEfectorGetEspecialidades {

    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response getEfectorEspecialidades(String codEfector) {
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/efectores/especialidades?' +
                'filter[codigo_efector]=' + codEfector, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSEfectorGetEspecialidadesResp  especialidades;
        public override void processResponse(HttpResponse response) {
            //especialidades = (WSEfectorGetEspecialidadesResp)
                    //JSON.deserialize(response.getBody(), WSEfectorGetEspecialidadesResp.class);
			especialidades = WSEfectorGetEspecialidadesResp.parse(response.getBody());
        }
    }
}