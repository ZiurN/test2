@isTest 
private class WSOpportunitySendAltaTest {
	static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
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
                .withBody(WSOpportunitySendAltaMock.getFound('sfid12345'))
                .addForAddress(WSOpportunitySendAlta.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta');

		body = 
			'{' +
				'"encabezado": [' +
					'{' +
						'"sf_id": "sfid12345",' +
						'"fecha_vigencia": "01/04/2020",' +
						'"agencia_codigo": "650098",' +
						'"usuario_carga": "SMASES",' +
						'"codigo_obrasocial": "640100",' +
						'"codigo_plan": "AS204",' +
						'"aa2_codigo": "DEBAUT",' +
						'"aa3_codigo": "SC",' +
						'"acti_codigo": "COM",' +
						'"aa_codigo": "VOLDIR",' +
						'"apellidos": "ZAPATA",' +
						'"nombres": "ANALIA",' +
						'"e_civil": "S",' +
						'"sexo": "F",' +
						'"fecha_nac": "01/09/1973",' +
						'"nacionalidad": "054",' +
						'"localidad": "3661",' +
						'"dom_calle": "Burela ",' +
						'"dom_numero": "2858",' +
						'"doc_piso": 1,' +
						'"doc_depto": 2,' +
						'"tel_tipo": "TEL",' +
						'"tel_numero": "1135973937",' +
						'"email": "ANALIA-Z@HOTMAIL.COM",' +
						'"doc_tipo": "DNI",' +
						'"doc_numero": "45231569",            ' +
						'"civa_codigo": "4",' +
						'"emergencia": "N",' +
						'"asoc_inmediata": "N", ' +
						'"referido": "N",' +
						'"cobro_numero": "4050710155583227",' +
						'"cobro_medio": "TRO02",' +
						'"nota": "Nota de prueba"' +
					'}' +
				'],' +
				'"familiares": [' +
					'{' +
						'"sf_id": "sfid45678",' +
						'"apellido": "ZACARO",' +
						'"nombres": "ROMAN",' +
						'"doc_tipo": "DNI",' +
						'"doc_numero": "46969480",' +
						'"e_civil": "S",' +
						'"sexo": "M",' +
						'"fecha_nac": "03/10/2005",' +
						'"nacionalidad": "054",' +
						'"parentesco": "HI",' +
						'"deriva_aportes": "F"' +
					'}' +
				']' +
			'}';

    }

    @IsTest
    private static void whenTheWSIsConsumeGetACorrectResponse(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        WSOpportunitySendAlta.Response responseToAssert = WSOpportunitySendAlta.sendAlta(body);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
    }
}