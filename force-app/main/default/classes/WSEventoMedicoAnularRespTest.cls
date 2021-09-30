@IsTest
private class WSEventoMedicoAnularRespTest {
    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
                '  \"error\": false,'+
                '  \"data\": {'+
                '    \"em_id\": \"249818\",'+
                '    \"fecha_inicio\": \"04-04-2020 00:00\",'+
                '    \"estado\": \"ANULADO\",'+
                '    \"emitido\": \"NO EMITIDO\",'+
                '    \"alerta\": \"EL AFILIADO TIENE ALERTAS DE AUTORIZACION PREVIA\",'+
                '    \"fecha_emision\": null,'+
                '    \"segmento\": \"VOL\",'+
                '    \"efe_codigo_lugar\": null,'+
                '    \"cons_lugar\": null,'+
                '    \"nom_lugar\": \" \",'+
                '    \"nom_cons\": null,'+
                '    \"efe_codigo_resp\": null,'+
                '    \"nom_resp\": \" \",'+
                '    \"efe_codigo_solic\": \"743222\",'+
                '    \"nom_solic\": \"BUILS ROBERTO JOSE\",'+
                '    \"tem_codigo\": \"ANTICONCEPTIVOS\",'+
                '    \"nom_tipo\": \"PROVISION ANTICONCEPTIVOS\",'+
                '    \"contexto\": \"AMBOS\",'+
                '    \"de_seguimiento\": \"V\",'+
                '    \"recupero\": \"F\",'+
                '    \"diferido\": \"F\",'+
                '    \"suspendido\": \"F\",'+
                '    \"fec_vto_certif\": null,'+
                '    \"cod_motivo\": \"ANTICONCEPTIVOS\",'+
                '    \"nom_motivo\": \"ANTICONCEPTIVOS\",'+
                '    \"mail\": null,'+
                '    \"diag_codigo\": \"Z30\",'+
                '    \"diag_nombre\": \"ATENCIÓN PARA LA ANTICONCEPCIÓN\",'+
                '    \"complicaciones\": \"SIN COMPLICACIONES\",'+
                '    \"grup_pres\": null,'+
                '    \"gpres_nombre\": null,'+
                '    \"nro_prestacion\": null,'+
                '    \"nom_prestacion\": null,'+
                '    \"aut_previa\": null,'+
                '    \"feem_codigo\": null,'+
                '    \"feem_nombre\": null,'+
                '    \"domi_entrega\": \"AGENCIA\",'+
                '    \"agenia\": \"650098\",'+
                '    \"otro_domi\": null,'+
                '    \"via_entrega\": \"AGENCIA\",'+
                '    \"domicilio\": \"650098\",'+
                '    \"em_de_seguimiento\": null,'+
                '    \"tipo_seg\": null,'+
                '    \"nom_tipo_seg\": null,'+
                '    \"estado_seg\": null,'+
                '    \"desc_seg\": null,'+
                '    \"cod_regla\": \"ANTICONCEPTIVOS\",'+
                '    \"nom_regla\": \"PROVISIÓN DE ANTICONCEPTIVOS\",'+
                '    \"sistema\": \"ABIERTO\",'+
                '    \"descr_em\": \"ACO\",'+
                '    \"nom_delegacion\": \"650098_ACA SALUD SUC. ROSARIO\",'+
                '    \"obs_em\": null,'+
                '    \"afi_afi_id\": \"383720\",'+
                '    \"apr_apr_id\": null,'+
                '    \"check_mat\": \"F\",'+
                '    \"check_presu\": \"F\",'+
                '    \"importe_presu\": null,'+
                '    \"nro_sf\": null'+
                '  },'+
                '  \"httpCode\": 200,'+
                '  \"message\": \"Se anuló correctamente el evento médico.\",'+
                '  \"meta\": {'+
                '    \"allowed_includes\": [],'+
                '    \"default_includes\": []'+
                '  }'+
                '}';
        WSEventoMedicoAnularResp r = WSEventoMedicoAnularResp.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSEventoMedicoAnularResp.Meta objMeta = new WSEventoMedicoAnularResp.Meta(System.JSON.createParser(json));
        System.assert(objMeta != null);
        System.assert(objMeta.allowed_includes == null);
        System.assert(objMeta.default_includes == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSEventoMedicoAnularResp.Allowed_includes objAllowed_includes = new WSEventoMedicoAnularResp.Allowed_includes(System.JSON.createParser(json));
        System.assert(objAllowed_includes != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSEventoMedicoAnularResp.Data objData = new WSEventoMedicoAnularResp.Data(System.JSON.createParser(json));
        System.assert(objData != null);
        System.assert(objData.em_id == null);
        System.assert(objData.fecha_inicio == null);
        System.assert(objData.estado == null);
        System.assert(objData.emitido == null);
        System.assert(objData.alerta == null);
        System.assert(objData.fecha_emision == null);
        System.assert(objData.segmento == null);
        System.assert(objData.efe_codigo_lugar == null);
        System.assert(objData.cons_lugar == null);
        System.assert(objData.nom_lugar == null);
        System.assert(objData.nom_cons == null);
        System.assert(objData.efe_codigo_resp == null);
        System.assert(objData.nom_resp == null);
        System.assert(objData.efe_codigo_solic == null);
        System.assert(objData.nom_solic == null);
        System.assert(objData.tem_codigo == null);
        System.assert(objData.nom_tipo == null);
        System.assert(objData.contexto == null);
        System.assert(objData.de_seguimiento == null);
        System.assert(objData.recupero == null);
        System.assert(objData.diferido == null);
        System.assert(objData.suspendido == null);
        System.assert(objData.fec_vto_certif == null);
        System.assert(objData.cod_motivo == null);
        System.assert(objData.nom_motivo == null);
        System.assert(objData.mail == null);
        System.assert(objData.diag_codigo == null);
        System.assert(objData.diag_nombre == null);
        System.assert(objData.complicaciones == null);
        System.assert(objData.grup_pres == null);
        System.assert(objData.gpres_nombre == null);
        System.assert(objData.nro_prestacion == null);
        System.assert(objData.nom_prestacion == null);
        System.assert(objData.aut_previa == null);
        System.assert(objData.feem_codigo == null);
        System.assert(objData.feem_nombre == null);
        System.assert(objData.domi_entrega == null);
        System.assert(objData.agenia == null);
        System.assert(objData.otro_domi == null);
        System.assert(objData.via_entrega == null);
        System.assert(objData.domicilio == null);
        System.assert(objData.em_de_seguimiento == null);
        System.assert(objData.tipo_seg == null);
        System.assert(objData.nom_tipo_seg == null);
        System.assert(objData.estado_seg == null);
        System.assert(objData.desc_seg == null);
        System.assert(objData.cod_regla == null);
        System.assert(objData.nom_regla == null);
        System.assert(objData.sistema == null);
        System.assert(objData.descr_em == null);
        System.assert(objData.nom_delegacion == null);
        System.assert(objData.obs_em == null);
        System.assert(objData.afi_afi_id == null);
        System.assert(objData.apr_apr_id == null);
        System.assert(objData.check_mat == null);
        System.assert(objData.check_presu == null);
        System.assert(objData.importe_presu == null);
        System.assert(objData.nro_sf == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WSEventoMedicoAnularResp objWSEventoMedicoAnularResp = new WSEventoMedicoAnularResp(System.JSON.createParser(json));
        System.assert(objWSEventoMedicoAnularResp != null);
        System.assert(objWSEventoMedicoAnularResp.error == null);
        System.assert(objWSEventoMedicoAnularResp.data == null);
        System.assert(objWSEventoMedicoAnularResp.httpCode == null);
        System.assert(objWSEventoMedicoAnularResp.message == null);
        System.assert(objWSEventoMedicoAnularResp.meta == null);
    }
}