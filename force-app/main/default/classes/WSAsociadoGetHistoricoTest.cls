@IsTest
public class WSAsociadoGetHistoricoTest  {
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
			.withBody(WSAsociadoGetHistoricoMock.getFound())
			.addForAddress(WSAsociadoGetHistorico.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/historico/458495');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetHistoricoMock.getError())
			.addForAddress(WSAsociadoGetHistorico.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/historico/0');
	}
	
	@IsTest
	private static void whenTheWSIsConsume_GetListOfHistoricoOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSAsociadoGetHistorico.Response responseToAssert = WSAsociadoGetHistorico.getAsociadoHistorico('458495');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(3, responseToAssert.asociadoHistorico.data.size());
		System.assertEquals('V', responseToAssert.asociadoHistorico.data[0].replicado);
		System.assertEquals('2017-07-01', responseToAssert.asociadoHistorico.data[0].fecha_vigencia);
		System.assertEquals('191670/15', responseToAssert.asociadoHistorico.data[0].codigo);
		System.assertEquals('A', responseToAssert.asociadoHistorico.data[0].estado);
		System.assertEquals('Obligatorio', responseToAssert.asociadoHistorico.data[0].afiliacion);
		System.assertEquals('Verdadero', responseToAssert.asociadoHistorico.data[0].aporta);
		System.assertEquals('Titular', responseToAssert.asociadoHistorico.data[0].tipo_afiliado);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].codigo_titular);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].apellidos_titular);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].nombres_titular);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].parentesco_descripcion);
		System.assertEquals('ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA', responseToAssert.asociadoHistorico.data[0].empresa_nombre);
		System.assertEquals('ACA SALUD C.P.S.M.A.L. - PLANES AL PERSONAL', responseToAssert.asociadoHistorico.data[0].sucursal_nombre);
		System.assertEquals('AS300', responseToAssert.asociadoHistorico.data[0].plan_codigo);
		System.assertEquals('SUPERIOR AS300', responseToAssert.asociadoHistorico.data[0].plan_nombre);
		System.assertEquals('640005', responseToAssert.asociadoHistorico.data[0].obra_social_codigo);
		System.assertEquals('OSDEPYM', responseToAssert.asociadoHistorico.data[0].obra_social_nombre);
		System.assertEquals('Soltero', responseToAssert.asociadoHistorico.data[0].estado_civil);
		System.assertEquals('Falso', responseToAssert.asociadoHistorico.data[0].discapacitado);
		System.assertEquals('2016-05-01', responseToAssert.asociadoHistorico.data[0].fecha_alta_adm);
		System.assertEquals('0', responseToAssert.asociadoHistorico.data[0].antiguedad_reconocida);
		System.assertEquals('F', responseToAssert.asociadoHistorico.data[0].adherente);
		System.assertEquals('650098', responseToAssert.asociadoHistorico.data[0].agencia_codigo);
		System.assertEquals('650098_ACA SALUD SUC. ROSARIO', responseToAssert.asociadoHistorico.data[0].agencia_nombre);
		System.assertEquals('OBLEMP', responseToAssert.asociadoHistorico.data[0].agrupacion);
		System.assertEquals('AFILIADOS OBLIGATORIOS POR EMPRESA', responseToAssert.asociadoHistorico.data[0].agrupacion_nombre);
		System.assertEquals('MEN', responseToAssert.asociadoHistorico.data[0].agrupacion1);
		System.assertEquals('AFILIADOS CON FACTURACION MENSUAL', responseToAssert.asociadoHistorico.data[0].agrupacion1_nombre);
		System.assertEquals('OTROS', responseToAssert.asociadoHistorico.data[0].agrupacion2);
		System.assertEquals('OTROS PAGOS DISTINTOS DE DEBITO AUTOMATICO', responseToAssert.asociadoHistorico.data[0].agrupacion2_nombre);
		System.assertEquals('SC', responseToAssert.asociadoHistorico.data[0].agrupacion3);
		System.assertEquals('SIN CARENCIAS', responseToAssert.asociadoHistorico.data[0].agrupacion3_nombre);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].agrupacion4);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].agrupacion4_nombre);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].tipo_baja_nombre);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].motivo_baja);
		System.assertEquals('GEN', responseToAssert.asociadoHistorico.data[0].categoria_codigo);
		System.assertEquals('GENERICO', responseToAssert.asociadoHistorico.data[0].categoria_nombre);
		System.assertEquals('Propio', responseToAssert.asociadoHistorico.data[0].cambio_a_nivel_de);
		System.assertEquals('957068', responseToAssert.asociadoHistorico.data[0].hist_afi_id);
		System.assertEquals('458495', responseToAssert.asociadoHistorico.data[0].afi_id_titular);

		System.assertEquals('2017-05-31', responseToAssert.asociadoHistorico.data[0].novedades[0].fecha);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].novedades[0].usuario);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].novedades[0].solicitud);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].novedades[0].fecha_vigencia);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].novedades[0].tipo_solicitud);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].novedades[0].tipo_baja);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].novedades[0].motivo);
		System.assertEquals('V', responseToAssert.asociadoHistorico.data[0].novedades[0].masiva);
		System.assertEquals(null, responseToAssert.asociadoHistorico.data[0].novedades[0].rotulo);
		System.assertEquals('150', responseToAssert.asociadoHistorico.data[0].novedades[0].solicitud_masiva);
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