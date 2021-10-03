@IsTest
public class WSAsociadoGetConsumosTest  {
	//static XHttpCalloutMock getResponseFound;
	//static XHttpCalloutMock getErrorResponse;

	static XHttpCalloutMock getResponseFoundPaginated;
	static XHttpCalloutMock getErrorResponsePaginated;

	static {
		//getResponseFound = new XHttpCalloutMock();
		//getResponseFound.buildResponse()
			//.withStatus('OK')
			//.withStatusCode(200)
			//.withBody(WSAuthTokenMock.getTokenSuccess())
			//.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		//getResponseFound.buildResponse()
			//.withStatus('OK')
			//.withStatusCode(200)
			//.withBody(WSAsociadoGetConsumosMock.getFound())
			//.addForAddress(WSAsociadoGetConsumos.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/consumos/191670-15');

		//getErrorResponse = new XHttpCalloutMock();
		//getErrorResponse.buildResponse()
			//.withStatus('Not Found')
			//.withStatusCode(404)
			//.withBody(WSAsociadoGetConsumosMock.getError())
			//.addForAddress(WSAsociadoGetConsumos.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/consumos/0');

		getResponseFoundPaginated = new XHttpCalloutMock();
		getResponseFoundPaginated.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundPaginated.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetConsumosMock.getFoundPaginated())
			.addForAddress(WSAsociadoGetConsumos.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/consumos/191670-15?sortBy=fecha_prestacion&sortOrder=desc&pageSize=50&page=1');

		getErrorResponsePaginated = new XHttpCalloutMock();
		getErrorResponsePaginated.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetConsumosMock.getError())
			.addForAddress(WSAsociadoGetConsumos.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/consumos/0?sortBy=fecha_prestacion&sortOrder=desc&pageSize=50&page=1');
	}
	
	//@IsTest
	//private static void whenTheWSIsConsume_GetListOfConsumosOfAsociado(){
		//Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		//Test.startTest();
		//WSAsociadoGetConsumos.Response responseToAssert = WSAsociadoGetConsumos.getAsociadoConsumos('191670-15');
		//Test.stopTest();

		//System.assertEquals(false, responseToAssert.hasError);
		//System.assertEquals(200, responseToAssert.response.getStatusCode());
		//System.assertEquals('OK', responseToAssert.response.getStatus());
		////System.assertEquals(1, responseToAssert.asociadoConsumos.data.size());
		//System.assertEquals('2018-11-06 00:00:00', responseToAssert.asociadoConsumos.data[0].fecha_prestacion);
		//System.assertEquals('458495', responseToAssert.asociadoConsumos.data[0].afi_afi_id);
		//System.assertEquals('Consumo', responseToAssert.asociadoConsumos.data[0].tipo);
		//System.assertEquals('Medicamento', responseToAssert.asociadoConsumos.data[0].tipo_prestacion);
		//System.assertEquals('999', responseToAssert.asociadoConsumos.data[0].diagnostico);
		//System.assertEquals('DIAGNOSTICO INDETERMINADO', responseToAssert.asociadoConsumos.data[0].nombre_diagnostico);
		//System.assertEquals('1', responseToAssert.asociadoConsumos.data[0].cantidad);
		//System.assertEquals('25367', responseToAssert.asociadoConsumos.data[0].prestacion);
		//System.assertEquals('SINALGICO SL, 10 MG COMP.SUBL.X 10', responseToAssert.asociadoConsumos.data[0].desc_prestacion);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].reintegro);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].nro_autorizacion);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].hd);
		//System.assertEquals('1013431967', responseToAssert.asociadoConsumos.data[0].autorizacion);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].pieza);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].caras);
		//System.assertEquals('C1EA--AA', responseToAssert.asociadoConsumos.data[0].vda_drv_estado_auditoria);
		//System.assertEquals('AUTORIZADO POR EL AUDITOR', responseToAssert.asociadoConsumos.data[0].nombre_estado);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].efector);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].efector_realizador);
		//System.assertEquals('753976', responseToAssert.asociadoConsumos.data[0].prescriptor);
		//System.assertEquals('MEDICO A DESIGNAR', responseToAssert.asociadoConsumos.data[0].efector_prescriptor);
		//System.assertEquals('0', responseToAssert.asociadoConsumos.data[0].presentado);
		//System.assertEquals('42.57', responseToAssert.asociadoConsumos.data[0].importe);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].presentacion);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].nro_factura);
		//System.assertEquals('COMPAÑIA DE SERVICIOS FARMACEUTICOS', responseToAssert.asociadoConsumos.data[0].lugar_realizacion);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].nro_caja_archivo);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].lote);
		//System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].renglones);
		//System.assertEquals('73899467', responseToAssert.asociadoConsumos.data[0].pca_id);
		//System.assertEquals('Post', responseToAssert.asociadoConsumos.data[0].origen);

	//}

	//@IsTest
	//private static void whenTheWSIsConsume_GetTokenErrorResponse(){
		//Test.setMock(HttpCalloutMock.class, getErrorResponse);
		//Test.startTest();
		//WSAuthToken.Response responseToAssert = WSAuthToken.getToken();
		//Test.stopTest();

		//System.assertEquals(true, responseToAssert.hasError);
		//System.assertEquals(404, responseToAssert.response.getStatusCode());
		//System.assertEquals('404 not found', responseToAssert.response.getStatus());
		//System.assertEquals(null, responseToAssert.token);
	//}

	@IsTest
	private static void whenTheWSIsConsume_GetListOfConsumosOfAsociadoPaginated(){
		Test.setMock(HttpCalloutMock.class, getResponseFoundPaginated);
		
		Test.startTest();
		WSAsociadoGetConsumos.Response responseToAssert = WSAsociadoGetConsumos.getAsociadoConsumosOrderByDateDesc('191670-15', 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(50, responseToAssert.asociadoConsumos.data.size());
		System.assertEquals('2018-11-06 00:00:00', responseToAssert.asociadoConsumos.data[0].fecha_prestacion);
		System.assertEquals('458495', responseToAssert.asociadoConsumos.data[0].afi_afi_id);
		System.assertEquals('Consumo', responseToAssert.asociadoConsumos.data[0].tipo);
		System.assertEquals('Medicamento', responseToAssert.asociadoConsumos.data[0].tipo_prestacion);
		System.assertEquals('999', responseToAssert.asociadoConsumos.data[0].diagnostico);
		System.assertEquals('DIAGNOSTICO INDETERMINADO', responseToAssert.asociadoConsumos.data[0].nombre_diagnostico);
		System.assertEquals('1', responseToAssert.asociadoConsumos.data[0].cantidad);
		System.assertEquals('25367', responseToAssert.asociadoConsumos.data[0].prestacion);
		System.assertEquals('SINALGICO SL, 10 MG COMP.SUBL.X 10', responseToAssert.asociadoConsumos.data[0].desc_prestacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].reintegro);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].nro_autorizacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].hd);
		System.assertEquals('1013431967', responseToAssert.asociadoConsumos.data[0].autorizacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].pieza);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].caras);
		System.assertEquals('C1EA--AA', responseToAssert.asociadoConsumos.data[0].vda_drv_estado_auditoria);
		System.assertEquals('AUTORIZADO POR EL AUDITOR', responseToAssert.asociadoConsumos.data[0].nombre_estado);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].efector);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].efector_realizador);
		System.assertEquals('753976', responseToAssert.asociadoConsumos.data[0].prescriptor);
		System.assertEquals('MEDICO A DESIGNAR', responseToAssert.asociadoConsumos.data[0].efector_prescriptor);
		System.assertEquals('0', responseToAssert.asociadoConsumos.data[0].presentado);
		System.assertEquals('42.57', responseToAssert.asociadoConsumos.data[0].importe);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].presentacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].nro_factura);
		System.assertEquals('COMPAÑIA DE SERVICIOS FARMACEUTICOS', responseToAssert.asociadoConsumos.data[0].lugar_realizacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].nro_caja_archivo);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].lote);
		System.assertEquals(null, responseToAssert.asociadoConsumos.data[0].renglones);
		System.assertEquals('73899467', responseToAssert.asociadoConsumos.data[0].pca_id);
		System.assertEquals('Post', responseToAssert.asociadoConsumos.data[0].origen);

	}

	@IsTest
	private static void whenTheWSIsConsume_GetTokenErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getErrorResponsePaginated);
		Test.startTest();
		WSAuthToken.Response responseToAssert = WSAuthToken.getToken();
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('404 not found', responseToAssert.response.getStatus());
		System.assertEquals(null, responseToAssert.token);
	}

	
}