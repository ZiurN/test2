@isTest 
private class WSOpportunityReingresoTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static String body;

	static {
		
		body = '{' +
					'"encabezado": [' +
						'{' +
        					'"solicitud_id": "723996",' +
							'"sf_id": "001Q000sdfHJSpxIAL",' +
							'"tipo_reingreso": "FAM",' +
							'"afi_codigo": "197495/23",' +
							'"afi_codigo_tit": "197495/16",' +
							'"parentesco": "HI",' +
							'"fecha_vigencia": "01/04/2020",' +
							'"agencia_codigo": "650260",' +
							'"usuario": "SMASES",' +
							'"nota": "Texto a insertar en notas."' +
						'}' +
					']' +
				'}';
		
		getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSOpportunityReingresoMock.getFound('001Q000sdfHJSpxIAL'))
                .addForAddress(WSOpportunityReingreso.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reingreso');
		
		
		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('La solicitud enviada es inválida.')
                .withStatusCode(404)
                .withBody(WSOpportunityReingresoMock.getError())
                .addForAddress(WSOpportunityReingreso.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reingreso');

	}

	@isTest
	private static void sendValidReingresoToSS() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        WSOpportunityReingreso.Response responseToAssert = WSOpportunityReingreso.sendReingreso(body);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals('001Q000sdfHJSpxIAL',responseToAssert.result.data[0].sf_id);
		System.assertEquals('723996',responseToAssert.result.data[0].solafi_id);
		System.assertEquals('INCOMPLETA',responseToAssert.result.data[0].estado_sol);
		System.assertEquals('NUEVA',responseToAssert.result.data[0].estado_dj);
		System.assertEquals('210886/18',responseToAssert.result.data[0].codigo_as);
		System.assertEquals('DSAFAM',responseToAssert.result.data[0].tipo_asoc);
		System.assertEquals(1,responseToAssert.result.data[0].notas.size());
		System.assertEquals('128788',responseToAssert.result.data[0].notas[0].nota_id);
		System.assertEquals('Texto a insertar en notas.',responseToAssert.result.data[0].notas[0].texto_nota);
	}

	@isTest
	private static void sendInvalidReingresoToSS() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);

        Test.startTest();
        WSOpportunityReingreso.Response responseToAssert = WSOpportunityReingreso.sendReingreso(body);
        Test.stopTest();
		
		String msg = 'El campo encabezado.0.codigo_obrasocial es obligatorio cuando encabezado.0.tipo_reingreso es TIT.\n' +
			'El campo encabezado.0.civa_codigo es obligatorio cuando encabezado.0.tipo_reingreso es TIT.\n';

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
        System.assertEquals('La solicitud enviada es inválida.', responseToAssert.response.getStatus());
		System.assertEquals(msg, responseToAssert.message);
	}
}