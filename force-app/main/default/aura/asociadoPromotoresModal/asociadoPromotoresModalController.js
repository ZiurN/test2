({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Fecha de Inicio', fieldName: 'fecha_inicio', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130 },
            { label: 'Fecha de Fin', fieldName: 'fecha_fin', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Usuario', fieldName: 'usuario', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Apellidos', fieldName: 'apellidos', type: 'text', fixedWidth: 250, cellAttributes: { alignment: 'center'} },
            { label: 'Nombres', fieldName: 'nombres', type: 'text', fixedWidth: 250, cellAttributes: { alignment: 'center'} }
        ]);
    }
})