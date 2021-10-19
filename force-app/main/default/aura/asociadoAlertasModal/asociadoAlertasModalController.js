({
	doInit: function (component, event, helper) {
        component.set('v.mycolumns', [
            { label: 'Fecha desde', fieldName: 'Fecha_Desde', type: 'text',
            	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha hasta', fieldName: 'Fecha_Hasta', type: 'text',
            	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
            { label: 'Código', fieldName: 'Codigo', type: 'text',
            	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
            { label: 'Nombre', fieldName: 'Nombre', type: 'text',
            	fixedWidth: 180, cellAttributes: { alignment: 'center'}},
            { label: 'Individual', fieldName: 'Individual', type: 'text',
             	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
            { label: 'Familiar', fieldName: 'Familia', type: 'text',
             	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
            { label: 'Empresa', fieldName: 'Empresa', type: 'text',
             	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
            { label: 'OOSS', fieldName: 'OOSS', type: 'text',
             	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
        ]);
    }
})