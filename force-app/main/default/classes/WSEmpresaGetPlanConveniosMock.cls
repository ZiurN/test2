public class WSEmpresaGetPlanConveniosMock  {
	public static String getFound(){
		return
            '{' +
                '"data": [' +
                    '{' +
                        '"fecha_desde": "01/07/2017",' +
                        '"fecha_hasta": "30/06/2019",' +
                        '"anulado": "F",' +
                        '"plan_codigo": "AS300",' +
                        '"plan_nombre": "SUPERIOR AS300",' +
                        '"plaperm_id": "32205"' +
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