public with sharing class WSAlertaRechazarMock {
    public static String getFound() {
        return
//            '{' +
//                '"error": false,' +
//                '"data": {' +
//                    '"em": {' +
//                        '"em_id": "275998",' +
//                        '"fecha_inicio": "25-02-2020 00:00",' +
//                        '"estado": "RECHAZADO",' +
//                        '"emitido": "NO EMITIDO",' +
//                        '"alerta": null,' +
//                        '"fecha_emision": null,' +
//                        '"segmento": [' +
//                            '{' +
//                                '"em_em_id": "275998",' +
//                                '"sem_id": "305822",' +
//                                '"fecha": "2020-02-29 00:00:00",' +
//                                '"solicitante": "700047",' +
//                                '"nom_solicitante": "ASOC. MEDICA DE ROSARIO",' +
//                                '"fecha_desde_tentativa": "25-02-2020 00:00",' +
//                                '"fecha_hasta_tentativa": "13-07-2047 00:00",' +
//                                '"cant_dias": "10000",' +
//                                '"estado": "AUTORIZADO",' +
//                                '"cod_auditor": null,' +
//                                '"ape_auditor": null,' +
//                                '"nom_auditor": null,' +
//                                '"fecha_real_desde": null,' +
//                                '"fecha_real_hasta": null,' +
//                                '"orig_fecha_real": "MESA CENSO",' +
//                                '"cod_audito2": null,' +
//                                '"ape_auditor2": null,' +
//                                '"nom_auditor2": null,' +
//                                '"prestador": null,' +
//                                '"pres_nombre": " ",' +
//                                '"presentacion": null,' +
//                                '"lote": null,' +
//                                '"obs": null,' +
//                                '"aca_nro_sf": null' +
//                            '}' +
//                        '],' +
//                        '"efe_codigo_lugar": null,' +
//                        '"cons_lugar": "0",' +
//                        '"nom_lugar": " ",' +
//                        '"nom_cons": null,' +
//                        '"efe_codigo_resp": null,' +
//                        '"nom_resp": " ",' +
//                        '"efe_codigo_solic": "700047",' +
//                        '"nom_solic": "ASOC. MEDICA DE ROSARIO",' +
//                        '"tem_codigo": "HIV",' +
//                        '"nom_tipo": "HIV",' +
//                        '"contexto": "AMBOS",' +
//                        '"de_seguimiento": "V",' +
//                        '"recupero": "F",' +
//                        '"diferido": "F",' +
//                        '"suspendido": "F",' +
//                        '"fec_vto_certif": null,' +
//                        '"cod_motivo": "HIV",' +
//                        '"nom_motivo": "TRATAMIENTO DE HIV",' +
//                        '"mail": null,' +
//                        '"diag_codigo": "B20",' +
//                        '"diag_nombre": "ENFERMEDAD POR VIRUS DE LA INMUNODEFICIENCIA HUMANA [VIH], R",' +
//                        '"complicaciones": "SIN COMPLICACIONES",' +
//                        '"grup_pres": null,' +
//                        '"gpres_nombre": null,' +
//                        '"nro_prestacion": null,' +
//                        '"nom_prestacion": null,' +
//                        '"aut_previa": "1014010147",' +
//                        '"feem_codigo": null,' +
//                        '"feem_nombre": null,' +
//                        '"domi_entrega": null,' +
//                        '"agenia": null,' +
//                        '"otro_domi": null,' +
//                        '"via_entrega": null,' +
//                        '"domicilio": null,' +
//                        '"em_de_seguimiento": null,' +
//                        '"tipo_seg": null,' +
//                        '"nom_tipo_seg": null,' +
//                        '"estado_seg": null,' +
//                        '"desc_seg": null,' +
//                        '"cod_regla": "HIV",' +
//                        '"nom_regla": "REGLA PARA EVENTOS HIV",' +
//                        '"sistema": "ABIERTO",' +
//                        '"descr_em": "Dasd",' +
//                        '"nom_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
//                        '"obs_em": null,' +
//                        '"afi_afi_id": "180013",' +
//                        '"apr_apr_id": "1014010147",' +
//                        '"check_mat": null,' +
//                        '"check_presu": "F",' +
//                        '"importe_presu": "0",' +
//                        '"nro_sf": "a00Q0000009kN5rIAE",' +
//                        '"ap": {' +
//                            '"apr_id": "1014010140",' +
//                            '"fecha": "2020-02-28 00:00:00",' +
//                            '"conexion": "CX--MOST",' +
//                            '"nombre_conexion": "Mostrador",' +
//                            '"delegacion": "650098",' +
//                            '"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
//                            '"fecha_probable": "2020-02-28 00:00:00",' +
//                            '"estado": "CA-----A",' +
//                            '"nombre_estado": "CENTRO AUTORIZADOR",' +
//                            '"user_insert": "CRIOS",' +
//                            '"fecha_insert": "2020-02-28 16:14:45",' +
//                            '"codigo_afiliado": "54076/15",' +
//                            '"apellidos_afiliado": "MARINSALDA JOSE PABLO",' +
//                            '"nombres_afiliado": ".",' +
//                            '"doc_afiliado": "DNI 06187024",' +
//                            '"evento_medico": "275998",' +
//                            '"fecha_prescripcion": "2020-02-28 00:00:00",' +
//                            '"diagnostico": "A24.2",' +
//                            '"desc_diagnostico": "MELIOIDOSIS SUBAGUDA Y CRÓNICA",' +
//                            '"prescriptor": "700047",' +
//                            '"nombre_prescriptor": "ASOC. MEDICA DE ROSARIO",' +
//                            '"prestador_dirige": null,' +
//                            '"nombre_prestador_dirige": null,' +
//                            '"prestador": null,' +
//                            '"nombre_prestador": null,' +
//                            '"consultorio": "0",' +
//                            '"nombre_consultorio": null,' +
//                            '"observaciones": "Autorizacion de evento medico 275998",' +
//                            '"mail": null,' +
//                            '"otros_mail": null,' +
//                            '"aca_agencia": null,' +
//                            '"tran_alta": null,' +
//                            '"tran_anulacion": null,' +
//                            '"ref_externa": null,' +
//                            '"urgente": null,' +
//                            '"afi_id": "131803",' +
//                            '"nro_sf": null,' +
//                            '"nivel": "N3",' +
//                            '"clasificacion": "BAJA COMPLEJIDAD",' +
//                            '"ap_material": "F",' +
//                            '"ap_presupuesto": "F",' +
//                            '"prestaciones": [' +
//                                '{' +
//                                    '"apr_id": "1014010140",' +
//                                    '"estado_prestacion": "C1EA-RAA",' +
//                                    '"estado_descripcion": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
//                                    '"contexto": "Ambulatorio",' +
//                                    '"cantidad": "1",' +
//                                    '"prestacion": "02501027",' +
//                                    '"nombre_prestacion": "CODIGO GENERICO EMS",' +
//                                    '"tipo_prestacion": "N",' +
//                                    '"troquel": null,' +
//                                    '"grupo_prestacion": null,' +
//                                    '"pca_id": "74042491",' +
//                                    '"alerta": null,' +
//                                    '"texto_aclarativo": null,' +
//                                    '"importe_plan_sys": "0",' +
//                                    '"importe_plan_aud": "0",' +
//                                    '"importe_convenio_sys": "0",' +
//                                    '"importe_convenio_aud": "0",' +
//                                    '"importe_rein_sys": "0",' +
//                                    '"importe_rein_aud": "0",' +
//                                    '"alertas": [' +
//                                        '{' +
//                                            '"pca_pca_id": "74042491",' +
//                                            '"aca_id": "16461630",' +
//                                            '"cca_cca_id": null,' +
//                                            '"control": "210",' +
//                                            '"nombre_control": "PRESTACION CUBIERTA",' +
//                                            '"funcion": "FCION_FRONT",' +
//                                            '"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
//                                            '"nivel_auditoria": "120",' +
//                                            '"estado_alerta": "C1EA-RAA",' +
//                                            '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
//                                            '"nota_auditor": null,' +
//                                            '"observaciones": null,' +
//                                            '"fecha_generacion": "2020-02-28 16:14:46",' +
//                                            '"fecha_lectura": "2020-02-28 16:32:19",' +
//                                            '"auditor_lee": "MAPPLICS",' +
//                                            '"fecha_resolucion": "2020-02-28 16:32:19",' +
//                                            '"auditor_resuelve": "MAPPLICS"' +
//                                        '},' +
//                                        '{' +
//                                            '"pca_pca_id": "74042491",' +
//                                            '"aca_id": "16461631",' +
//                                            '"cca_cca_id": "74105286",' +
//                                            '"control": "SABEM",' +
//                                            '"nombre_control": "AUDITORIA BACK EMS",' +
//                                            '"funcion": "FCION_BACK",' +
//                                            '"texto_aclarativo": "Informe de Alerta - Auditoría Back Ems",' +
//                                            '"nivel_auditoria": "201",' +
//                                            '"estado_alerta": "C1EA-RAA",' +
//                                            '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
//                                            '"nota_auditor": null,' +
//                                            '"observaciones": null,' +
//                                            '"fecha_generacion": "2020-02-28 16:14:52",' +
//                                            '"fecha_lectura": "2020-02-28 16:32:19",' +
//                                            '"auditor_lee": "MAPPLICS",' +
//                                            '"fecha_resolucion": "2020-02-28 16:32:19",' +
//                                            '"auditor_resuelve": "MAPPLICS"' +
//                                        '},' +
//                                        '{' +
//                                            '"pca_pca_id": "74042491",' +
//                                            '"aca_id": "16461633",' +
//                                            '"cca_cca_id": "74105286",' +
//                                            '"control": "210",' +
//                                            '"nombre_control": "PRESTACION CUBIERTA",' +
//                                            '"funcion": "FCION_FRONT",' +
//                                            '"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
//                                            '"nivel_auditoria": "120",' +
//                                            '"estado_alerta": "C1EA-RAA",' +
//                                            '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
//                                            '"nota_auditor": null,' +
//                                            '"observaciones": null,' +
//                                            '"fecha_generacion": "2020-02-28 16:14:53",' +
//                                            '"fecha_lectura": "2020-02-28 16:32:19",' +
//                                            '"auditor_lee": "MAPPLICS",' +
//                                            '"fecha_resolucion": "2020-02-28 16:32:19",' +
//                                            '"auditor_resuelve": "MAPPLICS"' +
//                                        '},' +
//                                        '{' +
//                                            '"pca_pca_id": "74042491",' +
//                                            '"aca_id": "16461634",' +
//                                            '"cca_cca_id": "74105286",' +
//                                            '"control": "245",' +
//                                            '"nombre_control": "VALORIZACIÓN PLAN",' +
//                                            '"funcion": "FCION_FRONT",' +
//                                            '"texto_aclarativo": "El valor del concepto para el Plan de afiliado es cero",' +
//                                            '"nivel_auditoria": "160",' +
//                                            '"estado_alerta": "C1EA-RAA",' +
//                                            '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
//                                            '"nota_auditor": null,' +
//                                            '"observaciones": null,' +
//                                            '"fecha_generacion": "2020-02-28 16:14:53",' +
//                                            '"fecha_lectura": "2020-02-28 16:32:19",' +
//                                            '"auditor_lee": "MAPPLICS",' +
//                                            '"fecha_resolucion": "2020-02-28 16:32:20",' +
//                                            '"auditor_resuelve": "MAPPLICS"' +
//                                        '}' +
//                                    ']' +
//                                '}' +
//                            ']' +
//                        '}' +
//                    '},' +
//                    '"httpCode": 200,' +
//                    '"message": "Se rechazó correctamente la alerta.",' +
//                    '"meta": {' +
//                        '"allowed_includes": [],' +
//                        '"default_includes": []' +
//                    '}' +
//                '}';
'{' +
                '"error": false,' +
                '"data": {' +
                    '"em": {' +
                        '"em_id": "276059",' +
                        '"fecha_inicio": "02-03-2020 00:00",' +
                        '"estado": "RECHAZADO",' +
                        '"emitido": "NO EMITIDO",' +
                        '"alerta": null,' +
                        '"fecha_emision": null,' +
                        '"segmento": [' +
                            '{' +
                                '"em_em_id": "276059",' +
                                '"sem_id": "305873",' +
                                '"fecha": "2020-03-02 00:00:00",' +
                                '"solicitante": "753415",' +
                                '"nom_solicitante": "PARDO GUILLERMO MANUEL",' +
                                '"fecha_desde_tentativa": "02-03-2020 00:00",' +
                                '"fecha_hasta_tentativa": "19-07-2047 00:00",' +
                                '"cant_dias": "10000",' +
                                '"estado": "RECHAZADO",' +
                                '"cod_auditor": null,' +
                                '"ape_auditor": null,' +
                                '"nom_auditor": null,' +
                                '"fecha_real_desde": "02-03-2020 00:00",' +
                                '"fecha_real_hasta": "19-07-2047 00:00",' +
                                '"orig_fecha_real": "MESA CENSO",' +
                                '"cod_audito2": null,' +
                                '"ape_auditor2": null,' +
                                '"nom_auditor2": null,' +
                                '"prestador": null,' +
                                '"pres_nombre": " ",' +
                                '"presentacion": null,' +
                                '"lote": null,' +
                                '"obs": null,' +
                                '"aca_nro_sf": null' +
                            '}' +
                        '],' +
                        '"efe_codigo_lugar": null,' +
                        '"cons_lugar": "0",' +
                        '"nom_lugar": " ",' +
                        '"nom_cons": null,' +
                        '"efe_codigo_resp": null,' +
                        '"nom_resp": " ",' +
                        '"efe_codigo_solic": "753415",' +
                        '"nom_solic": "PARDO GUILLERMO MANUEL",' +
                        '"tem_codigo": "HIV",' +
                        '"nom_tipo": "HIV",' +
                        '"contexto": "AMBOS",' +
                        '"de_seguimiento": "V",' +
                        '"recupero": "F",' +
                        '"diferido": "F",' +
                        '"suspendido": "F",' +
                        '"fec_vto_certif": null,' +
                        '"cod_motivo": "HIV",' +
                        '"nom_motivo": "TRATAMIENTO DE HIV",' +
                        '"mail": null,' +
                        '"diag_codigo": "B20",' +
                        '"diag_nombre": "ENFERMEDAD POR VIRUS DE LA INMUNODEFICIENCIA HUMANA [VIH], R",' +
                        '"complicaciones": "SIN COMPLICACIONES",' +
                        '"grup_pres": null,' +
                        '"gpres_nombre": null,' +
                        '"nro_prestacion": null,' +
                        '"nom_prestacion": null,' +
                        '"aut_previa": "1014010186",' +
                        '"feem_codigo": "RECH",' +
                        '"feem_nombre": "RECHAZADO",' +
                        '"domi_entrega": null,' +
                        '"agenia": null,' +
                        '"otro_domi": null,' +
                        '"via_entrega": null,' +
                        '"domicilio": null,' +
                        '"em_de_seguimiento": null,' +
                        '"tipo_seg": null,' +
                        '"nom_tipo_seg": null,' +
                        '"estado_seg": null,' +
                        '"desc_seg": null,' +
                        '"cod_regla": "HIV",' +
                        '"nom_regla": "REGLA PARA EVENTOS HIV",' +
                        '"sistema": "ABIERTO",' +
                        '"descr_em": "Asdad",' +
                        '"nom_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
                        '"obs_em": null,' +
                        '"afi_afi_id": "180012",' +
                        '"apr_apr_id": "1014010186",' +
                        '"check_mat": null,' +
                        '"check_presu": "F",' +
                        '"importe_presu": "0",' +
                        '"nro_sf": "a00Q0000009kNGBIA2",' +
                        '"ap": {' +
                            '"apr_id": "1014010186",' +
                            '"fecha": "2020-03-02 00:00:00",' +
                            '"conexion": "CX--MOST",' +
                            '"nombre_conexion": "Mostrador",' +
                            '"delegacion": "650098",' +
                            '"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
                            '"fecha_probable": "2020-03-02 00:00:00",' +
                            '"estado": "CA-----A",' +
                            '"nombre_estado": "CENTRO AUTORIZADOR",' +
                            '"user_insert": "CRIOS",' +
                            '"fecha_insert": "2020-03-02 12:33:56",' +
                            '"codigo_afiliado": "69793/39",' +
                            '"apellidos_afiliado": "ALZUGARAY LUCIA",' +
                            '"nombres_afiliado": ".",' +
                            '"doc_afiliado": "DNI 36004894",' +
                            '"evento_medico": "276059",' +
                            '"fecha_prescripcion": "2020-03-02 00:00:00",' +
                            '"diagnostico": "B20",' +
                            '"desc_diagnostico": "ENFERMEDAD POR VIRUS DE LA INMUNODEFICIENCIA HUMANA [VIH], R",' +
                            '"prescriptor": "753415",' +
                            '"nombre_prescriptor": "PARDO GUILLERMO MANUEL",' +
                            '"prestador_dirige": null,' +
                            '"nombre_prestador_dirige": null,' +
                            '"prestador": null,' +
                            '"nombre_prestador": null,' +
                            '"consultorio": "0",' +
                            '"nombre_consultorio": null,' +
                            '"observaciones": "Autorizacion de evento medico 276059",' +
                            '"mail": null,' +
                            '"otros_mail": null,' +
                            '"aca_agencia": null,' +
                            '"tran_alta": null,' +
                            '"tran_anulacion": null,' +
                            '"ref_externa": null,' +
                            '"urgente": null,' +
                            '"afi_id": "180012",' +
                            '"nro_sf": null,' +
                            '"nivel": "N3",' +
                            '"clasificacion": "BAJA COMPLEJIDAD",' +
                            '"ap_material": "F",' +
                            '"ap_presupuesto": "F",' +
                            '"prestaciones": [' +
                                '{' +
                                    '"apr_id": "1014010186",' +
                                    '"estado_prestacion": "C1EA-RAA",' +
                                    '"estado_descripcion": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                    '"contexto": "Ambulatorio",' +
                                    '"cantidad": "1",' +
                                    '"prestacion": "02501027",' +
                                    '"nombre_prestacion": "CODIGO GENERICO EMS",' +
                                    '"tipo_prestacion": "N",' +
                                    '"troquel": null,' +
                                    '"grupo_prestacion": null,' +
                                    '"pca_id": "74042509",' +
                                    '"alerta": null,' +
                                    '"texto_aclarativo": null,' +
                                    '"importe_plan_sys": "0",' +
                                    '"importe_plan_aud": "0",' +
                                    '"importe_convenio_sys": "0",' +
                                    '"importe_convenio_aud": "0",' +
                                    '"importe_cargo_al_socio_sys": "0",' +
                                    '"importe_cargo_al_socio_aud": "0",' +
                                    '"importe_rein_sys": "0",' +
                                    '"importe_rein_aud": "0",' +
                                    '"alertas": [' +
                                        '{' +
                                            '"pca_pca_id": "74042509",' +
                                            '"aca_id": "16461901",' +
                                            '"cca_cca_id": null,' +
                                            '"control": "210",' +
                                            '"nombre_control": "PRESTACION CUBIERTA",' +
                                            '"funcion": "FCION_FRONT",' +
                                            '"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
                                            '"nivel_auditoria": "120",' +
                                            '"estado_alerta": "C1EA-RAA",' +
                                            '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                            '"nota_auditor": null,' +
                                            '"observaciones": null,' +
                                            '"fecha_generacion": "2020-03-02 12:33:56",' +
                                            '"fecha_lectura": "2020-03-02 15:26:37",' +
                                            '"auditor_lee": "MAPPLICS",' +
                                            '"fecha_resolucion": "2020-03-02 15:26:37",' +
                                            '"auditor_resuelve": "MAPPLICS"' +
                                        '},' +
                                        '{' +
                                            '"pca_pca_id": "74042509",' +
                                            '"aca_id": "16461902",' +
                                            '"cca_cca_id": "74105336",' +
                                            '"control": "SABEM",' +
                                            '"nombre_control": "AUDITORIA BACK EMS",' +
                                            '"funcion": "FCION_BACK",' +
                                            '"texto_aclarativo": "Informe de Alerta - Auditoría Back Ems",' +
                                            '"nivel_auditoria": "201",' +
                                            '"estado_alerta": "C1EA-RAA",' +
                                            '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                            '"nota_auditor": null,' +
                                            '"observaciones": null,' +
                                            '"fecha_generacion": "2020-03-02 12:33:58",' +
                                            '"fecha_lectura": "2020-03-02 15:26:37",' +
                                            '"auditor_lee": "MAPPLICS",' +
                                            '"fecha_resolucion": "2020-03-02 15:26:37",' +
                                            '"auditor_resuelve": "MAPPLICS"' +
                                        '},' +
                                        '{' +
                                            '"pca_pca_id": "74042509",' +
                                            '"aca_id": "16461904",' +
                                            '"cca_cca_id": "74105336",' +
                                            '"control": "210",' +
                                            '"nombre_control": "PRESTACION CUBIERTA",' +
                                            '"funcion": "FCION_FRONT",' +
                                            '"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
                                            '"nivel_auditoria": "120",' +
                                            '"estado_alerta": "C1EA-RAA",' +
                                            '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                            '"nota_auditor": null,' +
                                            '"observaciones": null,' +
                                            '"fecha_generacion": "2020-03-02 12:33:58",' +
                                            '"fecha_lectura": "2020-03-02 15:26:37",' +
                                            '"auditor_lee": "MAPPLICS",' +
                                            '"fecha_resolucion": "2020-03-02 15:26:37",' +
                                            '"auditor_resuelve": "MAPPLICS"' +
                                        '},' +
                                        '{' +
                                            '"pca_pca_id": "74042509",' +
                                            '"aca_id": "16461905",' +
                                            '"cca_cca_id": "74105336",' +
                                            '"control": "245",' +
                                            '"nombre_control": "VALORIZACIÓN PLAN",' +
                                            '"funcion": "FCION_FRONT",' +
                                            '"texto_aclarativo": "El valor del concepto para el Plan de afiliado es cero",' +
                                            '"nivel_auditoria": "160",' +
                                            '"estado_alerta": "C1EA-RAA",' +
                                            '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                            '"nota_auditor": null,' +
                                            '"observaciones": null,' +
                                            '"fecha_generacion": "2020-03-02 12:33:58",' +
                                            '"fecha_lectura": "2020-03-02 15:26:37",' +
                                            '"auditor_lee": "MAPPLICS",' +
                                            '"fecha_resolucion": "2020-03-02 15:26:37",' +
                                            '"auditor_resuelve": "MAPPLICS"' +
                                        '}' +
                                    ']' +
                                '}' +
                            ']' +
                        '}' +
                    '}' +
                '},' +
                '"httpCode": 200,' +
                '"message": "Se rechazó correctamente la alerta.",' +
                '"meta": {' +
                    '"allowed_includes": [],' +
                    '"default_includes": []' +
                '}' +
            '}';
    }

    public static String getFound2() {
        return
            '{' +
                '"data": {' +
                    '"ap": {' +
                        '"apr_id": "1014010140",' +
                        '"fecha": "2020-02-28 00:00:00",' +
                        '"conexion": "CX--MOST",' +
                        '"nombre_conexion": "Mostrador",' +
                        '"delegacion": "650098",' +
                        '"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
                        '"fecha_probable": "2020-02-28 00:00:00",' +
                        '"estado": "CA-----A",' +
                        '"nombre_estado": "CENTRO AUTORIZADOR",' +
                        '"user_insert": "CRIOS",' +
                        '"fecha_insert": "2020-02-28 16:14:45",' +
                        '"codigo_afiliado": "54076/15",' +
                        '"apellidos_afiliado": "MARINSALDA JOSE PABLO",' +
                        '"nombres_afiliado": ".",' +
                        '"doc_afiliado": "DNI 06187024",' +
                        '"evento_medico": "275998",' +
                        '"fecha_prescripcion": "2020-02-28 00:00:00",' +
                        '"diagnostico": "A24.2",' +
                        '"desc_diagnostico": "MELIOIDOSIS SUBAGUDA Y CRÓNICA",' +
                        '"prescriptor": "700047",' +
                        '"nombre_prescriptor": "ASOC. MEDICA DE ROSARIO",' +
                        '"prestador_dirige": null,' +
                        '"nombre_prestador_dirige": null,' +
                        '"prestador": null,' +
                        '"nombre_prestador": null,' +
                        '"consultorio": "0",' +
                        '"nombre_consultorio": null,' +
                        '"observaciones": "Autorizacion de evento medico 275998",' +
                        '"mail": null,' +
                        '"otros_mail": null,' +
                        '"aca_agencia": null,' +
                        '"tran_alta": null,' +
                        '"tran_anulacion": null,' +
                        '"ref_externa": null,' +
                        '"urgente": null,' +
                        '"afi_id": "131803",' +
                        '"nro_sf": null,' +
                        '"nivel": "N3",' +
                        '"clasificacion": "BAJA COMPLEJIDAD",' +
                        '"ap_material": "F",' +
                        '"ap_presupuesto": "F",' +
                        '"prestaciones": [' +
                            '{' +
                                '"apr_id": "1014010140",' +
                                '"estado_prestacion": "C1EA-RAA",' +
                                '"estado_descripcion": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                '"contexto": "Ambulatorio",' +
                                '"cantidad": "1",' +
                                '"prestacion": "02501027",' +
                                '"nombre_prestacion": "CODIGO GENERICO EMS",' +
                                '"tipo_prestacion": "N",' +
                                '"troquel": null,' +
                                '"grupo_prestacion": null,' +
                                '"pca_id": "74042491",' +
                                '"alerta": null,' +
                                '"texto_aclarativo": null,' +
                                '"importe_plan_sys": "0",' +
                                '"importe_plan_aud": "0",' +
                                '"importe_convenio_sys": "0",' +
                                '"importe_convenio_aud": "0",' +
                                '"importe_rein_sys": "0",' +
                                '"importe_rein_aud": "0",' +
                                '"alertas": [' +
                                    '{' +
                                        '"pca_pca_id": "74042491",' +
                                        '"aca_id": "16461630",' +
                                        '"cca_cca_id": null,' +
                                        '"control": "210",' +
                                        '"nombre_control": "PRESTACION CUBIERTA",' +
                                        '"funcion": "FCION_FRONT",' +
                                        '"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
                                        '"nivel_auditoria": "120",' +
                                        '"estado_alerta": "C1EA-RAA",' +
                                        '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                        '"nota_auditor": null,' +
                                        '"observaciones": null,' +
                                        '"fecha_generacion": "2020-02-28 16:14:46",' +
                                        '"fecha_lectura": "2020-02-28 16:32:19",' +
                                        '"auditor_lee": "MAPPLICS",' +
                                        '"fecha_resolucion": "2020-02-28 16:32:19",' +
                                        '"auditor_resuelve": "MAPPLICS"' +
                                    '},' +
                                    '{' +
                                        '"pca_pca_id": "74042491",' +
                                        '"aca_id": "16461631",' +
                                        '"cca_cca_id": "74105286",' +
                                        '"control": "SABEM",' +
                                        '"nombre_control": "AUDITORIA BACK EMS",' +
                                        '"funcion": "FCION_BACK",' +
                                        '"texto_aclarativo": "Informe de Alerta - Auditoría Back Ems",' +
                                        '"nivel_auditoria": "201",' +
                                        '"estado_alerta": "C1EA-RAA",' +
                                        '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                        '"nota_auditor": null,' +
                                        '"observaciones": null,' +
                                        '"fecha_generacion": "2020-02-28 16:14:52",' +
                                        '"fecha_lectura": "2020-02-28 16:32:19",' +
                                        '"auditor_lee": "MAPPLICS",' +
                                        '"fecha_resolucion": "2020-02-28 16:32:19",' +
                                        '"auditor_resuelve": "MAPPLICS"' +
                                    '},' +
                                    '{' +
                                        '"pca_pca_id": "74042491",' +
                                        '"aca_id": "16461633",' +
                                        '"cca_cca_id": "74105286",' +
                                        '"control": "210",' +
                                        '"nombre_control": "PRESTACION CUBIERTA",' +
                                        '"funcion": "FCION_FRONT",' +
                                        '"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
                                        '"nivel_auditoria": "120",' +
                                        '"estado_alerta": "C1EA-RAA",' +
                                        '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                        '"nota_auditor": null,' +
                                        '"observaciones": null,' +
                                        '"fecha_generacion": "2020-02-28 16:14:53",' +
                                        '"fecha_lectura": "2020-02-28 16:32:19",' +
                                        '"auditor_lee": "MAPPLICS",' +
                                        '"fecha_resolucion": "2020-02-28 16:32:19",' +
                                        '"auditor_resuelve": "MAPPLICS"' +
                                    '},' +
                                    '{' +
                                        '"pca_pca_id": "74042491",' +
                                        '"aca_id": "16461634",' +
                                        '"cca_cca_id": "74105286",' +
                                        '"control": "245",' +
                                        '"nombre_control": "VALORIZACIÓN PLAN",' +
                                        '"funcion": "FCION_FRONT",' +
                                        '"texto_aclarativo": "El valor del concepto para el Plan de afiliado es cero",' +
                                        '"nivel_auditoria": "160",' +
                                        '"estado_alerta": "C1EA-RAA",' +
                                        '"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
                                        '"nota_auditor": null,' +
                                        '"observaciones": null,' +
                                        '"fecha_generacion": "2020-02-28 16:14:53",' +
                                        '"fecha_lectura": "2020-02-28 16:32:19",' +
                                        '"auditor_lee": "MAPPLICS",' +
                                        '"fecha_resolucion": "2020-02-28 16:32:20",' +
                                        '"auditor_resuelve": "MAPPLICS"' +
                                    '}' +
                                ']' +
                            '}' +
                        ']' +
                    '}' +
                '},' +
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
                        '"message": "La alerta solicitada es inválida.",' +
                        '"debug_message": [],' +
                        '"exception": "NotFoundHttpException",' +
                        '"line": 964' +
                    '}' +
                '}';
    }
}