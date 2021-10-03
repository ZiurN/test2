({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Fecha', fieldName: 'fecha', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Usuario', fieldName: 'usuario', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Solicitud', fieldName: 'solicitud', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha de Vigencia', fieldName: 'fecha_vigencia', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Tipo de Solicitud', fieldName: 'tipo_solicitud', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}},
            { label: 'Tipo de Baja', fieldName: 'tipo_baja', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}},
            { label: 'Motivo', fieldName: 'motivo', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Masiva', fieldName: 'masiva', type: 'text', fixedWidth: 80, cellAttributes: { alignment: 'center'}},
            { label: 'Rótulo', fieldName: 'rotulo', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Solicitud Masiva', fieldName: 'solicitud_masiva', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'}}
        ]);
    }
})