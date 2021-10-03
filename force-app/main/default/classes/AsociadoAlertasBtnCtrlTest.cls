@IsTest
public class AsociadoAlertasBtnCtrlTest  {
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoAlertasSucess_returnAListOfAlertas(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		AsociadoAlertasBtnCtrl.Response responseToAssert = AsociadoAlertasBtnCtrl.getAsociadoAlertas('131153');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message); 

		System.assertEquals(2, responseToAssert.asociadoChecks.size());
		System.assertEquals('15/01/2019', responseToAssert.asociadoChecks[0].Fecha_Desde);
		System.assertEquals('', responseToAssert.asociadoChecks[0].Fecha_Hasta);
		System.assertEquals('ALERTA_AUDIT_PREV', responseToAssert.asociadoChecks[0].Codigo);
		System.assertEquals('ALERTA AUDITORIA PREVIA', responseToAssert.asociadoChecks[0].Nombre);
		System.assertEquals('F', responseToAssert.asociadoChecks[0].Individual);
		System.assertEquals('V', responseToAssert.asociadoChecks[0].Familia);
		System.assertEquals('F', responseToAssert.asociadoChecks[0].Empresa);
		System.assertEquals('F', responseToAssert.asociadoChecks[0].OOSS);
		System.assertEquals('2', responseToAssert.asociadoChecks[0].Referencia);

        System.assertEquals(2, responseToAssert.asociadoAlertas.size());
		System.assertEquals('13/09/2018', responseToAssert.asociadoAlertas[0].Fecha_Desde);
		System.assertEquals('', responseToAssert.asociadoAlertas[0].Fecha_Hasta);
		System.assertEquals('CUOTAS_1', responseToAssert.asociadoAlertas[0].Codigo);
		System.assertEquals('CUOTAS ADEUDADAS 1 (ACA)', responseToAssert.asociadoAlertas[0].Nombre);
		System.assertEquals('F', responseToAssert.asociadoAlertas[0].Individual);
		System.assertEquals('V', responseToAssert.asociadoAlertas[0].Familia);
		System.assertEquals('F', responseToAssert.asociadoAlertas[0].Empresa);
		System.assertEquals('F', responseToAssert.asociadoAlertas[0].OOSS);
		System.assertEquals('4879269', responseToAssert.asociadoAlertas[0].Id_Alerta);
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