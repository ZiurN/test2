/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase para establecer respuestas a los mock del endpoint de solicitudes-afiliados.
@date			10/12/2021
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class SolicitudesAfiliadosMock {
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Devuelve respuesta correcta del endpoint de solicitudes-afiliados/{solafi_id}/incompleta
	@return			String con del JSON de respuesta.
	------------------------------------------------------------------------------------------------------------------------*/
	public static String getIncompletaResponseOk() {
		return '{' +
			'"error": false,' +
			'"data": null,' +
			'"httpCode": 200,' +
			'"message": "La solicitud ha pasado a estado Incompleta exitosamente.",' +
			'"meta": {' +
				'"allowed_includes": [],' +
				'"default_includes": [],' +
			'}' +
		'}';
	}
		/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Devuelve respuesta correcta del endpoint de solicitudes-afiliados/{solafi_id}/incompleta
	@return			String con del JSON de respuesta.
	------------------------------------------------------------------------------------------------------------------------*/
	public static String getIncompletaResponseError() {
		return '{' +
			'"error": false,' +
			'"data": null,' +
			'"httpCode": 200,' +
			'"message": "La solicitud ha pasado a estado Incompleta exitosamente.",' +
			'"meta": {' +
				'"allowed_includes": [],' +
				'"default_includes": [],' +
			'}' +
		'}';
	}
}
