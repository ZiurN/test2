@isTest 
private class WSOpportunityReingresoGFamTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;

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
                .withBody(WSOpportunityReingresoGFamMock.getFound())
                .addForAddress(WSOpportunityReingresoGFam.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reingreso-grupo-familiar');
		
		
		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('La solicitud enviada es inválida.')
                .withStatusCode(404)
                .withBody(WSOpportunityReingresoGFamMock.getError())
                .addForAddress(WSOpportunityReingresoGFam.SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reingreso-grupo-familiar');

	}

	@isTest
	private static void sendValidReingresoToSS() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		String body = '{'+
    '"encabezado": ['+
        '{'+
            '"sf_id": "12asd468wxe45",'+
            '"afi_codigo": "223483/17",'+
            '"fecha_vigencia": "01/04/2020",'+
            '"agencia_codigo": "650260",'+
            '"usuario_carga": "SMASES",'+
            '"codigo_obrasocial": "640100",'+
            '"codigo_plan": "AS204",'+
            '"aa2_codigo": "DEBAUT",'+
            '"aa3_codigo": "SC",'+
            '"acti_codigo": "COM",'+
            '"aa_codigo": "VOLDIR",'+
            '"apellidos": "APELLIDO3",'+
            '"nombres": "NOMBRE4",'+
			'"nacionalidad": "054",'+
            '"localidad": "3535",'+
            '"dom_calle": "Calle",'+
            '"dom_numero": "1423",'+
			'"dom_piso": "G",'+
            '"dom_dpto": "Ca",'+
            '"tel_tipo": "CEL",'+
            '"tel_numero": "3415213654",'+
            '"email": "prueba@HOTMAIL.COM",'+
            '"doc_tipo": "DNI",'+
            '"doc_numero": "41178818",            '+
            '"civa_codigo": "4",'+
            '"emergencia": "N",'+
            '"asoc_inmediata": "N", '+
            '"referido": "N",'+
            '"cobro_numero": "4050710155583227",'+
            '"cobro_medio": "TRO06",'+
            '"nota": "Nota de prueba"'+
        '}'+
    '],'+
    '"familiares": ['+
        '{'+
            '"sf_id": "34sadt4crw4et5",'+
            '"afi_codigo": "223483/24",'+
            '"e_civil": "S",'+
            '"sexo": "M",'+
            '"fecha_nac": "03/10/1988",'+
            '"nacionalidad": "054",'+
            '"parentesco": "HI",'+
            '"deriva_aportes": "F"'+
        '}'+
    ']'+
'}';

        Test.startTest();
        WSOpportunityReingresoGFam.Response responseToAssert = WSOpportunityReingresoGFam.enviarReingresoGrupoFamiliar(body);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(2,responseToAssert.result.data.size());
		System.assertEquals('12asd468wxe45',responseToAssert.result.data[0].sf_id);
		System.assertEquals('724402',responseToAssert.result.data[0].solafi_id);
		System.assertEquals('COMPLETA',responseToAssert.result.data[0].estado_sol);
		System.assertEquals('NUEVA',responseToAssert.result.data[0].estado_dj);
		System.assertEquals('223483/17',responseToAssert.result.data[0].codigo_as);
		System.assertEquals('DSATIT',responseToAssert.result.data[0].tipo_asoc);
		System.assertEquals(1,responseToAssert.result.data[0].notas.size());
		System.assertEquals('128878',responseToAssert.result.data[0].notas[0].nota_id);
		System.assertEquals('Nota de prueba',responseToAssert.result.data[0].notas[0].texto_nota);
	}

	@isTest
	private static void sendInvalidReingresoToSS() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		String body = '{'+
    '"encabezado": ['+
        '{'+
            '"sf_id": "12asd468wxe45",'+
            '"afi_codigo": "",'+
            '"fecha_vigencia": "01/04/2020",'+
            '"agencia_codigo": "650260",'+
            '"usuario_carga": "SMASES",'+
            '"codigo_obrasocial": "640100",'+
            '"codigo_plan": "AS204",'+
            '"aa2_codigo": "DEBAUT",'+
            '"aa3_codigo": "SC",'+
            '"acti_codigo": "COM",'+
            '"aa_codigo": "VOLDIR",'+
            '"apellidos": "APELLIDO3",'+
            '"nombres": "NOMBRE4",'+
			'"nacionalidad": "054",'+
            '"localidad": "3535",'+
            '"dom_calle": "Calle",'+
            '"dom_numero": "1423",'+
			'"dom_piso": "G",'+
            '"dom_dpto": "Ca",'+
            '"tel_tipo": "CEL",'+
            '"tel_numero": "3415213654",'+
            '"email": "prueba@HOTMAIL.COM",'+
            '"doc_tipo": "DNI",'+
            '"doc_numero": "41178818",            '+
            '"civa_codigo": "4",'+
            '"emergencia": "N",'+
            '"asoc_inmediata": "N", '+
            '"referido": "N",'+
            '"cobro_numero": "4050710155583227",'+
            '"cobro_medio": "TRO06",'+
            '"nota": "Nota de prueba"'+
        '}'+
    '],'+
    '"familiares": ['+
        '{'+
            '"sf_id": "34sadt4crw4et5",'+
            '"afi_codigo": "223483/24",'+
            '"e_civil": "S",'+
            '"sexo": "M",'+
            '"fecha_nac": "03/10/1988",'+
            '"nacionalidad": "054",'+
            '"parentesco": "HI",'+
            '"deriva_aportes": "F"'+
        '}'+
    ']'+
'}';

        Test.startTest();
        WSOpportunityReingresoGFam.Response responseToAssert = WSOpportunityReingresoGFam.enviarReingresoGrupoFamiliar(body);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
        System.assertEquals('La solicitud enviada es inválida.', responseToAssert.response.getStatus());
	}
}