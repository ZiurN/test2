public class WSAsociadoGetInterfazFinanciera  {

	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getInterfazFinanciera(String codigoDeEntidad){
		System.debug('CodigoEntidad: ' + codigoDeEntidad);
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/interfaz-financiera/' + codigoDeEntidad, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSAsociadoGetInterfazFinancieraResp interfazFinanciera;

		public override void processResponse(HttpResponse response) {
			//interfazFinanciera = (WSAsociadoGetInterfazFinancieraResp)
				//JSON.deserialize(response.getBody(), WSAsociadoGetInterfazFinancieraResp.class);
			interfazFinanciera = WSAsociadoGetInterfazFinancieraResp.parse(response.getBody());
		}
	}	
}