({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Código', fieldName: 'codigo', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'Secuencia', fieldName: 'secuencia', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha de Vigencia', fieldName: 'fecha_vigencia', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Fecha de Vencimiento', fieldName: 'fecha_vencimiento', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Fecha de Baja', fieldName: 'fecha_baja', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Fecha de Emisión', fieldName: 'fecha_emision', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Fecha de Generación', fieldName: 'fecha_generacion', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Fecha de Anulación', fieldName: 'fecha_anulacion', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha de Entrega', fieldName: 'fecha_entregada',type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}}
        ]);
    }
})