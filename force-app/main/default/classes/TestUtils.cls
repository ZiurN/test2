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
	@param			settings - Objeto con la configuración del endpoint.
	@param			settingsList - Lista de objetos con la configuración del endpoint.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void setMockResponse (XHttpCalloutMock mock,
										String url,
										String body) {
		setAuthToken(mock);
		mock.buildResponse()
			.withStatus('OK')
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
	public static void setMockResponse (XHttpCalloutMock mock, MockSettings settings) {
		setAuthToken(mock);
		mock.buildResponse()
			.withStatus(settings.status)
			.withStatusCode(settings.statusCode)
			.withBody(settings.body)
			.addForAddress(SERVICE_CONFIG.URL__c + settings.url);
	}
	public static void setMockResponse (XHttpCalloutMock mock, List<MockSettings> settingsList) {
		setAuthToken(mock);
		for (MockSettings settings : settingsList) {
			mock.buildResponse()
				.withStatus(settings.status)
				.withStatusCode(settings.statusCode)
				.withBody(settings.body)
				.addForAddress(SERVICE_CONFIG.URL__c + settings.url);
		}
	}
	public static void setMockResponse (Boolean setAuthToken,
										XHttpCalloutMock mock,
										String url,
										String body) {
		if (setAuthToken) {
			setAuthToken(mock);
		}
		mock.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
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
	public static void setMockResponse (Boolean setAuthToken,
										XHttpCalloutMock mock,
										MockSettings settings) {
		if (setAuthToken) {
			setAuthToken(mock);
		}
		mock.buildResponse()
			.withStatus(settings.status)
			.withStatusCode(settings.statusCode)
			.withBody(settings.body)
			.addForAddress(SERVICE_CONFIG.URL__c + settings.url);
	}
	public static void setMockResponse (Boolean setAuthToken,
										XHttpCalloutMock mock,
										List<MockSettings> settingsList) {
		if (setAuthToken) {
			setAuthToken(mock);
		}
		for (MockSettings settings : settingsList) {
			mock.buildResponse()
				.withStatus(settings.status)
				.withStatusCode(settings.statusCode)
				.withBody(settings.body)
				.addForAddress(SERVICE_CONFIG.URL__c + settings.url);
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Crea un HTMLBody con contentversions, imitando tener elementos pegados en los correos
	@param			mock - Mock para construir.
	@return			HtmlBody - El HTMLBody.
	------------------------------------------------------------------------------------------------------------------------*/
	public static String createHTMLBody (List<ContentVersion> cvs) {
		String HtmlBody = '<html>' +
			'<head>' +
				'<title></title>' +
			'</head>' +
			'<body>123132132<br clear="none" />' +
				'<b>From:</b> Jeferson Ruiz [jeferson.ruiz@globant.com]<br clear="none" />' +
				'<b>Sent:</b> 28/12/2021 22:15<br clear="none" />' +
				'<b>To:</b> jeferson.ruiz@xappia.com<br clear="none" />' +
				'<b>Subject:</b>Prueba imagenes pegadas a correo<br clear="none" />' +
				'<div dir="ltr">';
		for (ContentVersion cv : cvs) {
			HtmlBody += '<div>' +
				'<img alt="imagen.png" height="278"' +
					'src="https://acasalud--uat2--c.documentforce.com/sfc/servlet.shepherd/version/download/' + cv.Id + '?asPdf=false&operationContext=CHATTER"' +
					'width="531" />' +
					'<br clear="none" />' +
				'&nbsp;' +
			'</div>';
		}
		HtmlBody += '<br clear="none" />' +
				'</div>' +
			'</body>' +
			'</html>';
		return HtmlBody;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Crea un ContentVersion a partir de un recurso estático grande.
	@return			cvToReturn - el CV para utilizar.
	------------------------------------------------------------------------------------------------------------------------*/
	public static ContentVersion createContentVersionWithFileBiggerThan3MB () {
		StaticResource resource = XappiaHelper.getStaticResource('BigFile');
		ContentVersion cvToReturn = new ContentVersion(
			Title = 'BigFile',
			VersionData = Blob.valueOf(resource.body.toString()),
			PathOnClient = '/BigFile'
		);
		return cvToReturn;
	}
	public static void validatePlatformEventFired (Boolean shouldBeCreated, String eventDevName) {
		EventBusSubscriber[] subscribers =[SELECT Name,
												Type,
												Position,
												Retries,
												LastError
				 							FROM EventBusSubscriber
											WHERE Topic=: eventDevName];
		if (shouldBeCreated) {
			System.assertEquals(1, subscribers.size(), 'Debe haber un suscriptor por el trigger del evento');
		} else {
			System.assertEquals(0, subscribers.size(), 'No debe haber un suscriptor por el trigger del evento');
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Clase que permite crear un mock para otras clases de Apex
	@param			typeToMock - La clase que se desea "mockear".
	@param			mockProvider - Instancia de la clase MockProvider para crear el mock.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Object createClassMock(Type typeToMock, MockProvider mockProvider) {
		return Test.createStub(typeToMock, mockProvider);
	}
	/** Utils */
	public static void setAuthToken (XHttpCalloutMock mock) {
		mock.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(AUTH_TOKEN_URL);
	}
	public static void setAuthToken (XHttpCalloutMock mock,
									String body,
									Integer statusCode,
									String status) {
		mock.buildResponse()
			.withStatus(status)
			.withStatusCode(statusCode)
			.withBody(body)
			.addForAddress(AUTH_TOKEN_URL);
	}
	public class MockSettings {
		public Integer statusCode {get; set;}
		public String status {get;set;}
		public String body {get;set;}
		public String url {get;set;}
	}
}