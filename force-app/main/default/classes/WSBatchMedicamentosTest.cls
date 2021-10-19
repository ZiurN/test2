@isTest 
private class WSBatchMedicamentosTest {
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
			.withBody(WSBatchMedicamentosMock.getFound())
			.addForAddress(WSBatchMedicamentos.SERVICE_CONFIG.URL__c + '/v1/salud/batch/medicamentos/2019-01-01?pageSize=15&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSBatchMedicamentosMock.getError())
			.addForAddress(WSBatchMedicamentos.SERVICE_CONFIG.URL__c + '/v1/salud/batch/medicamentos/');
	}

	@IsTest
	private static void whenTheWSIsConsume_GetListOfMedicamentos() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSBatchMedicamentos.Response responseToAssert = WSBatchMedicamentos.getBatchMedicamentos('2019-01-01', 15, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(2, responseToAssert.result.data.size());
		//System.assertEquals('140975', responseToAssert.result.data[0].afi_id);
		//System.assertEquals(null, responseToAssert.result.data[0].afi_id_tit);
		//System.assertEquals('69791', responseToAssert.result.data[0].entidad);
		//System.assertEquals('69791/17', responseToAssert.result.data[0].codigo);
		System.assertEquals('51853', responseToAssert.result.data[0].codigo);
		System.assertEquals('NUTRAPLUS D', responseToAssert.result.data[0].nombre_producto);
		System.assertEquals('CR.PROTECT.P/MANOS X50ML', responseToAssert.result.data[0].nombre_presentacion);
		System.assertEquals('MENCVL0001', responseToAssert.result.data[0].grupo);
		System.assertEquals('MEDICAMENTOS VENTA LIBRE', responseToAssert.result.data[0].nombre_grupo);
		System.assertEquals('NO CUBIERTOS', responseToAssert.result.data[0].tipo_cober);
		System.assertEquals('9951853', responseToAssert.result.data[0].troquel);
		System.assertEquals('7612076460638', responseToAssert.result.data[0].codigo_barras);
		System.assertEquals('51853', responseToAssert.result.data[0].codigo_externo_1);
		System.assertEquals(null, responseToAssert.result.data[0].codigo_externo_2);
		System.assertEquals(null, responseToAssert.result.data[0].codigo_externo_3);
		System.assertEquals('321', responseToAssert.result.data[0].medlab_codigo);
		System.assertEquals('1', responseToAssert.result.data[0].tamano);
		System.assertEquals(null, responseToAssert.result.data[0].descripcion);
		System.assertEquals('DERMATOCOSMETICOS', responseToAssert.result.data[0].medat_nombre);
		System.assertEquals('CREMAS/GELES/POMADAS/UNGUENTOS', responseToAssert.result.data[0].nombre_forma);
		System.assertEquals('GALDERMA', responseToAssert.result.data[0].nombre_lab);
		System.assertEquals('GLICERINA+ASOC.', responseToAssert.result.data[0].nombre_monodroga);
		System.assertEquals('MENOR', responseToAssert.result.data[0].nombre_tam);
		System.assertEquals('NO CLASIFICADA', responseToAssert.result.data[0].nombre_unidad);
		System.assertEquals('UNIDADES DE 50 ML', responseToAssert.result.data[0].nombre_tipouni);
		System.assertEquals('USO EXTERNO', responseToAssert.result.data[0].descrip_via);
		System.assertEquals(null, responseToAssert.result.data[0].edad_maxima);
		System.assertEquals(null, responseToAssert.result.data[0].edad_minima);
		System.assertEquals('B', responseToAssert.result.data[0].estado_informado);
		System.assertEquals('B', responseToAssert.result.data[0].estado_presentacion);
		System.assertEquals(null, responseToAssert.result.data[0].estado_vigencia);
		System.assertEquals(null, responseToAssert.result.data[0].excluye_vademecum);
		System.assertEquals('2015-11-10 00:00:00', responseToAssert.result.data[0].fecha_activacion);
		System.assertEquals('2019-01-09 00:00:00', responseToAssert.result.data[0].fecha_baja);
		System.assertEquals('2019-01-09 00:00:00', responseToAssert.result.data[0].fecha_estado);
		System.assertEquals('4', responseToAssert.result.data[0].forma);
		System.assertEquals(null, responseToAssert.result.data[0].grupo_terapeutico);
		System.assertEquals(null, responseToAssert.result.data[0].max_unidades);
		System.assertEquals(null, responseToAssert.result.data[0].med_bonificado);
		System.assertEquals('321', responseToAssert.result.data[0].medlab_codigo_1);
		System.assertEquals('M513', responseToAssert.result.data[0].monodroga);
		System.assertEquals('I', responseToAssert.result.data[0].nacional);
		System.assertEquals('CREMAS/GELES/POMADAS/UNGUENTOS', responseToAssert.result.data[0].nombre_forma_1);
		System.assertEquals('GLICERINA+ASOC.', responseToAssert.result.data[0].nombre_monodroga_1);
		System.assertEquals('MENOR', responseToAssert.result.data[0].nombre_tam_1);
		System.assertEquals('24', responseToAssert.result.data[0].tipo_uni);
		System.assertEquals(null, responseToAssert.result.data[0].observaciones);
		System.assertEquals('F', responseToAssert.result.data[0].pmi_hijo);
		System.assertEquals('F', responseToAssert.result.data[0].pmi_madre);
		System.assertEquals(null, responseToAssert.result.data[0].potencia);
		System.assertEquals(null, responseToAssert.result.data[0].precio_referencia);
		System.assertEquals('F', responseToAssert.result.data[0].psicofarmaco);
		System.assertEquals(null, responseToAssert.result.data[0].referencia_externa_2);
		System.assertEquals(null, responseToAssert.result.data[0].referencia_externa_3);
		System.assertEquals(null, responseToAssert.result.data[0].resol_310);
		System.assertEquals('A', responseToAssert.result.data[0].sexo_permitido);
		System.assertEquals('1', responseToAssert.result.data[0].tama);
		System.assertEquals('1', responseToAssert.result.data[0].unidades_divisibles);
		System.assertEquals('1', responseToAssert.result.data[0].unidades_division);
		System.assertEquals('1', responseToAssert.result.data[0].unidad);
		System.assertEquals('V', responseToAssert.result.data[0].venta_libre);
		System.assertEquals('F', responseToAssert.result.data[0].estupefaciente);
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
	}
}