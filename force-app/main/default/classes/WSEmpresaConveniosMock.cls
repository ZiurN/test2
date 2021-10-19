public class WSEmpresaConveniosMock {

    public static String getFound(){
        return '{'+
                '"data": {'+
                '"convenios": {'+
                '"cabecera": {'+
                '"codigo": "600001",'+
                '"nombre": "A.C.A. ASOC.COOPERATIVAS ARGENTINAS",'+
                '"cuit": "30500120882",'+
                '"descripcion": "A.C.A. ASOC.COOPERATIVAS ARGENTINAS"'+
                '},'+
                '"detalles": ['+
                '{'+
                '"empl_id": "600001",'+
                '"ccp_id": "2608",'+
                '"fecha_desde": "01/06/2017",'+
                '"fecha_hasta": null,'+
                '"grado": "23",'+
                '"prioridad": "1",'+
                '"descripcion": "E600001-S6",'+
                '"sucursal": "MIGRACION PLANES AS",'+
                '"osoc_codigo": null,'+
                '"nombre_os": null,'+
                '"codigo_agrupacion": null,'+
                '"nombre_agrupacion": null,'+
                '"codigo_agrupacion1": null,'+
                '"nombre_agrupacion1": null,'+
                '"codigo_agrupacion2": null,'+
                '"nombre_agrupacion2": null,'+
                '"codigo_agrupacion3": null,'+
                '"nombre_agrupacion3": null,'+
                '"codigo_agrupacion4": null,'+
                '"nombre_agrupacion4": null,'+
                '"codigo_categoria": null,'+
                '"categoria_afiliado": null,'+
                '"zona_geografica": null,'+
                '"codigo_afiliado": null,'+
                '"apellido_afiliado": null,'+
                '"nombre_afiliado": null,'+
                '"permite_plan_mayor": "F"'+
                '},'+
                '{'+
                '"empl_id": "600001",'+
                '"ccp_id": "2471",'+
                '"fecha_desde": "01/10/2016",'+
                '"fecha_hasta": null,'+
                '"grado": "23",'+
                '"prioridad": "1",'+
                '"descripcion": "E600001-s5",'+
                '"sucursal": "SOCIOS SIN COBERTURA MEDICA-CONVENIO A.C.A.-",'+
                '"osoc_codigo": null,'+
                '"nombre_os": null,'+
                '"codigo_agrupacion": null,'+
                '"nombre_agrupacion": null,'+
                '"codigo_agrupacion1": null,'+
                '"nombre_agrupacion1": null,'+
                '"codigo_agrupacion2": null,'+
                '"nombre_agrupacion2": null,'+
                '"codigo_agrupacion3": null,'+
                '"nombre_agrupacion3": null,'+
                '"codigo_agrupacion4": null,'+
                '"nombre_agrupacion4": null,'+
                '"codigo_categoria": null,'+
                '"categoria_afiliado": null,'+
                '"zona_geografica": null,'+
                '"codigo_afiliado": null,'+
                '"apellido_afiliado": null,'+
                '"nombre_afiliado": null,'+
                '"permite_plan_mayor": "F"'+
                '},'+
                '{'+
                '"empl_id": "600001",'+
                '"ccp_id": "2285",'+
                '"fecha_desde": "01/09/2015",'+
                '"fecha_hasta": "31/01/2016",'+
                '"grado": "23",'+
                '"prioridad": "1",'+
                '"descripcion": "E600001-s4",'+
                '"sucursal": "COBERTURA BONIF.100% POR PROBLEMAS EN EL TRASPASO",'+
                '"osoc_codigo": null,'+
                '"nombre_os": null,'+
                '"codigo_agrupacion": null,'+
                '"nombre_agrupacion": null,'+
                '"codigo_agrupacion1": null,'+
                '"nombre_agrupacion1": null,'+
                '"codigo_agrupacion2": null,'+
                '"nombre_agrupacion2": null,'+
                '"codigo_agrupacion3": null,'+
                '"nombre_agrupacion3": null,'+
                '"codigo_agrupacion4": null,'+
                '"nombre_agrupacion4": null,'+
                '"codigo_categoria": null,'+
                '"categoria_afiliado": null,'+
                '"zona_geografica": null,'+
                '"codigo_afiliado": null,'+
                '"apellido_afiliado": null,'+
                '"nombre_afiliado": null,'+
                '"permite_plan_mayor": "F"'+
                '},'+
                '{'+
                '"empl_id": "600001",'+
                '"ccp_id": "1322",'+
                '"fecha_desde": "01/11/2010",'+
                '"fecha_hasta": null,'+
                '"grado": "23",'+
                '"prioridad": "1",'+
                '"descripcion": "E600001-S3",'+
                '"sucursal": "A.C.A. - PLAN 740",'+
                '"osoc_codigo": null,'+
                '"nombre_os": null,'+
                '"codigo_agrupacion": null,'+
                '"nombre_agrupacion": null,'+
                '"codigo_agrupacion1": null,'+
                '"nombre_agrupacion1": null,'+
                '"codigo_agrupacion2": null,'+
                '"nombre_agrupacion2": null,'+
                '"codigo_agrupacion3": null,'+
                '"nombre_agrupacion3": null,'+
                '"codigo_agrupacion4": null,'+
                '"nombre_agrupacion4": null,'+
                '"codigo_categoria": null,'+
                '"categoria_afiliado": null,'+
                '"zona_geografica": null,'+
                '"codigo_afiliado": null,'+
                '"apellido_afiliado": null,'+
                '"nombre_afiliado": null,'+
                '"permite_plan_mayor": "F"'+
                '},'+
                '{'+
                '"empl_id": "600001",'+
                '"ccp_id": "285",'+
                '"fecha_desde": "01/02/2003",'+
                '"fecha_hasta": "31/03/2004",'+
                '"grado": "23",'+
                '"prioridad": "1",'+
                '"descripcion": "E600001-S2",'+
                '"sucursal": "A.C.A. - VOLEMP",'+
                '"osoc_codigo": null,'+
                '"nombre_os": null,'+
                '"codigo_agrupacion": null,'+
                '"nombre_agrupacion": null,'+
                '"codigo_agrupacion1": null,'+
                '"nombre_agrupacion1": null,'+
                '"codigo_agrupacion2": null,'+
                '"nombre_agrupacion2": null,'+
                '"codigo_agrupacion3": null,'+
                '"nombre_agrupacion3": null,'+
                '"codigo_agrupacion4": null,'+
                '"nombre_agrupacion4": null,'+
                '"codigo_categoria": null,'+
                '"categoria_afiliado": null,'+
                '"zona_geografica": null,'+
                '"codigo_afiliado": null,'+
                '"apellido_afiliado": null,'+
                '"nombre_afiliado": null,'+
                '"permite_plan_mayor": "F"'+
                '}'+
                ']'+
                '}'+
                '},'+
                '"meta": {'+
                '"allowed_includes": [],'+
                '"default_includes": []'+
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
                '"message": "La empresa requerida es inválida.",'+
                '"debug_message": [],'+
                '"exception": "NotFoundHttpException",'+
                '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",'+
                '"line": 964'+
                '}'+
        '}';
    }


}