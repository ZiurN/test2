public class WSEmpresaConveniosPorAporteMock {

    public static String getFound(){
        return '{'+
                    '"data": ['+
                        '{'+
                            '"id": "147",'+
                            '"fecha_vigencia_desde": "2003-03-01",'+
                            '"fecha_vigencia_hasta": null,'+
                            '"grado": "105",'+
                            '"prioridad": "1",'+
                            '"importe": null,'+
                            '"importe_no_reconocido": null,'+
                            '"porcentaje": "95",'+
                            '"porcentaje_reconocido": "0",'+
                            '"suma_aportes": "Suma Todo",'+
                            '"agrupacion_empresa": "PA2CCTE",'+
                            '"grupo_empresa": null,'+
                            '"empresa": "ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA",'+
                            '"sucursal": "ACA SALUD C.P.S.M.A.L. - PLANES AL PERSONAL",'+
                            '"obra_social": "SIN DEFINIR",'+
                            '"modelo_plan": null,'+
                            '"agrupacion_plan": null,'+
                            '"plan": null,'+
                            '"categoria_afiliado": null,'+
                            '"agrupacion_afiliado": null,'+
                            '"agrupacion1_afiliado": null,'+
                            '"agrupacion2_afiliado": null,'+
                            '"agrupacion3_afiliado": null,'+
                            '"agrupacion4_afiliado": null,'+
                            '"codigo_afiliado": null,'+
                            '"apellidos_afiliado": null,'+
                            '"nombres_afiliado": null'+
                        '}'+
                    '],'+
                    '"meta": {'+
                        '"allowed_filters": ['+
                        '"codigo_empresa",'+
                        '"codigo_agrupacion_empresa",'+
                        '"codigo_grupo_empresarial"'+
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
                    '"data": {'+
                    '"error": true,'+
                    '"errors": [],'+
                    '"errorType": "exception",'+
                    '"httpCode": 500,'+
                    '"message": "invalid number",'+
                    '"debug_message": {'+
                    '"Error Code": "1722",'+
                    '"Error Message": "ORA-01722: invalid number",'+
                    '"Position": "3261",'+
                    '"Statement": ""'+
            '},'+
            '"exception": "QueryException",'+
            '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Database\\Connection.php",'+
            '"line": 664'+
            '}'+
        '}';
    }
}