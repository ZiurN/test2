public class WSAsociadoEstadoCredenciales  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getEstadoCredenciales(String codAsociado) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/estados/' + codAsociado, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public static ResponseDetalle getEstadoCredencialesDetalle(String codAsociado, String idOca) {
		RestWS ws = new RestWS(
			SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/estados/' + codAsociado + '/detalle/' + idOca, 
			'GET', 
			null
		);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		ResponseDetalle res = (ResponseDetalle) ws.invoke(new ResponseDetalle());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public static ResponseCarga cargaCredencial(String body) {
		RestWS ws = new RestWS(
			SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/carga-entrega', 
			'POST', 
			null,
			body
		);
		ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
        
		System.debug('****body: ' + ws.bodyParameter.value);

		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		ResponseCarga res = (ResponseCarga) ws.invoke(new ResponseCarga());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}
	
	public class Response extends WSResult {
		public WSAsociadoEstadoCredencialesResp  result;
		public override void processResponse(HttpResponse response) {
			result = WSAsociadoEstadoCredencialesResp.parse(response.getBody());
		}
	}

	public class ResponseDetalle extends WSResult {
		public WSAsociadoCredencialDetalleResp result;
		public override void processResponse(HttpResponse response) {
			result = WSAsociadoCredencialDetalleResp.parse(response.getBody());
		}
	}

	public class ResponseCarga extends WSResult {
		public WSAsociadoCargaCredencialResp result;
		public override void processResponse(HttpResponse response) {
			result = WSAsociadoCargaCredencialResp.parse(response.getBody());
		}

		public override void processError(HttpResponse response) {
            Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }
	}
}