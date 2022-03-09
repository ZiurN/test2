@isTest
public with sharing class WSCaseEnviarASSHelperTest {
	private static String AUTORIZACIONES_URL = ConfigUtils.getEndpointsByTipo('autorizaciones').get('autorizaciones').Endpoint__c;
	private static String REVERTIR_URL = ConfigUtils.getEndpointsByTipo('autorizaciones').get('centro-autorizador/revertir').Endpoint__c;
	private static String ANULAR_URL = ConfigUtils.getEndpointsByTipo('autorizaciones').get('orden-ap/anular').Endpoint__c;
    private static XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
	private static XHttpCalloutMock getResponseRevertFound = new XHttpCalloutMock();
    private static XHttpCalloutMock getErrorRevertResponse = new XHttpCalloutMock();
	private static XHttpCalloutMock getResponseAnularFound = new XHttpCalloutMock();
    private static XHttpCalloutMock getErrorResAnularponse = new XHttpCalloutMock();
    static {
		Case ap = new Case();
		insert ap;
		TestUtils.setMockResponse(getResponseFound, AUTORIZACIONES_URL, WSCaseAPGenerarCentroMock.getFound(ap.Id), 200, 'Ok');
		TestUtils.setMockResponse(getResponseRevertFound, REVERTIR_URL + '/1014009821', WSCasoEnviarASSMock.getFound(), 200, 'Ok');
        TestUtils.setMockResponse(getErrorRevertResponse, REVERTIR_URL + '/1014009821', WSCaseAPRevertirMock.getError(), 404, 'Ok');
		TestUtils.setMockResponse(getResponseAnularFound, ANULAR_URL + '/1014009953', WSCaseAPAnularMock.getFound());
		TestUtils.setMockResponse(getErrorResAnularponse, ANULAR_URL + '/101400995', WSCaseAPAnularMock.getError(), 404, 'La autorización solicitada es inválida.');
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
    @IsTest
    private static void sendValidCaseToAnular() {
        Test.setMock(HttpCalloutMock.class, getResponseAnularFound);
        String body = '{"username":"CRIOS"}';
        Test.startTest();
		WSCaseEnviarASSHelper.Response resp = WSCaseEnviarASSHelper.enviarASS(body, 'autorizaciones', 'orden-ap/anular', '1014009953');
        Test.stopTest();
        System.assert(!resp.hasError, 'No debe haber ocurrido un error');
        System.assertEquals('Ok', resp.message, 'El valor no es el esperado');
        System.assertEquals('1014009953',resp.result.data[0].ap[0].apr_id, 'El valor no es el esperado');
        System.assertEquals('2020-02-12 00:00:00',resp.result.data[0].ap[0].fecha, 'El valor no es el esperado');
        System.assertEquals('CX--MOST',resp.result.data[0].ap[0].conexion, 'El valor no es el esperado');
        System.assertEquals('Mostrador',resp.result.data[0].ap[0].nombre_conexion, 'El valor no es el esperado');
        System.assertEquals('650098',resp.result.data[0].ap[0].delegacion, 'El valor no es el esperado');
        System.assertEquals('650098_ACA SALUD SUC. ROSARIO',resp.result.data[0].ap[0].nombre_delegacion, 'El valor no es el esperado');
        System.assertEquals('2020-02-12 00:00:00',resp.result.data[0].ap[0].fecha_probable, 'El valor no es el esperado');
        System.assertEquals('CA-----N',resp.result.data[0].ap[0].estado, 'El valor no es el esperado');
        System.assertEquals('ANULADA',resp.result.data[0].ap[0].nombre_estado, 'El valor no es el esperado');
        System.assertEquals('CRIOS',resp.result.data[0].ap[0].user_insert, 'El valor no es el esperado');
        System.assertEquals('2020-02-12 13:59:15',resp.result.data[0].ap[0].fecha_insert, 'El valor no es el esperado');
        System.assertEquals('69794/38',resp.result.data[0].ap[0].codigo_afiliado, 'El valor no es el esperado');
        System.assertEquals('ORLOW',resp.result.data[0].ap[0].apellidos_afiliado, 'El valor no es el esperado');
        System.assertEquals('SOFIA',resp.result.data[0].ap[0].nombres_afiliado, 'El valor no es el esperado');
        System.assertEquals('DNI 35128344',resp.result.data[0].ap[0].doc_afiliado, 'El valor no es el esperado');
        System.assertEquals(null,resp.result.data[0].ap[0].evento_medico, 'El valor no es el esperado');
        System.assertEquals('2020-01-20 00:00:00',resp.result.data[0].ap[0].fecha_prescripcion, 'El valor no es el esperado');
        System.assertEquals('999',resp.result.data[0].ap[0].diagnostico, 'El valor no es el esperado');
        System.assertEquals('DIAGNOSTICO INDETERMINADO',resp.result.data[0].ap[0].desc_diagnostico, 'El valor no es el esperado');
        System.assertEquals('758415',resp.result.data[0].ap[0].prescriptor, 'El valor no es el esperado');
        System.assertEquals('ZAPATA AGUILA BENJAMIN',resp.result.data[0].ap[0].nombre_prescriptor, 'El valor no es el esperado');
        System.assertEquals(null,resp.result.data[0].ap[0].prestador_dirige, 'El valor no es el esperado');
        System.assertEquals(null,resp.result.data[0].ap[0].nombre_prestador_dirige, 'El valor no es el esperado');
        System.assertEquals(null,resp.result.data[0].ap[0].prestador, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].nombre_prestador, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].consultorio, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].nombre_consultorio, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].observaciones, 'Este valor debe ser nulo');
        System.assertEquals('crios@acasalud.com.ar',resp.result.data[0].ap[0].mail, 'El valor no es el esperado');
        System.assertEquals(null,resp.result.data[0].ap[0].otros_mail, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].aca_agencia, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].tran_alta, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].tran_anulacion, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].ref_externa, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].urgente, 'Este valor debe ser nulo');
        System.assertEquals('180015',resp.result.data[0].ap[0].afi_id, 'El valor no es el esperado');
        System.assertEquals(null,resp.result.data[0].ap[0].nro_sf, 'Este valor debe ser nulo');
        System.assertEquals('Nivel 1',resp.result.data[0].ap[0].nivel, 'El valor no es el esperado');
        System.assertEquals('BAJA COMPLEJIDAD',resp.result.data[0].ap[0].clasificacion, 'El valor no es el esperado');
        //Prestaciones
        System.assertEquals(1, resp.result.data[0].ap[0].prestaciones.size(), 'El valor no es el esperado');
        System.assertEquals('1014009953',resp.result.data[0].ap[0].prestaciones[0].apr_id, 'El valor no es el esperado');
        System.assertEquals('C1----AS',resp.result.data[0].ap[0].prestaciones[0].estado_prestacion, 'El valor no es el esperado');
        System.assertEquals('AUTORIZADO POR EL SISTEMA',resp.result.data[0].ap[0].prestaciones[0].estado_descripcion, 'El valor no es el esperado');
        System.assertEquals('Ambulatorio',resp.result.data[0].ap[0].prestaciones[0].contexto, 'El valor no es el esperado');
        System.assertEquals('1',resp.result.data[0].ap[0].prestaciones[0].cantidad, 'El valor no es el esperado');
        System.assertEquals('02170101',resp.result.data[0].ap[0].prestaciones[0].prestacion, 'El valor no es el esperado');
        System.assertEquals('ELECTROCARDIOGRAMA EN CONSULTORIO',resp.result.data[0].ap[0].prestaciones[0].nombre_prestacion, 'El valor no es el esperado');
        System.assertEquals('N',resp.result.data[0].ap[0].prestaciones[0].tipo_prestacion, 'El valor no es el esperado');
        System.assertEquals(null,resp.result.data[0].ap[0].prestaciones[0].troquel, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].prestaciones[0].grupo_prestacion, 'Este valor debe ser nulo');
        System.assertEquals('74042314',resp.result.data[0].ap[0].prestaciones[0].pca_id, 'El valor no es el esperado');
        System.assertEquals(null,resp.result.data[0].ap[0].prestaciones[0].alerta, 'Este valor debe ser nulo');
        System.assertEquals(null,resp.result.data[0].ap[0].prestaciones[0].texto_aclarativo, 'Este valor debe ser nulo');
    }
    @IsTest
    private static void sendInvalidCaseToAnular() {
        Test.setMock(HttpCalloutMock.class, getErrorResAnularponse);
        String body = '{"username":"CRIOS"}';
        Test.startTest();
		WSCaseEnviarASSHelper.Response resp = WSCaseEnviarASSHelper.enviarASS(body, 'autorizaciones', 'orden-ap/anular', '101400995');
        Test.stopTest();
        System.assert(resp.hasError, 'Debe haber un error');
        System.assertEquals('La autorización solicitada es inválida.', resp.message, 'El mensaje no indica el error');
    }
}