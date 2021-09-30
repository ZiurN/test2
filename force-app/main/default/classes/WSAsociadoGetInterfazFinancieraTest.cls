@isTest
private class WSAsociadoGetInterfazFinancieraTest{
	
	@isTest
	static void whenTheWSIsConsumedAndReturnsCode200_ResponseClassShouldBeFieldWithValuesFromTheWS(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		WSAsociadoGetInterfazFinanciera.Response resp = WSAsociadoGetInterfazFinanciera.getInterfazFinanciera('51989');
		Test.stopTest();
		
		System.debug('******Resp' + resp);
		System.assertEquals('No Categorizado Genericos', resp.interfazFinanciera.data[0].regimen_ganancias);
		System.assertEquals('N', resp.interfazFinanciera.data[0].inscripto_ganancias);
		System.assertEquals('F', resp.interfazFinanciera.data[0].agente_retencion_ganancias);
		System.assertEquals('0', resp.interfazFinanciera.data[0].porcentaje_exencion_ganancias);
		System.assertEquals(null, resp.interfazFinanciera.data[0].codigo_exencion_ganancias);
		System.assertEquals(null, resp.interfazFinanciera.data[0].resolucion_exencion_ganancias);
		System.assertEquals(null, resp.interfazFinanciera.data[0].fecha_desde_exencion_ganancias);
		System.assertEquals(null, resp.interfazFinanciera.data[0].fecha_hasta_exencion_ganancias);

		System.assertEquals('4', resp.interfazFinanciera.data[0].codigo_condicion_iva);
		System.assertEquals('F', resp.interfazFinanciera.data[0].agente_retencion_iva);
		System.assertEquals('No Retencion - Exento', resp.interfazFinanciera.data[0].descripcion_regimen_iva);
		System.assertEquals('F', resp.interfazFinanciera.data[0].comprobante_iva);
		System.assertEquals('0', resp.interfazFinanciera.data[0].porcentaje_exencion_iva);
		System.assertEquals(null, resp.interfazFinanciera.data[0].resolucion_exencion_iva);
		System.assertEquals(null, resp.interfazFinanciera.data[0].fecha_desde_exencion_iva);
		System.assertEquals(null, resp.interfazFinanciera.data[0].fecha_hasta_exencion_iva);

		System.assertEquals('No Retención', resp.interfazFinanciera.data[0].regimen_ib);
		System.assertEquals('No Corresponde', resp.interfazFinanciera.data[0].convenio_ib);
		System.assertEquals(' ', resp.interfazFinanciera.data[0].numero_ib);
		System.assertEquals(null, resp.interfazFinanciera.data[0].fecha_vigencia_ib);
		System.assertEquals(null, resp.interfazFinanciera.data[0].provincia_ib);
		System.assertEquals('F', resp.interfazFinanciera.data[0].agente_retencion_ib);

		System.assertEquals(null, resp.interfazFinanciera.data[0].cuit_cuil_cpte);
		System.assertEquals('F', resp.interfazFinanciera.data[0].presenta_cpte);
		System.assertEquals('NINGUNO', resp.interfazFinanciera.data[0].tipo_cuit_cpte);
		System.assertEquals(null, resp.interfazFinanciera.data[0].anses_codigo_cpte);

		System.assertEquals('75', resp.interfazFinanciera.data[0].nro_mco_clientes);
		System.assertEquals('LE', resp.interfazFinanciera.data[0].tipo_doc_mco_clientes);
		System.assertEquals('05481237', resp.interfazFinanciera.data[0].nro_doc_mco_clientes);
		System.assertEquals(null, resp.interfazFinanciera.data[0].banco_mco_clientes);
		System.assertEquals(null, resp.interfazFinanciera.data[0].sucursal_mco_clientes);
		System.assertEquals(null, resp.interfazFinanciera.data[0].moneda_mco_clientes);

		System.assertEquals(null, resp.interfazFinanciera.data[0].banco_prov);
		System.assertEquals(null, resp.interfazFinanciera.data[0].banco_sucursal_prov);
		System.assertEquals(null, resp.interfazFinanciera.data[0].banco_moneda_prov);
		System.assertEquals(null, resp.interfazFinanciera.data[0].banco_tipo_cta_prov);
		System.assertEquals(null, resp.interfazFinanciera.data[0].banco_cuenta_prov);
		System.assertEquals('PLATZ AVELINO MARCOS', resp.interfazFinanciera.data[0].orden_cheque_prov);
		System.assertEquals(null, resp.interfazFinanciera.data[0].cbu_prov);
		System.assertEquals(null, resp.interfazFinanciera.data[0].mpa_codigo_prov);
		System.assertEquals(null, resp.interfazFinanciera.data[0].mpa_descripcion_prov);

		System.assertEquals(null, resp.interfazFinanciera.data[0].personeria_otros);
		System.assertEquals(null, resp.interfazFinanciera.data[0].motivo_inhab_otros);
		System.assertEquals('FÍSICA', resp.interfazFinanciera.data[0].fecha_inicio_otros);
		System.assertEquals('1997-09-01 00:00:00', resp.interfazFinanciera.data[0].nombre_empresa_otros);
		System.assertEquals('1', resp.interfazFinanciera.data[0].alias_otros);
		
	}

	@IsTest
	private static void whenTheWSIsConsumedAndReturnsHTTPCode404_AMessageShouldBeDisplayAlertingARequestError(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		WSAsociadoGetInterfazFinanciera.Response resp = WSAsociadoGetInterfazFinanciera.getInterfazFinanciera('5198100');
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals(404, resp.response.getStatusCode());
	}

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getOAuthErrorResponse;

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
				.withBody(WSAsociadoGetInterfazFinancieraMock.getInterfazFinancieraOK())
				.addForAddress(WSAsociadoGetInterfazFinanciera.SERVICE_CONFIG.URL__c + '/v1/salud/interfaz-financiera/51989');

			getErrorResponse = new XHttpCalloutMock();
			getErrorResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
			getErrorResponse.buildResponse()
				.withStatus('Not found')
				.withStatusCode(404)
				.withBody(WSAsociadoGetInterfazFinancieraMock.getInterfazFinancieraERROR())
				.addForAddress(WSAsociadoGetInterfazFinanciera.SERVICE_CONFIG.URL__c + '/v1/salud/interfaz-financiera/519100');

			getOAuthErrorResponse = new XHttpCalloutMock();

			getOAuthErrorResponse.buildResponse() 
				.withStatus('Not found')
				.withStatusCode(401)
				.withBody(WSAuthTokenMock.getInvalidCredentialsError())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
			getOAuthErrorResponse.buildResponse()
				.withStatus('Not found')
				.withStatusCode(404)
				.withBody(WSAsociadoGetInterfazFinancieraMock.getInterfazFinancieraERROR())
				.addForAddress(WSAsociadoGetInterfazFinanciera.SERVICE_CONFIG.URL__c + '/v1/salud/interfaz-financiera/51989');
	}
}