({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Id de Lote', fieldName: 'lote', type: 'text', fixedWidth: 100 },
            { label: 'Id de operación', fieldName: 'opr_id', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'} },
            { label: 'Nombre destinatario', fieldName: 'nombre_destinatario', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'} },
            { label: 'Estado', fieldName: 'contratada', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'} },
			{ label: 'Nombre estado', fieldName: 'nombre_estado', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'} }
        ]);
    }
})