({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Período', fieldName: 'periodo', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'CUIT', fieldName: 'cuit', type: 'text', fixedWidth: 105, cellAttributes: { alignment: 'center'}},
            { label: 'Empleador', fieldName: 'empleador', type: 'text', fixedWidth: 102, cellAttributes: { alignment: 'center'}},
            { label: 'Detalle Empleador', fieldName: 'nombre', type: 'text', fixedWidth: 400, cellAttributes: { alignment: 'center'}},
            { label: 'Obra Social', fieldName: 'obra_social', type: 'text', fixedWidth: 76, cellAttributes: { alignment: 'center'}},
            { label: 'Código Obra Social', fieldName: 'codigo_obra_social', type: 'text', fixedWidth: 87, cellAttributes: { alignment: 'center'}},
            { label: 'Descripción Obra Social', fieldName: 'nombre_obra_social', type: 'text', fixedWidth: 128, cellAttributes: { alignment: 'center'}},
            { label: 'Origen de Aporte', fieldName: 'origen_aporte', type: 'text', fixedWidth: 80, cellAttributes: { alignment: 'center'}},
            { label: 'Remuneración', fieldName: 'remuneracion', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Aporte', fieldName: 'aporte', type: 'currency',
                typeAttributes: { currencyCode: 'ARS', maximumSignificantDigits: 7}, fixedWidth: 91, cellAttributes: { alignment: 'center'}},
            { label: 'Aporte reconocido', fieldName: 'aporte_reconocido', type: 'currency',
                typeAttributes: { currencyCode: 'ARS', maximumSignificantDigits: 7}, fixedWidth: 103, cellAttributes: { alignment: 'center'}},
            { label: 'Aporte derivado', fieldName: 'aporte_derivado', type: 'currency',
                typeAttributes: { currencyCode: 'ARS', maximumSignificantDigits: 7}, fixedWidth: 91, cellAttributes: { alignment: 'center'}},
            { label: 'Secuencia', fieldName: 'secuencia', type: 'text', fixedWidth: 105, cellAttributes: { alignment: 'center'}}
        ]);
    }
})