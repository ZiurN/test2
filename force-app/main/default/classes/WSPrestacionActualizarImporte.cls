public class WSPrestacionActualizarImporte {
    @TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response sendImporteToSS(String body, String idReintegro, String idPrestacion){
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/' + idReintegro + '/prestaciones/' + idPrestacion + '/importe',
            'POST',
            null,
            body
        );
        
		ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		//-------------------------------------------------
        System.debug('body****: ' + ws.bodyParameter.value);
        //-------------------------------------------------
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult{
		public WSPrestacionActualizarImporteResp prestacion;
		public override void processResponse(HttpResponse response) {
			prestacion = WSPrestacionActualizarImporteResp.parse(response.getBody());
		}

		public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
		}

	
	}
}