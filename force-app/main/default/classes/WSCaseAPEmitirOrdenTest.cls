/**
 * Created by xappia on 13/2/20.
 */

@IsTest
private class WSCaseAPEmitirOrdenTest {
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
                .withBody(WSCaseAPEmitirOrdenMock.getFound())
                .addForAddress(WSCaseAPEmitirOrden.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/generar/1014009998');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('La autorización solicitada es inválida.')
                .withStatusCode(404)
                .withBody(WSCaseAPEmitirOrdenMock.getError())
                .addForAddress(WSCaseAPEmitirOrden.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/generar/101400999');

    }

    @IsTest
    private static void sendValidCaseToEmitirOrden() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        String body = '{"username":"CRIOS"}';
        Test.startTest();
        WSCaseAPEmitirOrden.Response resp = WSCaseAPEmitirOrden.emitirOrden('1014009998',body);
        Test.stopTest();

        System.assertEquals(false,resp.hasError);
        System.assertEquals(null,resp.message);
        System.assertEquals('1014009998',resp.result.data.ap.apr_id);
        System.assertEquals('2020-02-02 00:00:00',resp.result.data.ap.fecha);
        System.assertEquals('CX--MOST',resp.result.data.ap.conexion);
        System.assertEquals('Mostrador',resp.result.data.ap.nombre_conexion);
        System.assertEquals('650098',resp.result.data.ap.delegacion);
        System.assertEquals('650098_ACA SALUD SUC. ROSARIO',resp.result.data.ap.nombre_delegacion);
        System.assertEquals('2019-02-02 00:00:00',resp.result.data.ap.fecha_probable);
        System.assertEquals('CA-----E',resp.result.data.ap.estado);
        System.assertEquals('ORDEN EMITIDA',resp.result.data.ap.nombre_estado);
        System.assertEquals('CRIOS',resp.result.data.ap.user_insert);
        System.assertEquals('2020-02-13 15:45:28',resp.result.data.ap.fecha_insert);
        System.assertEquals('86712/26',resp.result.data.ap.codigo_afiliado);
        System.assertEquals('FRANCIONI MIGUEL',resp.result.data.ap.apellidos_afiliado);
        System.assertEquals('.',resp.result.data.ap.nombres_afiliado);
        System.assertEquals('DNI 11585637',resp.result.data.ap.doc_afiliado);
        System.assertEquals(null,resp.result.data.ap.evento_medico);
        System.assertEquals('2020-01-31 00:00:00',resp.result.data.ap.fecha_prescripcion);
        System.assertEquals('999',resp.result.data.ap.diagnostico);
        System.assertEquals('DIAGNOSTICO INDETERMINADO',resp.result.data.ap.desc_diagnostico);
        System.assertEquals('758415',resp.result.data.ap.prescriptor);
        System.assertEquals('ZAPATA AGUILA BENJAMIN',resp.result.data.ap.nombre_prescriptor);
        System.assertEquals('700125',resp.result.data.ap.prestador_dirige);
        System.assertEquals('INST. GAMMA',resp.result.data.ap.nombre_prestador_dirige);
        System.assertEquals('700125',resp.result.data.ap.prestador);
        System.assertEquals('INST. GAMMA',resp.result.data.ap.nombre_prestador);
        System.assertEquals('1',resp.result.data.ap.consultorio);
        System.assertEquals('CONSULTORIO PPAL PRESTADOR :700125',resp.result.data.ap.nombre_consultorio);
        System.assertEquals('Prueba AP SF',resp.result.data.ap.observaciones);
        System.assertEquals('test@mapplics.com',resp.result.data.ap.mail);
        System.assertEquals(null,resp.result.data.ap.otros_mail);
        System.assertEquals(null,resp.result.data.ap.aca_agencia);
        System.assertEquals(null,resp.result.data.ap.tran_alta);
        System.assertEquals(null,resp.result.data.ap.tran_anulacion);
        System.assertEquals(null,resp.result.data.ap.ref_externa);
        System.assertEquals(null,resp.result.data.ap.urgente);
        System.assertEquals('131155',resp.result.data.ap.afi_id);
        System.assertEquals('156151sadas',resp.result.data.ap.nro_sf);
        System.assertEquals('N1',resp.result.data.ap.nivel);
        System.assertEquals('CUBIERTOS',resp.result.data.ap.clasificacion);


    }

    @IsTest
    private static void sendInvalidCaseToEmitirOrden() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        String body = '{"username":"CRIOS"}';
        Test.startTest();
        WSCaseAPEmitirOrden.Response resp = WSCaseAPEmitirOrden.emitirOrden('101400999', body);
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
        System.assertEquals('No se pudo generar la orden. Por favor, intente nuevamente. NO SE PUEDE GENERAR UNA ORDEN EN ESTADO ANULADA', resp.message);
    }
}