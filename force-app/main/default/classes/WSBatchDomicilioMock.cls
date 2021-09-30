@isTest 
public class WSBatchDomicilioMock {

	public static String getFoundAndStop() {
		return 
			'{' +
				'"data": [' +
					'{' +
						'"rn": "3",' +
						'"afi_id": "131784",' +
						'"domiafi_id": "352276",' +
						'"calle": "MIGUEL CANE",' +
						'"numero": "406",' +
						'"piso": "PB",' +
						'"dpto": "A",' +
						'"loc_id": "10055",' +
						'"td_codigo": "COM",' +
						'"f_modif": "2020-06-05 14:08:17"' +
					'},' +
					'{' +
						'"rn": "4",' +
						'"afi_id": "131811",' +
						'"domiafi_id": "73461",' +
						'"calle": "7 DE OCTUBRE",' +
						'"numero": "229",' +
						'"piso": null,' +
						'"dpto": null,' +
						'"loc_id": "3032",' +
						'"td_codigo": "COM",' +
						'"f_modif": "2020-06-05 14:53:58"' +
					'}' +
				'],' +
				'"links": {' +
					'"first": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01?page=1",' +
					'"last": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01?page=2",' +
					'"prev": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01?page=1",' +
					'"next": null' +
				'},' +
				'"meta": {' +
					'"current_page": 2,' +
					'"from": 3,' +
					'"last_page": 2,' +
					'"path": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01",' +
					'"per_page": 2,' +
					'"to": 4,' +
					'"total": 3159,' +
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
						'"afi_id": "131811",' +
						'"domiafi_id": "72058",' +
						'"calle": "ALBERDI",' +
						'"numero": "130",' +
						'"piso": null,' +
						'"dpto": null,' +
						'"loc_id": "3032",' +
						'"td_codigo": "PART",' +
						'"f_modif": "2020-06-30 17:48:12"' +
					'},' +
					'{' +
						'"rn": "2",' +
						'"afi_id": "130591",' +
						'"domiafi_id": "72241",' +
						'"calle": "AGRELO",' +
						'"numero": "873",' +
						'"piso": null,' +
						'"dpto": null,' +
						'"loc_id": "2153",' +
						'"td_codigo": "COM",' +
						'"f_modif": "2020-06-18 01:59:53"' +
					'}' +
				'],' +
				'"links": {' +
					'"first": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01?page=1",' +
					'"last": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01?page=1580",' +
					'"prev": null,' +
					'"next": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01?page=2"' +
				'},' +
				'"meta": {' +
					'"current_page": 1,' +
					'"from": 1,' +
					'"last_page": 1580,' +
					'"path": "https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01",' +
					'"per_page": 2,' +
					'"to": 2,' +
					'"total": 3159,' +
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


	
}