@isTest
public class WSLocalidadTest {
	private static String LOCALIDADES_ZONAS_URL = ConfigUtils.getEndpointsByTipo('localidades-zonas').get('localidades-zonas').Endpoint__c;
    private static XHttpCalloutMock getResponseFound;
	private static XHttpCalloutMock getErrorResponse;
	private static XHttpCalloutMock getEmpty;
	private static String LOCALIDADES_ZONAS_URL_TAIL1 = '?filter[fecha_modificacion]=2020-04-06&pageSize=50&page=1';
	private static String LOCALIDADES_ZONAS_URL_TAIL2 = '?filter[fecha_modificacion]=2020-04-05&pageSize=50&page=1';
	static {
		getResponseFound = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseFound,
			LOCALIDADES_ZONAS_URL + LOCALIDADES_ZONAS_URL_TAIL1,
			XappiaHelper.getStaticResource('mockLocalidadOk').body.toString(),
			200,
			'OK'
		);
		getEmpty = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getEmpty,
			LOCALIDADES_ZONAS_URL + LOCALIDADES_ZONAS_URL_TAIL2,
			XappiaHelper.getStaticResource('mockLocalidadEmpty').body.toString(),
			200,
			'OK'
		);
		getErrorResponse = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			false,
			getErrorResponse,
			LOCALIDADES_ZONAS_URL,
			XappiaHelper.getStaticResource('mockLocalidadError').body.toString(),
			404,
			'Not Found'
		);
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