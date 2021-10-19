({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Código', fieldName: 'codigo', type: 'text', fixedWidth: 130 },
            { label: 'Nombre', fieldName: 'nombre', type: 'text', fixedWidth: 350, cellAttributes: { alignment: 'center'} },
            { label: 'Característica', fieldName: 'caracteristica', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Contratada', fieldName: 'contratada', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
			{ label: 'Informa', fieldName: 'informa', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'} },
            { label: 'Bonificable', fieldName: 'bonificable', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
            { label: 'Permanente?', fieldName: 'permanente', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Fecha Desde', fieldName: 'fecha_vigencia_desde', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Fecha Hasta', fieldName: 'fecha_vigencia_hasta', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} }
        ]);
    }
})