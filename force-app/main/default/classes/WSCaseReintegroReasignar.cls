public class WSCaseReintegroReasignar  {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response reasignarReintegro(String codigoReintegro, String body) {
		if(codigoReintegro == null) {
			Response resp = new Response();
			resp.hasError = true;
			resp.message = 'No se puede reasignar el lote porque el reintegro no fue enviado a SS.';

			return resp;
		}

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/' + codigoReintegro, 'PUT', 
								null, 
								body
		);
        WSAuthToken.setAuth(ws);
        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
        Response resp = (Response) ws.invoke(new Response());
        return resp;
    }

    public class Response extends WSResult {
        public WSCaseReintegroReasignarResp result;
        public override void processResponse(HttpResponse response) {
            result = WSCaseReintegroReasignarResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Object> data = (Map<String,Object>) body.get('data');
            message = data.get('message').toString();
        }

    }
}