public with sharing class WSCaseEnviarASSHelper {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');


    public static Response enviarASS(String body, String service) {
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/' + service,
                'POST',
                null,
                body);
        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
        System.debug('****body: ' + ws.bodyParameter.value);
        WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
        Response res = (Response) ws.invoke(new Response());
        WSAuthToken.manageTokenResponse(tokenResp);
        return res;
    }

    public class Response extends WSResult {
        public WSCaseEnviarASSGenericResponse result ;
        public override void processResponse(HttpResponse response) {
			result = WSCaseEnviarASSGenericResponse.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            this.message = processMessage(response);
        }
    }
    

    private static String processMessage(HttpResponse response) {
        Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        Map<String,Object> data = (Map<String,Object>) body.get('data');
        Map<String,Object> errors;
        try {
            errors = (Map<String,Object>) data.get('errors');
        } catch (Exception e) {
            errors = new Map<String,Object>();
        }
        String message = '';
        if(data.get('httpCode') == 500){
            if(!errors.isEmpty()) {
                message = errors.get('message').toString();
            } else {
                message = data.get('message').toString();
            }
        }
        else{
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body).replaceAll('familiar.0.', '').replaceAll('encabezado.0.', '');
        }
        return message;
    }

    public abstract class Notas {
		public String nota_id;
		public String texto_nota;
		public String sf_id;
	}
}