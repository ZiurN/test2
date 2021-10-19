@IsTest
public class WSAsociadoGetConsumoDeTopeTest  {
	@IsTest
	private static void whenTheWSIsConsume_GetListOfConsumoDeTopesOfAsociado(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		WSAsociadoGetConsumoDeTope.Response responseToAssert =  WSAsociadoGetConsumoDeTope.getConsumoDeTope('140983', Date.valueOf('2019-12-15'), 'M', '1782');
		Test.stopTest();
		
		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(4, responseToAssert.asociadoConsumoDeTope.data.size());
		System.assertEquals('73053719', responseToAssert.asociadoConsumoDeTope.data[0].pca_id);
		System.assertEquals('N', responseToAssert.asociadoConsumoDeTope.data[0].tipo);
		System.assertEquals('02330101', responseToAssert.asociadoConsumoDeTope.data[0].prestacion_grupo);
		System.assertEquals('PSICOTERAPIAS INDIVIDUALES, NINOS O ADULTOS, POR SESION     MINIMA DE 40 MINUTOS', responseToAssert.asociadoConsumoDeTope.data[0].nombre_prestacion);
		System.assertEquals('1', responseToAssert.asociadoConsumoDeTope.data[0].cantidad);
		System.assertEquals('406', responseToAssert.asociadoConsumoDeTope.data[0].honorarios);
		System.assertEquals('0', responseToAssert.asociadoConsumoDeTope.data[0].gastos);
		System.assertEquals('0', responseToAssert.asociadoConsumoDeTope.data[0].copago);
		System.assertEquals('2019-01-07 00:00:00', responseToAssert.asociadoConsumoDeTope.data[0].fecha_prestacion);
		System.assertEquals('ON LINE', responseToAssert.asociadoConsumoDeTope.data[0].origen);
		System.assertEquals('F', responseToAssert.asociadoConsumoDeTope.data[0].es_modulo);
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
			.withBody(WSAsociadoGetConsumoDeTopeMock.getFound())
			.addForAddress(WSAsociadoGetConsumoDeTope.SERVICE_CONFIG.URL__c + '/v1/salud/topes/consumo/140983/2019-12-15/M/1782');
	}
}