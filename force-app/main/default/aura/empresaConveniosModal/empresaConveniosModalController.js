({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Fecha desde', fieldName: 'fecha_desde', type: 'date', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha hasta', fieldName: 'fecha_hasta', type: 'date', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Grado', fieldName: 'grado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Prioridad', fieldName: 'prioridad', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Descripción', fieldName: 'descripcion', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Sucursal', fieldName: 'sucursal', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Zona geografica', fieldName: 'zona_geografica', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Código de Obra social', fieldName: 'osoc_codigo', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación afiliados', fieldName: 'nombre_agrupacion', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación 2 afiliados', fieldName: 'nombre_agrupacion1', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación 3 afiliados', fieldName: 'nombre_agrupacion2', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación 4 afiliados', fieldName: 'nombre_agrupacion3', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación 5 afiliados', fieldName: 'nombre_agrupacion4', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Categoría/Jerarquía', fieldName: 'categoria_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Afiliado', fieldName: 'codigo_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Apellido', fieldName: 'apellido_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Nombre', fieldName: 'nombre_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Permite plan mayor', fieldName: 'permite_plan_mayor', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}}
        ]);
    },

	handleShowPlanes: function (component, event, helper) {
		let planId = event.getParam('selectedRows')[0].ccp_id;
		helper.goToApex(component, event, planId);
	}
});