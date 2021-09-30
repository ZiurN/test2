({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
			{ label: 'Nro de Presentación', fieldName: 'pp_id', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Período', fieldName: 'periodo', type: 'date-local', fixedWidth: 130, cellAttributes: { alignment: 'center'},
				typeAttributes: {day: "2-digit", month: "2-digit", year: "numeric"} },
            { label: 'Prestador', fieldName: 'prestador', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Nombre Prestador', fieldName: 'nombre_prestador', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Localidad', fieldName: 'localidad', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha Recepción', fieldName: 'fecha_recepcion', type: 'date-local', fixedWidth: 130, cellAttributes: { alignment: 'center'},
				typeAttributes: {day: "2-digit", month: "2-digit", year: "numeric"} },
            { label: 'Fecha Vencimiento', fieldName: 'fecha_vencimiento', type: 'date-local', fixedWidth: 130, cellAttributes: { alignment: 'center'},
				typeAttributes: {day: "2-digit", month: "2-digit", year: "numeric"} },
            { label: 'Total', fieldName: 'total', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Estado', fieldName: 'estado', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}}
        ]);
    },

	showPresentacionDetail: function (component, event, helper){
        let selectedPresentacion = event.getParam('selectedRows');
		let idPresentacion = selectedPresentacion[0].pp_id;
		helper.goToApex(component, event, idPresentacion);
       	
    }
})