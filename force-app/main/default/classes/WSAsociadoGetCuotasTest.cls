@IsTest
public class WSAsociadoGetCuotasTest {
	@IsTest
	private static void whenTheWSIsConsume_GetListOfCuotasOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		WSAsociadoGetCuotas.Response responseToAssert = WSAsociadoGetCuotas.getAsociadoCuotas('131153');
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		
        System.assertEquals(7, responseToAssert.asociadoCuotas.data.size());
		System.assertEquals('2019-05-01', responseToAssert.asociadoCuotas.data[0].periodo);
		System.assertEquals('2019-04-23', responseToAssert.asociadoCuotas.data[0].fecha_generacion);
		System.assertEquals('7051.94', responseToAssert.asociadoCuotas.data[0].monto);
		System.assertEquals('E630001-M AS200-S1', responseToAssert.asociadoCuotas.data[0].cuadro_costos);
		System.assertEquals(null, responseToAssert.asociadoCuotas.data[0].recargo_bonificacion);
		System.assertEquals('0', responseToAssert.asociadoCuotas.data[0].monto_regla_adicional);
		System.assertEquals('0', responseToAssert.asociadoCuotas.data[0].monto_general);
		System.assertEquals('0', responseToAssert.asociadoCuotas.data[0].monto_bonificacion_recargo);

		System.assertEquals(1, responseToAssert.asociadoCuotas.data[0].detalle.size());
		System.assertEquals('CUOTA BASICA', responseToAssert.asociadoCuotas.data[0].detalle[0].clausula);
        System.assertEquals('INDIVIDUO', responseToAssert.asociadoCuotas.data[0].detalle[0].categoria_grupal);
        System.assertEquals(null, responseToAssert.asociadoCuotas.data[0].detalle[0].regla_adicional);
        System.assertEquals('0', responseToAssert.asociadoCuotas.data[0].detalle[0].cantidad);
        System.assertEquals('7051.94', responseToAssert.asociadoCuotas.data[0].detalle[0].importe_final);
        System.assertEquals('0', responseToAssert.asociadoCuotas.data[0].detalle[0].importe_regla_adicional);
        System.assertEquals('0', responseToAssert.asociadoCuotas.data[0].detalle[0].importe_cuadro_costo);
        System.assertEquals('0', responseToAssert.asociadoCuotas.data[0].detalle[0].importe_bonif_recargo);
        System.assertEquals('1', responseToAssert.asociadoCuotas.data[0].detalle[0].coeficiente);
        System.assertEquals('1', responseToAssert.asociadoCuotas.data[0].detalle[0].coeficiente_general);
        System.assertEquals('1', responseToAssert.asociadoCuotas.data[0].detalle[0].coeficiente_b_r);
	}
	
	@IsTest
	private static void whenTheWSIsConsume_consumeWSAfiliadoCuotaError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		WSAsociadoGetCuotas.Response responseToAssert = WSAsociadoGetCuotas.getAsociadoCuotas('131153');
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('Not Found', responseToAssert.response.getStatus());
		System.assertEquals(null, responseToAssert.asociadoCuotas);
	}

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
			.withBody(WSAsociadoGetCuotasMock.getFound())
			.addForAddress(WSAsociadoGetCuotas.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/cuotas/131153');
		
		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetCuotasMock.getError())
			.addForAddress(WSAsociadoGetCuotas.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/cuotas/131153');
	}
}