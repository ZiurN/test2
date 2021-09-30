public class WSAlertaReintegroAutorizarRespMock  {
	public static String getFound() {
		return
            '{' +
				'"error": false,' +
				'"data": {' +
					'"reintegro": {' +
					'"lote": "5392",' +
					'"lote_original": null,' +
					'"rei_id": "553276",' +
					'"orei_orei_id": null,' +
					'"fecha": "2020-02-20 00:00:00",' +
					'"del_os_codigo": "650098",' +
					'"afi_afi_id": "140978",' +
					'"codigo": "69794/14",' +
					'"asociado_nombre": "RIOS ANA CAROLINA",' +
					'"em_em_id": null,' +
					'"efe_codigo_realizador": "758415",' +
					'"efe_codigo_prescriptor": "758415",' +
					'"fecha_prescripcion": "2020-02-01 00:00:00",' +
					'"diag_codigo": "999",' +
					'"cobro_indeb": "N",' +
					'"razon_social": "PRUEBA REINT",' +
					'"cuit": "27169355865",' +
					'"tipo_comprobante": "RXC",' +
					'"nro_comprobante": "0001-005953",' +
					'"fecha_comprobante": "2020-02-10 00:00:00",' +
					'"importe": "1000",' +
					'"vda_drv_estado": "CR-----A",' +
					'"nombre_estado": "CENTRO AUTORIZADOR",' +
					'"nro_sf": "dasdsa0003",' +
					'"prestaciones": [' +
						'{' +
						'"rei_id": "553276",' +
						'"estado_prestacion": "C1EA--AA",' +
						'"estado_descripcion": "AUTORIZADO POR EL AUDITOR",' +
						'"contexto": "Ambulatorio",' +
						'"cantidad": "1",' +
						'"prestacion": "02170101",' +
						'"nombre_prestacion": "ELECTROCARDIOGRAMA EN CONSULTORIO",' +
						'"tipo_prestacion": "N",' +
						'"troquel": null,' +
						'"grupo_prestacion": null,' +
						'"pca_id": "74043156",' +
						'"cara_pieza_dental": null,' +
						'"importe_pagar": "800",' +
						'"pieza_dental": null,' +
						'"texto_aclarativo": null,' +
						'"importe_plan_sys": "176.68",' +
						'"importe_plan_aud": "800",' +
						'"importe_convenio_sys": "0",' +
						'"importe_convenio_aud": "0",' +
						'"importe_cargo_al_socio_sys": "0",' +
						'"importe_cargo_al_socio_aud": "0",' +
						'"importe_rein_sys": "176.68",' +
						'"importe_rein_aud": "800",' +
						'"alertas": [' +
							'{' +
							'"pca_pca_id": "74043156",' +
							'"aca_id": "16464703",' +
							'"cca_cca_id": null,' +
							'"control": "171",' +
							'"nombre_control": "VIOLACION NORMA AUDITORIA X PERIODO",' +
							'"funcion": "AM",' +
							'"texto_aclarativo": "Los consumos superan en 1 la cantidad indicada por la Norma de Auditoría por período, Código 1XDIA(UNA PRESTACION POR DIA)",' +
							'"nivel_auditoria": "199",' +
							'"estado_alerta": "C1EA--AA",' +
							'"descripcion_estado": "AUTORIZADO POR EL AUDITOR",' +
							'"nota_auditor": null,' +
							'"observaciones": null,' +
							'"fecha_generacion": "2020-04-09 15:46:19",' +
							'"fecha_lectura": "2020-04-10 12:55:24",' +
							'"auditor_lee": "CRIOS",' +
							'"fecha_resolucion": "2020-04-10 12:55:24",' +
							'"auditor_resuelve": "CRIOS"' +
							'},' +
							'{' +
							'"pca_pca_id": "74043156",' +
							'"aca_id": "16464704",' +
							'"cca_cca_id": null,' +
							'"control": "240",' +
							'"nombre_control": "DOBLE FACTURACION",' +
							'"funcion": "FCION_FRONT",' +
							'"texto_aclarativo": "Ya existe un consumo de la prestación 02170101, o de un módulo que la incluye, en la fecha 01/02/2020",' +
							'"nivel_auditoria": "160",' +
							'"estado_alerta": "C1EA--AA",' +
							'"descripcion_estado": "AUTORIZADO POR EL AUDITOR",' +
							'"nota_auditor": null,' +
							'"observaciones": null,' +
							'"fecha_generacion": "2020-04-09 15:46:19",' +
							'"fecha_lectura": "2020-04-10 12:54:42",' +
							'"auditor_lee": "CRIOS",' +
							'"fecha_resolucion": "2020-04-10 12:54:42",' +
							'"auditor_resuelve": "CRIOS"' +
							'},' +
							'{' +
							'"pca_pca_id": "74043156",' +
							'"aca_id": "16464705",' +
							'"cca_cca_id": "74106317",' +
							'"control": "RC",' +
							'"nombre_control": "REINTEGROS COBRO INDEBIDO",' +
							'"funcion": "FCION_FRONT",' +
							'"texto_aclarativo": "Informe de Alerta - ALERTA INFORMADA EN GRABACION",' +
							'"nivel_auditoria": "105",' +
							'"estado_alerta": "C1EA--AA",' +
							'"descripcion_estado": "AUTORIZADO POR EL AUDITOR",' +
							'"nota_auditor": null,' +
							'"observaciones": null,' +
							'"fecha_generacion": "2020-04-09 15:46:20",' +
							'"fecha_lectura": "2020-04-10 12:52:57",' +
							'"auditor_lee": "CRIOS",' +
							'"fecha_resolucion": "2020-04-10 12:52:57",' +
							'"auditor_resuelve": "CRIOS"' +
							'},' +
							'{' +
							'"pca_pca_id": "74043156",' +
							'"aca_id": "16464706",' +
							'"cca_cca_id": "74106318",' +
							'"control": "RC",' +
							'"nombre_control": "REINTEGROS COBRO INDEBIDO",' +
							'"funcion": "FCION_FRONT",' +
							'"texto_aclarativo": "Informe de Alerta - ALERTA INFORMADA EN GRABACION",' +
							'"nivel_auditoria": "105",' +
							'"estado_alerta": "C1EA--AA",' +
							'"descripcion_estado": "AUTORIZADO POR EL AUDITOR",' +
							'"nota_auditor": null,' +
							'"observaciones": null,' +
							'"fecha_generacion": "2020-04-09 15:46:21",' +
							'"fecha_lectura": "2020-04-10 12:29:31",' +
							'"auditor_lee": "CRIOS",' +
							'"fecha_resolucion": "2020-04-10 12:29:31",' +
							'"auditor_resuelve": "CRIOS"' +
							'}' +
						']' +
						'}' +
					']' +
					'}' +
				'},' +
				'"httpCode": 200,' +
				'"message": "Se ha autorizado correctamente el alerta.",' +
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
                    '"errors": {' +
                        '"alerta_id": [' +
                            '"alerta id debe ser numérico."' +
                        ']' +
                    '},' +
                    '"errorType": "exception",' +
                    '"httpCode": 422,' +
                    '"message": "The given data was invalid.",' +
                    '"debug_message": [],' +
                    '"exception": "ValidationException",' +
                    '"line": 126' +
                '}' +
            '}';
	}
}