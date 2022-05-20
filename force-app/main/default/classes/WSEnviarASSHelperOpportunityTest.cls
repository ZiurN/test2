/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase para validar los métodos y funcionalidades de la clase WSOpportunityEnviarASSHelper.
@date			10/05/2022
------------------------------------------------------------------------------------------------------------------------*/
@isTest
public with sharing class WSEnviarASSHelperOpportunityTest {
	private static Map<String,Webservice_endpoint__mdt> solicitudesAfiliadosEndpoints = ConfigUtils.getEndpointsByTipo('solicitudes-afiliados');
	private static final String SOLICITUDES_AFILIADOS_URL = solicitudesAfiliadosEndpoints.get('solicitudes-afiliados').Endpoint__c;
	private static XHttpCalloutMock ssSolicitudesAfiliadosResponseMock = new XHttpCalloutMock();
	@isTest
	private static void oppClosedLost_ifSSResponseIsOk_getResponse () {
		String body = '{"nota_usuario" : "CRIOS"}';
		String expectedMessage = 'La solicitud ha pasado a estado Incompleta exitosamente.';
		String extraParams = '12345678/incompleta';
		String finalURL = SOLICITUDES_AFILIADOS_URL + '/' + extraParams;
		System.debug(finalURL);
		TestUtils.setMockResponse(ssSolicitudesAfiliadosResponseMock, finalURL, SolicitudesAfiliadosMock.getIncompletaResponseOk());
		Test.setMock(HttpCalloutMock.class, ssSolicitudesAfiliadosResponseMock);
		Test.startTest();
		WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(body, 'solicitudes-afiliados', 'solicitudes-afiliados', 'PUT', extraParams);
		WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
		Test.stopTest();
		System.assert(!response.hasError, 'No debe haber ningun error');
		System.assertEquals(expectedMessage, response.message, 'El mensaje no es el esperado');
	}
	@isTest
	private static void oppClosedLost_ifSSResponseIsError_getResponse () {
		String body = '{"nota_usuario" : "CRIOS"}';
		String expectedMessage = 'No se pudo pasar a imcompleta la solicitud. La solicitud está transformada, no se puede modificar\n';
		String extraParams = '12345678/incompleta';
		String finalURL = SOLICITUDES_AFILIADOS_URL + '/' + extraParams;
		TestUtils.setMockResponse(ssSolicitudesAfiliadosResponseMock, finalURL, SolicitudesAfiliadosMock.getIncompletaResponseError(), 400, 'Not Found');
		Test.setMock(HttpCalloutMock.class, ssSolicitudesAfiliadosResponseMock);
		Test.startTest();
		Test.startTest();
		WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(body, 'solicitudes-afiliados', 'solicitudes-afiliados', 'PUT', extraParams);
		WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
		Test.stopTest();
		System.assert(response.hasError, 'Debe presentarse un error');
		System.assertEquals(expectedMessage, response.message, 'El mensaje no es el esperado');
	}
}
