@isTest
public with sharing class WSCaseEnviarASSHelperTest {
	private static String AUTORIZACIONES_URL = ConfigUtils.getEndpointsByTipo('autorizaciones').get('autorizaciones').Endpoint__c;
	private static String REVERTIR_URL = ConfigUtils.getEndpointsByTipo('autorizaciones').get('centro-autorizador/revertir').Endpoint__c;
    private static XHttpCalloutMock getResponseFound;
	private static XHttpCalloutMock getResponseRevertFound;
    private static XHttpCalloutMock getErrorRevertResponse;
    static {
		Case ap = new Case();
		insert ap;
        getResponseFound = new XHttpCalloutMock();
		TestUtils.setMockResponse(getResponseFound, AUTORIZACIONES_URL, WSCaseAPGenerarCentroMock.getFound(ap.Id), 200, 'Ok');
		getResponseRevertFound = new XHttpCalloutMock();
		TestUtils.setMockResponse(getResponseRevertFound, REVERTIR_URL + '/1014009821', WSCasoEnviarASSMock.getFound(), 200, 'Ok');
		getErrorRevertResponse = new XHttpCalloutMock();
        TestUtils.setMockResponse(getErrorRevertResponse, REVERTIR_URL + '/1014009821', WSCaseAPRevertirMock.getError(), 404, 'Ok');
    }
    @IsTest
    private static void whenTheWSIsConsume_APUpdated() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        String body = '{'+
					'"fecha": "2019-05-05",'+
					'"fecha_prob": "2019-05-05",'+
					'"agencia_codigo": "650261",'+
					'"codigo_afiliado": "69794/14",'+
					'"evento_medico_id": "55863",'+
					'"fecha_pres": "2018-04-01",'+
					'"codigo_diagnostico": "X99",'+
					'"efectores_prestador": "707595",'+
					'"prestador": "707595",'+
					'"consultorio": "1",'+
					'"observaciones": "Autorización de evento médico XX",'+
					'"mail": "test@mapplics.com",'+
					'"otros_mail": null,'+
					'"alerta": "A22",'+
					'"contexto": "A",'+
					'"numero_sf": "1005277888",'+
					'"prestaciones": [{'+
						'"cantidad": 1,'+
						'"nom_prestacion_pdh": "02166001",'+
						'"tipo_prestacion": "N",'+
						'"descripcion": "ELECTROCARDIOGRAMA"'+
					'}]'+
				'}';
        Test.startTest();
        WSCaseEnviarASSHelper.Response responseToAssert = WSCaseEnviarASSHelper.enviarASS(body, 'autorizaciones', 'autorizaciones');
        Test.stopTest();
        System.assert(!responseToAssert.hasError, 'No debe haber ningun error');
        System.assertEquals(200, responseToAssert.response.getStatusCode(), 'El código de respuesta debe ser 200');
        System.assertEquals('Ok', responseToAssert.response.getStatus(), 'El mensaje debe ser Ok');
    }
    @IsTest
    static void revertValidAP() {
        Case ap = new Case(Nro_AP__c = '1014009821');
        Test.setMock(HttpCalloutMock.class, getResponseRevertFound);
        Test.startTest();
		WSCaseEnviarASSHelper.Response response = WSCaseEnviarASSHelper.enviarASS('{"username":"CRIOS"}', 'autorizaciones', 'centro-autorizador/revertir', ap.Nro_AP__c);
        Test.stopTest();
        System.assert(!response.hasError, 'No debe haber ningun error');
        System.assertEquals('Ok', response.message, 'El mensaje debe ser OK');
    }
    @IsTest
    static void revertInvalidAP() {
        Case ap = new Case(Nro_AP__c = '1014009821');
		String errorMsg = 'No se pudo generar el centro autorizador. Intente nuevamente. LA AP NO ESTA EN CENTRO AUTORIZADOR\n';
        Test.setMock(HttpCalloutMock.class, getErrorRevertResponse);
        Test.startTest();
		WSCaseEnviarASSHelper.Response response = WSCaseEnviarASSHelper.enviarASS('{"username":"CRIOS"}', 'autorizaciones', 'centro-autorizador/revertir', ap.Nro_AP__c);
        Test.stopTest();
        System.assert(response.hasError, 'Debe haber ocurrido un error');
        System.assertEquals(errorMsg, response.message, 'El mensaje no indica el error');
    }
}