public class WSEfectorSuspensionesMock {

    public static String getFound(){
        return '{'+
                    '"data": ['+
                    '{'+
                    '"pres_efe_codigo": "700047",'+
                    '"fecha_inicio": "2014-07-10 00:00:00",'+
                    '"fecha_finalizacion": "2000-01-01 00:00:00",'+
                    '"motivo": "Chicos, la pxma presentación de AMR se pasa sin fotocopiar.Solo etiqueta en la hoja de resumen.Cualquier duda coordinen con Lili Araujo.Muchas graciasMaría Daniela Mazondo",'+
                    '"observaciones": null'+
                    '},'+
                    '{'+
                    '"pres_efe_codigo": "700047",'+
                    '"fecha_inicio": "2012-12-05 00:00:00",'+
                    '"fecha_finalizacion": "2012-12-13 00:00:00",'+
                    '"motivo": "amr va enviar el comprobante y doc 756187 BATALLA VICTOR AGUSTIN] dar vto 21/01/13   RMURNO",'+
                    '"observaciones": null'+
                    '},'+
                    '{'+
                    '"pres_efe_codigo": "700047",'+
                    '"fecha_inicio": "2011-03-01 00:00:00",'+
                    '"fecha_finalizacion": "2010-10-01 00:00:00",'+
                    '"motivo": "ATENCION GRABADORES: POR FAVOR VERIFICAR EN PUNCIONES DRA. TORRES EL PAGO DE LAS AGUJAS, HACE DOS MESES QUE LAS ESTAMOS DEBITANDO COMO DIFERENCIA DE PRECIO!!!!!!!!!!!!!",'+
                    '"observaciones": null'+
                    '},'+
                    '{'+
                    '"pres_efe_codigo": "700047",'+
                    '"fecha_inicio": "2010-06-01 00:00:00",'+
                    '"fecha_finalizacion": "2010-10-01 00:00:00",'+
                    '"motivo": "CODIFICADORAS: DEBITAR LAS  PRESTACIONES FACTURADAS CON BONO ESTEN O NO  VALIDADAS VIA ONLINE. SOLO PUEDEN FACTURAR CON AP DE LAS AGENCIAS ( DELEGACION) O LO GESTIONADO A TRAVES DEL APICATIVO.OJO CON LAS AGUJAS DE TORRES MARIA $ 120.00,NO DEBITAR CORREPONDE FUERA DE MODULO.-",'+
                    '"observaciones": null'+
                    '},'+
                    '{'+
                    '"pres_efe_codigo": "700047",'+
                    '"fecha_inicio": "2010-02-01 00:00:00",'+
                    '"fecha_finalizacion": "2010-03-01 00:00:00",'+
                    '"motivo": "claudia, no ingresar los comprobantes, pedir archivos - codificadoras: ojo en ecografías intervencionistas no debitar agujas.-",'+
                    '"observaciones": null'+
                    '},'+
                    '{'+
                    '"pres_efe_codigo": "700047",'+
                    '"fecha_inicio": "2000-01-01 00:00:00",'+
                    '"fecha_finalizacion": "2006-01-31 00:00:00",'+
                    '"motivo": "ANDRES SUSPENDE EL CONSULTORIO ASOCIADO DEL PRESTADOR 703954 CLINICA DE CAMARA GAMMA",'+
                    '"observaciones": null'+
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
                '"httpCode": 404,'+
                '"message": "La ruta que está buscando no existe.",'+
                '"debug_message": [],'+
                '"exception": "NotFoundHttpException",'+
                '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Routing\\RouteCollection.php",'+
                '"line": 179'+
                '}'+
                '}';
    }
}