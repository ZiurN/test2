@isTest 
private class WSLoteEnviarASSTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseError;

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
			.withBody(WSLoteEnviarASSMock.getFound())
			.addForAddress(WSLoteEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes');
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSLoteEnviarASSMock.getError())
			.addForAddress(WSLoteEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes');
		
	}

	@isTest
	private static void sendNewLoteToSS() {
		String body = JSON.serialize(new Map<String,Object>{
			'usuario' => 'CRIOS',
			'observaciones' => 'OBSERVACION DE PRUEBA',
			'emision' => 'S',
			'fecha' => '2020-04-09'
		});
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Test.startTest();
		WSLoteEnviarASS.Response resp = WSLoteEnviarASS.sendLoteToSS(body);
		Test.stopTest();

		System.assertEquals(false,resp.hasError);
		System.assertEquals('Ok', resp.message);
		System.assertEquals(5400,resp.lote.data.lote_id);
		System.assertEquals('A',resp.lote.data.estado);
	}

		@isTest
	private static void sendNewLoteToSSWithInvalidUsuario() {
		String body = JSON.serialize(new Map<String,Object>{
			'usuario' => 'asdf',
			'observaciones' => 'OBSERVACION DE PRUEBA',
			'emision' => 'S',
			'fecha' => '2020-04-09'
		});
		Test.setMock(HttpCalloutMock.class,getResponseError);
		Test.startTest();
		WSLoteEnviarASS.Response resp = WSLoteEnviarASS.sendLoteToSS(body);
		Test.stopTest();

		System.assertEquals(true,resp.hasError);
		System.assertNotEquals('usuario invalido.\n',resp.message);
	}
}