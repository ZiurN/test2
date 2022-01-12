@IsTest
private class WSSegmentoActualizarTest {
    /*static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
    static String body;

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
                .withBody(WSSegmentoEliminarMock.getFound())
                .addForAddress(WSSegmentoActualizar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305716');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('La autorización solicitada es inválida.')
                .withStatusCode(404)
                .withBody(WSSegmentoEliminarMock.getError())
                .addForAddress(WSSegmentoActualizar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305716');

        body = '{' +
                    '"fecha_desde": "03/02/2020",' +
                    '"fecha_hasta": "04/02/2020",' +
                    '"usuario": "MAPPLICS"' +
                '}';

    }

    @IsTest
    private static void deleteValidSegment() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
//        String body = '{"username":"CRIOS"}';
        Test.startTest();
        WSSegmentoActualizar.Response resp = WSSegmentoActualizar.actualizarSegmento('275822','305716', body);
        Test.stopTest();

        System.assertEquals(false,resp.hasError);
        System.assertEquals('Ok', resp.message);
        System.assertEquals(null,resp.result.data.em.nro_sf);
        System.assertEquals('275822',resp.result.data.em.em_id);
        System.assertEquals('20-02-0011 20:00',resp.result.data.em.fecha_inicio);
        System.assertEquals('AUTORIZADO',resp.result.data.em.estado);
        System.assertEquals('NO EMITIDO',resp.result.data.em.emitido);
        System.assertEquals(null,resp.result.data.em.alerta);
        System.assertEquals(null,resp.result.data.em.fecha_emision);
        System.assertEquals('700616',resp.result.data.em.efe_codigo_lugar);
        System.assertEquals('1',resp.result.data.em.cons_lugar);
        System.assertEquals('SANATORIO PARQUE',resp.result.data.em.nom_lugar);
        System.assertEquals('CONSULTORIO PPAL PRESTADOR :700616',resp.result.data.em.nom_cons);
        System.assertEquals('758415',resp.result.data.em.efe_codigo_resp);
        System.assertEquals('ZAPATA AGUILA BENJAMIN',resp.result.data.em.nom_resp);
        System.assertEquals('758415',resp.result.data.em.efe_codigo_solic);
        System.assertEquals('ZAPATA AGUILA BENJAMIN',resp.result.data.em.nom_solic);
        System.assertEquals('IA',resp.result.data.em.tem_codigo);
        System.assertEquals('INTERNACION',resp.result.data.em.nom_tipo);
        System.assertEquals('INTERNACION',resp.result.data.em.contexto);
        System.assertEquals('F',resp.result.data.em.de_seguimiento);
        System.assertEquals('F',resp.result.data.em.recupero);
        System.assertEquals('F',resp.result.data.em.diferido);
        System.assertEquals('F',resp.result.data.em.suspendido);
        System.assertEquals(null,resp.result.data.em.fec_vto_certif);
        System.assertEquals('CLINICO',resp.result.data.em.cod_motivo);
        System.assertEquals('CLINICO',resp.result.data.em.nom_motivo);
        System.assertEquals(null,resp.result.data.em.mail);
        System.assertEquals('F10',resp.result.data.em.diag_codigo);
        System.assertEquals('TRASTORNOS MENTALES Y DEL COMPORTAMIENTO DEBIDOS AL USO DE A',resp.result.data.em.diag_nombre);
        System.assertEquals('SIN COMPLICACIONES',resp.result.data.em.complicaciones);
        System.assertEquals(null,resp.result.data.em.grup_pres);
        System.assertEquals(null,resp.result.data.em.gpres_nombre);
        System.assertEquals('02430199',resp.result.data.em.nro_prestacion);
        System.assertEquals('INTERNACION CLINICA (FACTURAR CODIGO PENSION)',resp.result.data.em.nom_prestacion);
        System.assertEquals('1014010046',resp.result.data.em.aut_previa);
        System.assertEquals(null,resp.result.data.em.feem_codigo);
        System.assertEquals(null,resp.result.data.em.feem_nombre);
        System.assertEquals(null,resp.result.data.em.domi_entrega);
        System.assertEquals(null,resp.result.data.em.agenia);
        System.assertEquals(null,resp.result.data.em.otro_domi);
        System.assertEquals(null,resp.result.data.em.via_entrega);
        System.assertEquals(null,resp.result.data.em.domicilio);
        System.assertEquals(null,resp.result.data.em.em_de_seguimiento);
        System.assertEquals(null,resp.result.data.em.tipo_seg);
        System.assertEquals(null,resp.result.data.em.nom_tipo_seg);
        System.assertEquals(null,resp.result.data.em.estado_seg);
        System.assertEquals(null,resp.result.data.em.desc_seg);
        System.assertEquals('INT_CLINICA',resp.result.data.em.cod_regla);
        System.assertEquals('INTERNACION CLINICA',resp.result.data.em.nom_regla);
        System.assertEquals('ABIERTO',resp.result.data.em.sistema);
        System.assertEquals('.',resp.result.data.em.descr_em);
        System.assertEquals('650098_ACA SALUD SUC. ROSARIO',resp.result.data.em.nom_delegacion);
        System.assertEquals(null,resp.result.data.em.obs_em);
        System.assertEquals('274762',resp.result.data.em.afi_afi_id);
        System.assertEquals('1014010046',resp.result.data.em.apr_apr_id);
        System.assertEquals(null,resp.result.data.em.check_mat);
        System.assertEquals(null,resp.result.data.em.check_presu);
        System.assertEquals(null,resp.result.data.em.importe_presu);
        System.assertEquals(null,resp.result.data.em.nro_sf);
        System.assertEquals(2,resp.result.data.em.segmento.size());


        System.assertEquals('275822',resp.result.data.em.segmento[0].em_em_id);
        System.assertEquals('305720',resp.result.data.em.segmento[0].sem_id);
        System.assertEquals('2020-02-18 00:00:00',resp.result.data.em.segmento[0].fecha);
        System.assertEquals('708375',resp.result.data.em.segmento[0].solicitante);
        System.assertEquals('AREVALO JORGE OSCAR',resp.result.data.em.segmento[0].nom_solicitante);
        System.assertEquals('06-02-2020 01:00',resp.result.data.em.segmento[0].fecha_desde_tentativa);
        System.assertEquals('08-02-2020 00:00',resp.result.data.em.segmento[0].fecha_hasta_tentativa);
        System.assertEquals('5114',resp.result.data.em.segmento[0].cant_dias);
        System.assertEquals('AUTORIZADO',resp.result.data.em.segmento[0].estado);
        System.assertEquals(null,resp.result.data.em.segmento[0].cod_auditor);
        System.assertEquals(null,resp.result.data.em.segmento[0].ape_auditor);
        System.assertEquals(null,resp.result.data.em.segmento[0].nom_auditor);
        System.assertEquals('0011-02-20 20:00:00',resp.result.data.em.segmento[0].fecha_real_desde);
        System.assertEquals('0025-02-20 20:00:00',resp.result.data.em.segmento[0].fecha_real_hasta);
        System.assertEquals('MESA CENSO',resp.result.data.em.segmento[0].orig_fecha_real);
        System.assertEquals(null,resp.result.data.em.segmento[0].cod_audito2);
        System.assertEquals(null,resp.result.data.em.segmento[0].ape_auditor2);
        System.assertEquals(null,resp.result.data.em.segmento[0].nom_auditor2);
        System.assertEquals(null,resp.result.data.em.segmento[0].prestador);
        System.assertEquals(' ',resp.result.data.em.segmento[0].pres_nombre);
        System.assertEquals(null,resp.result.data.em.segmento[0].presentacion);
        System.assertEquals(null,resp.result.data.em.segmento[0].lote);
        System.assertEquals(null,resp.result.data.em.segmento[0].obs);


    }

    @IsTest
    private static void deleteInvalidSegment() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
//        String body = '{"username":"CRIOS"}';
        Test.startTest();
        WSSegmentoActualizar.Response resp = WSSegmentoActualizar.actualizarSegmento('275822','305716', body);
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
        System.assertEquals('El segmento solicitado es inválido.', resp.message);
    }*/
}