({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Nombre', fieldName: 'descripcion', type: 'text', fixedWidth: 400, cellAttributes: { alignment: 'center'}},
            { label: 'Cartilla', fieldName: 'aca_cartilla', type: 'text', fixedWidth: 250, cellAttributes: { alignment: 'center'}}
        ]);
    }
})