public class WSLoteOrdenReintegroMock  {

	public static string getFound() {
		return
		'{' +
			'"data": [' +
				'{' +
					'"lr_id": "5381",' +
					'"codigo": "229937/39",' +
					'"afi_nom": "QUIROGA SEEWALD NERINA",' +
					'"fecha": "2020-04-07 09:08:25",' +
					'"orei_id": "651075",' +
					'"orden_pago": "395011",' +
					'"estado": "CR-----E",' +
					'"nombre_estado": "ORDEN EMITIDA",' +
					'"importe": "0",' +
					'"nombre_destinatario": "SEEWALD, NERINA ANAHI",' +
					'"est_financiero": "REEF---C",' +
					'"estado_financiero": "CONTABILIZADO",' +
					'"reintegros": [' +
						'{' +
							'"lote": "5381",' +
							'"lote_original": "5381",' +
							'"rei_id": "553243",' +
							'"orei_orei_id": "651075",' +
							'"fecha": "2020-02-12 00:00:00",' +
							'"del_os_codigo": "650321",' +
							'"afi_afi_id": "523710",' +
							'"codigo": "229937/39",' +
							'"asociado_nombre": "QUIROGA SEEWALD NERINA",' +
							'"em_em_id": null,' +
							'"efe_codigo_realizador": "759433",' +
							'"efe_codigo_prescriptor": "759433",' +
							'"fecha_prescripcion": "2020-02-12 00:00:00",' +
							'"diag_codigo": "R68.8",' +
							'"cobro_indeb": "N",' +
							'"razon_social": null,' +
							'"cuit": null,' +
							'"tipo_comprobante": null,' +
							'"nro_comprobante": null,' +
							'"fecha_comprobante": "2020-02-12 00:00:00",' +
							'"importe": "1000",' +
							'"vda_drv_estado": "CR-----E",' +
							'"nombre_estado": "ORDEN EMITIDA",' +
							'"nro_sf": null' +
						'}' +
					']' +
				'},' +
				'{' +
					'"lr_id": "5381",' +
					'"codigo": "50216/11",' +
					'"afi_nom": "ROBERTS GUILLERMO ROY   .",' +
					'"fecha": "2020-04-07 09:08:25",' +
					'"orei_id": "651076",' +
					'"orden_pago": "395008",' +
					'"estado": "CR-----E",' +
					'"nombre_estado": "ORDEN EMITIDA",' +
					'"importe": "0",' +
					'"nombre_destinatario": "ROBERTS GUILLERMO ROY  ",' +
					'"est_financiero": "REEF---C",' +
					'"estado_financiero": "CONTABILIZADO",' +
					'"reintegros": [' +
						'{' +
							'"lote": "5381",' +
							'"lote_original": "5381",' +
							'"rei_id": "553239",' +
							'"orei_orei_id": "651076",' +
							'"fecha": "2020-02-12 00:00:00",' +
							'"del_os_codigo": "650098",' +
							'"afi_afi_id": "130611",' +
							'"codigo": "50216/11",' +
							'"asociado_nombre": "ROBERTS GUILLERMO ROY   .",' +
							'"em_em_id": null,' +
							'"efe_codigo_realizador": "758415",' +
							'"efe_codigo_prescriptor": "758415",' +
							'"fecha_prescripcion": "2020-01-10 00:00:00",' +
							'"diag_codigo": "999",' +
							'"cobro_indeb": "N",' +
							'"razon_social": null,' +
							'"cuit": null,' +
							'"tipo_comprobante": "FXC",' +
							'"nro_comprobante": null,' +
							'"fecha_comprobante": null,' +
							'"importe": "1000",' +
							'"vda_drv_estado": "CR-----E",' +
							'"nombre_estado": "ORDEN EMITIDA",' +
							'"nro_sf": null' +
						'}' +
					']' +
				'}' +
			'],' +
			'"meta": {' +
				'"allowed_filters": [],' +
				'"allowed_sorts": [],' +
				'"allowed_appends": [],' +
				'"allowed_fields": [],' +
				'"allowed_includes": [],' +
				'"default_includes": [],' +
				'"optional_get_vars": {' +
					'"sortBy": [],' +
					'"sortOrder": [' +
						'"asc",' +
						'"desc"' +
					']' +
				'}' +
			'}' +
		'}';
	}

	public static string getError() {
		return
		'{' +
			'"data": {' +
				'"error": true,' +
				'"errors": [],' +
				'"errorType": "exception",' +
				'"httpCode": 404,' +
				'"message": "El lote solicitado es inválido.",' +
				'"debug_message": [],' +
				'"exception": "NotFoundHttpException",' +
				'"line": 964' +
			'}' +
		'}';
	}
}