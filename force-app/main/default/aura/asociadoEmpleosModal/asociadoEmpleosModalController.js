({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Fecha de Inicio', fieldName: 'fecha_inicio', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha de Fin', fieldName: 'fecha_fin', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Código', fieldName: 'codigo', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Descripción', fieldName: 'descripcion', type: 'text', fixedWidth: 550, cellAttributes: { alignment: 'center'}}
        ]);
    }
})