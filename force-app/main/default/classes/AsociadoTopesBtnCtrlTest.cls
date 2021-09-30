@IsTest
public class AsociadoTopesBtnCtrlTest  {
	@IsTest
	private static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoTopesGetFound_returnListOfTopesOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		AsociadoTopesBtnCtrl.TopesResponse responseToAssert = AsociadoTopesBtnCtrl.getAsociadoTopes('140983',Date.valueOf('2019-12-15'));
		Test.stopTest();
		
		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(8, responseToAssert.asociadoTopes.size());
		System.assertEquals('ALERGIA TESTIFICACION', responseToAssert.asociadoTopes[0].rubro_tope);
		System.assertEquals('TOPE DE 1 POR AÑO', responseToAssert.asociadoTopes[0].tope);
		System.assertEquals('CUOTA BASICA', responseToAssert.asociadoTopes[0].clausula);
		System.assertEquals('1', responseToAssert.asociadoTopes[0].valor_tope);
		System.assertEquals('0', responseToAssert.asociadoTopes[0].consumo);
		System.assertEquals('1', responseToAssert.asociadoTopes[0].remanente);
		System.assertEquals(null, responseToAssert.asociadoTopes[0].valor_red);
		System.assertEquals(null, responseToAssert.asociadoTopes[0].remanente_red);
		System.assertEquals(null, responseToAssert.asociadoTopes[0].nombre_red);
		System.assertEquals('1500', responseToAssert.asociadoTopes[0].tocmpc_id);
		System.assertEquals('M', responseToAssert.asociadoTopes[0].tope_id);
	}
	
	@IsTest
	private static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoConsumoDeTopeGetFound_returnListOfConsumosDeTopeOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getConsumoDeTopeResponseFound);
		Test.startTest();
		AsociadoTopesBtnCtrl.ConsumosDeTopeResponse responseToAssert =  AsociadoTopesBtnCtrl.getAsociadoConsumoDeTope('140983', Date.valueOf('2019-12-15'), 'M', '1782');
		Test.stopTest();
		
		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(4, responseToAssert.asociadoConsumosDeTope.size());
		System.assertEquals('73053719', responseToAssert.asociadoConsumosDeTope[0].pca_id);
		System.assertEquals('N', responseToAssert.asociadoConsumosDeTope[0].tipo);
		System.assertEquals('02330101', responseToAssert.asociadoConsumosDeTope[0].prestacion_grupo);
		System.assertEquals('PSICOTERAPIAS INDIVIDUALES, NINOS O ADULTOS, POR SESION     MINIMA DE 40 MINUTOS', responseToAssert.asociadoConsumosDeTope[0].nombre_prestacion);
		System.assertEquals('1', responseToAssert.asociadoConsumosDeTope[0].cantidad);
		System.assertEquals('406', responseToAssert.asociadoConsumosDeTope[0].honorarios);
		System.assertEquals('0', responseToAssert.asociadoConsumosDeTope[0].gastos);
		System.assertEquals('0', responseToAssert.asociadoConsumosDeTope[0].copago);
		System.assertEquals('2019-01-07 00:00:00', responseToAssert.asociadoConsumosDeTope[0].fecha_prestacion);
		System.assertEquals('ON LINE', responseToAssert.asociadoConsumosDeTope[0].origen);
		System.assertEquals('F', responseToAssert.asociadoConsumosDeTope[0].es_modulo);
	}

	@IsTest
	private static void whenTheWSIsConsume_GetErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		Test.startTest();
		AsociadoTopesBtnCtrl.TopesResponse responseToAssert = AsociadoTopesBtnCtrl.getAsociadoTopes('140983',Date.valueOf('2019-12-15'));
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('Hubo un error al intentar obtener los topes del afiliado desde SaludSoft', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoTopes);
	}
	
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getConsumoDeTopeResponseFound;
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
			.withBody(WSAsociadoGetTopesMock.getFound())
			.addForAddress(WSAsociadoGetTopes.SERVICE_CONFIG.URL__c + '/v1/salud/topes/140983/2019-12-15');
		
		getConsumoDeTopeResponseFound = new XHttpCalloutMock();
		getConsumoDeTopeResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getConsumoDeTopeResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetConsumoDeTopeMock.getFound())
			.addForAddress(WSAsociadoGetConsumoDeTope.SERVICE_CONFIG.URL__c + '/v1/salud/topes/consumo/140983/2019-12-15/M/1782');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetTopesMock.getError())
			.addForAddress(WSAsociadoGetTopes.SERVICE_CONFIG.URL__c + '/v1/salud/topes/140983/2019-12-15');
	}
}