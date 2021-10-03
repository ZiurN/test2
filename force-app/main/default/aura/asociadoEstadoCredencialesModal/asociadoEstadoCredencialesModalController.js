({
	init: function (component, event, helper) {
        component.set('v.mycolumns', [
            { label: 'Código', fieldName: 'codigo', type: 'text', fixedWidth: 130 },
            { label: 'Nombre', fieldName: 'apellido_nombre', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'} },
            { label: 'Secuencia', fieldName: 'secuencia', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Fecha de emisión', fieldName: 'fecha_emision', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Fecha de vigencia', fieldName: 'fecha_vigencia', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Fecha de baja', fieldName: 'fecha_baja', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Fecha de anulación', fieldName: 'fecha_anulacion', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Id Oca', fieldName: 'id_oca', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
            { label: 'Estado', fieldName: 'estado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: ' ', type: 'button', fixedWidth: 110, typeAttributes: {label: 'Detalle', name: 'detalles', disabled:{fieldName:'disable_detalle'}, title: 'Detalles'} },
			{ label: ' ', type: 'button', fixedWidth: 110, typeAttributes: {label: 'Entregar', name: 'entregar', disabled:{fieldName:'disable_detalle'}, title: 'Entregar'} }
			//{ label: 'Consultar', type: 'button', initialWidth: 171, 
             	//typeAttributes: {label: 'Consumo Analizado', name: 'consumo_analizado',disabled:{fieldName:'sin_consumo'}, title: 'Consumo Analizado'}},
        ]);
    },

	detailHandler: function (component, event, helper){
		helper.goToApex(component, event);
    }
})