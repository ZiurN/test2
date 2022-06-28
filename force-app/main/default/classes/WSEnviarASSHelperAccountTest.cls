/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase de pruebas para los envios a SS de información de cuentas.
@date			24/05/2022
------------------------------------------------------------------------------------------------------------------------*/
@isTest
public with sharing class WSEnviarASSHelperAccountTest {
    private static String DATOS_SF_URL = ConfigUtils.getEndpointsByTipo('afiliado').get('datos-sf').Endpoint__c;
	private static String AFILIADO_URL = ConfigUtils.getEndpointsByTipo('afiliado').get('afiliado').Endpoint__c;
	private static String FACTURA_ELECTRONICA_URL = AFILIADO_URL + '/477443/factura-electronica';
	private static String bodyDatosSF = '{' +
		'"afi_id": "140510",' +
		'"email": "pruebaactualizacion@email.com"' +
	'}';
	private static String bodyFacturaElectronica = '{"adherido": "S"}';
	private static XHttpCalloutMock getDatosSFResponse = new XHttpCalloutMock('afiliado', 'datos-sf');
	private static XHttpCalloutMock getFacturaElectronicaResponse = new XHttpCalloutMock();
	/**-----------------------------------------------------------------------
		Endpoint: /afiliado/datos-sf
	------------------------------------------------------------------------*/
		@isTest
		private static void test_getDatosSFResponseOk () {
			String expectedMessage = 'Se ejecutó el proceso.';
			TestUtils.setMockResponse(getDatosSFResponse, DATOS_SF_URL, AfiliadoEndpointsMockResponses.getDatosSFResponseOk());
			Test.setMock(HttpCalloutMock.class, getDatosSFResponse);
			WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(bodyDatosSF, 'afiliado', 'datos-sf', 'POST', null);
			Test.startTest();
			WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
			Test.stopTest();
			System.assert(!response.hasError, 'No debe haber ocurrido un error');
			System.assertEquals(expectedMessage, response.message, 'El mensaje no es el esperado');
		}
		@isTest
		private static void test_getDatosSFResponseError () {
			String expectedMessage = 'No se pudieron replicar los datos.';
			TestUtils.setMockResponse(getDatosSFResponse, DATOS_SF_URL, AfiliadoEndpointsMockResponses.getDatosSFResponseError(), 400, 'Not found');
			Test.setMock(HttpCalloutMock.class, getDatosSFResponse);
			WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(bodyDatosSF, 'afiliado', 'datos-sf', 'POST', null);
			Test.startTest();
			WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
			Test.stopTest();
			System.assert(response.hasError, 'Debe haber ocurrido un error');
			System.assertEquals(expectedMessage, response.message, 'El mensaje no es el esperado');
		}
	/**-----------------------------------------------------------------------
		Endpoint: /afiliado/{{afi_id}}/factura-electronica
	------------------------------------------------------------------------*/
		@isTest
		private static void updateFacturaElectronicaSuccess () {
			String expectedMessage = 'Se actualizó la información de FE del socio.';
			TestUtils.setMockResponse(getFacturaElectronicaResponse, FACTURA_ELECTRONICA_URL, AfiliadoEndpointsMockResponses.getAsociacionFacturaElectronicaOK());
			Test.setMock(HttpCalloutMock.class, getFacturaElectronicaResponse);
			String extraParams = '477443/factura-electronica';
			WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(bodyFacturaElectronica, 'afiliado', 'afiliado', 'PUT', extraParams);
			Test.startTest();
			WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
			Test.stopTest();
			System.assert(!response.hasError, 'No debe haber ocurrido un error');
			System.assertEquals(expectedMessage, response.message, 'El mensaje no es el esperado');
		}
		@isTest
		private static void updateFacturaElectronicaError () {
			String expectedMessage = 'No se pudo actualizar la información de FE del socio. DATO INGRESADO IGUAL AL ACTUAL.\n';
			TestUtils.setMockResponse(getFacturaElectronicaResponse, FACTURA_ELECTRONICA_URL, AfiliadoEndpointsMockResponses.getAsociacionFacturaElectronicaError(), 400, 'Not found');
			Test.setMock(HttpCalloutMock.class, getFacturaElectronicaResponse);
			String extraParams = '477443/factura-electronica';
			WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(bodyFacturaElectronica, 'afiliado', 'afiliado', 'PUT', extraParams);
			Test.startTest();
			WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
			Test.stopTest();
			System.assert(response.hasError, 'Debe haber ocurrido un error');
			System.assertEquals(expectedMessage, response.message, 'El mensaje no es el esperado');
		}
}
