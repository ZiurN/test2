public class WSBatchConvenioMock  {
	public static String getFound(){
		return 
            '{' +
                '"data": [' +
                    '{' +
                        '"rn": "1",' +
                        '"convenio": "R700711",' +
                        '"fecha_desde": "2008-08-01 00:00:00",' +
                        '"fecha_hasta": null,' +
                        '"prestador": "700711",' +
                        '"cons_secuencia": null,' +
                        '"modconv_codigo": null,' +
                        '"coeficiente_modelo": null,' +
                        '"an_codigo": "GO",' +
                        '"estado": "A",' +
                        '"fecha_activacion": "2008-11-24 10:10:20",' +
                        '"fecha_baja": null,' +
                        '"observaciones": "prestador que tiene VALORES PROPIOS VER AL FINAL DE LA GRILLA//  FERTYA",' +
                        '"f_modif": "2020-01-07 00:00:00"' +
                    '},' +
					'{' +
					'"rn": "2",' +
					'"convenio": "R700047",' +
					'"fecha_desde": "2016-03-01 00:00:00",' +
					'"fecha_hasta": null,' +
					'"prestador": "700047",' +
					'"cons_secuencia": null,' +
					'"modconv_codigo": null,' +
					'"coeficiente_modelo": null,' +
					'"an_codigo": "HOMOLOGADO",' +
					'"estado": "A",' +
					'"fecha_activacion": "2016-04-18 15:37:29",' +
					'"fecha_baja": null,' +
					'"observaciones": "null pero en string",' +
					'"f_modif": "2020-01-07 00:00:00"' +
					'}' +
                '],' +
                '"links": {' +
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/convenios-prestadores/07-01-2020?page=1",' +
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/convenios-prestadores/07-01-2020?page=2",' +
                    '"prev": null,' +
                    '"next": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/convenios-prestadores/07-01-2020?page=2"' +
                '},' +
                '"meta": {' +
                    '"current_page": 1,' +
                    '"from": 1,' +
                    '"last_page": 2,' +
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/convenios-prestadores/07-01-2020",' +
                    '"per_page": 1,' +
                    '"to": 1,' +
                    '"total": 2,' +
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

	public static String getFoundSecondPage(){
		return
            '{' +
                '"data": [' +
                    '{' +
                        '"rn": "2",' +
                        '"convenio": "R700047",' +
                        '"fecha_desde": "2016-03-01 00:00:00",' +
                        '"fecha_hasta": null,' +
                        '"prestador": "700047",' +
                        '"cons_secuencia": null,' +
                        '"modconv_codigo": null,' +
                        '"coeficiente_modelo": null,' +
                        '"an_codigo": "HOMOLOGADO",' +
                        '"estado": "A",' +
                        '"fecha_activacion": "2016-04-18 15:37:29",' +
                        '"fecha_baja": null,' +
                        '"observaciones": null,' +
                        '"f_modif": "2020-01-07 00:00:00"' +
                    '}' +
                '],' +
                '"links": {' +
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/convenios-prestadores/07-01-2020?page=1",' +
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/convenios-prestadores/07-01-2020?page=2",' +
                    '"prev": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/convenios-prestadores/07-01-2020?page=1",' +
                    '"next": null' +
                '},' +
                '"meta": {' +
                    '"current_page": 2,' +
                    '"from": 2,' +
                    '"last_page": 2,' +
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/convenios-prestadores/07-01-2020",' +
                    '"per_page": 1,' +
                    '"to": 2,' +
                    '"total": 2,' +
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


	public static String getError(){
		return
            '{' +
                '"data": {' +
                    '"error": true,' +
                    '"errors": [],' +
                    '"errorType": "exception",' +
                    '"httpCode": 404,' +
                    '"message": "Formato de fecha inválido. El formato debe ser d-m-Y.",' +
                    '"debug_message": [],' +
                    '"exception": "NotFoundHttpException",' +
                    '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",' +
                    '"line": 964' +
                '}' +
            '}';
	}

}