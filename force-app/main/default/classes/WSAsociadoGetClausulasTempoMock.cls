public class WSAsociadoGetClausulasTempoMock  {

	public static String getFound(){
		return
			'{' +
				'"data": [' +
					'{' +
						'"tipo_clausula": "C_PMI-MADRE",' +
						'"tipo_clausula_descripcion": "COBERTURA PMI PARA MADRES",' +
						'"fecha_vigencia_desde": "2004-10-26",' +
						'"fecha_vigencia_hasta": "2005-08-26",' +
						'"tipo_asignacion": "PMI_MADRE",' +
						'"tipo_asignacion_descripcion": "PLAN MATERNO",' +
						'"nivel_aprobacion": "0",' +
						'"requiere_evento": "F",' +
						'"requiere_patologia": "V",' +
						'"diag_codigo": "Z34",' +
						'"diag_descripcion": "SUPERVISIÓN DE EMBARAZO NORMAL",' +
						'"diag_fecha": "2004-10-26",' +
						'"numero_evento": null,' +
						'"descripcion_evento": null,' +
						'"observaciones": null' +
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
						'],' +
						'"pageSize": {' +
							'"0": "?pageSize=0",' +
							'"15": "?pageSize=15",' +
							'"50": "?pageSize=50",' +
							'"100": "?pageSize=100"' +
						'}' +
					'}' +
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
					'"message": "La ruta que está buscando no existe.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Routing\\RouteCollection.php",' +
					'"line": 179' +
				'}' +
			'}';
	}
}