public class WSPrestacionAPActualizarImporteMock  {
	public static String getFound() {
		return
			'{' +
				'"error": false,' +
				'"data": [' +
					'{' +
						'"apr_id": "1014009728",' +
						'"estado_prestacion": "C1-----A",' +
						'"estado_descripcion": "EN AUDITORIA",' +
						'"contexto": "Ambulatorio",' +
						'"cantidad": "1",' +
						'"prestacion": "707008150",' +
						'"nombre_prestacion": "PRODUCTO SIN CODIFICAR CIRUGIA GENERAL (NACIONAL)",' +
						'"tipo_prestacion": "N",' +
						'"troquel": null,' +
						'"grupo_prestacion": null,' +
						'"pca_id": "74042009",' +
						'"alerta": null,' +
						'"texto_aclarativo": null,' +
						'"importe_plan_sys": "0",' +
						'"importe_plan_aud": "187.5",' +
						'"importe_convenio_sys": "0",' +
						'"importe_convenio_aud": "200.75",' +
						'"importe_cargo_al_socio_sys": "0",' +
						'"importe_cargo_al_socio_aud": "250.5",' +
						'"importe_rein_sys": "0",' +
						'"importe_rein_aud": "0"' +
					'}' +
				'],' +
				'"httpCode": 200,' +
				'"message": "El importe fue cargado satisfactoriamente.",' +
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
					'"message": "La prestación solicitada es inválida.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"line": 964' +
				'}' +
			'}';
	}
}