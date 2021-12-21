@isTest
public with sharing class WSSegmentoEnviarASSHelperTest {
	private static String URL = ConfigUtils.getEndpointsByTipo('eventos-medicos').get('eventos-medicos').Endpoint__c + '/275822/segmentos';
	private static XHttpCalloutMock getResponseFoundEliminar;
    private static XHttpCalloutMock getErrorResponse;
	private static XHttpCalloutMock getResponseAltaOK;
	private static XHttpCalloutMock getResponseAltaError;
    private static String bodyDelete;
	private static String bodyCreate;
	private static String errorResponse = XappiaHelper.getStaticResource('mockEventoMedicoSegmentoActualizarError').body.toString();
	private static String okResponseBody1 = XappiaHelper.getStaticResource('mockEventoMedicoSegmentoEliminar').body.toString();
    static {
        getResponseFoundEliminar = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseFoundEliminar,
			URL + '/305716',
			okResponseBody1
		);
        getErrorResponse = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getErrorResponse,
			URL + '/305716',
			errorResponse,
			404,
			'La autorización solicitada es inválida.'
		);
		getResponseAltaOK = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseAltaOK,
			URL,
			okResponseBody1
		);
		getResponseAltaError = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseAltaError,
			URL,
			errorResponse,
			404,
			'La autorización solicitada es inválida.'
		);
		bodyDelete = '{' +
					'"fecha_desde": "03/02/2020",' +
					'"fecha_hasta": "04/02/2020",' +
					'"usuario": "MAPPLICS"' +
				'}';
		bodyCreate = '{' +
						'"fecha_desde": "06/02/2020",' +
						'"fecha_hasta": "09/02/2020",' +
						'"numero_sf":"asFEge01234564SdQ",' +
                		'"efector":"708375",' +
						'"username":"CRIOS"' +
					'}';
    }
    @IsTest
    private static void deleteValidSegment() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundEliminar);
        Test.startTest();
        WSSegmentoEnviarASSHelper.Response resp = WSSegmentoEnviarASSHelper.enviarASS(bodyDelete, 'eventos-medicos', 'eventos-medicos', '275822', '305716');
        Test.stopTest();
        System.assert(!resp.hasError, 'No debe haber errores');
        System.assertEquals('Ok', resp.message, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.nro_sf, 'Los valores no coinciden');
        System.assertEquals('275822',resp.result.data[0].em.em_id, 'Los valores no coinciden');
        System.assertEquals('20-02-0011 20:00',resp.result.data[0].em.fecha_inicio, 'Los valores no coinciden');
        System.assertEquals('AUTORIZADO',resp.result.data[0].em.estado, 'Los valores no coinciden');
        System.assertEquals('NO EMITIDO',resp.result.data[0].em.emitido, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.alerta, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.fecha_emision, 'Los valores no coinciden');
        System.assertEquals('700616',resp.result.data[0].em.efe_codigo_lugar, 'Los valores no coinciden');
        System.assertEquals('1',resp.result.data[0].em.cons_lugar, 'Los valores no coinciden');
        System.assertEquals('SANATORIO PARQUE',resp.result.data[0].em.nom_lugar, 'Los valores no coinciden');
        System.assertEquals('CONSULTORIO PPAL PRESTADOR :700616',resp.result.data[0].em.nom_cons, 'Los valores no coinciden');
        System.assertEquals('758415',resp.result.data[0].em.efe_codigo_resp, 'Los valores no coinciden');
        System.assertEquals('ZAPATA AGUILA BENJAMIN',resp.result.data[0].em.nom_resp, 'Los valores no coinciden');
        System.assertEquals('758415',resp.result.data[0].em.efe_codigo_solic, 'Los valores no coinciden');
        System.assertEquals('ZAPATA AGUILA BENJAMIN',resp.result.data[0].em.nom_solic, 'Los valores no coinciden');
        System.assertEquals('IA',resp.result.data[0].em.tem_codigo, 'Los valores no coinciden');
        System.assertEquals('INTERNACION',resp.result.data[0].em.nom_tipo, 'Los valores no coinciden');
        System.assertEquals('INTERNACION',resp.result.data[0].em.contexto, 'Los valores no coinciden');
        System.assertEquals('F',resp.result.data[0].em.de_seguimiento, 'Los valores no coinciden');
        System.assertEquals('F',resp.result.data[0].em.recupero, 'Los valores no coinciden');
        System.assertEquals('F',resp.result.data[0].em.diferido, 'Los valores no coinciden');
        System.assertEquals('F',resp.result.data[0].em.suspendido, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.fec_vto_certif, 'Los valores no coinciden');
        System.assertEquals('CLINICO',resp.result.data[0].em.cod_motivo, 'Los valores no coinciden');
        System.assertEquals('CLINICO',resp.result.data[0].em.nom_motivo, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.mail, 'Los valores no coinciden');
        System.assertEquals('F10',resp.result.data[0].em.diag_codigo, 'Los valores no coinciden');
        System.assertEquals('TRASTORNOS MENTALES Y DEL COMPORTAMIENTO DEBIDOS AL USO DE A',resp.result.data[0].em.diag_nombre, 'Los valores no coinciden');
        System.assertEquals('SIN COMPLICACIONES',resp.result.data[0].em.complicaciones, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.grup_pres, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.gpres_nombre, 'Los valores no coinciden');
        System.assertEquals('02430199',resp.result.data[0].em.nro_prestacion, 'Los valores no coinciden');
        System.assertEquals('INTERNACION CLINICA (FACTURAR CODIGO PENSION)',resp.result.data[0].em.nom_prestacion, 'Los valores no coinciden');
        System.assertEquals('1014010046',resp.result.data[0].em.aut_previa, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.feem_codigo, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.feem_nombre, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.domi_entrega, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.agenia, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.otro_domi, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.via_entrega, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.domicilio, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.em_de_seguimiento, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.tipo_seg, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.nom_tipo_seg, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.estado_seg, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.desc_seg, 'Los valores no coinciden');
        System.assertEquals('INT_CLINICA',resp.result.data[0].em.cod_regla, 'Los valores no coinciden');
        System.assertEquals('INTERNACION CLINICA',resp.result.data[0].em.nom_regla, 'Los valores no coinciden');
        System.assertEquals('ABIERTO',resp.result.data[0].em.sistema, 'Los valores no coinciden');
        System.assertEquals('.',resp.result.data[0].em.descr_em, 'Los valores no coinciden');
        System.assertEquals('650098_ACA SALUD SUC. ROSARIO',resp.result.data[0].em.nom_delegacion, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.obs_em, 'Los valores no coinciden');
        System.assertEquals('274762',resp.result.data[0].em.afi_afi_id, 'Los valores no coinciden');
        System.assertEquals('1014010046',resp.result.data[0].em.apr_apr_id, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.check_mat, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.check_presu, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.importe_presu, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.nro_sf, 'Los valores no coinciden');
        System.assertEquals(2,resp.result.data[0].em.segmento.size(), 'Los valores no coinciden');
        System.assertEquals('275822',resp.result.data[0].em.segmento[0].em_em_id, 'Los valores no coinciden');
        System.assertEquals('305720',resp.result.data[0].em.segmento[0].sem_id, 'Los valores no coinciden');
        System.assertEquals('2020-02-18 00:00:00',resp.result.data[0].em.segmento[0].fecha, 'Los valores no coinciden');
        System.assertEquals('708375',resp.result.data[0].em.segmento[0].solicitante, 'Los valores no coinciden');
        System.assertEquals('AREVALO JORGE OSCAR',resp.result.data[0].em.segmento[0].nom_solicitante, 'Los valores no coinciden');
        System.assertEquals('06-02-2020 01:00',resp.result.data[0].em.segmento[0].fecha_desde_tentativa, 'Los valores no coinciden');
        System.assertEquals('08-02-2020 00:00',resp.result.data[0].em.segmento[0].fecha_hasta_tentativa, 'Los valores no coinciden');
        System.assertEquals('5114',resp.result.data[0].em.segmento[0].cant_dias, 'Los valores no coinciden');
        System.assertEquals('AUTORIZADO',resp.result.data[0].em.segmento[0].estado, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].cod_auditor, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].ape_auditor, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].nom_auditor, 'Los valores no coinciden');
        System.assertEquals('0011-02-20 20:00:00',resp.result.data[0].em.segmento[0].fecha_real_desde, 'Los valores no coinciden');
        System.assertEquals('0025-02-20 20:00:00',resp.result.data[0].em.segmento[0].fecha_real_hasta, 'Los valores no coinciden');
        System.assertEquals('MESA CENSO',resp.result.data[0].em.segmento[0].orig_fecha_real, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].cod_audito2, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].ape_auditor2, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].nom_auditor2, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].prestador, 'Los valores no coinciden');
        System.assertEquals(' ',resp.result.data[0].em.segmento[0].pres_nombre, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].presentacion, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].lote, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].obs, 'Los valores no coinciden');
    }
    @IsTest
    private static void deleteInvalidSegment() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
		WSSegmentoEnviarASSHelper.Response resp = WSSegmentoEnviarASSHelper.enviarASS(bodyDelete, 'eventos-medicos', 'eventos-medicos', '275822', '305716');
        Test.stopTest();
        System.assert(resp.hasError, 'Debe haber un error');
        System.assertEquals('El segmento solicitado es inválido.', resp.message, 'El mensaje no indica el error');
    }
	@IsTest
    private static void createValidSegment() {
        Test.setMock(HttpCalloutMock.class, getResponseAltaOK);
        Test.startTest();
		WSSegmentoEnviarASSHelper.Response resp = WSSegmentoEnviarASSHelper.enviarASS(bodyDelete, 'eventos-medicos', 'eventos-medicos', '275822');
        Test.stopTest();
        System.assert(!resp.hasError, 'No debe haber errores');
        System.assertEquals('Ok', resp.message, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.nro_sf, 'Los valores no coinciden');
        System.assertEquals('275822',resp.result.data[0].em.em_id, 'Los valores no coinciden');
        System.assertEquals('20-02-0011 20:00',resp.result.data[0].em.fecha_inicio, 'Los valores no coinciden');
        System.assertEquals('AUTORIZADO',resp.result.data[0].em.estado, 'Los valores no coinciden');
        System.assertEquals('NO EMITIDO',resp.result.data[0].em.emitido, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.alerta, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.fecha_emision, 'Los valores no coinciden');
        System.assertEquals('700616',resp.result.data[0].em.efe_codigo_lugar, 'Los valores no coinciden');
        System.assertEquals('1',resp.result.data[0].em.cons_lugar, 'Los valores no coinciden');
        System.assertEquals('SANATORIO PARQUE',resp.result.data[0].em.nom_lugar, 'Los valores no coinciden');
        System.assertEquals('CONSULTORIO PPAL PRESTADOR :700616',resp.result.data[0].em.nom_cons, 'Los valores no coinciden');
        System.assertEquals('758415',resp.result.data[0].em.efe_codigo_resp, 'Los valores no coinciden');
        System.assertEquals('ZAPATA AGUILA BENJAMIN',resp.result.data[0].em.nom_resp, 'Los valores no coinciden');
        System.assertEquals('758415',resp.result.data[0].em.efe_codigo_solic, 'Los valores no coinciden');
        System.assertEquals('ZAPATA AGUILA BENJAMIN',resp.result.data[0].em.nom_solic, 'Los valores no coinciden');
        System.assertEquals('IA',resp.result.data[0].em.tem_codigo, 'Los valores no coinciden');
        System.assertEquals('INTERNACION',resp.result.data[0].em.nom_tipo, 'Los valores no coinciden');
        System.assertEquals('INTERNACION',resp.result.data[0].em.contexto, 'Los valores no coinciden');
        System.assertEquals('F',resp.result.data[0].em.de_seguimiento, 'Los valores no coinciden');
        System.assertEquals('F',resp.result.data[0].em.recupero, 'Los valores no coinciden');
        System.assertEquals('F',resp.result.data[0].em.diferido, 'Los valores no coinciden');
        System.assertEquals('F',resp.result.data[0].em.suspendido, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.fec_vto_certif, 'Los valores no coinciden');
        System.assertEquals('CLINICO',resp.result.data[0].em.cod_motivo, 'Los valores no coinciden');
        System.assertEquals('CLINICO',resp.result.data[0].em.nom_motivo, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.mail, 'Los valores no coinciden');
        System.assertEquals('F10',resp.result.data[0].em.diag_codigo, 'Los valores no coinciden');
        System.assertEquals('TRASTORNOS MENTALES Y DEL COMPORTAMIENTO DEBIDOS AL USO DE A',resp.result.data[0].em.diag_nombre, 'Los valores no coinciden');
        System.assertEquals('SIN COMPLICACIONES',resp.result.data[0].em.complicaciones, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.grup_pres, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.gpres_nombre, 'Los valores no coinciden');
        System.assertEquals('02430199',resp.result.data[0].em.nro_prestacion, 'Los valores no coinciden');
        System.assertEquals('INTERNACION CLINICA (FACTURAR CODIGO PENSION)',resp.result.data[0].em.nom_prestacion, 'Los valores no coinciden');
        System.assertEquals('1014010046',resp.result.data[0].em.aut_previa, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.feem_codigo, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.feem_nombre, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.domi_entrega, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.agenia, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.otro_domi, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.via_entrega, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.domicilio, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.em_de_seguimiento, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.tipo_seg, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.nom_tipo_seg, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.estado_seg, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.desc_seg, 'Los valores no coinciden');
        System.assertEquals('INT_CLINICA',resp.result.data[0].em.cod_regla, 'Los valores no coinciden');
        System.assertEquals('INTERNACION CLINICA',resp.result.data[0].em.nom_regla, 'Los valores no coinciden');
        System.assertEquals('ABIERTO',resp.result.data[0].em.sistema, 'Los valores no coinciden');
        System.assertEquals('.',resp.result.data[0].em.descr_em, 'Los valores no coinciden');
        System.assertEquals('650098_ACA SALUD SUC. ROSARIO',resp.result.data[0].em.nom_delegacion, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.obs_em, 'Los valores no coinciden');
        System.assertEquals('274762',resp.result.data[0].em.afi_afi_id, 'Los valores no coinciden');
        System.assertEquals('1014010046',resp.result.data[0].em.apr_apr_id, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.check_mat, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.check_presu, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.importe_presu, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.nro_sf, 'Los valores no coinciden');
        System.assertEquals(2,resp.result.data[0].em.segmento.size(), 'Los valores no coinciden');
        System.assertEquals('275822',resp.result.data[0].em.segmento[0].em_em_id, 'Los valores no coinciden');
        System.assertEquals('305720',resp.result.data[0].em.segmento[0].sem_id, 'Los valores no coinciden');
        System.assertEquals('2020-02-18 00:00:00',resp.result.data[0].em.segmento[0].fecha, 'Los valores no coinciden');
        System.assertEquals('708375',resp.result.data[0].em.segmento[0].solicitante, 'Los valores no coinciden');
        System.assertEquals('AREVALO JORGE OSCAR',resp.result.data[0].em.segmento[0].nom_solicitante, 'Los valores no coinciden');
        System.assertEquals('06-02-2020 01:00',resp.result.data[0].em.segmento[0].fecha_desde_tentativa, 'Los valores no coinciden');
        System.assertEquals('08-02-2020 00:00',resp.result.data[0].em.segmento[0].fecha_hasta_tentativa, 'Los valores no coinciden');
        System.assertEquals('5114',resp.result.data[0].em.segmento[0].cant_dias, 'Los valores no coinciden');
        System.assertEquals('AUTORIZADO',resp.result.data[0].em.segmento[0].estado, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].cod_auditor, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].ape_auditor, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].nom_auditor, 'Los valores no coinciden');
        System.assertEquals('0011-02-20 20:00:00',resp.result.data[0].em.segmento[0].fecha_real_desde, 'Los valores no coinciden');
        System.assertEquals('0025-02-20 20:00:00',resp.result.data[0].em.segmento[0].fecha_real_hasta, 'Los valores no coinciden');
        System.assertEquals('MESA CENSO',resp.result.data[0].em.segmento[0].orig_fecha_real, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].cod_audito2, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].ape_auditor2, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].nom_auditor2, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].prestador, 'Los valores no coinciden');
        System.assertEquals(' ',resp.result.data[0].em.segmento[0].pres_nombre, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].presentacion, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].lote, 'Los valores no coinciden');
        System.assertEquals(null,resp.result.data[0].em.segmento[0].obs, 'Los valores no coinciden');
    }
    @IsTest
    private static void createInvalidSegment() {
        Test.setMock(HttpCalloutMock.class, getResponseAltaError);
        Test.startTest();
		WSSegmentoEnviarASSHelper.Response resp = WSSegmentoEnviarASSHelper.enviarASS(bodyDelete, 'eventos-medicos', 'eventos-medicos', '275822');
        Test.stopTest();
        System.assert(resp.hasError, 'Debe haber un error');
        System.assertEquals('El segmento solicitado es inválido.', resp.message, 'El mensaje no indica el error');
    }
}
