({
	init: function (component, event, helper) {
        component.set('v.mycolumns', [
            { label: 'Fecha', fieldName: 'fecha', type: "date",
                typeAttributes: {
                    day: "2-digit",
                    month: "2-digit",
                    year: "numeric",
                    hour: "2-digit",
                    minute: "2-digit"
                },
                fixedWidth: 150, cellAttributes: { alignment: 'center'} 
            },
            // { label: 'Descripcion', fieldName: 'descripcion', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'} },
            { label: 'Estado', fieldName: 'estado', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'} },
            { label: 'Motivo', fieldName: 'motivo', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'} },
            { label: 'Nombre', fieldName: 'nombre', type: 'text', fixedWidth: 300, cellAttributes: { alignment: 'center'} },
            { label: 'Rendicion', fieldName: 'rendicion', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} }
        ]);
    }

})