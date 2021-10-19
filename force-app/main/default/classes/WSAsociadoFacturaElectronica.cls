public class WSAsociadoFacturaElectronica  {
	@TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static Response updateFacturaElectronica(String afiId, String body) {
        RestWS ws = new RestWS(
								SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/' + afiId + '/factura-electronica', 'PUT', 
								null, 
								body
		);
        WSAuthToken.setAuth(ws);
        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		System.debug('****body: ' + ws.bodyParameter.value);
        Response resp = (Response) ws.invoke(new Response());
        return resp;
    }

    public class Response extends WSResult {
        public WSAsociadoFacturaElectronicaResp result;
        public override void processResponse(HttpResponse response) {
            result = WSAsociadoFacturaElectronicaResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Object> data = (Map<String,Object>) body.get('data');
			if(data.get('message') != null){
				message = data.get('message').toString();
			}
        }

    }
}