({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Tipo de Domicilio', fieldName: 'tipo_domicilio', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Domicilio', fieldName: 'domicilio_efector', type: 'text', fixedWidth: 250, cellAttributes: { alignment: 'center'}},
            { label: 'Código Postal', fieldName: 'codigo_postal', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Localidad', fieldName: 'localidad', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Provincia', fieldName: 'provincia', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}}
        ]);
    }
})