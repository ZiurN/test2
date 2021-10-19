@isTest 
public class WSBatchClausulasTempMock {
	public static String getFound() {
		return 
            '{' +
                '"data": [' +
                    '{' +
                        '"rn": "1",' +
                        '"codigo": "51692/10",' +
                        '"tacta_codigo": "PMI_MADRE",' +
                        '"fecha_vigencia_desde": "2020-05-01 00:00:00",' +
                        '"fecha_vigencia_hasta": "2020-11-30 00:00:00",' +
                        '"diag_codigo": "Z34",' +
                        '"observaciones": null,' +
                        '"fecha_fum": "2020-05-01 00:00:00",' +
                        '"fecha_pp": "2020-05-31 00:00:00",' +
                        '"acta_id": "48574"' +
                    '},' +
                    '{' +
                        '"rn": "2",' +
                        '"codigo": "51773/14",' +
                        '"tacta_codigo": "PMI_MADRE",' +
                        '"fecha_vigencia_desde": "2020-04-01 00:00:00",' +
                        '"fecha_vigencia_hasta": "2020-05-04 00:00:00",' +
                        '"diag_codigo": "Z34",' +
                        '"observaciones": null,' +
                        '"fecha_fum": "2020-04-01 00:00:00",' +
                        '"fecha_pp": "2020-04-04 00:00:00",' +
                        '"acta_id": "47508"' +
                    '}' +
                '],' +
                '"links": {' +
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/clausulas-temporarias/2020-01-01?page=1",' +
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/clausulas-temporarias/2020-01-01?page=274",' +
                    '"prev": null,' +
                    '"next": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/clausulas-temporarias/2020-01-01?page=2"' +
                '},' +
                '"meta": {' +
                    '"current_page": 1,' +
                    '"from": 1,' +
                    '"last_page": 2,' +
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/clausulas-temporarias/2020-01-01",' +
                    '"per_page": 2,' +
                    '"to": 2,' +
                    '"total": 547,' +
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

	public static String getFoundSecondPage() {
		return        
            '{' +
                '"data": [' +
                    '{' +
                        '"rn": "3",' +
                        '"codigo": "51773/14",' +
                        '"tacta_codigo": "PMI_MADRE",' +
                        '"fecha_vigencia_desde": "2020-06-01 00:00:00",' +
                        '"fecha_vigencia_hasta": "2020-06-25 00:00:00",' +
                        '"diag_codigo": "Z34",' +
                        '"observaciones": null,' +
                        '"fecha_fum": "2020-06-01 00:00:00",' +
                        '"fecha_pp": "2020-05-26 00:00:00",' +
                        '"acta_id": "48580"' +
                    '},' +
                    '{' +
                        '"rn": "4",' +
                        '"codigo": "51773/14",' +
                        '"tacta_codigo": "PMI_MADRE",' +
                        '"fecha_vigencia_desde": "2019-04-01 00:00:00",' +
                        '"fecha_vigencia_hasta": "2019-04-24 00:00:00",' +
                        '"diag_codigo": "Z34",' +
                        '"observaciones": null,' +
                        '"fecha_fum": "2019-04-01 00:00:00",' +
                        '"fecha_pp": "2019-03-25 00:00:00",' +
                        '"acta_id": "47511"' +
                    '}' +
                '],' +
                '"links": {' +
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/clausulas-temporarias/2020-01-01?page=1",' +
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/clausulas-temporarias/2020-01-01?page=274",' +
                    '"prev": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/clausulas-temporarias/2020-01-01?page=1",' +
                    '"next": null' +
                '},' +
                '"meta": {' +
                    '"current_page": 2,' +
                    '"from": 3,' +
                    '"last_page": 2,' +
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/clausulas-temporarias/2020-01-01",' +
                    '"per_page": 2,' +
                    '"to": 4,' +
                    '"total": 547,' +
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
            '{'+
                '"data": {'+
                    '"error": true,'+
                    '"errors": [],'+
                    '"errorType": "exception",'+
                    '"httpCode": 404,'+
                    '"message": "Formato de fecha inválido. El formato debe ser Y-m-d.",'+
                    '"debug_message": [],'+
                    '"exception": "NotFoundHttpException",'+
                    '"line": 964'+
                '}'+
            '}';
    }
    
}