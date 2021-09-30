@isTest
public class WSLocalidadTest {
    static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmpty;

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
			.withBody(WSLocalidadMock.getFound())
			.addForAddress(WSLocalidad.SERVICE_CONFIG.URL__c + '/v1/salud/localidades-zonas?filter[fecha_modificacion]=2020-04-06&pageSize=50&page=1');

		getEmpty = new XHttpCalloutMock();
		getEmpty.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getEmpty.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLocalidadMock.getEmpty())
			.addForAddress(WSLocalidad.SERVICE_CONFIG.URL__c + '/v1/salud/localidades-zonas?filter[fecha_modificacion]=2020-04-05&pageSize=50&page=1');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSLocalidadMock.getError())
			.addForAddress(WSLocalidad.SERVICE_CONFIG.URL__c + '/v1/salud/localidades-zona');
    }

    @IsTest
	private static void whenTheWSIsConsume_GetListOfLocalidades(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		WSLocalidad.Response responseToAssert = WSLocalidad.getLocalidadPorFechaModificacion('2020-04-06', 50, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(50, responseToAssert.localidad.data.size());
		System.assertEquals('1077CFE', responseToAssert.localidad.data[0].codigo_postal);
		System.assertEquals('3640', responseToAssert.localidad.data[0].loc_loc_id);
		System.assertEquals('C', responseToAssert.localidad.data[0].pcia_codigo);
		System.assertEquals('CAPITAL FEDERAL', responseToAssert.localidad.data[0].localidad);
		System.assertEquals('2020-04-06', responseToAssert.localidad.data[0].f_modif_or);
		
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




	@IsTest
	private static void whenTheWSIsConsume_GetEmpty(){
		Test.setMock(HttpCalloutMock.class, getEmpty);
		
		Test.startTest();
		WSLocalidad.Response responseToAssert = WSLocalidad.getLocalidadPorFechaModificacion('2020-04-05', 50, 1);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals(0, responseToAssert.localidad.data.size());

	}
}