({
	doInit : function(component, event, helper) {
		let asociadoConsumosDeTope = component.get('v.mydata');
		let asociadoMontoExcedente = component.get('v.asociadoMontoExcedente');

		asociadoConsumosDeTope.forEach(consumo => {
			consumo['monto_excedente'] = asociadoMontoExcedente;
		});

		component.set('v.mydata', asociadoConsumosDeTope);

		component.set('v.mycolumns', [
			{ label: 'PCA ID', fieldName: 'pca_id', type: 'text', 
				fixedWidth: 95, cellAttributes: { alignment: 'center'}},
			{ label: 'Tipo', fieldName: 'tipo', type: 'text',
				fixedWidth: 60, cellAttributes: { alignment: 'center'}},
			{ label: 'Prestación/Grupo', fieldName: 'prestacion_grupo', type: 'text',
				fixedWidth: 105, cellAttributes: { alignment: 'center'}},
			{ label: 'Nombre de Prestación/Grupo', fieldName: 'nombre_prestacion', type: 'text',
				fixedWidth: 180, cellAttributes: { alignment: 'center'}},
			{ label: 'Cantidad', fieldName: 'cantidad', type: 'text',
				fixedWidth: 90, cellAttributes: { alignment: 'center'}},
			{ label: 'Honorarios', fieldName: 'honorarios', type: 'text',
				fixedWidth: 105, cellAttributes: { alignment: 'center'}},
			{ label: 'Gastos', fieldName: 'gastos', type: 'text',
				fixedWidth: 75, cellAttributes: { alignment: 'center'}},
			{ label: 'Copago', fieldName: 'copago', type: 'text',
				fixedWidth: 80, cellAttributes: { alignment: 'center'}},
			{ label: 'Fecha de Prestación', fieldName: 'fecha_prestacion', type: 'date',
				fixedWidth: 100, cellAttributes: { alignment: 'center'}},
			{ label: 'Origen', fieldName: 'origen', type: 'text',
				fixedWidth: 80, cellAttributes: { alignment: 'center'}},
			{ label: 'Es módulo', fieldName: 'es_modulo', type: 'text',
				fixedWidth: 85, cellAttributes: { alignment: 'center'}},
			{ label: 'Monto Excedente', fieldName: 'monto_excedente', type: 'currency',
				fixedWidth: 105, cellAttributes: { alignment: 'center'}}
		]);

		component.set('v.isLoading', false);
	}
})