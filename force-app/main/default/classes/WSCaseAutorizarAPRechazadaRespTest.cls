//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSCaseAutorizarAPRechazadaRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"error\": false,'+
		'  \"data\": {'+
		'    \"ap\": {'+
		'      \"apr_id\": \"1014011025\",'+
		'      \"fecha\": \"2020-05-19 00:00:00\",'+
		'      \"conexion\": \"CX--MOST\",'+
		'      \"nombre_conexion\": \"Mostrador\",'+
		'      \"delegacion\": \"650098\",'+
		'      \"nombre_delegacion\": \"650098_ACA SALUD SUC. ROSARIO\",'+
		'      \"fecha_probable\": \"2020-05-19 00:00:00\",'+
		'      \"estado\": \"CA-----A\",'+
		'      \"nombre_estado\": \"CENTRO AUTORIZADOR\",'+
		'      \"user_insert\": \"CRIOS\",'+
		'      \"fecha_insert\": \"2020-05-19 11:06:07\",'+
		'      \"codigo_afiliado\": \"69794/21\",'+
		'      \"apellidos_afiliado\": \"ORLOW ROBERTO MARTIN\",'+
		'      \"nombres_afiliado\": \".\",'+
		'      \"doc_afiliado\": \"DNI 14631923\",'+
		'      \"evento_medico\": null,'+
		'      \"fecha_prescripcion\": null,'+
		'      \"diagnostico\": null,'+
		'      \"desc_diagnostico\": null,'+
		'      \"prescriptor\": null,'+
		'      \"nombre_prescriptor\": null,'+
		'      \"prestador_dirige\": null,'+
		'      \"nombre_prestador_dirige\": null,'+
		'      \"prestador\": null,'+
		'      \"nombre_prestador\": null,'+
		'      \"consultorio\": null,'+
		'      \"nombre_consultorio\": null,'+
		'      \"observaciones\": null,'+
		'      \"mail\": \"crios@acasalud.com.ar\",'+
		'      \"otros_mail\": null,'+
		'      \"aca_agencia\": null,'+
		'      \"tran_alta\": null,'+
		'      \"tran_anulacion\": null,'+
		'      \"ref_externa\": null,'+
		'      \"urgente\": null,'+
		'      \"afi_id\": \"180014\",'+
		'      \"aca_nro_sf\": null,'+
		'      \"nro_sf\": null,'+
		'      \"nivel\": \"N1\",'+
		'      \"clasificacion\": \"BAJA COMPLEJIDAD\",'+
		'      \"tipo_ap_sf\": \"PRESTACION\",'+
		'      \"ap_material\": \"F\",'+
		'      \"ap_presupuesto\": \"F\",'+
		'      \"imp_presu\": null,'+
		'      \"prestaciones\": ['+
		'        {'+
		'          \"apr_id\": \"1014011025\",'+
		'          \"estado_prestacion\": \"C1EA--AA\",'+
		'          \"estado_descripcion\": \"AUTORIZADO POR EL AUDITOR\",'+
		'          \"contexto\": \"A\",'+
		'          \"cantidad\": \"1\",'+
		'          \"prestacion\": \"02170101\",'+
		'          \"nombre_prestacion\": \"ELECTROCARDIOGRAMA EN CONSULTORIO\",'+
		'          \"tipo_prestacion\": \"N\",'+
		'          \"troquel\": null,'+
		'          \"grupo_prestacion\": null,'+
		'          \"pca_id\": \"74043569\",'+
		'          \"alerta\": null,'+
		'          \"texto_aclarativo\": null,'+
		'          \"importe_plan_sys\": \"0\",'+
		'          \"importe_plan_aud\": null,'+
		'          \"importe_convenio_sys\": \"0\",'+
		'          \"importe_convenio_aud\": null,'+
		'          \"importe_cargo_al_socio_sys\": \"0\",'+
		'          \"importe_cargo_al_socio_aud\": null,'+
		'          \"importe_rein_sys\": \"0\",'+
		'          \"importe_rein_aud\": null,'+
		'          \"alertas\": ['+
		'            {'+
		'              \"pca_pca_id\": \"74043569\",'+
		'              \"aca_id\": \"16465740\",'+
		'              \"cca_cca_id\": null,'+
		'              \"control\": \"202\",'+
		'              \"nombre_control\": \"REQUIERE DIAGNOSTICO\",'+
		'              \"funcion\": \"FCION_FRONT\",'+
		'              \"texto_aclarativo\": \"La prestación requiere que se informe un diagnóstico\",'+
		'              \"nivel_auditoria\": \"110\",'+
		'              \"estado_alerta\": \"C1EA-RAA\",'+
		'              \"descripcion_estado\": \"RECHAZADO POR EL AUDITOR AL AFILIADO\",'+
		'              \"nota_auditor\": null,'+
		'              \"observaciones\": null,'+
		'              \"fecha_generacion\": \"2020-05-19 11:06:16\",'+
		'              \"fecha_lectura\": \"2020-05-19 11:06:28\",'+
		'              \"auditor_lee\": \"CRIOS\",'+
		'              \"fecha_resolucion\": \"2020-05-19 11:06:30\",'+
		'              \"auditor_resuelve\": \"CRIOS\"'+
		'            },'+
		'            {'+
		'              \"pca_pca_id\": \"74043569\",'+
		'              \"aca_id\": \"16465741\",'+
		'              \"cca_cca_id\": \"74106822\",'+
		'              \"control\": \"201\",'+
		'              \"nombre_control\": \"REQUIERE PRESCRIPCION\",'+
		'              \"funcion\": \"FCION_FRONT\",'+
		'              \"texto_aclarativo\": \"El concepto: UG requiere que se informe prescriptor y fecha de prescripción\",'+
		'              \"nivel_auditoria\": \"110\",'+
		'              \"estado_alerta\": \"C1EA-RAA\",'+
		'              \"descripcion_estado\": \"RECHAZADO POR EL AUDITOR AL AFILIADO\",'+
		'              \"nota_auditor\": null,'+
		'              \"observaciones\": null,'+
		'              \"fecha_generacion\": \"2020-05-19 11:06:16\",'+
		'              \"fecha_lectura\": \"2020-05-19 11:06:28\",'+
		'              \"auditor_lee\": \"CRIOS\",'+
		'              \"fecha_resolucion\": \"2020-05-19 11:06:30\",'+
		'              \"auditor_resuelve\": \"CRIOS\"'+
		'            },'+
		'            {'+
		'              \"pca_pca_id\": \"74043569\",'+
		'              \"aca_id\": \"16465742\",'+
		'              \"cca_cca_id\": \"74106823\",'+
		'              \"control\": \"201\",'+
		'              \"nombre_control\": \"REQUIERE PRESCRIPCION\",'+
		'              \"funcion\": \"FCION_FRONT\",'+
		'              \"texto_aclarativo\": \"El concepto: GP requiere que se informe prescriptor y fecha de prescripción\",'+
		'              \"nivel_auditoria\": \"110\",'+
		'              \"estado_alerta\": \"C1EA-RAA\",'+
		'              \"descripcion_estado\": \"RECHAZADO POR EL AUDITOR AL AFILIADO\",'+
		'              \"nota_auditor\": null,'+
		'              \"observaciones\": null,'+
		'              \"fecha_generacion\": \"2020-05-19 11:06:18\",'+
		'              \"fecha_lectura\": \"2020-05-19 11:06:28\",'+
		'              \"auditor_lee\": \"CRIOS\",'+
		'              \"fecha_resolucion\": \"2020-05-19 11:06:30\",'+
		'              \"auditor_resuelve\": \"CRIOS\"'+
		'            },'+
		'            {'+
		'              \"pca_pca_id\": \"74043569\",'+
		'              \"aca_id\": \"16465743\",'+
		'              \"cca_cca_id\": \"74106822\",'+
		'              \"control\": \"APRU_CPTO\",'+
		'              \"nombre_control\": \"APRUEBA CONCEPTO\",'+
		'              \"funcion\": \"AUD_ADMIN\",'+
		'              \"texto_aclarativo\": \"Concepto aprobado por auditor\",'+
		'              \"nivel_auditoria\": \"105\",'+
		'              \"estado_alerta\": \"C1EA--AA\",'+
		'              \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
		'              \"nota_auditor\": null,'+
		'              \"observaciones\": \"Alerta creado y aprobado al forzar la prestación a Autorizada\",'+
		'              \"fecha_generacion\": \"2020-05-19 13:08:16\",'+
		'              \"fecha_lectura\": \"2020-05-19 13:08:16\",'+
		'              \"auditor_lee\": \"MAPPLICS\",'+
		'              \"fecha_resolucion\": \"2020-05-19 13:08:16\",'+
		'              \"auditor_resuelve\": \"MAPPLICS\"'+
		'            },'+
		'            {'+
		'              \"pca_pca_id\": \"74043569\",'+
		'              \"aca_id\": \"16465744\",'+
		'              \"cca_cca_id\": \"74106823\",'+
		'              \"control\": \"APRU_CPTO\",'+
		'              \"nombre_control\": \"APRUEBA CONCEPTO\",'+
		'              \"funcion\": \"AUD_ADMIN\",'+
		'              \"texto_aclarativo\": \"Concepto aprobado por auditor\",'+
		'              \"nivel_auditoria\": \"105\",'+
		'              \"estado_alerta\": \"C1EA--AA\",'+
		'              \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
		'              \"nota_auditor\": null,'+
		'              \"observaciones\": \"Alerta creado y aprobado al forzar la prestación a Autorizada\",'+
		'              \"fecha_generacion\": \"2020-05-19 13:08:16\",'+
		'              \"fecha_lectura\": \"2020-05-19 13:08:16\",'+
		'              \"auditor_lee\": \"MAPPLICS\",'+
		'              \"fecha_resolucion\": \"2020-05-19 13:08:16\",'+
		'              \"auditor_resuelve\": \"MAPPLICS\"'+
		'            },'+
		'            {'+
		'              \"pca_pca_id\": \"74043569\",'+
		'              \"aca_id\": \"16465745\",'+
		'              \"cca_cca_id\": null,'+
		'              \"control\": \"APRU_PREST\",'+
		'              \"nombre_control\": \"APRUEBA PRESTACIÓN\",'+
		'              \"funcion\": \"AUD_ADMIN\",'+
		'              \"texto_aclarativo\": \"Prestación aprobada por auditor\",'+
		'              \"nivel_auditoria\": \"105\",'+
		'              \"estado_alerta\": \"C1EA--AA\",'+
		'              \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
		'              \"nota_auditor\": null,'+
		'              \"observaciones\": \"Alerta creado y aprobado al forzar la prestación a Autorizada\",'+
		'              \"fecha_generacion\": \"2020-05-19 13:08:16\",'+
		'              \"fecha_lectura\": \"2020-05-19 13:08:16\",'+
		'              \"auditor_lee\": \"MAPPLICS\",'+
		'              \"fecha_resolucion\": \"2020-05-19 13:08:16\",'+
		'              \"auditor_resuelve\": \"MAPPLICS\"'+
		'            }'+
		'          ]'+
		'        }'+
		'      ]'+
		'    }'+
		'  },'+
		'  \"httpCode\": 200,'+
		'  \"message\": \"Se autorizó correctamente la AP.\",'+
		'  \"meta\": {'+
		'    \"allowed_includes\": [],'+
		'    \"default_includes\": []'+
		'  }'+
		'}';
		WSCaseAutorizarAPRechazadaResp r = WSCaseAutorizarAPRechazadaResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseAutorizarAPRechazadaResp.Meta objMeta = new WSCaseAutorizarAPRechazadaResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseAutorizarAPRechazadaResp.Allowed_includes objAllowed_includes = new WSCaseAutorizarAPRechazadaResp.Allowed_includes(System.JSON.createParser(json));
		System.assert(objAllowed_includes != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseAutorizarAPRechazadaResp.Prestaciones objPrestaciones = new WSCaseAutorizarAPRechazadaResp.Prestaciones(System.JSON.createParser(json));
		System.assert(objPrestaciones != null);
		System.assert(objPrestaciones.apr_id == null);
		System.assert(objPrestaciones.estado_prestacion == null);
		System.assert(objPrestaciones.estado_descripcion == null);
		System.assert(objPrestaciones.contexto == null);
		System.assert(objPrestaciones.cantidad == null);
		System.assert(objPrestaciones.prestacion == null);
		System.assert(objPrestaciones.nombre_prestacion == null);
		System.assert(objPrestaciones.tipo_prestacion == null);
		System.assert(objPrestaciones.troquel == null);
		System.assert(objPrestaciones.grupo_prestacion == null);
		System.assert(objPrestaciones.pca_id == null);
		System.assert(objPrestaciones.alerta == null);
		System.assert(objPrestaciones.texto_aclarativo == null);
		System.assert(objPrestaciones.importe_plan_sys == null);
		System.assert(objPrestaciones.importe_plan_aud == null);
		System.assert(objPrestaciones.importe_convenio_sys == null);
		System.assert(objPrestaciones.importe_convenio_aud == null);
		System.assert(objPrestaciones.importe_cargo_al_socio_sys == null);
		System.assert(objPrestaciones.importe_cargo_al_socio_aud == null);
		System.assert(objPrestaciones.importe_rein_sys == null);
		System.assert(objPrestaciones.importe_rein_aud == null);
		System.assert(objPrestaciones.alertas == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseAutorizarAPRechazadaResp objWSCaseAutorizarAPRechazadaResp = new WSCaseAutorizarAPRechazadaResp(System.JSON.createParser(json));
		System.assert(objWSCaseAutorizarAPRechazadaResp != null);
		System.assert(objWSCaseAutorizarAPRechazadaResp.error == null);
		System.assert(objWSCaseAutorizarAPRechazadaResp.data == null);
		System.assert(objWSCaseAutorizarAPRechazadaResp.httpCode == null);
		System.assert(objWSCaseAutorizarAPRechazadaResp.message == null);
		System.assert(objWSCaseAutorizarAPRechazadaResp.meta == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseAutorizarAPRechazadaResp.Data objData = new WSCaseAutorizarAPRechazadaResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.ap == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseAutorizarAPRechazadaResp.Alertas objAlertas = new WSCaseAutorizarAPRechazadaResp.Alertas(System.JSON.createParser(json));
		System.assert(objAlertas != null);
		System.assert(objAlertas.pca_pca_id == null);
		System.assert(objAlertas.aca_id == null);
		System.assert(objAlertas.cca_cca_id == null);
		System.assert(objAlertas.control == null);
		System.assert(objAlertas.nombre_control == null);
		System.assert(objAlertas.funcion == null);
		System.assert(objAlertas.texto_aclarativo == null);
		System.assert(objAlertas.nivel_auditoria == null);
		System.assert(objAlertas.estado_alerta == null);
		System.assert(objAlertas.descripcion_estado == null);
		System.assert(objAlertas.nota_auditor == null);
		System.assert(objAlertas.observaciones == null);
		System.assert(objAlertas.fecha_generacion == null);
		System.assert(objAlertas.fecha_lectura == null);
		System.assert(objAlertas.auditor_lee == null);
		System.assert(objAlertas.fecha_resolucion == null);
		System.assert(objAlertas.auditor_resuelve == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseAutorizarAPRechazadaResp.Ap objAp = new WSCaseAutorizarAPRechazadaResp.Ap(System.JSON.createParser(json));
		System.assert(objAp != null);
		System.assert(objAp.apr_id == null);
		System.assert(objAp.fecha == null);
		System.assert(objAp.conexion == null);
		System.assert(objAp.nombre_conexion == null);
		System.assert(objAp.delegacion == null);
		System.assert(objAp.nombre_delegacion == null);
		System.assert(objAp.fecha_probable == null);
		System.assert(objAp.estado == null);
		System.assert(objAp.nombre_estado == null);
		System.assert(objAp.user_insert == null);
		System.assert(objAp.fecha_insert == null);
		System.assert(objAp.codigo_afiliado == null);
		System.assert(objAp.apellidos_afiliado == null);
		System.assert(objAp.nombres_afiliado == null);
		System.assert(objAp.doc_afiliado == null);
		System.assert(objAp.evento_medico == null);
		System.assert(objAp.fecha_prescripcion == null);
		System.assert(objAp.diagnostico == null);
		System.assert(objAp.desc_diagnostico == null);
		System.assert(objAp.prescriptor == null);
		System.assert(objAp.nombre_prescriptor == null);
		System.assert(objAp.prestador_dirige == null);
		System.assert(objAp.nombre_prestador_dirige == null);
		System.assert(objAp.prestador == null);
		System.assert(objAp.nombre_prestador == null);
		System.assert(objAp.consultorio == null);
		System.assert(objAp.nombre_consultorio == null);
		System.assert(objAp.observaciones == null);
		System.assert(objAp.mail == null);
		System.assert(objAp.otros_mail == null);
		System.assert(objAp.aca_agencia == null);
		System.assert(objAp.tran_alta == null);
		System.assert(objAp.tran_anulacion == null);
		System.assert(objAp.ref_externa == null);
		System.assert(objAp.urgente == null);
		System.assert(objAp.afi_id == null);
		System.assert(objAp.aca_nro_sf == null);
		System.assert(objAp.nro_sf == null);
		System.assert(objAp.nivel == null);
		System.assert(objAp.clasificacion == null);
		System.assert(objAp.tipo_ap_sf == null);
		System.assert(objAp.ap_material == null);
		System.assert(objAp.ap_presupuesto == null);
		System.assert(objAp.imp_presu == null);
		System.assert(objAp.prestaciones == null);
	}
}