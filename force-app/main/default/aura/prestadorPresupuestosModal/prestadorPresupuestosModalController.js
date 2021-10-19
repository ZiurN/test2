({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Fecha de vigencia', fieldName: 'fecha', type: 'date', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Nombre del archivo', fieldName: 'nombre_arch', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'}},
            { label: 'URL del archivo', fieldName: 'p_link', type: 'url', fixedWidth: 300, cellAttributes: { alignment: 'center'}},
            { label: 'Observaciones', fieldName: 'descripcion', type: 'text', fixedWidth: 350, cellAttributes: { alignment: 'center'}}
        ]);
    }
})