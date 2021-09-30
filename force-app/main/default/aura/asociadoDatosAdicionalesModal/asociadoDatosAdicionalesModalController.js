({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Código', fieldName: 'codigo', type: 'text', fixedWidth: 130 },
            { label: 'Nombre', fieldName: 'nombre', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'} },
            { label: 'Valor', fieldName: 'valor', type: 'text', fixedWidth: 250, cellAttributes: { alignment: 'center'} },
            { label: 'Observaciones', fieldName: 'observaciones', type: 'text', fixedWidth: 350, cellAttributes: { alignment: 'center'} }
        ]);
    }
})