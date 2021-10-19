public class WSAsociadoGetDeudaMock {
    public static String getFound(){
        return
                '{'+
                '"data": {'+
                    '"vencimiento": "03/12/2019",'+
                    '"p_tcp_codigo_act": "FA",'+
                    '"p_cpr_letra_act": "B",'+
                    '"p_cpr_sucursal_act": "22",'+
                    '"p_cpr_numero_act": "1566119",'+
                    '"p_det_cuota_act": "1",'+
                    '"p_dat_nro": "23162069",'+
                    '"p_deuda_act": "163.55"'+
                '},'+
                '"meta": {'+
                    '"allowed_includes": [],'+
                    '"default_includes": []'+
            '}'+
        '}';
    }

    public static String getEmpty() {
        return
                '{'+
                        '"data": {'+
                        '"vencimiento": null,'+
                        '"p_tcp_codigo_act": null,'+
                        '"p_cpr_letra_act": null,'+
                        '"p_cpr_sucursal_act": null,'+
                        '"p_cpr_numero_act": null,'+
                        '"p_det_cuota_act": null,'+
                        '"p_dat_nro": null,'+
                        '"p_deuda_act": null'+
                        '},'+
                        '"meta": {'+
                        '"allowed_includes": [],'+
                        '"default_includes": []'+
                        '}'+
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
                        '"message": "La entidad ingresada es inválida.",' +
                        '"debug_message": [],' +
                        '"exception": "NotFoundHttpException",' +
                        '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",' +
                        '"line": 964' +
                        '}' +
                        '}';
    }
}