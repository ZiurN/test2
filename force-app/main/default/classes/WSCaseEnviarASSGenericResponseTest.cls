@isTest
public class WSCaseEnviarASSGenericResponseTest {
	public static String jsonError = '{'+
			'\"data\": {'+
				'\"error\": true,'+
				'\"errors\": {'+
					'\"familiar.0.nombres\": ['+
						'\"El campo familiar.0.nombres es obligatorio.\"'+
					']'+
				'},'+
				'\"errorType\": \"exception\",'+
				'\"httpCode\": 422,'+
				'\"message\": \"The given data was invalid.\",'+
				'\"debug_message\": [],'+
				'\"exception\": \"ValidationException\",'+
				'\"file\": \"C:\\\\Apache24_64\\\\htdocs\\\\aca_salud_test\\\\vendor\\\\laravel\\\\framework\\\\src\\\\Illuminate\\\\Foundation\\\\Http\\\\FormRequest.php\",'+
				'\"line\": 126'+
			'}'+
		'}';
	public static String json(String notaId, String caseId) {
		return '{'+
			'\"error\": false,'+
			'\"data\": ['+
			'{'+
				'\"sf_id\": \"' + caseId + '\",'+
				'\"solafi_id\": \"725187\",'+
				'\"estado_sol\": \"INCOMPLETA\",'+
				'\"estado_dj\": \"NUEVA\",'+
				'\"codigo_as\": null,'+
				'\"tipo_asoc\": \"DSAFAM\",'+
				'\"afi_id\": null,'+
				'\"empresa_codigo\": \"630001\",'+
				'\"suc_empresa\": \"4\",'+
				'\"notas\": ['+
				'{'+
					'\"nota_id\": \"129163\",'+
					'\"texto_nota\": \"nota de prueba1\",'+
					'\"sf_id\": \"' + notaId + '\"'+
				'}'+
				']'+
			'}'+
			'],'+
			'\"httpCode\": 200,'+
			'\"message\": "Success Message",'+
			'\"meta\": {'+
			'\"allowed_includes\": [],'+
			'\"default_includes\": []'+
			'}'+
		'}';
	}
	public static String json(String notaId) {
		return json(notaId, '');
	}
	public static String jsonUpdate(String validId) {
		return '{'+
			'\"error\": false,'+
			'\"data\": ['+
			'{'+
				'\"sf_id\": \"\",'+
				'\"solafi_id\": \"725187\",'+
				'\"estado_sol\": \"COMPLETA\",'+
				'\"estado_dj\": \"NUEVA\",'+
				'\"codigo_as\": null,'+
				'\"tipo_asoc\": \"DSAFAM\",'+
				'\"afi_id\": null,'+
				'\"empresa_codigo\": \"630001\",'+
				'\"suc_empresa\": \"4\",'+
				'\"notas\": ['+
				'{'+
					'\"nota_id\": \"129163\",'+
					'\"texto_nota\": \"nota de prueba1\",'+
					'\"sf_id\": \"' + validId + '\"'+
				'}' +
				']'+
			'}'+
			'],'+
			'\"httpCode\": 200,'+
			'\"message\": "Success update message.",'+
			'\"meta\": {'+
			'\"allowed_includes\": [],'+
			'\"default_includes\": []'+
			'}'+
		'}';
	}
	static testMethod void testParse() {
		String json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseEnviarASSGenericResponse.Meta objMeta = new WSCaseEnviarASSGenericResponse.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null, 'No debe ser nulo');
		System.assert(objMeta.Allowed_includes == null, 'Debe ser nulo');
		System.assert(objMeta.default_includes == null, 'Debe ser nulo');
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseEnviarASSGenericResponse.Notas objNotas = new WSCaseEnviarASSGenericResponse.Notas(System.JSON.createParser(json));
		System.assert(objNotas != null, 'No debe ser nulo');
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseEnviarASSGenericResponse.Prestaciones objPrestaciones = new WSCaseEnviarASSGenericResponse.Prestaciones(System.JSON.createParser(json));
		System.assert(objPrestaciones != null, 'No debe ser nulo');
		System.assert(objPrestaciones.apr_id == null, 'Debe ser nulo');
		System.assert(objPrestaciones.estado_prestacion == null, 'Debe ser nulo');
		System.assert(objPrestaciones.estado_descripcion == null, 'Debe ser nulo');
		System.assert(objPrestaciones.contexto == null, 'Debe ser nulo');
		System.assert(objPrestaciones.cantidad == null, 'Debe ser nulo');
		System.assert(objPrestaciones.prestacion == null, 'Debe ser nulo');
		System.assert(objPrestaciones.nombre_prestacion == null, 'Debe ser nulo');
		System.assert(objPrestaciones.tipo_prestacion == null, 'Debe ser nulo');
		System.assert(objPrestaciones.troquel == null, 'Debe ser nulo');
		System.assert(objPrestaciones.grupo_prestacion == null, 'Debe ser nulo');
		System.assert(objPrestaciones.pca_id == null, 'Debe ser nulo');
		System.assert(objPrestaciones.alerta == null, 'Debe ser nulo');
		System.assert(objPrestaciones.texto_aclarativo == null, 'Debe ser nulo');
		System.assert(objPrestaciones.importe_plan_sys == null, 'Debe ser nulo');
		System.assert(objPrestaciones.importe_plan_aud == null, 'Debe ser nulo');
		System.assert(objPrestaciones.importe_convenio_sys == null, 'Debe ser nulo');
		System.assert(objPrestaciones.importe_convenio_aud == null, 'Debe ser nulo');
		System.assert(objPrestaciones.importe_cargo_al_socio_sys == null, 'Debe ser nulo');
		System.assert(objPrestaciones.importe_cargo_al_socio_aud == null, 'Debe ser nulo');
		System.assert(objPrestaciones.importe_rein_sys == null, 'Debe ser nulo');
		System.assert(objPrestaciones.importe_rein_aud == null, 'Debe ser nulo');
		System.assert(objPrestaciones.alertas == null, 'Debe ser nulo');
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseEnviarASSGenericResponse.Data objData = new WSCaseEnviarASSGenericResponse.Data(System.JSON.createParser(json));
		System.assert(objData != null, 'No debe ser nulo');
		System.assert(objData.ap == null, 'Debe ser nulo');
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseEnviarASSGenericResponse.Alertas objAlertas = new WSCaseEnviarASSGenericResponse.Alertas(System.JSON.createParser(json));
		System.assert(objAlertas != null, 'No debe ser nulo');
		System.assert(objAlertas.pca_pca_id == null, 'Debe ser nulo');
		System.assert(objAlertas.aca_id == null, 'Debe ser nulo');
		System.assert(objAlertas.cca_cca_id == null, 'Debe ser nulo');
		System.assert(objAlertas.control == null, 'Debe ser nulo');
		System.assert(objAlertas.nombre_control == null, 'Debe ser nulo');
		System.assert(objAlertas.funcion == null, 'Debe ser nulo');
		System.assert(objAlertas.texto_aclarativo == null, 'Debe ser nulo');
		System.assert(objAlertas.nivel_auditoria == null, 'Debe ser nulo');
		System.assert(objAlertas.estado_alerta == null, 'Debe ser nulo');
		System.assert(objAlertas.descripcion_estado == null, 'Debe ser nulo');
		System.assert(objAlertas.nota_auditor == null, 'Debe ser nulo');
		System.assert(objAlertas.observaciones == null, 'Debe ser nulo');
		System.assert(objAlertas.fecha_generacion == null, 'Debe ser nulo');
		System.assert(objAlertas.fecha_lectura == null, 'Debe ser nulo');
		System.assert(objAlertas.auditor_lee == null, 'Debe ser nulo');
		System.assert(objAlertas.fecha_resolucion == null, 'Debe ser nulo');
		System.assert(objAlertas.auditor_resuelve == null, 'Debe ser nulo');
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseEnviarASSGenericResponse objWSCaseEnviarASSGenericResponse = new WSCaseEnviarASSGenericResponse(System.JSON.createParser(json));
		System.assert(objWSCaseEnviarASSGenericResponse != null, 'No debe ser nulo');
		System.assert(objWSCaseEnviarASSGenericResponse.error == null, 'Debe ser nulo');
		System.assert(objWSCaseEnviarASSGenericResponse.data == null, 'Debe ser nulo');
		System.assert(objWSCaseEnviarASSGenericResponse.httpCode == null, 'Debe ser nulo');
		System.assert(objWSCaseEnviarASSGenericResponse.message == null, 'Debe ser nulo');
		System.assert(objWSCaseEnviarASSGenericResponse.meta == null, 'Debe ser nulo');
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseEnviarASSGenericResponse.Ap objAp = new WSCaseEnviarASSGenericResponse.Ap(System.JSON.createParser(json));
		System.assert(objAp != null, 'No debe ser nulo');
		System.assert(objAp.apr_id == null, 'Debe ser nulo');
		System.assert(objAp.fecha == null, 'Debe ser nulo');
		System.assert(objAp.conexion == null, 'Debe ser nulo');
		System.assert(objAp.nombre_conexion == null, 'Debe ser nulo');
		System.assert(objAp.delegacion == null, 'Debe ser nulo');
		System.assert(objAp.nombre_delegacion == null, 'Debe ser nulo');
		System.assert(objAp.fecha_probable == null, 'Debe ser nulo');
		System.assert(objAp.estado == null, 'Debe ser nulo');
		System.assert(objAp.nombre_estado == null, 'Debe ser nulo');
		System.assert(objAp.user_insert == null, 'Debe ser nulo');
		System.assert(objAp.fecha_insert == null, 'Debe ser nulo');
		System.assert(objAp.codigo_afiliado == null, 'Debe ser nulo');
		System.assert(objAp.apellidos_afiliado == null, 'Debe ser nulo');
		System.assert(objAp.nombres_afiliado == null, 'Debe ser nulo');
		System.assert(objAp.doc_afiliado == null, 'Debe ser nulo');
		System.assert(objAp.evento_medico == null, 'Debe ser nulo');
		System.assert(objAp.fecha_prescripcion == null, 'Debe ser nulo');
		System.assert(objAp.diagnostico == null, 'Debe ser nulo');
		System.assert(objAp.desc_diagnostico == null, 'Debe ser nulo');
		System.assert(objAp.prescriptor == null, 'Debe ser nulo');
		System.assert(objAp.nombre_prescriptor == null, 'Debe ser nulo');
		System.assert(objAp.prestador_dirige == null, 'Debe ser nulo');
		System.assert(objAp.nombre_prestador_dirige == null, 'Debe ser nulo');
		System.assert(objAp.prestador == null, 'Debe ser nulo');
		System.assert(objAp.nombre_prestador == null, 'Debe ser nulo');
		System.assert(objAp.consultorio == null, 'Debe ser nulo');
		System.assert(objAp.nombre_consultorio == null, 'Debe ser nulo');
		System.assert(objAp.observaciones == null, 'Debe ser nulo');
		System.assert(objAp.mail == null, 'Debe ser nulo');
		System.assert(objAp.otros_mail == null, 'Debe ser nulo');
		System.assert(objAp.aca_agencia == null, 'Debe ser nulo');
		System.assert(objAp.tran_alta == null, 'Debe ser nulo');
		System.assert(objAp.tran_anulacion == null, 'Debe ser nulo');
		System.assert(objAp.ref_externa == null, 'Debe ser nulo');
		System.assert(objAp.urgente == null, 'Debe ser nulo');
		System.assert(objAp.afi_id == null, 'Debe ser nulo');
		System.assert(objAp.nro_sf == null, 'Debe ser nulo');
		System.assert(objAp.nivel == null, 'Debe ser nulo');
		System.assert(objAp.clasificacion == null, 'Debe ser nulo');
		System.assert(objAp.tipo_ap_sf == null, 'Debe ser nulo');
		System.assert(objAp.ap_material == null, 'Debe ser nulo');
		System.assert(objAp.ap_presupuesto == null, 'Debe ser nulo');
		System.assert(objAp.celula == null, 'Debe ser nulo');
		System.assert(objAp.sla == null, 'Debe ser nulo');
		System.assert(objAp.estado_em == null, 'Debe ser nulo');
		System.assert(objAp.prestaciones == null, 'Debe ser nulo');
	}
	@isTest
	static void testParseSolicitudResponse () {
		WSCaseEnviarASSGenericResponse obj = WSCaseEnviarASSGenericResponse.parse(json('someId'));
		System.assert(obj != null, 'No debe ser nulo');
		System.assert(!obj.error, 'No deben haber errores');
		System.assertEquals(200, obj.httpCode, 'El código debe ser 200');
		System.assertEquals('Success Message', obj.message, 'EL mensaje debe ser de éxito');
		System.assertEquals(1, obj.data.size(), 'Debe haber un data');
	}
	@isTest
	static void testParseSolicitudErrorResponse () {
		WSCaseEnviarASSGenericResponse obj = WSCaseEnviarASSGenericResponse.parse(jsonError);
		System.assert(obj != null, 'No debe ser nulo');
		System.assert(obj.data != null, 'No debe ser nulo');
		System.assertEquals(1, obj.data.size(), 'Debe haber un objeto Data');
		WSCaseEnviarASSGenericResponse.Data data = obj.data[0];
		System.assert(data.error, 'Debe haber un error');
		System.assertEquals('exception', data.errorType, 'El error debe ser de tipo excepción');
		Map<String, String[]> errors = data.errors.errors;
		System.assertEquals('El campo familiar.0.nombres es obligatorio.', errors.get('familiar.0.nombres')[0], 'El mensaje debe indicar el error');
	}
	@isTest
	static void testParseAPResponse () {
		String json = '{'+
			'\"error\": false,'+
			'\"data\": {'+
				'\"ap\": ['+
					'{'+
						'\"apr_id\": \"1014010605\",'+
						'\"fecha\": \"2020-03-03 00:00:00\",'+
						'\"conexion\": \"CX--MOST\",'+
						'\"nombre_conexion\": \"Mostrador\",'+
						'\"delegacion\": \"650098\",'+
						'\"nombre_delegacion\": \"650098_ACA SALUD SUC. ROSARIO\",'+
						'\"fecha_probable\": \"2020-03-02 00:00:00\",'+
						'\"estado\": \"CA-----A\",'+
						'\"nombre_estado\": \"CENTRO AUTORIZADOR\",'+
						'\"user_insert\": \"CRIOS\",'+
						'\"fecha_insert\": \"2020-03-26 10:21:42\",'+
						'\"codigo_afiliado\": \"2722/12\",'+
						'\"apellidos_afiliado\": \"PUSSETTO CELESTINO\",'+
						'\"nombres_afiliado\": \".\",'+
						'\"doc_afiliado\": \"DNI 06583495\",'+
						'\"evento_medico\": null,'+
						'\"fecha_prescripcion\": \"2020-01-31 00:00:00\",'+
						'\"diagnostico\": \"999\",'+
						'\"desc_diagnostico\": \"DIAGNOSTICO INDETERMINADO\",'+
						'\"prescriptor\": \"758415\",'+
						'\"nombre_prescriptor\": \"ZAPATA AGUILA BENJAMIN\",'+
						'\"prestador_dirige\": \"700125\",'+
						'\"nombre_prestador_dirige\": \"INST. GAMMA\",'+
						'\"prestador\": \"700125\",'+
						'\"nombre_prestador\": \"INST. GAMMA\",'+
						'\"consultorio\": \"1\",'+
						'\"nombre_consultorio\": \"CONSULTORIO PPAL PRESTADOR :700125\",'+
						'\"observaciones\": \"Cambios\",'+
						'\"mail\": \"test@mapplics.com\",'+
						'\"otros_mail\": null,'+
						'\"aca_agencia\": null,'+
						'\"tran_alta\": null,'+
						'\"tran_anulacion\": null,'+
						'\"ref_externa\": null,'+
						'\"urgente\": null,'+
						'\"afi_id\": \"133234\",'+
						'\"nro_sf\": \"543262sf\",'+
						'\"nivel\": \"N1\",'+
						'\"clasificacion\": \"BAJA COMPLEJIDAD\",'+
						'\"tipo_ap_sf\": \"PRESTACION\",'+
						'\"ap_material\": \"F\",'+
						'\"ap_presupuesto\": \"F\",'+
				'\"celula\": \"Celula 2\",' +
			' \"sla\": \"24\",' +
			' \"estado_em\": \"Autorizado\",' +
						'\"prestaciones\": ['+
							'{'+
								'\"apr_id\": \"1014010605\",'+
								'\"estado_prestacion\": \"C1-----A\",'+
								'\"estado_descripcion\": \"EN AUDITORIA\",'+
								'\"contexto\": \"Ambulatorio\",'+
								'\"cantidad\": \"1\",'+
								'\"prestacion\": \"02170101\",'+
								'\"nombre_prestacion\": \"ELECTROCARDIOGRAMA EN CONSULTORIO\",'+
								'\"tipo_prestacion\": \"N\",'+
								'\"troquel\": null,'+
								'\"grupo_prestacion\": null,'+
								'\"pca_id\": \"74042932\",'+
								'\"alerta\": null,'+
								'\"texto_aclarativo\": \"ALERTA SAM\",'+
								'\"importe_plan_sys\": \"0\",'+
								'\"importe_plan_aud\": \"0\",'+
								'\"importe_convenio_sys\": \"308.8\",'+
								'\"importe_convenio_aud\": \"0\",'+
								'\"importe_cargo_al_socio_sys\": \"0\",'+
								'\"importe_cargo_al_socio_aud\": \"0\",'+
								'\"importe_rein_sys\": \"0\",'+
								'\"importe_rein_aud\": \"0\",'+
								'\"alertas\": ['+
									'{'+
										'\"pca_pca_id\": \"74042932\",'+
										'\"aca_id\": \"16463780\",'+
										'\"cca_cca_id\": null,'+
										'\"control\": \"210\",'+
										'\"nombre_control\": \"PRESTACION CUBIERTA\",'+
										'\"funcion\": \"FCION_FRONT\",'+
										'\"texto_aclarativo\": \"La Prestación/Medicamento no está cubierta para el Afiliado\",'+
										'\"nivel_auditoria\": \"120\",'+
										'\"estado_alerta\": \"C1-----A\",'+
										'\"descripcion_estado\": \"EN AUDITORIA\",'+
										'\"nota_auditor\": null,'+
										'\"observaciones\": null,'+
										'\"fecha_generacion\": \"2020-03-26 11:17:47\",'+
										'\"fecha_lectura\": null,'+
										'\"auditor_lee\": null,'+
										'\"fecha_resolucion\": null,'+
										'\"auditor_resuelve\": null'+
									'},'+
									'{'+
										'\"pca_pca_id\": \"74042932\",'+
										'\"aca_id\": \"16463782\",'+
										'\"cca_cca_id\": \"74105942\",'+
										'\"control\": \"210\",'+
										'\"nombre_control\": \"PRESTACION CUBIERTA\",'+
										'\"funcion\": \"FCION_FRONT\",'+
										'\"texto_aclarativo\": \"La Prestación/Medicamento no está cubierta para el Afiliado\",'+
										'\"nivel_auditoria\": \"120\",'+
										'\"estado_alerta\": \"C1-----A\",'+
										'\"descripcion_estado\": \"EN AUDITORIA\",'+
										'\"nota_auditor\": null,'+
										'\"observaciones\": null,'+
										'\"fecha_generacion\": \"2020-03-26 11:17:49\",'+
										'\"fecha_lectura\": null,'+
										'\"auditor_lee\": null,'+
										'\"fecha_resolucion\": null,'+
										'\"auditor_resuelve\": null'+
									'},'+
									'{'+
										'\"pca_pca_id\": \"74042932\",'+
										'\"aca_id\": \"16463783\",'+
										'\"cca_cca_id\": \"74105943\",'+
										'\"control\": \"210\",'+
										'\"nombre_control\": \"PRESTACION CUBIERTA\",'+
										'\"funcion\": \"FCION_FRONT\",'+
										'\"texto_aclarativo\": \"La Prestación/Medicamento no está cubierta para el Afiliado\",'+
										'\"nivel_auditoria\": \"120\",'+
										'\"estado_alerta\": \"C1-----A\",'+
										'\"descripcion_estado\": \"EN AUDITORIA\",'+
										'\"nota_auditor\": null,'+
										'\"observaciones\": null,'+
										'\"fecha_generacion\": \"2020-03-26 11:17:49\",'+
										'\"fecha_lectura\": null,'+
										'\"auditor_lee\": null,'+
										'\"fecha_resolucion\": null,'+
										'\"auditor_resuelve\": null'+
									'}'+
								']'+
							'},'+
							'{'+
								'\"apr_id\": \"1014010605\",'+
								'\"estado_prestacion\": \"C1-----A\",'+
								'\"estado_descripcion\": \"EN AUDITORIA\",'+
								'\"contexto\": \"Ambulatorio\",'+
								'\"cantidad\": \"1\",'+
								'\"prestacion\": \"02170111\",'+
								'\"nombre_prestacion\": \"ERGOMETRIA\",'+
								'\"tipo_prestacion\": \"N\",'+
								'\"troquel\": null,'+
								'\"grupo_prestacion\": null,'+
								'\"pca_id\": \"74042933\",'+
								'\"alerta\": null,'+
								'\"texto_aclarativo\": \"ALERTA SAM\",'+
								'\"importe_plan_sys\": \"0\",'+
								'\"importe_plan_aud\": \"0\",'+
								'\"importe_convenio_sys\": \"762\",'+
								'\"importe_convenio_aud\": \"0\",'+
								'\"importe_cargo_al_socio_sys\": \"0\",'+
								'\"importe_cargo_al_socio_aud\": \"0\",'+
								'\"importe_rein_sys\": \"0\",'+
								'\"importe_rein_aud\": \"0\",'+
								'\"alertas\": ['+
									'{'+
										'\"pca_pca_id\": \"74042933\",'+
										'\"aca_id\": \"16463784\",'+
										'\"cca_cca_id\": null,'+
										'\"control\": \"210\",'+
										'\"nombre_control\": \"PRESTACION CUBIERTA\",'+
										'\"funcion\": \"FCION_FRONT\",'+
										'\"texto_aclarativo\": \"La Prestación/Medicamento no está cubierta para el Afiliado\",'+
										'\"nivel_auditoria\": \"120\",'+
										'\"estado_alerta\": \"C1-----A\",'+
										'\"descripcion_estado\": \"EN AUDITORIA\",'+
										'\"nota_auditor\": null,'+
										'\"observaciones\": null,'+
										'\"fecha_generacion\": \"2020-03-26 11:17:49\",'+
										'\"fecha_lectura\": null,'+
										'\"auditor_lee\": null,'+
										'\"fecha_resolucion\": null,'+
										'\"auditor_resuelve\": null'+
									'},'+
									'{'+
										'\"pca_pca_id\": \"74042933\",'+
										'\"aca_id\": \"16463786\",'+
										'\"cca_cca_id\": \"74105944\",'+
										'\"control\": \"210\",'+
										'\"nombre_control\": \"PRESTACION CUBIERTA\",'+
										'\"funcion\": \"FCION_FRONT\",'+
										'\"texto_aclarativo\": \"La Prestación/Medicamento no está cubierta para el Afiliado\",'+
										'\"nivel_auditoria\": \"120\",'+
										'\"estado_alerta\": \"C1-----A\",'+
										'\"descripcion_estado\": \"EN AUDITORIA\",'+
										'\"nota_auditor\": null,'+
										'\"observaciones\": null,'+
										'\"fecha_generacion\": \"2020-03-26 11:17:51\",'+
										'\"fecha_lectura\": null,'+
										'\"auditor_lee\": null,'+
										'\"fecha_resolucion\": null,'+
										'\"auditor_resuelve\": null'+
									'},'+
									'{'+
										'\"pca_pca_id\": \"74042933\",'+
										'\"aca_id\": \"16463787\",'+
										'\"cca_cca_id\": \"74105945\",'+
										'\"control\": \"210\",'+
										'\"nombre_control\": \"PRESTACION CUBIERTA\",'+
										'\"funcion\": \"FCION_FRONT\",'+
										'\"texto_aclarativo\": \"La Prestación/Medicamento no está cubierta para el Afiliado\",'+
										'\"nivel_auditoria\": \"120\",'+
										'\"estado_alerta\": \"C1-----A\",'+
										'\"descripcion_estado\": \"EN AUDITORIA\",'+
										'\"nota_auditor\": null,'+
										'\"observaciones\": null,'+
										'\"fecha_generacion\": \"2020-03-26 11:17:51\",'+
										'\"fecha_lectura\": null,'+
										'\"auditor_lee\": null,'+
										'\"fecha_resolucion\": null,'+
										'\"auditor_resuelve\": null'+
									'}'+
								']'+
							'}'+
						']'+
					'}'+
				']'+
			'},'+
			'\"httpCode\": 200,'+
			'\"message\": \"Se actualizó correctamente la autorización previa.\",'+
			'\"meta\": {'+
				'\"allowed_includes\": [],'+
				'\"default_includes\": []'+
			'}'+
		'}';
		WSCaseEnviarASSGenericResponse obj = WSCaseEnviarASSGenericResponse.parse(json);
		System.assert(obj != null, 'No debe ser nulo');
		System.assert(obj.data[0].ap != null, 'No debe ser nulo');
	}
	@isTest
	static void testParseAPErrorResponse () {
		String json = WSCaseAPGenerarCentroMock.getError();
		WSCaseEnviarASSGenericResponse obj = WSCaseEnviarASSGenericResponse.parse(json);
		System.assert(obj != null, 'No debe ser nulo');
		System.assert(obj.data != null, 'No debe ser nulo');
		System.assertEquals(1, obj.data.size(), 'Debe haber un objeto Data');
		WSCaseEnviarASSGenericResponse.Data data = obj.data[0];
		System.assert(data.error, 'Debe haber error');
		System.assertEquals('exception', data.errorType, 'El error debe ser de tipo excepción');
		System.assertEquals(422, data.httpCode, 'El error debe ser de tipo excepción');
		System.assertEquals('The given data was invalid.', data.message, 'El mensaje debe indicar el error');
		System.assertEquals('ValidationException', data.exception_text, 'Debe indicar el tipo de excepción');
		System.assertEquals(126, data.line, 'Debe indicar una línea');
	}
	@isTest
	static void testParseReintegroResponse () {
		String json = '{'+
			'\"error\": false,'+
			'\"data\": {'+
			'\"reintegro\": {'+
				'\"lote\": \"5392\",'+
				'\"lote_original\": null,'+
				'\"rei_id\": \"553276\",'+
				'\"orei_orei_id\": null,'+
				'\"fecha\": \"2020-02-20 00:00:00\",'+
				'\"del_os_codigo\": \"650098\",'+
				'\"afi_afi_id\": \"140978\",'+
				'\"codigo\": \"69794/14\",'+
				'\"asociado_nombre\": \"RIOS ANA CAROLINA\",'+
				'\"em_em_id\": null,'+
				'\"efe_codigo_realizador\": \"758415\",'+
				'\"efe_codigo_prescriptor\": \"758415\",'+
				'\"fecha_prescripcion\": \"2020-02-01 00:00:00\",'+
				'\"diag_codigo\": \"999\",'+
				'\"cobro_indeb\": \"N\",'+
				'\"razon_social\": \"PRUEBA REINT\",'+
				'\"cuit\": \"27169355865\",'+
				'\"tipo_comprobante\": \"RXC\",'+
				'\"nro_comprobante\": \"0001-005953\",'+
				'\"fecha_comprobante\": \"2020-02-10 00:00:00\",'+
				'\"importe\": \"1000\",'+
				'\"vda_drv_estado\": \"CR-----A\",'+
				'\"nombre_estado\": \"CENTRO AUTORIZADOR\",'+
				'\"nro_sf\": \"dasdsa0003\",'+
				'\"nivel\": \"N3\",'+
				'\"celula\": \"Celula 8\",' +
			'\"sla\": \"240\",' +
			'\"link_rein\": \"http://www.extranet.acasalud.com.ar/SF/REIN_553517.pdf\",'+
				'\"prestaciones\": ['+
				'{'+
					'\"rei_id\": \"553276\",'+
			' \"nro_sf\": \"dasdsa0003\",'+
					'\"estado_prestacion\": \"C1-----A\",'+
					'\"estado_descripcion\": \"EN AUDITORIA\",'+
					'\"contexto\": \"Ambulatorio\",'+
					'\"cantidad\": \"1\",'+
					'\"prestacion\": \"02170101\",'+
					'\"nombre_prestacion\": \"ELECTROCARDIOGRAMA EN CONSULTORIO\",'+
					'\"tipo_prestacion\": \"N\",'+
					'\"troquel\": null,'+
					'\"grupo_prestacion\": null,'+
					'\"pca_id\": \"74043156\",'+
					'\"cara_pieza_dental\": null,'+
					'\"importe_pagar\": \"800\",'+
					'\"pieza_dental\": null,'+
					'\"texto_aclarativo\": null,'+
					'\"importe_plan_sys\": \"176.68\",'+
					'\"importe_plan_aud\": \"800\",'+
					'\"importe_convenio_sys\": \"0\",'+
					'\"importe_convenio_aud\": \"0\",'+
					'\"importe_cargo_al_socio_sys\": \"0\",'+
					'\"importe_cargo_al_socio_aud\": \"0\",'+
					'\"importe_rein_sys\": \"176.68\",'+
					'\"importe_rein_aud\": \"800\",'+
					'\"alertas\": ['+
					'{'+
						'\"pca_pca_id\": \"74043156\",'+
						'\"aca_id\": \"16464703\",'+
						'\"cca_cca_id\": null,'+
						'\"control\": \"171\",'+
						'\"nombre_control\": \"VIOLACION NORMA AUDITORIA X PERIODO\",'+
						'\"funcion\": \"AM\",'+
						'\"texto_aclarativo\": \"Los consumos superan en 1 la cantidad indicada por la Norma de Auditoría por período, Código 1XDIA(UNA PRESTACION POR DIA)\",'+
						'\"nivel_auditoria\": \"199\",'+
						'\"estado_alerta\": \"C1-----A\",'+
						'\"descripcion_estado\": \"EN AUDITORIA\",'+
						'\"nota_auditor\": null,'+
						'\"observaciones\": null,'+
						'\"fecha_generacion\": \"2020-04-09 15:46:19\",'+
						'\"fecha_lectura\": null,'+
						'\"auditor_lee\": null,'+
						'\"fecha_resolucion\": null,'+
						'\"auditor_resuelve\": null'+
					'},'+
					'{'+
						'\"pca_pca_id\": \"74043156\",'+
						'\"aca_id\": \"16464704\",'+
						'\"cca_cca_id\": null,'+
						'\"control\": \"240\",'+
						'\"nombre_control\": \"DOBLE FACTURACION\",'+
						'\"funcion\": \"FCION_FRONT\",'+
						'\"texto_aclarativo\": \"Ya existe un consumo de la prestación 02170101, o de un módulo que la incluye, en la fecha 01/02/2020\",'+
						'\"nivel_auditoria\": \"160\",'+
						'\"estado_alerta\": \"C1-----A\",'+
						'\"descripcion_estado\": \"EN AUDITORIA\",'+
						'\"nota_auditor\": null,'+
						'\"observaciones\": null,'+
						'\"fecha_generacion\": \"2020-04-09 15:46:19\",'+
						'\"fecha_lectura\": null,'+
						'\"auditor_lee\": null,'+
						'\"fecha_resolucion\": null,'+
						'\"auditor_resuelve\": null'+
					'},'+
					'{'+
						'\"pca_pca_id\": \"74043156\",'+
						'\"aca_id\": \"16464705\",'+
						'\"cca_cca_id\": \"74106317\",'+
						'\"control\": \"RC\",'+
						'\"nombre_control\": \"REINTEGROS COBRO INDEBIDO\",'+
						'\"funcion\": \"FCION_FRONT\",'+
						'\"texto_aclarativo\": \"Informe de Alerta - ALERTA INFORMADA EN GRABACION\",'+
						'\"nivel_auditoria\": \"105\",'+
						'\"estado_alerta\": \"C1-----A\",'+
						'\"descripcion_estado\": \"EN AUDITORIA\",'+
						'\"nota_auditor\": null,'+
						'\"observaciones\": null,'+
						'\"fecha_generacion\": \"2020-04-09 15:46:20\",'+
						'\"fecha_lectura\": null,'+
						'\"auditor_lee\": null,'+
						'\"fecha_resolucion\": null,'+
						'\"auditor_resuelve\": null'+
					'},'+
					'{'+
						'\"pca_pca_id\": \"74043156\",'+
						'\"aca_id\": \"16464706\",'+
						'\"cca_cca_id\": \"74106318\",'+
						'\"control\": \"RC\",'+
						'\"nombre_control\": \"REINTEGROS COBRO INDEBIDO\",'+
						'\"funcion\": \"FCION_FRONT\",'+
						'\"texto_aclarativo\": \"Informe de Alerta - ALERTA INFORMADA EN GRABACION\",'+
						'\"nivel_auditoria\": \"105\",'+
						'\"estado_alerta\": \"C1-----A\",'+
						'\"descripcion_estado\": \"EN AUDITORIA\",'+
						'\"nota_auditor\": null,'+
						'\"observaciones\": null,'+
						'\"fecha_generacion\": \"2020-04-09 15:46:21\",'+
						'\"fecha_lectura\": null,'+
						'\"auditor_lee\": null,'+
						'\"fecha_resolucion\": null,'+
						'\"auditor_resuelve\": null'+
					'}'+
					']'+
				'}'+
				']'+
			'}'+
			'},'+
			'\"httpCode\": 200,'+
			'\"message\": \"El reintegro fue cargado satisfactoriamente.\",'+
			'\"meta\": {'+
			'\"allowed_includes\": [],'+
			'\"default_includes\": []'+
			'}'+
		'}';
		WSCaseEnviarASSGenericResponse r = WSCaseEnviarASSGenericResponse.parse(json);
		System.assert(r != null, 'No debe ser nulo');
	}
	/** El cuerpo de la propiedad Errors cambia */
	@isTest
	static void testParseReintegroAltaError () {
		String jsonError = '{' +
							'"data": {' +
							'"error": true,' +
							'"errors": {' +
								'"message": "ERROR AL DAR DE ALTA REINTEGRO . reintegro 636550 no tiene CBU y la modalidad de pago es transferencia",' +
								'"debug_message": {' +
								'"ERROR AL DAR DE ALTA REINTEGRO ORA-20002": [' +
									'"El reintegro 636550 no tiene CBU y la modalidad de pago es transferencia",' +
									'"ORA-06512: at LIBRERIA.LIB_ERROR, line 421",' +
									'"ORA-06512: at LIBRERIA.LIB_ERROR, line 527",' +
									'"ORA-06512: at SALUD.SA_REI_TRG3, line 50",' +
									'"ORA-04088: error during execution of trigger \'SALUD.SA_REI_TRG3\'"' +
								']' +
								'}' +
							'},' +
							'"data": null,' +
							'"httpCode": 400,' +
							'"message": "No se pudo generar el reintegro."' +
							'}' +
						'}';
		String errorMsg = 'ERROR AL DAR DE ALTA REINTEGRO . reintegro 636550 no tiene CBU y la modalidad de pago es transferencia\n';
		WSCaseEnviarASSGenericResponse r = WSCaseEnviarASSGenericResponse.parse(jsonError);
		System.assert(r != null, 'No debe ser nulo');
		System.assertEquals(errorMsg, r.processMessage(), 'El mensaje de error debe ser claro y estar dentro del objeto');
	}
	@IsTest
	static void testParseAPError () {
		String jsonError = '{"data":{"error":true,"errors":{"message":"No se pudo actualizar la autorizaci\u00f3n previa. Es presupuesto y la AP no tiene prestador","debug_message":""},"data":null,"httpCode":500,"message":"No se pudo actualizar la autorizaci\u00f3n previa. Es presupuesto y la AP no tiene prestador"}}';
		String errorMsg = 'ERROR AL DAR DE ALTA REINTEGRO . reintegro 636550 no tiene CBU y la modalidad de pago es transferencia\n';
		WSCaseEnviarASSGenericResponse r = WSCaseEnviarASSGenericResponse.parse(jsonError);
		System.assert(r != null, 'No debe ser nulo');
		System.assertEquals(errorMsg, r.processMessage(), 'El mensaje de error debe ser claro y estar dentro del objeto');
	}
}