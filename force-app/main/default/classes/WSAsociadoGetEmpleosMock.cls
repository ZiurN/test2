public class WSAsociadoGetEmpleosMock  {

	public static String getFound(){
		return
			'{' +
				'"data": [' +
					'{' +
						'"fecha_inicio": "2016-08-01",' +
						'"fecha_fin": null,' +
						'"codigo": "600011",' +
						'"descripcion": "ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA"' +
					'},' +
					'{' +
						'"fecha_inicio": "2016-08-01",' +
						'"fecha_fin": null,' +
						'"codigo": "600011",' +
						'"descripcion": "ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA"' +
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