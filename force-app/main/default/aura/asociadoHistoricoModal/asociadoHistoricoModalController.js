({
	init: function (cmp, event, helper) { 
        cmp.set('v.mycolumns', [
            { label: 'Replicado', fieldName: 'replicado', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha de Vigencia', fieldName: 'fecha_vigencia', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'Código', fieldName: 'codigo', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'Estado', fieldName: 'estado', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Aporta', fieldName: 'aporta', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Afiliación', fieldName: 'afiliacion', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'Tipo de Afiliado', fieldName: 'tipo_afiliado', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Código del Titular', fieldName: 'codigo_titular', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'Apellidos', fieldName: 'apellidos_titular', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}},
			{ label: 'Nombres', fieldName: 'nombres_titular', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}},
            { label: 'Parentesco', fieldName: 'parentesco_descripcion', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Razón Social', fieldName: 'empresa_nombre', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'}},
            { label: 'Sucursal', fieldName: 'sucursal_nombre', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}},
			{ label: 'Código del Plan', fieldName: 'plan_codigo', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Descripción del Plan', fieldName: 'plan_nombre', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Código de Obra Social', fieldName: 'obra_social_codigo', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Descripción de Obra Social', fieldName: 'obra_social_nombre', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Estado Civil', fieldName: 'estado_civil', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Discapacitado', fieldName: 'discapacitado', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Fecha de Alta Administrativa', fieldName: 'fecha_alta_adm',type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Antigüedad Reconocida', fieldName: 'antiguedad_reconocida', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Adherente', fieldName: 'adherente', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Código de agencia', fieldName: 'agencia_codigo', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Descripción de Agencia', fieldName: 'agencia_nombre', type: 'agencia_nombre', fixedWidth: 200, cellAttributes: { alignment: 'center'}},
            { label: 'Código de Agrupación', fieldName: 'agrupacion', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Descripción de agrupación', fieldName: 'agrupacion_nombre', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'}},
            { label: 'Código de Agrupación 1', fieldName: 'agrupacion1', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Descripción de agrupación 1', fieldName: 'agrupacion1_nombre', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'}},
            { label: 'Código de Agrupación 2', fieldName: 'agrupacion2', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Descripción de agrupación 2', fieldName: 'agrupacion2_nombre', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'}},
            { label: 'Código de Agrupación 3', fieldName: 'agrupacion3', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Descripción de agrupación 3', fieldName: 'agrupacion3_nombre', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'}},
            { label: 'Código de Agrupación 4', fieldName: 'agrupacion4', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Descripción de agrupación 4', fieldName: 'agrupacion4_nombre', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'}},
            { label: 'Tipo de Baja', fieldName: 'tipo_baja_nombre', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Motivo de Baja', fieldName: 'motivo_baja', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Código de Categoría', fieldName: 'categoria_codigo', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Descripción de Categoría', fieldName: 'categoria_nombre', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Cambio a Nivel de', fieldName: 'cambio_a_nivel_de', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Id de Afiliado Histórico', fieldName: 'hist_afi_id', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Titular', fieldName: 'afi_id_titular', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}}

        ]);
    },
	
	handleShowNovedades: function (component, event, helper){
        let novedades = event.getParam('selectedRows')[0].novedades;
		if (novedades.length > 0) {
			helper.showNovedades(component, novedades);
		} else {
			LightningUtils.showToast("No hay datos", 'No hay novedades para este histórico', {"type":"warning"});
		}
    }
})