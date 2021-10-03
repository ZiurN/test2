@IsTest
public class WSBatchEmpresaTest  {
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
			.withBody(WSBatchEmpresaMock.getFound())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/empresas/09-12-2019?pageSize=100&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSBatchEmpresaMock.getError())
			.addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/empresas/');
	}

	@IsTest
	private static void whenTheWSIsConsume_GetListOfEmpresas(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSBatchEmpresa.Response responseToAssert = WSBatchEmpresa.getBatchEmpresa('09-12-2019', 100, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(1, responseToAssert.empresa.data.size());
		System.assertEquals('4822', responseToAssert.empresa.data[0].numero_solicitud);
		System.assertEquals('2002-10-01 00:00:00', responseToAssert.empresa.data[0].fecha_presentacion);
		System.assertEquals('650098_ACA SALUD SUC. ROSARIO', responseToAssert.empresa.data[0].agencia);
		System.assertEquals('TRANSFORMADA', responseToAssert.empresa.data[0].estado_solicitud);
		System.assertEquals('ALTA', responseToAssert.empresa.data[0].codigo_motivo);
		System.assertEquals('ALTA', responseToAssert.empresa.data[0].descripcion_motivo);
		System.assertEquals('600011', responseToAssert.empresa.data[0].codigo_empresa);
		System.assertEquals('ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA', responseToAssert.empresa.data[0].razon_social);
		System.assertEquals(null, responseToAssert.empresa.data[0].minimo_grupos);
		System.assertEquals(null, responseToAssert.empresa.data[0].maximo_grupos);
		System.assertEquals(null, responseToAssert.empresa.data[0].limite_edad);
		System.assertEquals(null, responseToAssert.empresa.data[0].porcentaje_limite_edad);
		System.assertEquals('F', responseToAssert.empresa.data[0].canje);
		System.assertEquals(null, responseToAssert.empresa.data[0].porcentaje_canje);
		System.assertEquals(null, responseToAssert.empresa.data[0].importe_canje);
		System.assertEquals('F', responseToAssert.empresa.data[0].afiliados_sujetos_facturacion);
		System.assertEquals('Empresa', responseToAssert.empresa.data[0].identificacion_afiliados);
		System.assertEquals('Nunca', responseToAssert.empresa.data[0].solicitudes_afiliado_auditoria);
		System.assertEquals(null, responseToAssert.empresa.data[0].grupos);
		System.assertEquals('ALTA', responseToAssert.empresa.data[0].tipo_sol_alta_masiva);
		System.assertEquals('SOLICITUD DE ALTA', responseToAssert.empresa.data[0].tipo_sol_alta_masiva_desc);
		System.assertEquals('ALTA', responseToAssert.empresa.data[0].mot_sol_alta_masiva);
		System.assertEquals('ALTA', responseToAssert.empresa.data[0].mot_sol_alta_masiva_desc);
		System.assertEquals('BAJA', responseToAssert.empresa.data[0].tipo_sol_baja_masiva);
		System.assertEquals('SOLICITUD DE BAJA DE GRUPO FAMILIAR', responseToAssert.empresa.data[0].tipo_sol_baja_masiva_desc);
		System.assertEquals('BAJA', responseToAssert.empresa.data[0].mot_sol_baja_masiva);
		System.assertEquals('BAJA', responseToAssert.empresa.data[0].mot_sol_baja_masiva_desc);
		System.assertEquals('NOSUBS', responseToAssert.empresa.data[0].codigo_tipo_baja);
		System.assertEquals('BAJA NO SUBVENCIONADA', responseToAssert.empresa.data[0].descripcion_tipo_baja);
		System.assertEquals('OBLEMP', responseToAssert.empresa.data[0].codigo_agrupacion);
		System.assertEquals('AFILIADOS OBLIGATORIOS POR EMPRESA', responseToAssert.empresa.data[0].descripcion_agrupacion);
		System.assertEquals('OBLDIR,OBLEMP,VOLDIR,VOLEMP', responseToAssert.empresa.data[0].agrupaciones_permitidas);
		System.assertEquals('CODIGO1', responseToAssert.empresa.data[0].codigo_agrupacion1);
		System.assertEquals('DESCRIPCION1', responseToAssert.empresa.data[0].descripcion_agrupacion1);
		System.assertEquals(null, responseToAssert.empresa.data[0].agrupaciones_permitidas1);
		System.assertEquals('CODIGO2', responseToAssert.empresa.data[0].codigo_agrupacion2);
		System.assertEquals('DESCRIPCION2', responseToAssert.empresa.data[0].descripcion_agrupacion2);
		System.assertEquals(null, responseToAssert.empresa.data[0].agrupaciones_permitidas2);
		System.assertEquals('CODIGO3', responseToAssert.empresa.data[0].codigo_agrupacion3);
		System.assertEquals('DESCRIPCION3', responseToAssert.empresa.data[0].descripcion_agrupacion3);
		System.assertEquals(null, responseToAssert.empresa.data[0].agrupaciones_permitidas3);
		System.assertEquals('CODIGO4', responseToAssert.empresa.data[0].codigo_agrupacion4);
		System.assertEquals('DESCRIPCION4', responseToAssert.empresa.data[0].descripcion_agrupacion4);
		System.assertEquals(null, responseToAssert.empresa.data[0].agrupaciones_permitidas4);
		System.assertEquals('EMPRESA', responseToAssert.empresa.data[0].tipo_empresa);
		System.assertEquals('V', responseToAssert.empresa.data[0].es_sujeto_facturacion);
		System.assertEquals('ACA SALUD CASA ROSARIO', responseToAssert.empresa.data[0].descripcion_empresa);
		System.assertEquals('30604958640', responseToAssert.empresa.data[0].cuit);
		System.assertEquals('A', responseToAssert.empresa.data[0].estado_empresa);
		System.assertEquals(null, responseToAssert.empresa.data[0].email);
		System.assertEquals('PA2CCTE', responseToAssert.empresa.data[0].codigo_agrupacion_empresa);
		System.assertEquals('PA2CCTE', responseToAssert.empresa.data[0].descripcion_agrupacion_empresa);
		System.assertEquals('52', responseToAssert.empresa.data[0].codigo_grupo_empresarial);
		System.assertEquals('ACA SALUD', responseToAssert.empresa.data[0].descripcion_grupo_empresarial);
		System.assertEquals(null, responseToAssert.empresa.data[0].observaciones);
		System.assertEquals('2002-10-01 00:00:00', responseToAssert.empresa.data[0].fecha_registracion);
		System.assertEquals('2019-12-09 00:00:00', responseToAssert.empresa.data[0].f_modif);

		
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