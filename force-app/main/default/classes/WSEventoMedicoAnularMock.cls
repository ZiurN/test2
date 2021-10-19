public with sharing class WSEventoMedicoAnularMock {
    public static String getFound() {
        return
            '{' +
                '"error": false,' +
                '"data": {' +
                '"em_id": "249818",' +
                '"fecha_inicio": "04-04-2020 00:00",' +
                '"estado": "ANULADO",' +
                '"emitido": "NO EMITIDO",' +
                '"alerta": "EL AFILIADO TIENE ALERTAS DE AUTORIZACION PREVIA",' +
                '"fecha_emision": null,' +
                '"segmento": "VOL",' +
                '"efe_codigo_lugar": null,' +
                '"cons_lugar": null,' +
                '"nom_lugar": " ",' +
                '"nom_cons": null,' +
                '"efe_codigo_resp": null,' +
                '"nom_resp": " ",' +
                '"efe_codigo_solic": "743222",' +
                '"nom_solic": "BUILS ROBERTO JOSE",' +
                '"tem_codigo": "ANTICONCEPTIVOS",' +
                '"nom_tipo": "PROVISION ANTICONCEPTIVOS",' +
                '"contexto": "AMBOS",' +
                '"de_seguimiento": "V",' +
                '"recupero": "F",' +
                '"diferido": "F",' +
                '"suspendido": "F",' +
                '"fec_vto_certif": null,' +
                '"cod_motivo": "ANTICONCEPTIVOS",' +
                '"nom_motivo": "ANTICONCEPTIVOS",' +
                '"mail": null,' +
                '"diag_codigo": "Z30",' +
                '"diag_nombre": "ATENCIÓN PARA LA ANTICONCEPCIÓN",' +
                '"complicaciones": "SIN COMPLICACIONES",' +
                '"grup_pres": null,' +
                '"gpres_nombre": null,' +
                '"nro_prestacion": null,' +
                '"nom_prestacion": null,' +
                '"aut_previa": null,' +
                '"feem_codigo": null,' +
                '"feem_nombre": null,' +
                '"domi_entrega": "AGENCIA",' +
                '"agenia": "650098",' +
                '"otro_domi": null,' +
                '"via_entrega": "AGENCIA",' +
                '"domicilio": "650098",' +
                '"em_de_seguimiento": null,' +
                '"tipo_seg": null,' +
                '"nom_tipo_seg": null,' +
                '"estado_seg": null,' +
                '"desc_seg": null,' +
                '"cod_regla": "ANTICONCEPTIVOS",' +
                '"nom_regla": "PROVISIÓN DE ANTICONCEPTIVOS",' +
                '"sistema": "ABIERTO",' +
                '"descr_em": "ACO",' +
                '"nom_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
                '"obs_em": null,' +
                '"afi_afi_id": "383720",' +
                '"apr_apr_id": null,' +
                '"check_mat": "F",' +
                '"check_presu": "F",' +
                '"importe_presu": null,' +
                '"nro_sf": null' +
                '},' +
                    '"httpCode": 200,' +
                    '"message": "Se anuló correctamente el evento médico.",' +
                    '"meta": {' +
                    '"allowed_includes": [],' +
                    '"default_includes": []' +
                '}' +
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
                '"message": "El evento médico solicitado es inválido.",' +
                '"debug_message": [],' +
                '"exception": "NotFoundHttpException",' +
                '"line": 964' +
                '}' +
            '}';
    }
}