@IsTest
private class WSCaseAPGenerarCentroTest {

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
                .withBody(WSCasoEnviarASSMock.getFound())
                .addForAddress(WSCaseAPGenerarCentro.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/centro-autorizador/generar/1014009821');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('No se pudo generar el centro autorizador. Intente nuevamente. LA AP ESTA EN ESTADO CENTRO AUTORIZADOR')
                .withStatusCode(500)
                .withBody(WSCaseAPGenerarCentroMock.getError())
                .addForAddress(WSCaseAPGenerarCentro.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/centro-autorizador/generar/1014009821');

    }

    @IsTest
    private static void sendValidCaseToGenerarCentroAutorizador() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        String body = '{"username":"CRIOS"}';
        Test.startTest();
        WSCaseAPGenerarCentro.Response resp = WSCaseAPGenerarCentro.enviarCaso('1014009821',body);
        Test.stopTest();

        System.assertEquals(false,resp.hasError);
        System.assertEquals(null,resp.message);
        System.assertEquals('1014010015',resp.result.data.ap.apr_id);
        System.assertEquals('2020-02-02 00:00:00',resp.result.data.ap.fecha);
        System.assertEquals('CX--MOST',resp.result.data.ap.conexion);
        System.assertEquals('Mostrador',resp.result.data.ap.nombre_conexion);
        System.assertEquals('650098',resp.result.data.ap.delegacion);
        System.assertEquals('650098_ACA SALUD SUC. ROSARIO',resp.result.data.ap.nombre_delegacion);
        System.assertEquals('2019-02-02 00:00:00',resp.result.data.ap.fecha_probable);
        System.assertEquals('CA-----A',resp.result.data.ap.estado);
        System.assertEquals('CENTRO AUTORIZADOR',resp.result.data.ap.nombre_estado);
        System.assertEquals('CRIOS',resp.result.data.ap.user_insert);
        System.assertEquals('2020-02-14 10:13:37',resp.result.data.ap.fecha_insert);
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
        System.assertEquals('Nivel 1',resp.result.data.ap.nivel);
        System.assertEquals('CUBIERTOS',resp.result.data.ap.clasificacion);

        //Prestaciones
        System.assertEquals(1, resp.result.data.ap.prestaciones.size());
        System.assertEquals('1014010015',resp.result.data.ap.prestaciones[0].apr_id);
        System.assertEquals('C1-----A',resp.result.data.ap.prestaciones[0].estado_prestacion);
        System.assertEquals('EN AUDITORIA',resp.result.data.ap.prestaciones[0].estado_descripcion);
        System.assertEquals('Ambulatorio',resp.result.data.ap.prestaciones[0].contexto);
        System.assertEquals('1',resp.result.data.ap.prestaciones[0].cantidad);
        System.assertEquals('13904',resp.result.data.ap.prestaciones[0].prestacion);
        System.assertEquals('ILVICO N, COMP.X 20',resp.result.data.ap.prestaciones[0].nombre_prestacion);
        System.assertEquals('N',resp.result.data.ap.prestaciones[0].tipo_prestacion);
        System.assertEquals('3758671',resp.result.data.ap.prestaciones[0].troquel);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].grupo_prestacion);
        System.assertEquals('74042384',resp.result.data.ap.prestaciones[0].pca_id);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].alerta);
        System.assertEquals('NO REQUIERE OBSERV',resp.result.data.ap.prestaciones[0].texto_aclarativo);

        //Alertas
        System.assertEquals(1,resp.result.data.ap.prestaciones[0].alertas.size());
        System.assertEquals('74042384',resp.result.data.ap.prestaciones[0].alertas[0].pca_pca_id);
        System.assertEquals('16461179',resp.result.data.ap.prestaciones[0].alertas[0].aca_id);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].alertas[0].cca_cca_id);
        System.assertEquals('105',resp.result.data.ap.prestaciones[0].alertas[0].control);
        System.assertEquals('MEDICAMENTO ACTIVO',resp.result.data.ap.prestaciones[0].alertas[0].nombre_control);
        System.assertEquals('FCION_FRONT',resp.result.data.ap.prestaciones[0].alertas[0].funcion);
        System.assertEquals('El medicamento no existe o no está activo',resp.result.data.ap.prestaciones[0].alertas[0].texto_aclarativo);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].alertas[0].nota_auditor);
        System.assertEquals('105',resp.result.data.ap.prestaciones[0].alertas[0].nivel_auditoria);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].alertas[0].observaciones);
        System.assertEquals('2020-02-14 10:13:38',resp.result.data.ap.prestaciones[0].alertas[0].fecha_generacion);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].alertas[0].fecha_resolucion);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].alertas[0].fecha_lectura);
        System.assertEquals(null,resp.result.data.ap.prestaciones[0].alertas[0].auditor_resuelve);


    }

    @IsTest
    private static void sendInvalidCaseToGenerarCentroAutorizador() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        String body = '{"username":"CRIOS"}';
        Test.startTest();
        WSCaseAPGenerarCentro.Response resp = WSCaseAPGenerarCentro.enviarCaso('1014009821', body);
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
        System.assertEquals('The given data was invalid.', resp.message);
    }
}