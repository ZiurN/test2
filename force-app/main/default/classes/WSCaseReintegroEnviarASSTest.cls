@isTest 
private class WSCaseReintegroEnviarASSTest {
	/*static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static String body;

	static {
		WSCaseReintegroEnviarASSMock mock = new WSCaseReintegroEnviarASSMock();
		string mockFound = mock.getFound('');
		
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(mockFound)
			.addForAddress(WSCaseReintegroEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSCaseReintegroEnviarASSMock.getError())
			.addForAddress(WSCaseReintegroEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros');

		body = 
				'{' +
					'"fecha": "2020-02-20",' +
					'"lote": "5392",' +
					'"agencia_codigo": "650098",' +
					'"codigo_afiliado": "69794/14",' +
					'"cuit": "27169355865",' +
					'"razon_social": "PRUEBA REINT",' +
					'"tipo_comprobante": "RXC",' +
					'"numero_comprobante": "0001-005953",' +
					'"fecha_comprobante": "2020-02-10",' +
					'"importe": "1000",' +
					'"observaciones": "Prueba Reintegro",' +
					'"codigo_diagnostico": "999",' +
					'"fecha_prescripcion": "2020-02-01",' +
					'"efector_prescriptor": "758415",' +
					'"efector_realizador": "758415",' +
					'"cobro": "N",' +
					'"em_id": null,' +
					'"numero_sf": "dasdsa0003",' +
					'"usuario": "CRIOS",' +
					'"prestaciones": [{' +
					  '"nom_prestacion": "02170101",' +
					  '"contexto": "A",' +
					  '"cantidad": 1,' +
					  '"tipo_prestacion": "N",' +
					  '"importe_total": "1000",' +
					  '"importe_a_pagar": "800",' +
					  '"honorarios": "11",' +
					  '"pieza_dental": null,' +
					  '"cara": null,' +
					  '"fecha": "2020-02-01",' +
					  '"alerta": null,' +
					  '"observaciones": "Ninguna"' +
					'}]' +
				'}';
	}
	
	@IsTest
	private static void whenTheWSIsConsume_getReintegroPrestacionesAndAlertas(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSCaseReintegroEnviarASS.Response responseToAssert = WSCaseReintegroEnviarASS.enviarReintegro(body);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals('553276', responseToAssert.result.data.reintegro.rei_id);
		System.assertEquals('5392', responseToAssert.result.data.reintegro.lote);
		System.assertEquals('140978', responseToAssert.result.data.reintegro.afi_afi_id);
		System.assertEquals('650098', responseToAssert.result.data.reintegro.del_os_codigo);
		System.assertEquals('69794/14', responseToAssert.result.data.reintegro.codigo);
		
		System.assertEquals('553276', responseToAssert.result.data.reintegro.prestaciones[0].rei_id);
		System.assertEquals('C1-----A', responseToAssert.result.data.reintegro.prestaciones[0].estado_prestacion);
		System.assertEquals('02170101', responseToAssert.result.data.reintegro.prestaciones[0].prestacion);
		System.assertEquals('N', responseToAssert.result.data.reintegro.prestaciones[0].tipo_prestacion);
		
		System.assertEquals('74043156', responseToAssert.result.data.reintegro.prestaciones[0].alertas[0].pca_pca_id);
		System.assertEquals('16464703', responseToAssert.result.data.reintegro.prestaciones[0].alertas[0].aca_id);
		System.assertEquals('171', responseToAssert.result.data.reintegro.prestaciones[0].alertas[0].control);
		System.assertEquals('AM', responseToAssert.result.data.reintegro.prestaciones[0].alertas[0].funcion);
	}

	@IsTest
	private static void whenTheWSIsConsume_GetTokenErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);

		Test.startTest();
		WSAuthToken.Response responseToAssert = WSAuthToken.getToken();
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('404 not found', responseToAssert.response.getStatus());
		System.assertEquals(null, responseToAssert.token);
	}*/
	
}