public with sharing class WSCotizador {

    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response cotizar(String body) {

		System.debug(body);

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/cotizador/cotizaciones',
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

    public static ResponseCorporativa cotizarCorporativa(String body) {

        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/cotizador/corporativa/cotizaciones',
                'POST',
                null,
                body);

        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		ResponseCorporativa res = (ResponseCorporativa) ws.invoke(new ResponseCorporativa());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

	public static ResponseCorporativaPDF getCorporativaPDF(String cotIdSS) {
        RestWS ws = new RestWS(
			SERVICE_CONFIG.URL__c + '/v1/cotizador/corporativa/cotizaciones/print/' + cotIdSS,
			'GET', 
			null
		);
                
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		ResponseCorporativaPDF res = (ResponseCorporativaPDF) ws.invoke(new ResponseCorporativaPDF());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

	public static ResponseCorporativaPDF getContratoCorporativaPDF(String cotIdSS) {
        RestWS ws = new RestWS(
			SERVICE_CONFIG.URL__c + '/v1/cotizador/corporativa/cotizaciones/print/' + cotIdSS + '/contrato',
			'GET', 
			null
		);
                
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		ResponseCorporativaPDF res = (ResponseCorporativaPDF) ws.invoke(new ResponseCorporativaPDF());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

    public class Response extends WSResult {
        public WSCotizadorResp cotizacion ;
        public override void processResponse(HttpResponse response) {
            cotizacion = WSCotizadorResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
		    Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
    public class ResponseCorporativa extends WSResult {
        public WSCotizadorCorporativaResp cotizacion ;
        public override void processResponse(HttpResponse response) {
            cotizacion = WSCotizadorCorporativaResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
			Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }

	public class ResponseCorporativaPDF extends WSResult {
        public WSCotizadorCorporativaPDFResp cotizacion ;

        public override void processResponse(HttpResponse response) {
            cotizacion = WSCotizadorCorporativaPDFResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
			Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }

    }
}