({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Período', fieldName: 'periodo', type: 'date', fixedWidth: 130 },
            { label: 'CUIT', fieldName: 'cuit', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Código del Empleador', fieldName: 'empleador', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Descripción del Empleador', fieldName: 'nombre_empleador', type: 'text', fixedWidth: 250, cellAttributes: { alignment: 'center'} },
			{ label: 'Código de Obra Social', fieldName: 'cod_ooss', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Descripción de Obra Social', fieldName: 'nombre_ooss', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'} },
            { label: 'Origen del Aporte', fieldName: 'origen_aporte', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Aporte', fieldName: 'aporte', type: 'currency', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Aporte Reconocido', fieldName: 'aporte_reconocido', type: 'currency', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Aporte Derivado', fieldName: 'aporte_derivado', type: 'currency', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Subsidio', fieldName: 'subsidio', type: 'currency', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Secuencia', fieldName: 'secuencia', type: 'currency', fixedWidth: 130, cellAttributes: { alignment: 'center'} }
        ]);
    }
})