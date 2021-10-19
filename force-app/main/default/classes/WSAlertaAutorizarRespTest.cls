@IsTest
private class WSAlertaAutorizarRespTest {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
                '    \"error\": false,'+
                '    \"data\": {'+
                '        \"em\": {'+
                '            \"em_id\": \"276013\",'+
                '            \"fecha_inicio\": \"25-02-2020 00:00\",'+
                '            \"estado\": \"AUTORIZADO\",'+
                '            \"emitido\": \"NO EMITIDO\",'+
                '            \"alerta\": null,'+
                '            \"fecha_emision\": null,'+
                '            \"segmento\": ['+
                '                {'+
                '                    \"em_em_id\": \"276013\",'+
                '                    \"sem_id\": \"305822\",'+
                '                    \"fecha\": \"2020-02-29 00:00:00\",'+
                '                    \"solicitante\": \"700047\",'+
                '                    \"nom_solicitante\": \"ASOC. MEDICA DE ROSARIO\",'+
                '                    \"fecha_desde_tentativa\": \"25-02-2020 00:00\",'+
                '                    \"fecha_hasta_tentativa\": \"13-07-2047 00:00\",'+
                '                    \"cant_dias\": \"10000\",'+
                '                    \"estado\": \"AUTORIZADO\",'+
                '                    \"cod_auditor\": null,'+
                '                    \"ape_auditor\": null,'+
                '                    \"nom_auditor\": null,'+
                '                    \"fecha_real_desde\": null,'+
                '                    \"fecha_real_hasta\": null,'+
                '                    \"orig_fecha_real\": \"MESA CENSO\",'+
                '                    \"cod_audito2\": null,'+
                '                    \"ape_auditor2\": null,'+
                '                    \"nom_auditor2\": null,'+
                '                    \"prestador\": null,'+
                '                    \"pres_nombre\": \" \",'+
                '                    \"presentacion\": null,'+
                '                    \"lote\": null,'+
                '                    \"obs\": null,'+
                '                    \"aca_nro_sf\": null'+
                '                }'+
                '            ],'+
                '            \"efe_codigo_lugar\": null,'+
                '            \"cons_lugar\": \"0\",'+
                '            \"nom_lugar\": \" \",'+
                '            \"nom_cons\": null,'+
                '            \"efe_codigo_resp\": null,'+
                '            \"nom_resp\": \" \",'+
                '            \"efe_codigo_solic\": \"700047\",'+
                '            \"nom_solic\": \"ASOC. MEDICA DE ROSARIO\",'+
                '            \"tem_codigo\": \"HIV\",'+
                '            \"nom_tipo\": \"HIV\",'+
                '            \"contexto\": \"AMBOS\",'+
                '            \"de_seguimiento\": \"V\",'+
                '            \"recupero\": \"F\",'+
                '            \"diferido\": \"F\",'+
                '            \"suspendido\": \"F\",'+
                '            \"fec_vto_certif\": null,'+
                '            \"cod_motivo\": \"HIV\",'+
                '            \"nom_motivo\": \"TRATAMIENTO DE HIV\",'+
                '            \"mail\": null,'+
                '            \"diag_codigo\": \"B20\",'+
                '            \"diag_nombre\": \"ENFERMEDAD POR VIRUS DE LA INMUNODEFICIENCIA HUMANA [VIH], R\",'+
                '            \"complicaciones\": \"SIN COMPLICACIONES\",'+
                '            \"grup_pres\": null,'+
                '            \"gpres_nombre\": null,'+
                '            \"nro_prestacion\": null,'+
                '            \"nom_prestacion\": null,'+
                '            \"aut_previa\": \"1014010147\",'+
                '            \"feem_codigo\": null,'+
                '            \"feem_nombre\": null,'+
                '            \"domi_entrega\": null,'+
                '            \"agenia\": null,'+
                '            \"otro_domi\": null,'+
                '            \"via_entrega\": null,'+
                '            \"domicilio\": null,'+
                '            \"em_de_seguimiento\": null,'+
                '            \"tipo_seg\": null,'+
                '            \"nom_tipo_seg\": null,'+
                '            \"estado_seg\": null,'+
                '            \"desc_seg\": null,'+
                '            \"cod_regla\": \"HIV\",'+
                '            \"nom_regla\": \"REGLA PARA EVENTOS HIV\",'+
                '            \"sistema\": \"ABIERTO\",'+
                '            \"descr_em\": \"Dasd\",'+
                '            \"nom_delegacion\": \"650098_ACA SALUD SUC. ROSARIO\",'+
                '            \"obs_em\": null,'+
                '            \"afi_afi_id\": \"180013\",'+
                '            \"apr_apr_id\": \"1014010147\",'+
                '            \"check_mat\": null,'+
                '            \"check_presu\": \"F\",'+
                '            \"importe_presu\": \"0\",'+
                '            \"nro_sf\": \"a00Q0000009kN5rIAE\",'+
                '            \"ap\": {'+
                '                \"apr_id\": \"1014010147\",'+
                '                \"fecha\": \"2020-02-29 00:00:00\",'+
                '                \"conexion\": \"CX--MOST\",'+
                '                \"nombre_conexion\": \"Mostrador\",'+
                '                \"delegacion\": \"650098\",'+
                '                \"nombre_delegacion\": \"650098_ACA SALUD SUC. ROSARIO\",'+
                '                \"fecha_probable\": \"2020-02-29 00:00:00\",'+
                '                \"estado\": \"CA-----A\",'+
                '                \"nombre_estado\": \"CENTRO AUTORIZADOR\",'+
                '                \"user_insert\": \"CRIOS\",'+
                '                \"fecha_insert\": \"2020-02-29 02:50:15\",'+
                '                \"codigo_afiliado\": \"69793/46\",'+
                '                \"apellidos_afiliado\": \"ALZUGARAY CAMILA\",'+
                '                \"nombres_afiliado\": \".\",'+
                '                \"doc_afiliado\": \"DNI 38135944\",'+
                '                \"evento_medico\": \"276013\",'+
                '                \"fecha_prescripcion\": \"2020-02-25 00:00:00\",'+
                '                \"diagnostico\": \"B20\",'+
                '                \"desc_diagnostico\": \"ENFERMEDAD POR VIRUS DE LA INMUNODEFICIENCIA HUMANA [VIH], R\",'+
                '                \"prescriptor\": \"700047\",'+
                '                \"nombre_prescriptor\": \"ASOC. MEDICA DE ROSARIO\",'+
                '                \"prestador_dirige\": null,'+
                '                \"nombre_prestador_dirige\": null,'+
                '                \"prestador\": null,'+
                '                \"nombre_prestador\": null,'+
                '                \"consultorio\": \"0\",'+
                '                \"nombre_consultorio\": null,'+
                '                \"observaciones\": \"Autorizacion de evento medico 276013\",'+
                '                \"mail\": null,'+
                '                \"otros_mail\": null,'+
                '                \"aca_agencia\": null,'+
                '                \"tran_alta\": null,'+
                '                \"tran_anulacion\": null,'+
                '                \"ref_externa\": null,'+
                '                \"urgente\": null,'+
                '                \"afi_id\": \"180013\",'+
                '                \"nro_sf\": null,'+
                '                \"nivel\": \"N3\",'+
                '                \"clasificacion\": \"BAJA COMPLEJIDAD\",'+
                '                \"ap_material\": \"F\",'+
                '                \"ap_presupuesto\": \"F\",'+
                '                \"prestaciones\": ['+
                '                    {'+
                '                        \"apr_id\": \"1014010147\",'+
                '                        \"estado_prestacion\": \"C1EA--AA\",'+
                '                        \"estado_descripcion\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                        \"contexto\": \"Ambulatorio\",'+
                '                        \"cantidad\": \"1\",'+
                '                        \"prestacion\": \"02501027\",'+
                '                        \"nombre_prestacion\": \"CODIGO GENERICO EMS\",'+
                '                        \"tipo_prestacion\": \"N\",'+
                '                        \"troquel\": null,'+
                '                        \"grupo_prestacion\": null,'+
                '                        \"pca_id\": \"74042498\",'+
                '                        \"alerta\": null,'+
                '                        \"texto_aclarativo\": null,'+
                '                        \"importe_plan_sys\": \"0\",'+
                '                        \"importe_plan_aud\": \"0\",'+
                '                        \"importe_convenio_sys\": \"0\",'+
                '                        \"importe_convenio_aud\": \"0\",'+
                '                        \"importe_rein_sys\": \"0\",'+
                '                        \"importe_rein_aud\": \"0\",'+
                '                        \"alertas\": ['+
                '                            {'+
                '                                \"pca_pca_id\": \"74042498\",'+
                '                                \"aca_id\": \"16461690\",'+
                '                                \"cca_cca_id\": null,'+
                '                                \"control\": \"210\",'+
                '                                \"nombre_control\": \"PRESTACION CUBIERTA\",'+
                '                                \"funcion\": \"FCION_FRONT\",'+
                '                                \"texto_aclarativo\": \"La Prestación/Medicamento no está cubierta para el Afiliado\",'+
                '                                \"nivel_auditoria\": \"120\",'+
                '                                \"estado_alerta\": \"C1EA--AA\",'+
                '                                \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                                \"nota_auditor\": null,'+
                '                                \"observaciones\": null,'+
                '                                \"fecha_generacion\": \"2020-02-29 02:50:16\",'+
                '                                \"fecha_lectura\": \"2020-02-29 02:57:22\",'+
                '                                \"auditor_lee\": \"CRIOS\",'+
                '                                \"fecha_resolucion\": \"2020-02-29 02:57:22\",'+
                '                                \"auditor_resuelve\": \"CRIOS\"'+
                '                            },'+
                '                            {'+
                '                                \"pca_pca_id\": \"74042498\",'+
                '                                \"aca_id\": \"16461691\",'+
                '                                \"cca_cca_id\": \"74105295\",'+
                '                                \"control\": \"SABEM\",'+
                '                                \"nombre_control\": \"AUDITORIA BACK EMS\",'+
                '                                \"funcion\": \"FCION_BACK\",'+
                '                                \"texto_aclarativo\": \"Informe de Alerta - Auditoría Back Ems\",'+
                '                                \"nivel_auditoria\": \"201\",'+
                '                                \"estado_alerta\": \"C1EA--AA\",'+
                '                                \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                                \"nota_auditor\": null,'+
                '                                \"observaciones\": null,'+
                '                                \"fecha_generacion\": \"2020-02-29 02:50:17\",'+
                '                                \"fecha_lectura\": \"2020-02-29 02:57:22\",'+
                '                                \"auditor_lee\": \"CRIOS\",'+
                '                                \"fecha_resolucion\": \"2020-02-29 02:57:22\",'+
                '                                \"auditor_resuelve\": \"CRIOS\"'+
                '                            },'+
                '                            {'+
                '                                \"pca_pca_id\": \"74042498\",'+
                '                                \"aca_id\": \"16461693\",'+
                '                                \"cca_cca_id\": \"74105295\",'+
                '                                \"control\": \"210\",'+
                '                                \"nombre_control\": \"PRESTACION CUBIERTA\",'+
                '                                \"funcion\": \"FCION_FRONT\",'+
                '                                \"texto_aclarativo\": \"La Prestación/Medicamento no está cubierta para el Afiliado\",'+
                '                                \"nivel_auditoria\": \"120\",'+
                '                                \"estado_alerta\": \"C1EA--AA\",'+
                '                                \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                                \"nota_auditor\": null,'+
                '                                \"observaciones\": null,'+
                '                                \"fecha_generacion\": \"2020-02-29 02:50:17\",'+
                '                                \"fecha_lectura\": \"2020-02-29 02:57:22\",'+
                '                                \"auditor_lee\": \"CRIOS\",'+
                '                                \"fecha_resolucion\": \"2020-02-29 02:57:22\",'+
                '                                \"auditor_resuelve\": \"CRIOS\"'+
                '                            },'+
                '                            {'+
                '                                \"pca_pca_id\": \"74042498\",'+
                '                                \"aca_id\": \"16461694\",'+
                '                                \"cca_cca_id\": \"74105295\",'+
                '                                \"control\": \"245\",'+
                '                                \"nombre_control\": \"VALORIZACIÓN PLAN\",'+
                '                                \"funcion\": \"FCION_FRONT\",'+
                '                                \"texto_aclarativo\": \"El valor del concepto para el Plan de afiliado es cero\",'+
                '                                \"nivel_auditoria\": \"160\",'+
                '                                \"estado_alerta\": \"C1EA--AA\",'+
                '                                \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                                \"nota_auditor\": null,'+
                '                                \"observaciones\": null,'+
                '                                \"fecha_generacion\": \"2020-02-29 02:50:17\",'+
                '                                \"fecha_lectura\": \"2020-02-29 02:57:22\",'+
                '                                \"auditor_lee\": \"CRIOS\",'+
                '                                \"fecha_resolucion\": \"2020-02-29 02:57:22\",'+
                '                                \"auditor_resuelve\": \"CRIOS\"'+
                '                            }'+
                '                        ]'+
                '                    }'+
                '                ]'+
                '            }'+
                '        },'+
                '        \"ap\": {'+
                '            \"apr_id\": \"1014010152\",'+
                '            \"fecha\": \"2020-02-29 00:00:00\",'+
                '            \"conexion\": \"CX--MOST\",'+
                '            \"nombre_conexion\": \"Mostrador\",'+
                '            \"delegacion\": \"650098\",'+
                '            \"nombre_delegacion\": \"650098_ACA SALUD SUC. ROSARIO\",'+
                '            \"fecha_probable\": \"2020-02-29 00:00:00\",'+
                '            \"estado\": \"CA-----A\",'+
                '            \"nombre_estado\": \"CENTRO AUTORIZADOR\",'+
                '            \"user_insert\": \"CRIOS\",'+
                '            \"fecha_insert\": \"2020-02-29 17:55:31\",'+
                '            \"codigo_afiliado\": \"69793\\/46\",'+
                '            \"apellidos_afiliado\": \"ALZUGARAY CAMILA\",'+
                '            \"nombres_afiliado\": \".\",'+
                '            \"doc_afiliado\": \"DNI 38135944\",'+
                '            \"evento_medico\": \"276015\",'+
                '            \"fecha_prescripcion\": \"2020-02-29 00:00:00\",'+
                '            \"diagnostico\": \"B20\",'+
                '            \"desc_diagnostico\": \"ENFERMEDAD POR VIRUS DE LA INMUNODEFICIENCIA HUMANA [VIH], R\",'+
                '            \"prescriptor\": \"700047\",'+
                '            \"nombre_prescriptor\": \"ASOC. MEDICA DE ROSARIO\",'+
                '            \"prestador_dirige\": null,'+
                '            \"nombre_prestador_dirige\": null,'+
                '            \"prestador\": null,'+
                '            \"nombre_prestador\": null,'+
                '            \"consultorio\": \"0\",'+
                '            \"nombre_consultorio\": null,'+
                '            \"observaciones\": \"Autorizacion de evento medico 276015\",'+
                '            \"mail\": null,'+
                '            \"otros_mail\": null,'+
                '            \"aca_agencia\": null,'+
                '            \"tran_alta\": null,'+
                '            \"tran_anulacion\": null,'+
                '            \"ref_externa\": null,'+
                '            \"urgente\": null,'+
                '            \"afi_id\": \"180013\",'+
                '            \"nro_sf\": null,'+
                '            \"nivel\": \"N3\",'+
                '            \"clasificacion\": \"BAJA COMPLEJIDAD\",'+
                '            \"ap_material\": \"F\",'+
                '            \"ap_presupuesto\": \"F\",'+
                '            \"prestaciones\": ['+
                '                {'+
                '                    \"apr_id\": \"1014010152\",'+
                '                    \"estado_prestacion\": \"C1EA--AA\",'+
                '                    \"estado_descripcion\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                    \"contexto\": \"Ambulatorio\",'+
                '                    \"cantidad\": \"1\",'+
                '                    \"prestacion\": \"02501027\",'+
                '                    \"nombre_prestacion\": \"CODIGO GENERICO EMS\",'+
                '                    \"tipo_prestacion\": \"N\",'+
                '                    \"troquel\": null,'+
                '                    \"grupo_prestacion\": null,'+
                '                    \"pca_id\": \"74042503\",'+
                '                    \"alerta\": null,'+
                '                    \"texto_aclarativo\": null,'+
                '                    \"importe_plan_sys\": \"0\",'+
                '                    \"importe_plan_aud\": \"0\",'+
                '                    \"importe_convenio_sys\": \"0\",'+
                '                    \"importe_convenio_aud\": \"0\",'+
                '                    \"importe_rein_sys\": \"0\",'+
                '                    \"importe_rein_aud\": \"0\",'+
                '                    \"alertas\": ['+
                '                        {'+
                '                            \"pca_pca_id\": \"74042503\",'+
                '                            \"aca_id\": \"16461790\",'+
                '                            \"cca_cca_id\": \"74105315\",'+
                '                            \"control\": \"SABEM\",'+
                '                            \"nombre_control\": \"AUDITORIA BACK EMS\",'+
                '                            \"funcion\": \"FCION_BACK\",'+
                '                            \"texto_aclarativo\": \"Informe de Alerta - Auditor\\u00eda Back Ems\",'+
                '                            \"nivel_auditoria\": \"201\",'+
                '                            \"estado_alerta\": \"C1EA--AA\",'+
                '                            \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                            \"nota_auditor\": null,'+
                '                            \"observaciones\": null,'+
                '                            \"fecha_generacion\": \"2020-02-29 18:24:25\",'+
                '                            \"fecha_lectura\": \"2020-02-29 18:26:08\",'+
                '                            \"auditor_lee\": \"CRIOS\",'+
                '                            \"fecha_resolucion\": \"2020-02-29 18:26:08\",'+
                '                            \"auditor_resuelve\": \"CRIOS\"'+
                '                        },'+
                '                        {'+
                '                            \"pca_pca_id\": \"74042503\",'+
                '                            \"aca_id\": \"16461792\",'+
                '                            \"cca_cca_id\": \"74105315\",'+
                '                            \"control\": \"210\",'+
                '                            \"nombre_control\": \"PRESTACION CUBIERTA\",'+
                '                            \"funcion\": \"FCION_FRONT\",'+
                '                            \"texto_aclarativo\": \"La Prestaci\\u00f3n\\/Medicamento no est\\u00e1 cubierta para el Afiliado\",'+
                '                            \"nivel_auditoria\": \"120\",'+
                '                            \"estado_alerta\": \"C1EA--AA\",'+
                '                            \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                            \"nota_auditor\": null,'+
                '                            \"observaciones\": null,'+
                '                            \"fecha_generacion\": \"2020-02-29 18:24:26\",'+
                '                            \"fecha_lectura\": \"2020-02-29 18:26:08\",'+
                '                            \"auditor_lee\": \"CRIOS\",'+
                '                            \"fecha_resolucion\": \"2020-02-29 18:26:08\",'+
                '                            \"auditor_resuelve\": \"CRIOS\"'+
                '                        },'+
                '                        {'+
                '                            \"pca_pca_id\": \"74042503\",'+
                '                            \"aca_id\": \"16461793\",'+
                '                            \"cca_cca_id\": \"74105315\",'+
                '                            \"control\": \"245\",'+
                '                            \"nombre_control\": \"VALORIZACI\\u00d3N PLAN\",'+
                '                            \"funcion\": \"FCION_FRONT\",'+
                '                            \"texto_aclarativo\": \"El valor del concepto para el Plan de afiliado es cero\",'+
                '                            \"nivel_auditoria\": \"160\",'+
                '                            \"estado_alerta\": \"C1EA--AA\",'+
                '                            \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                            \"nota_auditor\": null,'+
                '                            \"observaciones\": null,'+
                '                            \"fecha_generacion\": \"2020-02-29 18:24:26\",'+
                '                            \"fecha_lectura\": \"2020-02-29 18:26:08\",'+
                '                            \"auditor_lee\": \"CRIOS\",'+
                '                            \"fecha_resolucion\": \"2020-02-29 18:26:08\",'+
                '                            \"auditor_resuelve\": \"CRIOS\"'+
                '                        },'+
                '                        {'+
                '                            \"pca_pca_id\": \"74042503\",'+
                '                            \"aca_id\": \"16461789\",'+
                '                            \"cca_cca_id\": null,'+
                '                            \"control\": \"210\",'+
                '                            \"nombre_control\": \"PRESTACION CUBIERTA\",'+
                '                            \"funcion\": \"FCION_FRONT\",'+
                '                            \"texto_aclarativo\": \"La Prestaci\\u00f3n\\/Medicamento no est\\u00e1 cubierta para el Afiliado\",'+
                '                            \"nivel_auditoria\": \"120\",'+
                '                            \"estado_alerta\": \"C1EA--AA\",'+
                '                            \"descripcion_estado\": \"AUTORIZADO POR EL AUDITOR\",'+
                '                            \"nota_auditor\": null,'+
                '                            \"observaciones\": null,'+
                '                            \"fecha_generacion\": \"2020-02-29 18:24:25\",'+
                '                            \"fecha_lectura\": \"2020-02-29 18:26:08\",'+
                '                            \"auditor_lee\": \"CRIOS\",'+
                '                            \"fecha_resolucion\": \"2020-02-29 18:26:08\",'+
                '                            \"auditor_resuelve\": \"CRIOS\"'+
                '                        }'+
                '                    ]'+
                '                }'+
                '            ]'+
                '        }'+
                '    },'+
                '    \"httpCode\": 200,'+
                '    \"message\": \"Se autorizó correctamente la alerta.\",'+
                '    \"meta\": {'+
                '        \"allowed_includes\": [],'+
                '        \"default_includes\": []'+
                '    }'+
                '}';
        WSAlertaAutorizarResp r = WSAlertaAutorizarResp.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSAlertaAutorizarResp.Meta objMeta = new WSAlertaAutorizarResp.Meta(System.JSON.createParser(json));
        System.assert(objMeta != null);
        System.assert(objMeta.allowed_includes == null);
        System.assert(objMeta.default_includes == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSAlertaAutorizarResp.Allowed_includes objAllowed_includes = new WSAlertaAutorizarResp.Allowed_includes(System.JSON.createParser(json));
        System.assert(objAllowed_includes != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSAlertaAutorizarResp.Prestaciones objPrestaciones = new WSAlertaAutorizarResp.Prestaciones(System.JSON.createParser(json));
        System.assert(objPrestaciones != null);
        System.assert(objPrestaciones.apr_id == null);
        System.assert(objPrestaciones.estado_prestacion == null);
        System.assert(objPrestaciones.estado_descripcion == null);
        System.assert(objPrestaciones.contexto == null);
        System.assert(objPrestaciones.cantidad == null);
        System.assert(objPrestaciones.prestacion == null);
        System.assert(objPrestaciones.nombre_prestacion == null);
        System.assert(objPrestaciones.tipo_prestacion == null);
        System.assert(objPrestaciones.troquel == null);
        System.assert(objPrestaciones.grupo_prestacion == null);
        System.assert(objPrestaciones.pca_id == null);
        System.assert(objPrestaciones.alerta == null);
        System.assert(objPrestaciones.texto_aclarativo == null);
        System.assert(objPrestaciones.importe_plan_sys == null);
        System.assert(objPrestaciones.importe_plan_aud == null);
        System.assert(objPrestaciones.importe_convenio_sys == null);
        System.assert(objPrestaciones.importe_convenio_aud == null);
        System.assert(objPrestaciones.importe_rein_sys == null);
        System.assert(objPrestaciones.importe_rein_aud == null);
        System.assert(objPrestaciones.alertas == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSAlertaAutorizarResp.Segmento objSegmento = new WSAlertaAutorizarResp.Segmento(System.JSON.createParser(json));
        System.assert(objSegmento != null);
        System.assert(objSegmento.em_em_id == null);
        System.assert(objSegmento.sem_id == null);
        System.assert(objSegmento.fecha == null);
        System.assert(objSegmento.solicitante == null);
        System.assert(objSegmento.nom_solicitante == null);
        System.assert(objSegmento.fecha_desde_tentativa == null);
        System.assert(objSegmento.fecha_hasta_tentativa == null);
        System.assert(objSegmento.cant_dias == null);
        System.assert(objSegmento.estado == null);
        System.assert(objSegmento.cod_auditor == null);
        System.assert(objSegmento.ape_auditor == null);
        System.assert(objSegmento.nom_auditor == null);
        System.assert(objSegmento.fecha_real_desde == null);
        System.assert(objSegmento.fecha_real_hasta == null);
        System.assert(objSegmento.orig_fecha_real == null);
        System.assert(objSegmento.cod_audito2 == null);
        System.assert(objSegmento.ape_auditor2 == null);
        System.assert(objSegmento.nom_auditor2 == null);
        System.assert(objSegmento.prestador == null);
        System.assert(objSegmento.pres_nombre == null);
        System.assert(objSegmento.presentacion == null);
        System.assert(objSegmento.lote == null);
        System.assert(objSegmento.obs == null);
        System.assert(objSegmento.aca_nro_sf == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSAlertaAutorizarResp.Em objEm = new WSAlertaAutorizarResp.Em(System.JSON.createParser(json));
        System.assert(objEm != null);
        System.assert(objEm.em_id == null);
        System.assert(objEm.fecha_inicio == null);
        System.assert(objEm.estado == null);
        System.assert(objEm.emitido == null);
        System.assert(objEm.alerta == null);
        System.assert(objEm.fecha_emision == null);
        System.assert(objEm.segmento == null);
        System.assert(objEm.efe_codigo_lugar == null);
        System.assert(objEm.cons_lugar == null);
        System.assert(objEm.nom_lugar == null);
        System.assert(objEm.nom_cons == null);
        System.assert(objEm.efe_codigo_resp == null);
        System.assert(objEm.nom_resp == null);
        System.assert(objEm.efe_codigo_solic == null);
        System.assert(objEm.nom_solic == null);
        System.assert(objEm.tem_codigo == null);
        System.assert(objEm.nom_tipo == null);
        System.assert(objEm.contexto == null);
        System.assert(objEm.de_seguimiento == null);
        System.assert(objEm.recupero == null);
        System.assert(objEm.diferido == null);
        System.assert(objEm.suspendido == null);
        System.assert(objEm.fec_vto_certif == null);
        System.assert(objEm.cod_motivo == null);
        System.assert(objEm.nom_motivo == null);
        System.assert(objEm.mail == null);
        System.assert(objEm.diag_codigo == null);
        System.assert(objEm.diag_nombre == null);
        System.assert(objEm.complicaciones == null);
        System.assert(objEm.grup_pres == null);
        System.assert(objEm.gpres_nombre == null);
        System.assert(objEm.nro_prestacion == null);
        System.assert(objEm.nom_prestacion == null);
        System.assert(objEm.aut_previa == null);
        System.assert(objEm.feem_codigo == null);
        System.assert(objEm.feem_nombre == null);
        System.assert(objEm.domi_entrega == null);
        System.assert(objEm.agenia == null);
        System.assert(objEm.otro_domi == null);
        System.assert(objEm.via_entrega == null);
        System.assert(objEm.domicilio == null);
        System.assert(objEm.em_de_seguimiento == null);
        System.assert(objEm.tipo_seg == null);
        System.assert(objEm.nom_tipo_seg == null);
        System.assert(objEm.estado_seg == null);
        System.assert(objEm.desc_seg == null);
        System.assert(objEm.cod_regla == null);
        System.assert(objEm.nom_regla == null);
        System.assert(objEm.sistema == null);
        System.assert(objEm.descr_em == null);
        System.assert(objEm.nom_delegacion == null);
        System.assert(objEm.obs_em == null);
        System.assert(objEm.afi_afi_id == null);
        System.assert(objEm.apr_apr_id == null);
        System.assert(objEm.check_mat == null);
        System.assert(objEm.check_presu == null);
        System.assert(objEm.importe_presu == null);
        System.assert(objEm.nro_sf == null);
        System.assert(objEm.ap == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSAlertaAutorizarResp.Data objData = new WSAlertaAutorizarResp.Data(System.JSON.createParser(json));
        System.assert(objData != null);
        System.assert(objData.em == null);
        System.assert(objData.ap == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSAlertaAutorizarResp objWSAlertaAutorizarResp = new WSAlertaAutorizarResp(System.JSON.createParser(json));
        System.assert(objWSAlertaAutorizarResp != null);
        System.assert(objWSAlertaAutorizarResp.error == null);
        System.assert(objWSAlertaAutorizarResp.data == null);
        System.assert(objWSAlertaAutorizarResp.httpCode == null);
        System.assert(objWSAlertaAutorizarResp.message == null);
        System.assert(objWSAlertaAutorizarResp.meta == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSAlertaAutorizarResp.Ap objAp = new WSAlertaAutorizarResp.Ap(System.JSON.createParser(json));
        System.assert(objAp != null);
        System.assert(objAp.apr_id == null);
        System.assert(objAp.fecha == null);
        System.assert(objAp.conexion == null);
        System.assert(objAp.nombre_conexion == null);
        System.assert(objAp.delegacion == null);
        System.assert(objAp.nombre_delegacion == null);
        System.assert(objAp.fecha_probable == null);
        System.assert(objAp.estado == null);
        System.assert(objAp.nombre_estado == null);
        System.assert(objAp.user_insert == null);
        System.assert(objAp.fecha_insert == null);
        System.assert(objAp.codigo_afiliado == null);
        System.assert(objAp.apellidos_afiliado == null);
        System.assert(objAp.nombres_afiliado == null);
        System.assert(objAp.doc_afiliado == null);
        System.assert(objAp.evento_medico == null);
        System.assert(objAp.fecha_prescripcion == null);
        System.assert(objAp.diagnostico == null);
        System.assert(objAp.desc_diagnostico == null);
        System.assert(objAp.prescriptor == null);
        System.assert(objAp.nombre_prescriptor == null);
        System.assert(objAp.prestador_dirige == null);
        System.assert(objAp.nombre_prestador_dirige == null);
        System.assert(objAp.prestador == null);
        System.assert(objAp.nombre_prestador == null);
        System.assert(objAp.consultorio == null);
        System.assert(objAp.nombre_consultorio == null);
        System.assert(objAp.observaciones == null);
        System.assert(objAp.mail == null);
        System.assert(objAp.otros_mail == null);
        System.assert(objAp.aca_agencia == null);
        System.assert(objAp.tran_alta == null);
        System.assert(objAp.tran_anulacion == null);
        System.assert(objAp.ref_externa == null);
        System.assert(objAp.urgente == null);
        System.assert(objAp.afi_id == null);
        System.assert(objAp.nro_sf == null);
        System.assert(objAp.nivel == null);
        System.assert(objAp.clasificacion == null);
        System.assert(objAp.ap_material == null);
        System.assert(objAp.ap_presupuesto == null);
        System.assert(objAp.prestaciones == null);
    }
}