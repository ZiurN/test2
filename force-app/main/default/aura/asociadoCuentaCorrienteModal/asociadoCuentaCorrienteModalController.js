({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Movimiento', fieldName: 'movimiento', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
            { label: 'Comprobante', fieldName: 'comprobante', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130 },
			{ label: 'Vencimiento', fieldName: 'vencimiento', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Tipo', fieldName: 'tipo', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'} },
			{ label: 'Letra', fieldName: 'letra', type: 'text', fixedWidth: 120, cellAttributes: { alignment: 'center'} },
			{ label: 'Sucursal', fieldName: 'sucursal', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
            { label: 'Numero', fieldName: 'numero', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Cuota', fieldName: 'cuota', type: 'text', fixedWidth: 100, cellAttributes: { alignment: 'center'} },
            { label: 'Importe', fieldName: 'importe', type: 'currency', fixedWidth: 130 },
			{ label: 'Saldo', fieldName: 'saldo', type: 'currency', fixedWidth: 130 }
        ]);
    }
})