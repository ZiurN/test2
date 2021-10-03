({
	init: function (component, event, helper) {
        component.set('v.mycolumns', [
            { label: 'Período', fieldName: 'periodo', type: 'text', 
            	fixedWidth: 88, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha de generación', fieldName: 'fecha_generacion', type: 'date-local',
            	fixedWidth: 105, cellAttributes: { alignment: 'center'},
				typeAttributes:{year: "numeric", month: "2-digit", day: "2-digit"}},
            { label: 'Monto', fieldName: 'monto', fixedWidth: 110,
            	cellAttributes: { alignment: 'center'},type: 'currency',
                typeAttributes: { currencyCode: 'ARS', maximumSignificantDigits: 7}},
            { label: 'Cuadro de Costo', fieldName: 'cuadro_costos', type: 'text',
            	fixedWidth: 180, cellAttributes: { alignment: 'center'}},
            { label: 'Recargo - Bonificación', fieldName: 'recargo_bonificacion',type: 'currency',
                typeAttributes: { currencyCode: 'ARS', maximumSignificantDigits: 7},
             	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
            { label: 'Monto regla adicional', fieldName: 'monto_regla_adicional',type: 'currency',
                typeAttributes: { currencyCode: 'ARS', maximumSignificantDigits: 7},
             	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
            { label: 'Monto general', fieldName: 'monto_general',type: 'currency',
                typeAttributes: { currencyCode: 'ARS', maximumSignificantDigits: 7},
             	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
            { label: 'Monto Bonificación Recargo', fieldName: 'monto_bonificacion_recargo',type: 'currency',
                typeAttributes: { currencyCode: 'ARS', maximumSignificantDigits: 7},
             	fixedWidth: 110, cellAttributes: { alignment: 'center'}},
			{ label: ' ', type: 'button', fixedWidth: 60, 
             	typeAttributes: {label: '+', name: 'detalles', title: 'Detalles'}},
        ]);
    },
    
	cuotaDetailHandler: function (component, event, helper){
		helper.showCuotaDetail(component, event);
       	
    }
})