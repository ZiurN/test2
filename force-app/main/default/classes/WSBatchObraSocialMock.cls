public class WSBatchObraSocialMock {

    public static String getFoundSecondPage(){
        return '{'+
                    '"data": ['+
                        '{'+
                        '"rn": "1",'+
                        '"codigo": "640004",'+
                        '"nombre": "O.S.S.E.G.",'+
                        '"descripcion": "OBRA SOCIAL DEL SEGURO",'+
                        '"codigo_rnos": "901",'+
                        '"tipo": "Cliente",'+
                        '"cuit": "30500053522",'+
                        '"fecha_activacion": "1900-01-01 00:00:00",'+
                        '"codigo_financiero": null,'+
                        '"estado": "A",'+
                        '"email": "sin mail",'+
                        '"codigo_agrupacion": "TRFAPO",'+
                        '"descripcion_agrupacion": "TRANSFERENCIA DE APORTES",'+
                        '"clase": "Obra social sindical",'+
                        '"delegacion": "650098_ACA SALUD SUC. ROSARIO",'+
                        '"observaciones": null,'+
                        '"f_modif": "2020-01-20 00:00:00"'+
                        '},'+
                        '{'+
                        '"rn": "2",'+
                        '"codigo": "640014",'+
                        '"nombre": "C N SANTA FE",'+
                        '"descripcion": "Caja Notarial de Santa Fe",'+
                        '"codigo_rnos": "2",'+
                        '"tipo": "Cliente",'+
                        '"cuit": "30999248213",'+
                        '"fecha_activacion": "1900-01-01 00:00:00",'+
                        '"codigo_financiero": null,'+
                        '"estado": "A",'+
                        '"email": "sin mail",'+
                        '"codigo_agrupacion": "DERTERCAP",'+
                        '"descripcion_agrupacion": "DERIVACION DE TERCEROS CAPITADOS",'+
                        '"clase": "Obra social gremial",'+
                        '"delegacion": "650098_ACA SALUD SUC. ROSARIO",'+
                        '"observaciones": null,'+
                        '"f_modif": "2020-01-20 00:00:00"'+
                        '}'+
                        '],'+
                    '"links": {'+
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-20?page=1",'+
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-20?page=1",'+
                    '"prev": null,'+
                    '"next": null'+
                    '},'+
                    '"meta": {'+
                    '"current_page": 2,'+
                    '"from": 1,'+
                    '"last_page": 2,'+
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-20",'+
                    '"per_page": 15,'+
                    '"to": 2,'+
                    '"total": 2,'+
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

    public static String getFound(){
    return '{'+
        '"data": ['+
        '{'+
        '"rn": "1",'+
        '"codigo": "640005",'+
        '"nombre": "O.S.S.F.G.",'+
        '"descripcion": "OBRA SOCIAL DEL SEGURO F",'+
        '"codigo_rnos": "911",'+
        '"tipo": "Cliente",'+
        '"cuit": "30500063522",'+
        '"fecha_activacion": "1900-01-01 00:00:00",'+
        '"codigo_financiero": null,'+
        '"estado": "A",'+
        '"email": "sin mail",'+
        '"codigo_agrupacion": "TRFAPO",'+
        '"descripcion_agrupacion": "TRANSFERENCIA DE APORTES",'+
        '"clase": "Obra social sindical",'+
        '"delegacion": "650098_ACA SALUD SUC. ROSARIO",'+
        '"observaciones": null,'+
        '"f_modif": "2020-01-20 00:00:00"'+
        '}'+
    '],'+
    '"links": {'+
    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-20?page=1",'+
    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-20?page=2",'+
    '"prev": null,'+
    '"next": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-20?page=2"'+
    '},'+
    '"meta": {'+
    '"current_page": 1,'+
    '"from": 1,'+
    '"last_page": 2,'+
    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-20",'+
    '"per_page": 15,'+
    '"to": 2,'+
    '"total": 2,'+
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

    public static String getEmpty(){
        return '{'+
                    '"data": [],'+
                    '"links": {'+
                    '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-18?page=1",'+
                    '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-18?page=1",'+
                    '"prev": null,'+
                    '"next": null'+
                    '},'+
                    '"meta": {'+
                    '"current_page": 1,'+
                    '"from": null,'+
                    '"last_page": 1,'+
                    '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/obras-sociales/2020-01-18",'+
                    '"per_page": 15,'+
                    '"to": null,'+
                    '"total": 0,'+
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
                '"data": {'+
                '"error": true,'+
                '"errors": [],'+
                '"errorType": "exception",'+
                '"httpCode": 404,'+
                '"message": "Formato de fecha inválido. El formato debe ser Y-m-d.",'+
                '"debug_message": [],'+
                '"exception": "NotFoundHttpException",'+
                '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",'+
                '"line": 964'+
                '}'+
                '}';
    }
}