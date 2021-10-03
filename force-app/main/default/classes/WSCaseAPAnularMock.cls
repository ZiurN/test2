public class WSCaseAPAnularMock {

    public static String getFound(){
        return '{'+
                '"data": {'+
                '"ap": {'+
                '"apr_id": "1014009953",'+
                '"fecha": "2020-02-12 00:00:00",'+
                '"conexion": "CX--MOST",'+
                '"nombre_conexion": "Mostrador",'+
                '"delegacion": "650098",'+
                '"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",'+
                '"fecha_probable": "2020-02-12 00:00:00",'+
                '"estado": "CA-----N",'+
                '"nombre_estado": "ANULADA",'+
                '"user_insert": "CRIOS",'+
                '"fecha_insert": "2020-02-12 13:59:15",'+
                '"codigo_afiliado": "69794/38",'+
                '"apellidos_afiliado": "ORLOW",'+
                '"nombres_afiliado": "SOFIA",'+
                '"doc_afiliado": "DNI 35128344",'+
                '"evento_medico": null,'+
                '"fecha_prescripcion": "2020-01-20 00:00:00",'+
                '"diagnostico": "999",'+
                '"desc_diagnostico": "DIAGNOSTICO INDETERMINADO",'+
                '"prescriptor": "758415",'+
                '"nombre_prescriptor": "ZAPATA AGUILA BENJAMIN",'+
                '"prestador_dirige": null,'+
                '"nombre_prestador_dirige": null,'+
                '"prestador": null,'+
                '"nombre_prestador": null,'+
                '"consultorio": null,'+
                '"nombre_consultorio": null,'+
                '"observaciones": null,'+
                '"mail": "crios@acasalud.com.ar",'+
                '"otros_mail": null,'+
                '"aca_agencia": null,'+
                '"tran_alta": null,'+
                '"tran_anulacion": null,'+
                '"ref_externa": null,'+
                '"urgente": null,'+
                '"afi_id": "180015",'+
                '"nro_sf": null,'+
                '"nivel": "N1",'+
                '"clasificacion": "BAJA COMPLEJIDAD",'+
                '"prestaciones": ['+
                '{'+
                '"apr_id": "1014009953",'+
                '"estado_prestacion": "C1----AS",'+
                '"estado_descripcion": "AUTORIZADO POR EL SISTEMA",'+
                '"contexto": "Ambulatorio",'+
                '"cantidad": "1",'+
                '"prestacion": "02170101",'+
                '"nombre_prestacion": "ELECTROCARDIOGRAMA EN CONSULTORIO",'+
                '"tipo_prestacion": "N",'+
                '"troquel": null,'+
                '"grupo_prestacion": null,'+
                '"pca_id": "74042314",'+
                '"alerta": null,'+
                '"texto_aclarativo": null'+
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
                '"message": "La autorización solicitada es inválida.",'+
                '"debug_message": [],'+
                '"exception": "NotFoundHttpException",'+
                '"line": 964'+
                '}'+
                '}';
    }

}