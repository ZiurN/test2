@IsTest
public class WSBatchAsociadoTest  {
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
			.withBody(WSBatchAsociadoMock.getFound())
			.addForAddress(WSBatchAsociado.SERVICE_CONFIG.URL__c + '/v1/salud/batch/afiliados/17-12-2019?pageSize=15&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSBatchAsociadoMock.getError())
			.addForAddress(WSBatchAsociado.SERVICE_CONFIG.URL__c + '/v1/salud/batch/afiliados/');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfAsociados(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSBatchAsociado.Response responseToAssert = WSBatchAsociado.getBatchAsociado('17-12-2019', 15, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(15, responseToAssert.asociado.data.size());
		System.assertEquals('140975', responseToAssert.asociado.data[0].afi_id);
		System.assertEquals(null, responseToAssert.asociado.data[0].afi_id_tit);
		System.assertEquals('69791', responseToAssert.asociado.data[0].entidad);
		System.assertEquals('69791/17', responseToAssert.asociado.data[0].codigo);
		System.assertEquals('ESPINOSA GABRIEL ERNESTO', responseToAssert.asociado.data[0].apellidos);
		System.assertEquals('.', responseToAssert.asociado.data[0].nombres);
		System.assertEquals('F', responseToAssert.asociado.data[0].pam);
		System.assertEquals('TIT', responseToAssert.asociado.data[0].tipo_afiliado);
		System.assertEquals(null, responseToAssert.asociado.data[0].parentesco);
		System.assertEquals('F', responseToAssert.asociado.data[0].tiene_alertas);
		System.assertEquals('A', responseToAssert.asociado.data[0].estado);
		System.assertEquals('AS300', responseToAssert.asociado.data[0].plan_codigo);
		System.assertEquals('SUPERIOR AS300', responseToAssert.asociado.data[0].plan_nombre);
		System.assertEquals('AS300', responseToAssert.asociado.data[0].modelo_plan_codigo);
		System.assertEquals('SUPERIOR AS300', responseToAssert.asociado.data[0].modelo_plan_nombre);
		System.assertEquals('650098', responseToAssert.asociado.data[0].agencia_codigo);
		System.assertEquals('650098_ACA SALUD SUC. ROSARIO', responseToAssert.asociado.data[0].agencia_nombre);
		System.assertEquals('GEN', responseToAssert.asociado.data[0].categoria_codigo);
		System.assertEquals('GENERICO', responseToAssert.asociado.data[0].categoria_nombre);
		System.assertEquals('OBLEMP', responseToAssert.asociado.data[0].agrupacion_codigo);
		System.assertEquals('AFILIADOS OBLIGATORIOS POR EMPRESA', responseToAssert.asociado.data[0].agrupacion_nombre);
		System.assertEquals('MEN', responseToAssert.asociado.data[0].agrupacion1_codigo);
		System.assertEquals('AFILIADOS CON FACTURACION MENSUAL', responseToAssert.asociado.data[0].agrupacion1_nombre);
		System.assertEquals('OTROS', responseToAssert.asociado.data[0].agrupacion2_codigo);
		System.assertEquals('OTROS PAGOS DISTINTOS DE DEBITO AUTOMATICO', responseToAssert.asociado.data[0].agrupacion2_nombre);
		System.assertEquals('SC', responseToAssert.asociado.data[0].agrupacion3_codigo);
		System.assertEquals('SIN CARENCIAS', responseToAssert.asociado.data[0].agrupacion3_nombre);
		System.assertEquals(null, responseToAssert.asociado.data[0].agrupacion4_codigo);
		System.assertEquals(null, responseToAssert.asociado.data[0].agrupacion4_nombre);
		System.assertEquals('600011', responseToAssert.asociado.data[0].empresa_codigo);
		System.assertEquals('1', responseToAssert.asociado.data[0].empresa_sucursal);
		System.assertEquals('ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA', responseToAssert.asociado.data[0].empresa_nombre);
		System.assertEquals('ACA SALUD C.P.S.M.A.L. - PLANES AL PERSONAL', responseToAssert.asociado.data[0].empresa_sucursal_nombre);
		System.assertEquals('Aporte Obligatorio', responseToAssert.asociado.data[0].afiliacion);
		System.assertEquals('Falso', responseToAssert.asociado.data[0].aporta);
		System.assertEquals('640008', responseToAssert.asociado.data[0].obra_social_codigo);
		System.assertEquals('O.S.P.ACA', responseToAssert.asociado.data[0].obra_social_nombre);
		System.assertEquals(null, responseToAssert.asociado.data[0].obra_social_ant_codigo);
		System.assertEquals(null, responseToAssert.asociado.data[0].obra_social_ant_nombre);
		System.assertEquals('DNI', responseToAssert.asociado.data[0].tipo_documento);
		System.assertEquals('20173680', responseToAssert.asociado.data[0].numero_documento);
		System.assertEquals('M', responseToAssert.asociado.data[0].sexo);
		System.assertEquals('1968-03-12', responseToAssert.asociado.data[0].fecha_nacimiento);
		System.assertEquals('51', responseToAssert.asociado.data[0].edad);
		System.assertEquals('C', responseToAssert.asociado.data[0].estado_civil);
		System.assertEquals('054', responseToAssert.asociado.data[0].codigo_1);
		System.assertEquals('ARGENTINO', responseToAssert.asociado.data[0].gentilicio);
		System.assertEquals('EMPL', responseToAssert.asociado.data[0].actividad_codigo);
		System.assertEquals('EMPLEADO', responseToAssert.asociado.data[0].actividad_nombre);
		System.assertEquals(null, responseToAssert.asociado.data[0].titular_codigo);
		System.assertEquals(null, responseToAssert.asociado.data[0].titular_apellidos);
		System.assertEquals(null, responseToAssert.asociado.data[0].titular_nombres);
		System.assertEquals('0', responseToAssert.asociado.data[0].antiguedad_reconocida);
		System.assertEquals('2002-09-01', responseToAssert.asociado.data[0].ultima_alta);
		System.assertEquals('2002-09-01', responseToAssert.asociado.data[0].fecha_alta_administrativa);
		System.assertEquals('2002-10-02', responseToAssert.asociado.data[0].fecha_alta);
		System.assertEquals('2017-07-01', responseToAssert.asociado.data[0].fecha_vigencia);
		System.assertEquals('20201736804', responseToAssert.asociado.data[0].cuit);
		System.assertEquals('Verdadero', responseToAssert.asociado.data[0].sujeto_facturacion);
		System.assertEquals('Falso', responseToAssert.asociado.data[0].adherente);
		System.assertEquals(null, responseToAssert.asociado.data[0].tipo_baja_codigo);
		System.assertEquals(null, responseToAssert.asociado.data[0].tipo_baja_nombre);
		System.assertEquals(null, responseToAssert.asociado.data[0].motivo_de_baja);
		System.assertEquals(null, responseToAssert.asociado.data[0].excedente);
		System.assertEquals('2019-12-17 00:00:00', responseToAssert.asociado.data[0].f_modif);
		System.assertEquals('69791', responseToAssert.asociado.data[0].entidad_codigo);
		System.assertEquals('ESPINOSA GABRIEL ERNESTO', responseToAssert.asociado.data[0].full_name);
		
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