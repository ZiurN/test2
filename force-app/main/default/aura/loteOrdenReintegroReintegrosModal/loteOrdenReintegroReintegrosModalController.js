({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'lote', fieldName: 'lote', type: 'text', fixedWidth: 130 },
            { label: 'lote_original', fieldName: 'lote_original', type: 'text', fixedWidth: 130 },
            { label: 'rei_id', fieldName: 'rei_id', type: 'text', fixedWidth: 130 },
            { label: 'orei_orei_id', fieldName: 'orei_orei_id', type: 'text', fixedWidth: 130 },
            { label: 'fecha', fieldName: 'fecha', type: 'text', fixedWidth: 130 },
            { label: 'del_os_codigo', fieldName: 'del_os_codigo', type: 'text', fixedWidth: 130 },
            { label: 'afi_afi_id', fieldName: 'afi_afi_id', type: 'text', fixedWidth: 130 },
            { label: 'codigo', fieldName: 'codigo', type: 'text', fixedWidth: 130 },
            { label: 'asociado_nombre', fieldName: 'asociado_nombre', type: 'text', fixedWidth: 220 },
            { label: 'em_em_id', fieldName: 'em_em_id', type: 'text', fixedWidth: 130 },
            { label: 'efe_codigo_realizador', fieldName: 'efe_codigo_realizador', type: 'text', fixedWidth: 130 },
            { label: 'efe_codigo_prescriptor', fieldName: 'efe_codigo_prescriptor', type: 'text', fixedWidth: 130 },
            { label: 'diag_codigo', fieldName: 'diag_codigo', type: 'text', fixedWidth: 130 },
            { label: 'cobro_indeb', fieldName: 'cobro_indeb', type: 'text', fixedWidth: 130 },
            { label: 'razon_social', fieldName: 'razon_social', type: 'text', fixedWidth: 130 },
            { label: 'cuit', fieldName: 'cuit', type: 'text', fixedWidth: 130 },
            { label: 'tipo_comprobante', fieldName: 'tipo_comprobante', type: 'text', fixedWidth: 130 },
            { label: 'nro_comprobante', fieldName: 'nro_comprobante', type: 'text', fixedWidth: 130 },
            { label: 'fecha_comprobante', fieldName: 'fecha_comprobante', type: 'text', fixedWidth: 130 },
            { label: 'importe', fieldName: 'importe', type: 'text', fixedWidth: 130 },
            { label: 'vda_drv_estado', fieldName: 'vda_drv_estado', type: 'text', fixedWidth: 130 },
            { label: 'nombre_estado', fieldName: 'nombre_estado', type: 'text', fixedWidth: 130 },
            { label: 'nro_sf', fieldName: 'nro_sf', type: 'text', fixedWidth: 130 }
        ]);
    }
})