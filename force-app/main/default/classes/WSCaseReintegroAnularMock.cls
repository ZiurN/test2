@isTest
public class WSCaseReintegroAnularMock  {
	
	public static String getFound() {
		return
			'{' +
				'"error": false,' +
				'"data": {' +
					'"reintegro": {' +
						'"lote": "5372",' +
						'"lote_original": "5368",' +
						'"rei_id": "553274",' +
						'"orei_orei_id": "651907",' +
						'"fecha": "2019-02-04 00:00:00",' +
						'"del_os_codigo": "650321",' +
						'"afi_afi_id": "465484",' +
						'"codigo": "195660/10",' +
						'"asociado_nombre": "FRASSE LEANDRO ANDRES",' +
						'"em_em_id": null,' +
						'"efe_codigo_realizador": "764612",' +
						'"efe_codigo_prescriptor": "764612",' +
						'"fecha_prescripcion": "2019-01-23 00:00:00",' +
						'"diag_codigo": "Z71.9",' +
						'"cobro_indeb": "S",' +
						'"razon_social": "VALLEJOS PABLO",' +
						'"cuit": null,' +
						'"tipo_comprobante": "LIQ",' +
						'"nro_comprobante": null,' +
						'"fecha_comprobante": "2019-01-23 00:00:00",' +
						'"importe": "400",' +
						'"vda_drv_estado": "CR-----N",' +
						'"nombre_estado": "ANULADO",' +
						'"nro_sf": null,' +
						'"nivel": "N3",' +
						'"celula": "Celula 8",' +
						'"sla": "80",' +
						'"link_rein": "http://www.extranet.acasalud.com.ar/SF/REIN_553274.pdf",' +
						'"prestaciones": [' +
							'{' +
								'"rei_id": "553274",' +
								'"estado_prestacion": "C1EA--AA",' +
								'"estado_descripcion": "AUTORIZADO POR EL AUDITOR",' +
								'"contexto": "Ambulatorio",' +
								'"cantidad": "1",' +
								'"prestacion": "02420101",' +
								'"nombre_prestacion": "CONSULTA MEDICA",' +
								'"tipo_prestacion": "N",' +
								'"troquel": null,' +
								'"grupo_prestacion": null,' +
								'"pca_id": "74616641",' +
								'"nro_sf": null,' +
								'"cara_pieza_dental": null,' +
								'"importe_pagar": null,' +
								'"pieza_dental": null,' +
								'"texto_aclarativo": null,' +
								'"importe_plan_sys": "0",' +
								'"importe_plan_aud": null,' +
								'"importe_convenio_sys": "0",' +
								'"importe_convenio_aud": null,' +
								'"importe_cargo_al_socio_sys": "0",' +
								'"importe_cargo_al_socio_aud": null,' +
								'"importe_rein_sys": "0",' +
								'"importe_rein_aud": null' +
							'}' +
						']' +
					'}' +
				'},' +
				'"httpCode": 200,' +
				'"message": "Se ha anulado el reintegro correctamente.",' +
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
					'"message": "El reintegro solicitado es inválido.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"line": 964' +
				'}' +
			'}';
	}
}