@IsTest
public class WSAsociadoGetAlertasTest  {
	@IsTest
	private static void whenTheWSIsConsume_GetListOfAlertasOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		WSAsociadoGetAlertas.Response responseToAssert = WSAsociadoGetAlertas.getAsociadoAlertas('131153');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());

		System.assertEquals(2, responseToAssert.asociadoAlertas.data.checks.size());
		System.assertEquals('15/01/2019', responseToAssert.asociadoAlertas.data.checks[0].Fecha_Desde);
		System.assertEquals('', responseToAssert.asociadoAlertas.data.checks[0].Fecha_Hasta);
		System.assertEquals('ALERTA_AUDIT_PREV', responseToAssert.asociadoAlertas.data.checks[0].Codigo);
		System.assertEquals('ALERTA AUDITORIA PREVIA', responseToAssert.asociadoAlertas.data.checks[0].Nombre);
		System.assertEquals('F', responseToAssert.asociadoAlertas.data.checks[0].Individual);
		System.assertEquals('V', responseToAssert.asociadoAlertas.data.checks[0].Familia);
		System.assertEquals('F', responseToAssert.asociadoAlertas.data.checks[0].Empresa);
		System.assertEquals('F', responseToAssert.asociadoAlertas.data.checks[0].OOSS);
		System.assertEquals('2', responseToAssert.asociadoAlertas.data.checks[0].Referencia);

        System.assertEquals(2, responseToAssert.asociadoAlertas.data.alertas.size());
		System.assertEquals('13/09/2018', responseToAssert.asociadoAlertas.data.alertas[0].Fecha_Desde);
		System.assertEquals('', responseToAssert.asociadoAlertas.data.alertas[0].Fecha_Hasta);
		System.assertEquals('CUOTAS_1', responseToAssert.asociadoAlertas.data.alertas[0].Codigo);
		System.assertEquals('CUOTAS ADEUDADAS 1 (ACA)', responseToAssert.asociadoAlertas.data.alertas[0].Nombre);
		System.assertEquals('F', responseToAssert.asociadoAlertas.data.alertas[0].Individual);
		System.assertEquals('V', responseToAssert.asociadoAlertas.data.alertas[0].Familia);
		System.assertEquals('F', responseToAssert.asociadoAlertas.data.alertas[0].Empresa);
		System.assertEquals('F', responseToAssert.asociadoAlertas.data.alertas[0].OOSS);
		System.assertEquals('4879269', responseToAssert.asociadoAlertas.data.alertas[0].Id_Alerta);
	}

	static XHttpCalloutMock getResponseFound;

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
			.withBody(WSAsociadoGetAlertasMock.getFound())
			.addForAddress(WSAsociadoGetAlertas.SERVICE_CONFIG.URL__c + '/v1/salud/alertas/131153');
	}
}