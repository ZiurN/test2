public class WSLocalidad  {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	
	// Formato fecha AAAA-MM-DD
	public static Response getLocalidadPorFechaModificacion(String fecha, Integer pageSize, Integer currentPage) {
		String filtroMod = '?filter[fecha_modificacion]=' + fecha;
		String filtro = pageSize > 0 ? '&pageSize=' + pageSize + '&page=' + currentPage : '';
		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/localidades-zonas' + filtroMod + filtro, 'GET', null);
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		Response res = (Response) ws.invoke(new Response());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
	}


	public class Response extends WSResult {
		public WSLocalidadResp localidad;
		public override void processResponse(HttpResponse response) {
			localidad = WSLocalidadResp.parse(response.getBody());
		}

		public override void processError(HttpResponse response) {
		}

	}
}