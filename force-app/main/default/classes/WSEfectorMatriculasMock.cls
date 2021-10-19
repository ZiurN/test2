public class WSEfectorMatriculasMock {

    public static String getFound(){
        return '{'+
                '"data": ['+
                    '{'+
                    '"rn": "1",'+
                    '"codigo": "765058",'+
                    '"nombre": "VIGNAU CARLOS GUSTAVO",'+
                    '"clase_efector": "HMED",'+
                    '"nombre_clase": "MEDICOS DIRECTOS",'+
                    '"tipo_matricula": "P",'+
                    '"pcia_codigo": "B",'+
                    '"nombre_pcia": "BUENOS AIRES",'+
                    '"matricula": "19392/01000000"'+
                    '}'+
                '],'+
                '"links": {'+
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/efectores/matriculas?page=1",'+
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/efectores/matriculas?page=1",'+
                    '"prev": null,'+
                    '"next": null'+
                '},'+
                '"meta": {'+
                    '"current_page": 1,'+
                    '"from": 1,'+
                    '"last_page": 1,'+
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/efectores/matriculas",'+
                    '"per_page": 15,'+
                    '"to": 1,'+
                    '"total": 1,'+
                    '"allowed_filters": ['+
                    '"clase_efector",'+
                    '"pcia_codigo",'+
                    '"nombre_pcia",'+
                    '"nombre",'+
                    '"matricula"'+
                '],'+
                '"allowed_sorts": [],'+
                '"allowed_appends": [],'+
                '"allowed_fields": [],'+
                '"allowed_includes": [],'+
                '"default_includes": [],'+
                '"optional_get_vars": {'+
                '"sortBy": [],'+
                '"sortOrder": ['+
                '"asc",'+
                '"desc"'+
                '],'+
                '"pageSize": {'+
                    '"0": "?pageSize=0",'+
                    '"15": "?pageSize=15",'+
                    '"50": "?pageSize=50",'+
                    '"100": "?pageSize=100"'+
                '}'+
                '}'+
                '}'+
                '}';
    }

    public static String getEmpty(){
        return '{'+
                '    "data": [],'+
                '    "links": {'+
                '        "first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/efectores/matriculas?page=1",'+
                '        "last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/efectores/matriculas?page=1",'+
                '        "prev": null,'+
                '        "next": null'+
                '    },'+
                '    "meta": {'+
                '        "current_page": 1,'+
                '        "from": null,'+
                '        "last_page": 1,'+
                '        "path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/efectores/matriculas",'+
                '        "per_page": 15,'+
                '        "to": null,'+
                '        "total": 0,'+
                '        "allowed_filters": [],'+
                '        "allowed_sorts": [],'+
                '        "allowed_appends": [],'+
                '        "allowed_fields": [],'+
                '        "allowed_includes": [],'+
                '        "default_includes": [],'+
                '        "optional_get_vars": {'+
                '            "sortBy": [],'+
                '            "sortOrder": ['+
                '                "asc",'+
                '                "desc"'+
                '            ],'+
                '            "pageSize": {'+
                '                "0": "?pageSize=0",'+
                '                "15": "?pageSize=15",'+
                '                "50": "?pageSize=50",'+
                '                "100": "?pageSize=100"'+
                '            }'+
                '        }'+
                '    }'+
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
					'"message": "Código de Afiliado inválido.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",' +
					'"line": 964' +
				'}' +
			'}';
	}

}