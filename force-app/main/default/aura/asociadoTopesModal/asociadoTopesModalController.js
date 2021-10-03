({	
	loadTable: function (component, event, helper) {
        component.set('v.mycolumns', [
            { label: 'Rubro de tope', fieldName: 'rubro_tope', type: 'text', 
            	fixedWidth: 180, cellAttributes: { alignment: 'center'}},
            { label: 'Tope', fieldName: 'tope', type: 'text',
            	fixedWidth: 105, cellAttributes: { alignment: 'center'}},
            { label: 'Cláusula', fieldName: 'clausula', type: 'text',
            	fixedWidth: 86, cellAttributes: { alignment: 'center'}},
            { label: 'Valor tope', fieldName: 'valor_tope', type: 'text',
            	fixedWidth: 80, cellAttributes: { alignment: 'center'}},
            { label: 'Consumo', fieldName: 'consumo', type: 'text',
             	fixedWidth: 92, cellAttributes: { alignment: 'center'}},
            { label: 'Consultar', type: 'button', initialWidth: 171, 
             	typeAttributes: {label: 'Consumo Analizado', name: 'consumo_analizado',disabled:{fieldName:'sin_consumo'}, title: 'Consumo Analizado'}},
            { label: 'Remanente', fieldName: 'remanente', type: 'text',
             	fixedWidth: 105, cellAttributes: { alignment: 'center'}},
            { label: 'Valor RED', fieldName: 'valor_red', type: 'text',
             	fixedWidth: 70, cellAttributes: { alignment: 'center'}},
            { label: 'Remanente RED', fieldName: 'remanente_red', type: 'text',
             	fixedWidth: 105, cellAttributes: { alignment: 'center'}},
			{ label: 'Nombre RED', fieldName: 'nombre_red', type: 'text',
             	fixedWidth: 105, cellAttributes: { alignment: 'center'}}
        ]);
    },

	handleClickBtn: function (component, event, helper) {
		let fechaHastaInput = component.find('fechaHastaInput');
		if(fechaHastaInput.checkValidity()){
			component.set('v.isLoading', true);
			let asociadoId = component.get('v.asociadoId');
			let fechaHasta = component.get('v.fechaHasta');
			helper.goToApex(component, event, asociadoId, fechaHasta);
		}
	},
    
    handleRowAction: function (component, event, helper) {
        let action = event.getParam('action');
        let row = event.getParam('row');
        if(action.name === 'consumo_analizado') {
            component.set('v.isLoading', true);
            let asociadoId = component.get('v.asociadoId');
			let fechaHasta = component.get('v.fechaHasta');
			let topeTipo = row.tope_id;
			let topeId = row.tocmpc_id;
			if(topeTipo.toLowerCase() == 'p') {
				topeId = row.tocpc_id;
			}
        	helper.getConsumoDeTopeFromApex(component, event, asociadoId, fechaHasta, topeTipo, topeId);
    	}
 	}
})