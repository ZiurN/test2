@IsTest
public class AsociadoConsumosBtnCtrlTest  {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmptyListResponse;

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
			.withBody(WSAsociadoGetConsumosMock.getFoundPaginated())
			.addForAddress(WSAsociadoGetConsumos.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/consumos/191670-15?sortBy=fecha_prestacion&sortOrder=desc&pageSize=50&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetConsumosMock.getError())
			.addForAddress(WSAsociadoGetConsumos.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/consumos/0?sortBy=fecha_prestacion&sortOrder=desc&pageSize=50&page=1');
	}

	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoConsumosSucess_returnAListOfConsumos(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		AsociadoConsumosBtnCtrl.Response responseToAssert = AsociadoConsumosBtnCtrl.getAsociadoConsumos('191670-15', 1);
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('2018-11-06 00:00:00', responseToAssert.asociadoConsumos[0].fecha_prestacion);
		System.assertEquals('458495', responseToAssert.asociadoConsumos[0].afi_afi_id);
		System.assertEquals('Consumo', responseToAssert.asociadoConsumos[0].tipo);
		System.assertEquals('Medicamento', responseToAssert.asociadoConsumos[0].tipo_prestacion);
		System.assertEquals('999', responseToAssert.asociadoConsumos[0].diagnostico);
		System.assertEquals('DIAGNOSTICO INDETERMINADO', responseToAssert.asociadoConsumos[0].nombre_diagnostico);
		System.assertEquals('1', responseToAssert.asociadoConsumos[0].cantidad);
		System.assertEquals('25367', responseToAssert.asociadoConsumos[0].prestacion);
		System.assertEquals('SINALGICO SL, 10 MG COMP.SUBL.X 10', responseToAssert.asociadoConsumos[0].desc_prestacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].reintegro);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].nro_autorizacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].hd);
		System.assertEquals('1013431967', responseToAssert.asociadoConsumos[0].autorizacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].pieza);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].caras);
		System.assertEquals('C1EA--AA', responseToAssert.asociadoConsumos[0].vda_drv_estado_auditoria);
		System.assertEquals('AUTORIZADO POR EL AUDITOR', responseToAssert.asociadoConsumos[0].nombre_estado);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].efector);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].efector_realizador);
		System.assertEquals('753976', responseToAssert.asociadoConsumos[0].prescriptor);
		System.assertEquals('MEDICO A DESIGNAR', responseToAssert.asociadoConsumos[0].efector_prescriptor);
		System.assertEquals('0', responseToAssert.asociadoConsumos[0].presentado);
		System.assertEquals('42.57', responseToAssert.asociadoConsumos[0].importe);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].presentacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].nro_factura);
		System.assertEquals('COMPAÑIA DE SERVICIOS FARMACEUTICOS', responseToAssert.asociadoConsumos[0].lugar_realizacion);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].nro_caja_archivo);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].lote);
		System.assertEquals(null, responseToAssert.asociadoConsumos[0].renglones);
		System.assertEquals('73899467', responseToAssert.asociadoConsumos[0].pca_id);
		System.assertEquals('Post', responseToAssert.asociadoConsumos[0].origen);

		System.assertEquals(1, responseToAssert.paginado.current);
		System.assertEquals(3, responseToAssert.paginado.last);
		System.assertEquals(null, responseToAssert.paginado.prev);
		System.assertEquals('https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/autorizaciones/consumos/191670-15?page=2',
			responseToAssert.paginado.next);
		System.assertEquals(110, responseToAssert.paginado.total);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoConsumosError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		AsociadoConsumosBtnCtrl.Response responseToAssert = AsociadoConsumosBtnCtrl.getAsociadoConsumos('0', 1);
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los consumos desde SaludSoft, asegúrese que el código de afiliado esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoConsumos);
	}

}