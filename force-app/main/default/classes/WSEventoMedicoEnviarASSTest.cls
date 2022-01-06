@isTest
public class WSEventoMedicoEnviarASSTest  {
	/*
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getErrorResponse500;
	static String body;

	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSEventoMedicoEnviarASSMock.getFound())
			.addForAddress(WSEventoMedicoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/seguimiento');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
				.withStatus('exception')
				.withStatusCode(422)
				.withBody(WSEventoMedicoEnviarASSMock.getError())
				.addForAddress(WSEventoMedicoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/seguimiento');

		getErrorResponse500 = new XHttpCalloutMock();
		getErrorResponse500.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse500.buildResponse()
				.withStatus('exception')
				.withStatusCode(500)
				.withBody(WSEventoMedicoEnviarASSMock.getError500())
				.addForAddress(WSEventoMedicoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/seguimiento');
//		getErrorResponse = new XHttpCalloutMock();
//		getErrorResponse.buildResponse()
//			.withStatus('Not Found')
//			.withStatusCode(404)
//			.withBody(WSEventoMedicoEnviarASSMock.getError())
//			.addForAddress(WSEventoMedicoEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/seguimiento');

		body = '{' +
			'"codigo_afiliado": "123456/15",' +
			'"agencia_codigo": "650098",' +
			'"fecha_inicio": "27/09/2019",' +
			'"codigo_lugar": "700076",' +
			'"consultorio": 1,' +
			'"responsable": "753415",' +
			'"solicitante": "753415",' +
			'"tipo_evento": "IA",' +
			'"motivo": "CLINICO",' +
			'"anestesia": "N",' +
			'"recupero": "V",' +
			'"codigo_diagnostico": "999",' +
			'"nivel_complicacion": 0,' +
			'"codigo_prestacion": "02430199",' +
			'"descripcion": "Descripción",' +
			'"observaciones": "Sin observaciones",' +
			'"usuario": "MAPPLICS",' +
			'"numero_sf": 2005,' +
			'"chk_material": "F",' +
			'"chk_presupuesto": "V"	,' +
			'"importe_presupuesto": "150.32"' +
		'}';
	}

	@IsTest
	private static void whenTheWSIsConsume_GetListOfEventosMedicos(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSEventoMedicoEnviarASS.Response responseToAssert = WSEventoMedicoEnviarASS.enviarEventoMedico(body);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());

		System.assertEquals('275751', responseToAssert.result.data.em.em_id);
		System.assertEquals('1014009814', responseToAssert.result.data.em.apr_apr_id);

		System.assertEquals(2, responseToAssert.result.data.em.ap.size());
		System.assertEquals('1014009814', responseToAssert.result.data.em.ap[0].apr_id);

		System.assertEquals(1, responseToAssert.result.data.em.ap[0].prestaciones.size());
		System.assertEquals('1014009814', responseToAssert.result.data.em.ap[0].prestaciones[0].apr_id);

		System.assertEquals(4, responseToAssert.result.data.em.ap[0].prestaciones[0].alertas.size());
		System.assertEquals('74042109', responseToAssert.result.data.em.ap[0].prestaciones[0].alertas[0].pca_pca_id);
		System.assertEquals('16460534', responseToAssert.result.data.em.ap[0].prestaciones[0].alertas[0].aca_id);
	}

	@IsTest
	private static void whenTheErrorCodeIsNot500_ShowTheCorrectMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);

		Test.startTest();
		WSEventoMedicoEnviarASS.Response responseToAssert = WSEventoMedicoEnviarASS.enviarEventoMedico(body);
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(422, responseToAssert.response.getStatusCode());
		System.assertEquals('exception', responseToAssert.response.getStatus());
		System.debug(responseToAssert.message);
		System.debug(responseToAssert.message + '\n');
		System.assertEquals('codigo afiliado es invalido.\n', responseToAssert.message);
	}

	@IsTest
	private static void whenTheErrorCodeIs500_ShowTheCorrectMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse500);

		Test.startTest();
		WSEventoMedicoEnviarASS.Response responseToAssert = WSEventoMedicoEnviarASS.enviarEventoMedico(body);
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(500, responseToAssert.response.getStatusCode());
		System.assertEquals('exception', responseToAssert.response.getStatus());
		System.debug('Mensaje***: ' + responseToAssert.message);
		System.debug('Result***: ' + responseToAssert.result);

		System.assertEquals('Error 500.', responseToAssert.message);
	}*/
}