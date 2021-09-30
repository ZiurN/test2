public class WSEfectorMatriculas {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response getEfectorMatriculas(String codEfector) {
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/efectores/matriculas?' +
                'filter[codigo]=' + codEfector, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSEfectorMatriculasResp  matriculas;
        public override void processResponse(HttpResponse response) {
            //matriculas = (WSEfectorMatriculasResp)
                    //JSON.deserialize(response.getBody(), WSEfectorMatriculasResp.class);
			matriculas = WSEfectorMatriculasResp.parse(response.getBody());
        }
    }
}