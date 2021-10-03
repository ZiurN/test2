({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Tipo de dato', fieldName: 'tipo_dato_adicional', type: 'text', fixedWidth: 130 },
            { label: 'Descripción', fieldName: 'descripcion_dato_adicional', type: 'text', fixedWidth: 350, cellAttributes: { alignment: 'center'} },
            { label: 'Valor', fieldName: 'valor', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'} }
        ]);
    }
})