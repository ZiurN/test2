/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase de pruebas para los envios a SS de información de cuentas.
@date			24/05/2022
------------------------------------------------------------------------------------------------------------------------*/
@isTest
public with sharing class WSEnviarASSHelperAccountTest {
    private static String DATOS_SF_URL = ConfigUtils.getEndpointsByTipo('afiliado').get('datos-sf').Endpoint__c;
	private static String body = '{' +
		'"afi_id": "140510",' +
		'"email": "pruebaactualizacion@email.com"' +
	'}';
	private static XHttpCalloutMock getDatosSFResponse = new XHttpCalloutMock('afiliado', 'datos-sf');
	private static XHttpCalloutMock getDatosSFResponseError = new XHttpCalloutMock('afiliado', 'datos-sf');
	@isTest
	private static void test_getDatosSFResponseOk () {
		String expectedMessage = 'Se ejecutó el proceso.';
		TestUtils.setMockResponse(getDatosSFResponse, DATOS_SF_URL, AfiliadoEndpointsMockResponses.getDatosSFResponseOk());
		Test.setMock(HttpCalloutMock.class, getDatosSFResponse);
		WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(body, 'afiliado', 'datos-sf', 'POST', null);
		Test.startTest();
		WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
		Test.stopTest();
		System.assert(!response.hasError, 'No debe haber ocurrido un error');
		System.assertEquals(expectedMessage, response.message, 'El mensaje no es el esperado');
	}
	@isTest
	private static void test_getDatosSFResponseError () {
		String expectedMessage = 'No se pudieron replicar los datos.';
		TestUtils.setMockResponse(getDatosSFResponseError, DATOS_SF_URL, AfiliadoEndpointsMockResponses.getDatosSFResponseError(), 400, 'Not found');
		Test.setMock(HttpCalloutMock.class, getDatosSFResponseError);
		WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(body, 'afiliado', 'datos-sf', 'POST', null);
		Test.startTest();
		WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
		Test.stopTest();
		System.assert(response.hasError, 'Debe haber ocurrido un error');
		System.assertEquals(expectedMessage, response.message, 'El mensaje no es el esperado');
	}
}
