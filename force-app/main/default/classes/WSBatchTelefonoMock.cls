@isTest 
public class WSBatchTelefonoMock {

	public static String getFoundAndStop() {
		return
			'{' +
				'"data": [' +
					'{' +
						'"rn": "2",' +
						'"afi_id": "167755",' +
						'"telafi_id": "226244",' +
						'"tipo": "TEL",' +
						'"numero": "3411480105",' +
						'"f_modif": "2020-11-10 11:37:58",' +
						'"ppal": "V"' +
					'}' +
				'],' +
				'"links": {' +
					'"first": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/telefonos-m/2020-06-01?page=1",' +
					'"last": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/telefonos-m/2020-06-01?page=1",' +
					'"prev": null,' +
					'"next": null' +
				'},' +
				'"meta": {' +
					'"current_page": 1,' +
					'"from": 1,' +
					'"last_page": 1,' +
					'"path": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/telefonos-m/2020-06-01",' +
					'"per_page": 1,' +
					'"to": 1,' +
					'"total": 1,' +
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

	public static String getFoundAndContinue() {
		return
			'{' +
				'"data": [' +
					'{' +
						'"rn": "1",' +
						'"afi_id": "167755",' +
						'"telafi_id": "226245",' +
						'"tipo": "CEL",' +
						'"numero": "3411480106",' +
						'"f_modif": "2020-11-10 11:37:58",' +
						'"ppal": "F"' +
					'}' +
				'],' +
				'"links": {' +
					'"first": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/telefonos-m/2020-06-01?page=1",' +
					'"last": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/telefonos-m/2020-06-01?page=1",' +
					'"prev": null,' +
					'"next": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/telefonos-m/2020-06-01?page=2"' +
				'},' +
				'"meta": {' +
					'"current_page": 1,' +
					'"from": 1,' +
					'"last_page": 2,' +
					'"path": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/telefonos-m/2020-06-01",' +
					'"per_page": 1,' +
					'"to": 1,' +
					'"total": 1,' +
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
					'"message": "Formato de fecha inválido. El formato debe ser Y-m-d.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"line": 964' +
				'}' +
			'}';
	}
}