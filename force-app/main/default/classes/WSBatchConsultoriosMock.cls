public class WSBatchConsultoriosMock {

    public static String getFound(){
        return '{'+
                '"data": ['+
                '{'+
                '"rn": "1",'+
                '"pres_efe_codigo": "700047",'+
                '"secuencia": "1",'+
                '"nombre": "CONSULTORIO PPAL PRESTADOR :700711",'+
                '"username": "7007110001",'+
                '"principal": "V",'+
                '"fecha_vigencia": "1970-01-01 00:00:00",'+
                '"estado": "A",'+
                '"descripcion": "SANATORIO DE NIÑOS",'+
                '"consultorio_diabetes": null,'+
                '"matri": null,'+
                '"mail": "facturacion@sanatoriodeninos.com.ar",'+
                '"codigo_externo": null,'+
                '"cod_pami": null,'+
                '"fecha_desde_usr": null,'+
                '"fecha_hasta_usr": null,'+
                '"horario": null,'+
                '"farmacias_leches": null,'+
                '"tipo_matricula": null,'+
                '"cuit": null,'+
                '"cons_cia": null,'+
                '"firma": "DAT_MGR",'+
                '"f_modif": "2020-01-07 00:00:00"'+
                '},'+
                '{'+
                '"rn": "2",'+
                '"pres_efe_codigo": "700047",'+
                '"secuencia": "9999",'+
                '"nombre": "CONSULTORIO GUARDIA",'+
                '"username": "700711/9999",'+
                '"principal": "F",'+
                '"fecha_vigencia": "2017-06-01 00:00:00",'+
                '"estado": "A",'+
                '"descripcion": "SANATORIO DE NIÑOS",'+
                '"consultorio_diabetes": null,'+
                '"matri": null,'+
                '"mail": null,'+
                '"codigo_externo": null,'+
                '"cod_pami": null,'+
                '"fecha_desde_usr": null,'+
                '"fecha_hasta_usr": null,'+
                '"horario": null,'+
                '"farmacias_leches": null,'+
                '"tipo_matricula": null,'+
                '"cuit": null,'+
                '"cons_cia": null,'+
                '"firma": null,'+
                '"f_modif": "2020-01-07 00:00:00"'+
                '},'+
                '{'+
                '"rn": "3",'+
                '"pres_efe_codigo": "700047",'+
                '"secuencia": "9998",'+
                '"nombre": "CONSULTORIO INTERNACION",'+
                '"username": "700711/9998",'+
                '"principal": "F",'+
                '"fecha_vigencia": "2017-06-01 00:00:00",'+
                '"estado": "A",'+
                '"descripcion": "SANATORIO DE NIÑOS",'+
                '"consultorio_diabetes": null,'+
                '"matri": null,'+
                '"mail": null,'+
                '"codigo_externo": null,'+
                '"cod_pami": null,'+
                '"fecha_desde_usr": null,'+
                '"fecha_hasta_usr": null,'+
                '"horario": null,'+
                '"farmacias_leches": null,'+
                '"tipo_matricula": null,'+
                '"cuit": null,'+
                '"cons_cia": null,'+
                '"firma": null,'+
                '"f_modif": "2020-01-07 00:00:00"'+
                '}'+
                '],'+
                '"links": {'+
                '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/07-01-2020?page=1",'+
                '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/07-01-2020?page=1",'+
                '"prev": null,'+
                '"next": null'+
                '},'+
                '"meta": {'+
                '"current_page": 1,'+
                '"from": 1,'+
                '"last_page": 1,'+
                '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/07-01-2020",'+
                '"per_page": 15,'+
                '"to": 3,'+
                '"total": 3,'+
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

    public static String getFoundAndContinue(){
        return '{'+
                '"data": ['+
                '{'+
                '"rn": "1",'+
                '"pres_efe_codigo": "700047",'+
                '"secuencia": "42",'+
                '"nombre": "CONSULTORIO SEC PRESTADOR :700711",'+
                '"username": "700711/0042",'+
                '"principal": "V",'+
                '"fecha_vigencia": "1970-01-01 00:00:00",'+
                '"estado": "A",'+
                '"descripcion": "SANATORIO DE NIÑOS",'+
                '"consultorio_diabetes": null,'+
                '"matri": null,'+
                '"mail": "facturacion@sanatoriodeninos.com.ar",'+
                '"codigo_externo": null,'+
                '"cod_pami": null,'+
                '"fecha_desde_usr": null,'+
                '"fecha_hasta_usr": null,'+
                '"horario": null,'+
                '"farmacias_leches": null,'+
                '"tipo_matricula": null,'+
                '"cuit": null,'+
                '"cons_cia": null,'+
                '"firma": "DAT_MGR",'+
                '"f_modif": "2020-01-07 00:00:00"'+
                '}'+
                '],'+
                '"links": {'+
                '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/07-01-2020?page=1",'+
                '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/07-01-2020?page=1",'+
                '"prev": null,'+
                '"next": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/07-01-2020?page=2"'+
                '},'+
                '"meta": {'+
                '"current_page": 1,'+
                '"from": 1,'+
                '"last_page": 2,'+
                '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/07-01-2020",'+
                '"per_page": 15,'+
                '"to": 3,'+
                '"total": 3,'+
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
                '"error": true,'+
                '"data": {'+
                '"errorType": "exception",'+
                '"errors": [],'+
                '"message": "La ruta que está buscando no existe.",'+
                '"httpCode": 404,'+
                '"exception": "NotFoundHttpException",'+
                '"debug_message": [],'+
                '"line": 179'+
                '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Routing\\RouteCollection.php",'+
                '}'+
                '}';
    }

    public static String getEmpty(){
        return '{'+
                '"data": [],'+
                '"links": {'+
                '"first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/06-01-2020?page=1",'+
                '"last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/06-01-2020?page=1",'+
                '"prev": null,'+
                '"next": null'+
                '},'+
                '"meta": {'+
                '"current_page": 1,'+
                '"from": null,'+
                '"last_page": 1,'+
                '"path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/consultorios/06-01-2020",'+
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
}