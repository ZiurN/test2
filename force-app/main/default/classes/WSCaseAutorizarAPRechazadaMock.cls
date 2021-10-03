public class WSCaseAutorizarAPRechazadaMock  {
	public static String getFound() {
		return
			'{' +
				'"error": false,' +
				'"data": {' +
					'"ap": {' +
						'"apr_id": "1014011025",' +
						'"fecha": "2020-05-19 00:00:00",' +
						'"conexion": "CX--MOST",' +
						'"nombre_conexion": "Mostrador",' +
						'"delegacion": "650098",' +
						'"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
						'"fecha_probable": "2020-05-19 00:00:00",' +
						'"estado": "CA-----A",' +
						'"nombre_estado": "CENTRO AUTORIZADOR",' +
						'"user_insert": "CRIOS",' +
						'"fecha_insert": "2020-05-19 11:06:07",' +
						'"codigo_afiliado": "69794/21",' +
						'"apellidos_afiliado": "ORLOW ROBERTO MARTIN",' +
						'"nombres_afiliado": ".",' +
						'"doc_afiliado": "DNI 14631923",' +
						'"evento_medico": null,' +
						'"fecha_prescripcion": null,' +
						'"diagnostico": null,' +
						'"desc_diagnostico": null,' +
						'"prescriptor": null,' +
						'"nombre_prescriptor": null,' +
						'"prestador_dirige": null,' +
						'"nombre_prestador_dirige": null,' +
						'"prestador": null,' +
						'"nombre_prestador": null,' +
						'"consultorio": null,' +
						'"nombre_consultorio": null,' +
						'"observaciones": null,' +
						'"mail": "crios@acasalud.com.ar",' +
						'"otros_mail": null,' +
						'"aca_agencia": null,' +
						'"tran_alta": null,' +
						'"tran_anulacion": null,' +
						'"ref_externa": null,' +
						'"urgente": null,' +
						'"afi_id": "180014",' +
						'"aca_nro_sf": null,' +
						'"nro_sf": null,' +
						'"nivel": "N1",' +
						'"clasificacion": "BAJA COMPLEJIDAD",' +
						'"tipo_ap_sf": "PRESTACION",' +
						'"ap_material": "F",' +
						'"ap_presupuesto": "F",' +
						'"imp_presu": null,' +
						'"prestaciones": [' +
							'{' +
								'"apr_id": "1014011025",' +
								'"estado_prestacion": "C1EA--AA",' +
								'"estado_descripcion": "AUTORIZADO POR EL AUDITOR",' +
								'"contexto": "A",' +
								'"cantidad": "1",' +
								'"prestacion": "02170101",' +
								'"nombre_prestacion": "ELECTROCARDIOGRAMA EN CONSULTORIO",' +
								'"tipo_prestacion": "N",' +
								'"troquel": null,' +
								'"grupo_prestacion": null,' +
								'"pca_id": "74043569",' +
								'"alerta": null,' +
								'"texto_aclarativo": null,' +
								'"importe_plan_sys": "0",' +
								'"importe_plan_aud": null,' +
								'"importe_convenio_sys": "0",' +
								'"importe_convenio_aud": null,' +
								'"importe_cargo_al_socio_sys": "0",' +
								'"importe_cargo_al_socio_aud": null,' +
								'"importe_rein_sys": "0",' +
								'"importe_rein_aud": null,' +
								'"alertas": [' +
									'{' +
										'"pca_pca_id": "74043569",' +
										'"aca_id": "16465740",' +
										'"cca_cca_id": null,' +
										'"control": "202",' +
										'"nombre_control": "REQUIERE DIAGNOSTICO",' +
										'"funcion": "FCION_FRONT",' +
										'"texto_aclarativo": "La prestación requiere que se informe un diagnóstico",' +
										'"nivel_auditoria": "110",' +
										'"estado_alerta": "C1EA-RAA",' +
										'"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
										'"nota_auditor": null,' +
										'"observaciones": null,' +
										'"fecha_generacion": "2020-05-19 11:06:16",' +
										'"fecha_lectura": "2020-05-19 11:06:28",' +
										'"auditor_lee": "CRIOS",' +
										'"fecha_resolucion": "2020-05-19 11:06:30",' +
										'"auditor_resuelve": "CRIOS"' +
									'},' +
									'{' +
										'"pca_pca_id": "74043569",' +
										'"aca_id": "16465741",' +
										'"cca_cca_id": "74106822",' +
										'"control": "201",' +
										'"nombre_control": "REQUIERE PRESCRIPCION",' +
										'"funcion": "FCION_FRONT",' +
										'"texto_aclarativo": "El concepto: UG requiere que se informe prescriptor y fecha de prescripción",' +
										'"nivel_auditoria": "110",' +
										'"estado_alerta": "C1EA-RAA",' +
										'"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
										'"nota_auditor": null,' +
										'"observaciones": null,' +
										'"fecha_generacion": "2020-05-19 11:06:16",' +
										'"fecha_lectura": "2020-05-19 11:06:28",' +
										'"auditor_lee": "CRIOS",' +
										'"fecha_resolucion": "2020-05-19 11:06:30",' +
										'"auditor_resuelve": "CRIOS"' +
									'},' +
									'{' +
										'"pca_pca_id": "74043569",' +
										'"aca_id": "16465742",' +
										'"cca_cca_id": "74106823",' +
										'"control": "201",' +
										'"nombre_control": "REQUIERE PRESCRIPCION",' +
										'"funcion": "FCION_FRONT",' +
										'"texto_aclarativo": "El concepto: GP requiere que se informe prescriptor y fecha de prescripción",' +
										'"nivel_auditoria": "110",' +
										'"estado_alerta": "C1EA-RAA",' +
										'"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
										'"nota_auditor": null,' +
										'"observaciones": null,' +
										'"fecha_generacion": "2020-05-19 11:06:18",' +
										'"fecha_lectura": "2020-05-19 11:06:28",' +
										'"auditor_lee": "CRIOS",' +
										'"fecha_resolucion": "2020-05-19 11:06:30",' +
										'"auditor_resuelve": "CRIOS"' +
									'},' +
									'{' +
										'"pca_pca_id": "74043569",' +
										'"aca_id": "16465743",' +
										'"cca_cca_id": "74106822",' +
										'"control": "APRU_CPTO",' +
										'"nombre_control": "APRUEBA CONCEPTO",' +
										'"funcion": "AUD_ADMIN",' +
										'"texto_aclarativo": "Concepto aprobado por auditor",' +
										'"nivel_auditoria": "105",' +
										'"estado_alerta": "C1EA--AA",' +
										'"descripcion_estado": "AUTORIZADO POR EL AUDITOR",' +
										'"nota_auditor": null,' +
										'"observaciones": "Alerta creado y aprobado al forzar la prestación a Autorizada",' +
										'"fecha_generacion": "2020-05-19 13:08:16",' +
										'"fecha_lectura": "2020-05-19 13:08:16",' +
										'"auditor_lee": "MAPPLICS",' +
										'"fecha_resolucion": "2020-05-19 13:08:16",' +
										'"auditor_resuelve": "MAPPLICS"' +
									'},' +
									'{' +
										'"pca_pca_id": "74043569",' +
										'"aca_id": "16465744",' +
										'"cca_cca_id": "74106823",' +
										'"control": "APRU_CPTO",' +
										'"nombre_control": "APRUEBA CONCEPTO",' +
										'"funcion": "AUD_ADMIN",' +
										'"texto_aclarativo": "Concepto aprobado por auditor",' +
										'"nivel_auditoria": "105",' +
										'"estado_alerta": "C1EA--AA",' +
										'"descripcion_estado": "AUTORIZADO POR EL AUDITOR",' +
										'"nota_auditor": null,' +
										'"observaciones": "Alerta creado y aprobado al forzar la prestación a Autorizada",' +
										'"fecha_generacion": "2020-05-19 13:08:16",' +
										'"fecha_lectura": "2020-05-19 13:08:16",' +
										'"auditor_lee": "MAPPLICS",' +
										'"fecha_resolucion": "2020-05-19 13:08:16",' +
										'"auditor_resuelve": "MAPPLICS"' +
									'},' +
									'{' +
										'"pca_pca_id": "74043569",' +
										'"aca_id": "16465745",' +
										'"cca_cca_id": null,' +
										'"control": "APRU_PREST",' +
										'"nombre_control": "APRUEBA PRESTACIÓN",' +
										'"funcion": "AUD_ADMIN",' +
										'"texto_aclarativo": "Prestación aprobada por auditor",' +
										'"nivel_auditoria": "105",' +
										'"estado_alerta": "C1EA--AA",' +
										'"descripcion_estado": "AUTORIZADO POR EL AUDITOR",' +
										'"nota_auditor": null,' +
										'"observaciones": "Alerta creado y aprobado al forzar la prestación a Autorizada",' +
										'"fecha_generacion": "2020-05-19 13:08:16",' +
										'"fecha_lectura": "2020-05-19 13:08:16",' +
										'"auditor_lee": "MAPPLICS",' +
										'"fecha_resolucion": "2020-05-19 13:08:16",' +
										'"auditor_resuelve": "MAPPLICS"' +
									'}' +
								']' +
							'}' +
						']' +
					'}' +
				'},' +
				'"httpCode": 200,' +
				'"message": "Se autorizó correctamente la AP.",' +
				'"meta": {' +
					'"allowed_includes": [],' +
					'"default_includes": []' +
				'}' +
			'}';
	}

	public static String getError() {
		return
			'{' +
				'"data": {' +
					'"error": true,' +
					'"errors": [],' +
					'"errorType": "exception",' +
					'"httpCode": 404,' +
					'"message": "La autorización solicitada es inválida.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"line": 964' +
				'}' +
			'}';
	}

}