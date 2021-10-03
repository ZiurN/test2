({
	loadTable: function (component, event, helper) {
		let years = [];
		let currentYear = new Date().getFullYear();
		let endYear = 1980;  
		while(currentYear >= endYear){
			years.push(currentYear);
			currentYear--;
		}
		component.set('v.years', years);

        component.set('v.mycolumns', [
            { label: 'Importe de valor cuota', fieldName: 'Importe', type: 'currency', 
            	fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Tipo de cláusula', fieldName: 'Tcc_Codigo', type: 'text',
            	fixedWidth: 85, cellAttributes: { alignment: 'center'}},
            { label: 'Nombre de cláusula', fieldName: 'Nombre_Clausula', type: 'text',
            	fixedWidth: 105, cellAttributes: { alignment: 'center'}},
            { label: 'Cantidad', fieldName: 'Cantidad', type: 'text',
            	fixedWidth: 90, cellAttributes: { alignment: 'center'}},
            { label: 'Coeficiente de detalle', fieldName: 'Coeficiente', type: 'text',
             	fixedWidth: 105, cellAttributes: { alignment: 'center'}},
            { label: 'Coeficiente general', fieldName: 'Coeficiente_General', type: 'text',
             	fixedWidth: 105, cellAttributes: { alignment: 'center'}},
            { label: 'Categoría grupal', fieldName: 'Cga_codigo', type: 'text',
             	fixedWidth: 100, cellAttributes: { alignment: 'center'}},
            { label: 'Descripción de Categoría grupal', fieldName: 'Nombre_Cat_Grupal', type: 'text',
             	fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Regla adicional', fieldName: 'Rcg_codigo', type: 'text',
             	fixedWidth: 90, cellAttributes: { alignment: 'center'}},
			{ label: 'Descripción de Regla adicional', fieldName: 'Nombre_Regla_Adic', type: 'text',
             	fixedWidth: 130, cellAttributes: { alignment: 'center'}}
        ]);

		component.set('v.isLoading', false);
    },

	handleClickBtn: function (component, event, helper) {
		let monthSelected = component.get('v.monthSelected');
		let yearSelected = component.get('v.yearSelected');

		if(monthSelected && yearSelected){
			component.set('v.isLoading', true);
			let asociadoId = component.get('v.asociadoId');
			helper.getValoracionesFromApex(component, event, asociadoId, monthSelected, yearSelected);
		}
	},
})