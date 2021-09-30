public class WSBatchSucursalMock  {
	public static String getFound(){
		return
			'{' +
				'"data": [' +
					'{' +
						'"rn": "1",' +
						'"empl_empl_id": "600001",' +
						'"nombre": "A.C.A. ASOC.COOPERATIVAS ARGENTINAS",' +
						'"codigo_suc": "1",' +
						'"descripcion": "A.C.A. ASOC.COOPERATIVAS ARGEN",' +
						'"fecha_activacion": "1900-01-01 00:00:00",' +
						'"estado_sucursal": "A",' +
						'"email": null,' +
						'"observaciones": null,' +
						'"es_sujeto_facturacion": "F",' +
						'"referencia_externa": "2914/1",' +
						'"f_modif": "2020-01-10 00:00:00"' +
					'}' +
				'],' +
				'"links": {' +
					'"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/sucursales-empresas/10-01-2020?page=1",' +
					'"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/sucursales-empresas/10-01-2020?page=2",' +
					'"prev": null,' +
					'"next": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/sucursales-empresas/10-01-2020?page=2"' +
				'},' +
				'"meta": {' +
					'"current_page": 1,' +
					'"from": 1,' +
					'"last_page": 2,' +
					'"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/sucursales-empresas/10-01-2020",' +
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
                        '"empl_empl_id": "600001",' +
                        '"nombre": "A.C.A. - VOLEMP",' +
                        '"codigo_suc": "2",' +
                        '"descripcion": "A.C.A. - VOLEMP",' +
                        '"fecha_activacion": "2003-02-01 00:00:00",' +
                        '"estado_sucursal": "A",' +
                        '"email": null,' +
                        '"observaciones": null,' +
                        '"es_sujeto_facturacion": "F",' +
                        '"referencia_externa": "2914/2",' +
                        '"f_modif": "2020-01-10 00:00:00"' +
                    '}' +
                '],' +
                '"links": {' +
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/sucursales-empresas/10-01-2020?page=1",' +
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/sucursales-empresas/10-01-2020?page=2",' +
                    '"prev": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/sucursales-empresas/10-01-2020?page=1",' +
                    '"next": null' +
                '},' +
                '"meta": {' +
                    '"current_page": 2,' +
                    '"from": 2,' +
                    '"last_page": 2,' +
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/sucursales-empresas/10-01-2020",' +
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