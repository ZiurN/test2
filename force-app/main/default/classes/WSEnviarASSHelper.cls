/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase abstracta para Enviar información a SaludSoft.
@date			06/05/2022
------------------------------------------------------------------------------------------------------------------------*/
public abstract class WSEnviarASSHelper {
	private static final Webservice_endpoint_setting__mdt SERVICE_CONFIG = ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	public Webservice_endpoint_setting__mdt getWSConfig() {
		return SERVICE_CONFIG;
	}
	public abstract Object enviarASS (String body, String serviceType, String service, String method, String extraParams);
	public static WSSSGenericResponse processResponse (HttpResponse response) {
		System.debug('BODY Respuesta: '); System.debug(response.getBody());
		return WSSSGenericResponse.parse(response.getBody());
	}
}