public with sharing class WSAlertaReintegroMock {
    public static string getFound(){
        return '{'+
            '"error": false,'+
            '"data": {'+
              '"reintegro": {'+
                '"lote": "999998",'+
                '"lote_original": "5800",'+
                '"rei_id": "636502",'+
                '"orei_orei_id": null,'+
                '"fecha": "2021-08-31 00:00:00",'+
                '"del_os_codigo": "650098",'+
                '"afi_afi_id": "561803",'+
                '"codigo": "251851/17",'+
                '"asociado_nombre": "CONTE NADINA GISEL",'+
                '"em_em_id": null,'+
                '"efe_codigo_realizador": "707614",'+
                '"efe_codigo_prescriptor": "707614",'+
                '"fecha_prescripcion": "2021-08-24 00:00:00",'+
                '"diag_codigo": "F10",'+
                '"cobro_indeb": "N",'+
                '"razon_social": null,'+
                '"cuit": null,'+
                '"tipo_comprobante": null,'+
                '"nro_comprobante": null,'+
                '"fecha_comprobante": null,'+
                '"importe": "1000",'+
                '"vda_drv_estado": "CR-----R",'+
                '"nombre_estado": "RECHAZADO",'+
                '"nro_sf": "5008A000008BIZQQA4",'+
                '"nivel": "N3",'+
                '"celula": "Celula 8",'+
                '"sla": "80",'+
                '"link_rein": "http://extranet.avalian.com/SF/REIN_636502.pdf",'+
                '"prestaciones": ['+
                  '{'+
                    '"rei_id": "74042509",'+
                    '"estado_prestacion": "C1EA-RAP",'+
                    '"estado_descripcion": "RECHAZADO POR EL AUDITOR AL PRESTADOR",'+
                    '"contexto": "Ambulatorio",'+
                    '"cantidad": "1",'+
                    '"prestacion": "02501027",'+
                    '"nombre_prestacion": "CODIGO GENERICO EMS",'+
                    '"tipo_prestacion": "N",'+
                    '"troquel": null,'+
                    '"grupo_prestacion": null,'+
                    '"pca_id": "74042509",'+
                    '"nro_sf": "a0i8A0000025w45QAA",'+
                    '"cara_pieza_dental": null,'+
                    '"importe_pagar": null,'+
                    '"pieza_dental": null,'+
                    '"texto_aclarativo": null,'+
                    '"importe_plan_sys": "0",'+
                    '"importe_plan_aud": null,'+
                    '"importe_convenio_sys": "0",'+
                    '"importe_convenio_aud": null,'+
                    '"importe_cargo_al_socio_sys": "0",'+
                    '"importe_cargo_al_socio_aud": null,'+
                    '"importe_rein_sys": "0",'+
                    '"importe_rein_aud": null,'+
                    '"alertas": ['+
                      '{'+
                        '"pca_pca_id": "16461901",'+
                        '"aca_id": "16461901",'+
                        '"cca_cca_id": "102632292",'+
                        '"control": "VREI",'+
                        '"nombre_control": "VALOR PLAN REINTEGROS 0",'+
                        '"funcion": "FCION_BACK",'+
                        '"texto_aclarativo": "EL VALOR AL PLAN DEL CONCEPTO ES 0",'+
                        '"nivel_auditoria": "199",'+
                        '"estado_alerta": "C1EA-RAP",'+
                        '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL PRESTADOR",'+
                        '"nota_auditor": null,'+
                        '"observaciones": "sin motivo",'+
                        '"fecha_generacion": "2021-08-31 09:54:02",'+
                        '"fecha_lectura": "2021-08-31 10:14:44",'+
                        '"auditor_lee": "CRIOS",'+
                        '"fecha_resolucion": "2021-08-31 00:00:00",'+
                        '"auditor_resuelve": "CRIOS"'+
                      '},'+
                      '{'+
                        '"pca_pca_id": "99349524",'+
                        '"aca_id": "22422963",'+
                        '"cca_cca_id": "102632292",'+
                        '"control": "NO_REI",'+
                        '"nombre_control": "NO CORREPONDE REINTEGRO AL PLAN",'+
                        '"funcion": "FCION_BACK",'+
                        '"texto_aclarativo": "Informe de Alerta - PLAN SIN REINTEGROS - Verificar tipo de prestación a reintegrar",'+
                        '"nivel_auditoria": "199",'+
                        '"estado_alerta": "C1-----A",'+
                        '"descripcion_estado": "EN AUDITORIA",'+
                        '"nota_auditor": null,'+
                        '"observaciones": null,'+
                        '"fecha_generacion": "2021-08-31 09:54:01",'+
                        '"fecha_lectura": null,'+
                        '"auditor_lee": null,'+
                        '"fecha_resolucion": null,'+
                        '"auditor_resuelve": null'+
                      '},'+
                      '{'+
                        '"pca_pca_id": "99349524",'+
                        '"aca_id": "22422964",'+
                        '"cca_cca_id": "102632292",'+
                        '"control": "SAM",'+
                        '"nombre_control": "SOLICITA AUDITORIA MEDICA",'+
                        '"funcion": "AM",'+
                        '"texto_aclarativo": "Informe de Alerta - ALERTA INFORMADA EN GRABACION",'+
                        '"nivel_auditoria": "200",'+
                        '"estado_alerta": "C1-----A",'+
                        '"descripcion_estado": "EN AUDITORIA",'+
                        '"nota_auditor": null,'+
                        '"observaciones": null,'+
                        '"fecha_generacion": "2021-08-31 09:54:01",'+
                        '"fecha_lectura": null,'+
                        '"auditor_lee": null,'+
                        '"fecha_resolucion": null,'+
                        '"auditor_resuelve": null' +
                      '},'+
                      '{'+
                        '"pca_pca_id": "99349524",'+
                        '"aca_id": "22422965",'+
                        '"cca_cca_id": "102632292",'+
                        '"control": "245",'+
                        '"nombre_control": "VALORIZACIÓN PLAN",'+
                        '"funcion": "FCION_FRONT",'+
                        '"texto_aclarativo": "El valor del concepto para el Plan de afiliado es cero",'+
                        '"nivel_auditoria": "160",'+
                        '"estado_alerta": "C1EA--AA",'+
                        '"descripcion_estado": "AUTORIZADO POR EL AUDITOR",'+
                        '"nota_auditor": null,'+
                        '"observaciones": null,'+
                        '"fecha_generacion": "2021-08-31 09:54:02",'+
                        '"fecha_lectura": "2021-08-31 09:40:23",'+
                        '"auditor_lee": "NCONTE",'+
                        '"fecha_resolucion": "2021-08-31 09:40:23",'+
                        '"auditor_resuelve": "NCONTE"'+ 
                      '}'+
                    ']'+
                  '}'+
                ']'+
              '}'+
            '},'+
            '"httpCode": 200,'+
            '"message": "Se pudo rechazar correctamente el alerta.",'+
            '"meta": {'+
              '"allowed_includes": [],'+
              '"default_includes": []'+
            '}'+
          '}';
    }

}