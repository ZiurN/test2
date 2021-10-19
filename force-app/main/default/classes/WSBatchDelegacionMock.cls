public class WSBatchDelegacionMock  {
	public static String getFoundFirstPage(){
		return
            '{' +
                '"data": [' +
                    '{' +
                        '"rn": "1",' +
                        '"tipo_delegacion": "AGENCIA",' +
                        '"codigo": "650261",' +
                        '"nombre": "650261_AG. GODEKEN - NORMA DE CICILIANI",' +
                        '"descripcion": "NORMA DE CICILIANI",' +
                        '"fecha_activacion": "1900-01-01 00:00:00",' +
                        '"estado": "A",' +
                        '"organizacion": "ROS",' +
                        '"correo_electronico": "acagodeken@outlook.com",' +
                        '"observaciones": null,' +
                        '"domicilio": "Calle 15 946  ",' +
                        '"localidad": "GODEKEN",' +
                        '"provincia": "SANTA FE",' +
                        '"url_convenio": null,' +
                        '"filial_depende": "650497",' +
                        '"pje_comis_dateras": null,' +
                        '"nivel_permiso": "D",' +
                        '"correo_gerencia_coop": null,' +
                        '"tipo_comision_venta": null,' +
						'"tipo_real_virtual": "REAL",' +
                        '"f_modif": "2020-01-20 00:00:00"' +
                    '}' +
                '],' +
                '"links": {' +
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/delegaciones/2020-01-20?page=1",' +
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/delegaciones/2020-01-20?page=2",' +
                    '"prev": null,' +
                    '"next": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/delegaciones/2020-01-20?page=2"' +
                '},' +
                '"meta": {' +
                    '"current_page": 1,' +
                    '"from": 1,' +
                    '"last_page": 2,' +
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/delegaciones/2020-01-20",' +
                    '"per_page": 1,' +
                    '"to": 1,' +
                    '"total": 2,' +
                    '"allowed_filters": [' +
                        '"codigo",' +
                        '"nombre",' +
                        '"organizacion",' +
                        '"filial_depende "' +
                    '],' +
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
                        '"tipo_delegacion": "AGENCIA",' +
                        '"codigo": "650077",' +
                        '"nombre": "650077_AG. ELORTONDO - COOP. AGROP.UNIF. LTDA DE ELORTONDO.",' +
                        '"descripcion": "COOPERATIVA AGROPECUARIA UNIFICADA LIMITADA DE ELORTONDO",' +
                        '"fecha_activacion": "1900-01-01 00:00:00",' +
                        '"estado": "A",' +
                        '"organizacion": "ROS",' +
                        '"correo_electronico": "serviciossociales@coopagroelortondo.com.ar",' +
                        '"observaciones": null,' +
                        '"domicilio": "San Martín 1046  ",' +
                        '"localidad": "ELORTONDO",' +
                        '"provincia": "SANTA FE",' +
                        '"url_convenio": null,' +
                        '"filial_depende": "650497",' +
                        '"pje_comis_dateras": null,' +
                        '"nivel_permiso": "D",' +
                        '"correo_gerencia_coop": "caule-gerencia@arnetbiz.com.ar",' +
                        '"tipo_comision_venta": "INCENTIVADA_B",' +
                        '"f_modif": "2020-01-20 00:00:00"' +
                    '}' +
                '],' +
                '"links": {' +
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/delegaciones/2020-01-20?page=1",' +
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/delegaciones/2020-01-20?page=2",' +
                    '"prev": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/delegaciones/2020-01-20?page=1",' +
                    '"next": null' +
                '},' +
                '"meta": {' +
                    '"current_page": 2,' +
                    '"from": 2,' +
                    '"last_page": 2,' +
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/delegaciones/2020-01-20",' +
                    '"per_page": 1,' +
                    '"to": 2,' +
                    '"total": 2,' +
                    '"allowed_filters": [' +
                        '"codigo",' +
                        '"nombre",' +
                        '"organizacion",' +
                        '"filial_depende "' +
                    '],' +
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