/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase auxiliar para los métodos de prueba.
@date			10/12/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ExcessiveParameterList')
public without sharing class TestUtils {
	private static final Webservice_endpoint_setting__mdt SERVICE_CONFIG = ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
	private static final String AUTH_TOKEN_URL = SERVICE_CONFIG.URL__c + '/oauth/token';
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Establece el mock de respuesta para las pruebas de llamado a MS
	@param			mock - Mock para construir.
	@param			url - Cola de la URL para simular el llamado.
	@param			body - Cuerpo de respuesta simulada.
	@param			statusCode - Código del estado de la respuesta.
	@param			status - Estado de la respuesta.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void setMockResponse (XHttpCalloutMock mock,
										String url,
										String body) {
		setAuthToken(mock);
		mock.buildResponse()
			.withStatus('status')
			.withStatusCode(200)
			.withBody(body)
			.addForAddress(SERVICE_CONFIG.URL__c + url);
	}
	public static void setMockResponse (XHttpCalloutMock mock,
										String url,
										String body,
										Integer statusCode,
										String status) {
		setAuthToken(mock);
		mock.buildResponse()
			.withStatus(status)
			.withStatusCode(statusCode)
			.withBody(body)
			.addForAddress(SERVICE_CONFIG.URL__c + url);
	}
	public static void setMockResponse (Boolean setAuthToken,
										XHttpCalloutMock mock,
										String url,
										String body,
										Integer statusCode,
										String status) {
		if (setAuthToken) {
			setAuthToken(mock);
		}
		mock.buildResponse()
			.withStatus(status)
			.withStatusCode(statusCode)
			.withBody(body)
			.addForAddress(SERVICE_CONFIG.URL__c + url);
	}
	/** Utils */
	public static void setAuthToken (XHttpCalloutMock mock) {
		mock.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(AUTH_TOKEN_URL);
	}
}