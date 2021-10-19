public class WSAsociadoGetDatosAdicionalesMock  {
	public static String getFound(){
		return
			'{' +
				'"data": [' +
					'{' +
						'"codigo": "SC",' +
						'"nombre": "SOCIO DE COOPERATIVA",' +
						'"valor": "F",' +
						'"observaciones": null,' +
						'"obligatorio": "F"' +
					'},' +
					'{' +
						'"codigo": "EM_S",' +
						'"nombre": "DIRECCION DE MAIL DEL SOCIO",' +
						'"valor": "MTARTABINI@ACASALUD.COM.AR",' +
						'"observaciones": null,' +
						'"obligatorio": "F"' +
					'},' +
					'{' +
						'"codigo": "FE",' +
						'"nombre": "ADHESION FACTURA ELECTRONICA",' +
						'"valor": "N",' +
						'"observaciones": null,' +
						'"obligatorio": "F"' +
					'},' +
					'{' +
						'"codigo": "APOR",' +
						'"nombre": "APORTES ESTIMADOS OBLDIR",' +
						'"valor": "910",' +
						'"observaciones": null,' +
						'"obligatorio": "F"' +
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

	public static String getFoundEmpresa(){
		return
            '{' +
                '"data": [' +
                    '{' +
                        '"tipo_dato_adicional": "AG_E",' +
                        '"descripcion_dato_adicional": "AGENCIA A LA QUE PERTENECE UNA EMPRESA",' +
                        '"valor": "650070"' +
                    '},' +
                    '{' +
                        '"tipo_dato_adicional": "COMI",' +
                        '"descripcion_dato_adicional": "EMPRESAS PARA COMISIONES",' +
                        '"valor": "V"' +
                    '},' +
                    '{' +
                        '"tipo_dato_adicional": "GREM",' +
                        '"descripcion_dato_adicional": "GREM CODIGO",' +
                        '"valor": "601043"' +
                    '},' +
                    '{' +
                        '"tipo_dato_adicional": "EM_1",' +
                        '"descripcion_dato_adicional": "MAIL PRINCIPAL",' +
                        '"valor": "/www.camaraeconomicata.com.ar"' +
                    '},' +
                    '{' +
                        '"tipo_dato_adicional": "SC",' +
                        '"descripcion_dato_adicional": "SOCIO DE COOPERATIVA",' +
                        '"valor": "F"' +
                    '},' +
                    '{' +
                        '"tipo_dato_adicional": "TEMP",' +
                        '"descripcion_dato_adicional": "TIPO DE EMPRESA",' +
                        '"valor": "RANGO_CAPITAS"' +
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

	public static String getFoundEfector(){
		return
            '{' +
                '"data": [' +
                    '{' +
                        '"efector": "536787",' +
                        '"tipo_dato": "UACT",' +
                        '"valor": "09/05/2018",' +
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

	public static String getError(){
		return
			'{' +
				'"data": {' +
					'"error": true,' +
					'"errors": [],' +
					'"errorType": "exception",' +
					'"httpCode": 404,' +
					'"message": "El ID del Afiliado inválido.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",' +
					'"line": 964' +
				'}' +
			'}';
	}
}