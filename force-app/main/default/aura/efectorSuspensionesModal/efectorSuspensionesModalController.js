({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Fecha de Inicio', fieldName: 'fecha_inicio', type: 'date', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha de Finalización', fieldName: 'fecha_finalizacion', type: 'date', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Motivo', fieldName: 'motivo', type: 'text', fixedWidth: 400, cellAttributes: { alignment: 'center'}},
            { label: 'Observación', fieldName: 'observaciones', type: 'text', fixedWidth: 250, cellAttributes: { alignment: 'center'}}
        ]);
    }
})