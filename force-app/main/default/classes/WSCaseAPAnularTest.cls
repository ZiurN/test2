/**
 * Created by xappia on 10/2/20.
 */

@IsTest
private class WSCaseAPAnularTest {
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
                .withBody(WSCaseAPAnularMock.getFound())
                .addForAddress(WSCaseAPAnular.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/anular/1014009953');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('La autorización solicitada es inválida.')
                .withStatusCode(404)
                .withBody(WSCaseAPAnularMock.getError())
                .addForAddress(WSCaseAPAnular.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/anular/101400995');

    }

    @IsTest
    private static void sendValidCaseToAnular() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        String body = '{"username":"CRIOS"}';
        Test.startTest();
        WSCaseAPAnular.Response resp = WSCaseAPAnular.anularCaso('1014009953',body);
        Test.stopTest();

        System.assertEquals(false,resp.hasError);
        System.assertEquals(null,resp.message);
        System.assertEquals('1014009953',resp.result.data.ap.apr_id);
        System.assertEquals('2020-02-12 00:00:00',resp.result.data.ap.fecha);
        System.assertEquals('CX--MOST',resp.result.data.ap.conexion);
        System.assertEquals('Mostrador',resp.result.data.ap.nombre_conexion);
        System.assertEquals('650098',resp.result.data.ap.delegacion);
        System.assertEquals('650098_ACA SALUD SUC. ROSARIO',resp.result.data.ap.nombre_delegacion);
        System.assertEquals('2020-02-12 00:00:00',resp.result.data.ap.fecha_probable);
        System.assertEquals('CA-----N',resp.result.data.ap.estado);
        System.assertEquals('ANULADA',resp.result.data.ap.nombre_estado);
        System.assertEquals('CRIOS',resp.result.data.ap.user_insert);
        System.assertEquals('2020-02-12 13:59:15',resp.result.data.ap.fecha_insert);
        System.assertEquals('69794/38',resp.result.data.ap.codigo_afiliado);
        System.assertEquals('ORLOW',resp.result.data.ap.apellidos_afiliado);
        System.assertEquals('SOFIA',resp.result.data.ap.nombres_afiliado);
        System.assertEquals('DNI 35128344',resp.result.data.ap.doc_afiliado);
        System.assertEquals(null,resp.result.data.ap.evento_medico);
        System.assertEquals('2020-01-20 00:00:00',resp.result.data.ap.fecha_prescripcion);
        System.assertEquals('999',resp.result.data.ap.diagnostico);
        System.assertEquals('DIAGNOSTICO INDETERMINADO',resp.result.data.ap.desc_diagnostico);
        System.assertEquals('758415',resp.result.data.ap.prescriptor);
        System.assertEquals('ZAPATA AGUILA BENJAMIN',resp.result.data.ap.nombre_prescriptor);
        System.assertEquals(null,resp.result.data.ap.prestador_dirige);
        System.assertEquals(null,resp.result.data.ap.nombre_prestador_dirige);
        System.assertEquals(null,resp.result.data.ap.prestador);
        System.assertEquals(null,resp.result.data.ap.nombre_prestador);
        System.assertEquals(null,resp.result.data.ap.consultorio);
        System.assertEquals(null,resp.result.data.ap.nombre_consultorio);
        System.assertEquals(null,resp.result.data.ap.observaciones);
        System.assertEquals('crios@acasalud.com.ar',resp.result.data.ap.mail);
        System.assertEquals(null,resp.result.data.ap.otros_mail);
        System.assertEquals(null,resp.result.data.ap.aca_agencia);
        System.assertEquals(null,resp.result.data.ap.tran_alta);
        System.assertEquals(null,resp.result.data.ap.tran_anulacion);
        System.assertEquals(null,resp.result.data.ap.ref_externa);
        System.assertEquals(null,resp.result.data.ap.urgente);
        System.assertEquals('180015',resp.result.data.ap.afi_id);
        System.assertEquals(null,resp.result.data.ap.nro_sf);
        System.assertEquals('Nivel 1',resp.result.data.ap.nivel);
        System.assertEquals('BAJA COMPLEJIDAD',resp.result.data.ap.clasificacion);

        //Prestaciones
        System.assertEquals(1, resp.result.data.ap.prestaciones.size());
        System.assertEquals('1014009953',resp.result.data.ap.prestaciones[0].apr_id);
        System.assertEquals('C1----AS',resp.result.data.ap.prestaciones[0].estado_prestacion);
        System.assertEquals('AUTORIZADO POR EL SISTEMA',resp.result.data.ap.prestaciones[0].estado_descripcion);
        System.assertEquals('Ambulatorio',resp.result.data.ap.prestaciones[0].contexto);
        System.assertEquals('1',resp.result.data.ap.prestaciones[0].cantidad);
        System.assertEquals('02170101',resp.result.data.ap.prestaciones[0].prestacion);
        System.assertEquals('ELECTROCARDIOGRAMA EN CONSULTORIO',resp.result.data.ap.prestaciones[0].nombre_prestacion);
        System.assertEquals('N',resp.result.data.ap.prestaciones[0].tipo_prestacion);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].troquel);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].grupo_prestacion);
        System.assertEquals('74042314',resp.result.data.ap.prestaciones[0].pca_id);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].alerta);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].texto_aclarativo);




    }

    @IsTest
    private static void sendInvalidCaseToAnular() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        String body = '{"username":"CRIOS"}';
        Test.startTest();
        WSCaseAPAnular.Response resp = WSCaseAPAnular.anularCaso('101400995', body);
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
        System.assertEquals('La autorización solicitada es inválida.', resp.message);
    }
}