public with sharing class WSLoteOrdenDePago {
    @TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	public static Response getOrdenesDePago(String id_lote) {
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/'+ id_lote +'/ordenes-pago', 'GET', null);

		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}

	public class Response extends WSResult {
		public WSLoteOrdenDePagoResp loteOrdenDePago;
		public override void processResponse(HttpResponse response) {
			loteOrdenDePago = WSLoteOrdenDePagoResp.parse(response.getBody());
		}

		public override void processError(HttpResponse response) {
		}

	}

}