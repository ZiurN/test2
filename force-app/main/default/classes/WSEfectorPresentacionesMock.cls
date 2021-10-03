public class WSEfectorPresentacionesMock {

    public static String getFound(){
        return '{'+
                '"data": ['+
                    '{'+
                        '"pp_id": "219010600",'+
                        '"periodo": "2018-12-16",'+
                        '"prestador": "700084",'+
                        '"nombre_prestador": "CIBIC",'+
                        '"localidad": "ROSARIO",'+
                        '"fecha_recepcion": "2019-01-09",'+
                        '"fecha_vencimiento": "2019-02-08",'+
                        '"total": "821979.01",'+
                        '"estado": "GRABACION"'+
                    '},'+
                    '{'+
                        '"pp_id": "219011160",'+
                        '"periodo": "2019-01-01",'+
                        '"prestador": "700084",'+
                        '"nombre_prestador": "CIBIC",'+
                        '"localidad": "ROSARIO",'+
                        '"fecha_recepcion": "2019-01-22",'+
                        '"fecha_vencimiento": "2019-02-21",'+
                        '"total": "1019021.71",'+
                        '"estado": "GRABACION"'+
                    '},'+
                    '{'+
                        '"pp_id": "219100001",'+
                        '"periodo": "2019-09-16",'+
                        '"prestador": "700084",'+
                        '"nombre_prestador": "CIBIC",'+
                        '"localidad": "ROSARIO",'+
                        '"fecha_recepcion": "2019-10-01",'+
                        '"fecha_vencimiento": "2019-10-31",'+
                        '"total": null,'+
                        '"estado": "GRABACION"'+
                    '},'+
                    '{'+
                        '"pp_id": "219010136",'+
                        '"periodo": "2018-12-16",'+
                        '"prestador": "700084",'+
                        '"nombre_prestador": "CIBIC",'+
                        '"localidad": "ROSARIO",'+
                        '"fecha_recepcion": "2019-01-02",'+
                        '"fecha_vencimiento": "2019-02-01",'+
                        '"total": "1068028.86",'+
                        '"estado": "TRANSFORMACION"'+
                    '},'+
                    '{'+
                        '"pp_id": "218120550",'+
                        '"periodo": "2018-11-16",'+
                        '"prestador": "700084",'+
                        '"nombre_prestador": "CIBIC",'+
                        '"localidad": "ROSARIO",'+
                        '"fecha_recepcion": "2018-12-12",'+
                        '"fecha_vencimiento": "2019-01-11",'+
                        '"total": "1164299.98",'+
                        '"estado": "TRANSFORMACION"'+
                    '}'+
                '],'+
                '"meta": {'+
                    '"allowed_filters": [],'+
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
                    ']'+
                '}'+
                '}'+
                '}';
    }

    public static String getEmpty(){
        return '{'+
                '"data": [],'+
                '"meta": {'+
                '"allowed_filters": [],'+
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

    public static String getError(){
        return '{'+
            '    "data": {'+
            '        "error": true,'+
            '        "errors": [],'+
            '        "errorType": "exception",'+
            '        "httpCode": 404,'+
            '        "message": "La ruta que está buscando no existe.",'+
            '        "debug_message": [],'+
            '        "exception": "NotFoundHttpException",'+
            '        "file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Routing\\RouteCollection.php",'+
            '        "line": 179'+
            '    }'+
            '}';
    }
}