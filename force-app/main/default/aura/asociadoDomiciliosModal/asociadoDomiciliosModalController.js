({
	/*
	// PARA MOSTRAR LOS DATOS EN UN DATATABLE

	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Tipo de Domicilio', fieldName: 'tipo_domicilio', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Calle', fieldName: 'calle', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Piso', fieldName: 'piso', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Dpto', fieldName: 'dpto', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Número', fieldName: 'numero', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Código Postal', fieldName: 'codigo_postal', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Localidad', fieldName: 'localidad', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Provincia', fieldName: 'provincia', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'País', fieldName: 'pais', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Telefonos', type: 'button', initialWidth: 135, typeAttributes: { label: 'Ver Teléfonos', name: 'view_phones', title: 'Click to View Details'} },
        ]);
    },
	

	//PARA MOSTRAR LOS TELEFONOS EN UN MODAL

	handleRowAction: function(component, event, helper) {
		let action = event.getParam('action');
        let row = event.getParam('row');
		if(action.name == 'view_phones') {
			$A.createComponent(
				"c:asociadoDomiciliosTelefonosModal",
				{
					"mydata" : row.telefonos
				},
				function(cmp, status, errorMessage){
					if (status === "SUCCESS") {
						let modalBody = cmp;
						//==================================================================
						component.find('overlayLib').showCustomModal({
							header: "Teléfonos",
							body: modalBody,
							showCloseButton: true
						});
						//==================================================================
					}
					else if (status === "INCOMPLETE") {
						console.log("No response from server or client is offline.");
					}
					else if (status === "ERROR") {
						console.log("Error: " + errorMessage);
					}
				}
			);
			//console.log(row.telefonos[0]);
			//console.log(JSON.stringify(row));
		}
	}
	*/
})