({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'lr_id', fieldName: 'lr_id', type: 'text', fixedWidth: 130 },
            { label: 'Código', fieldName: 'codigo', type: 'text', fixedWidth: 130 },
            { label: 'Nombre de afiliado', fieldName: 'afi_nom', type: 'text', fixedWidth: 220 },
			{ label: 'Fecha', fieldName: 'fecha', type: 'text', fixedWidth: 130 },
			{ label: 'orei_id', fieldName: 'orei_id', type: 'text', fixedWidth: 130 },
			{ label: 'Orden de pago', fieldName: 'orden_pago', type: 'text', fixedWidth: 130 },
			{ label: 'Estado', fieldName: 'estado', type: 'text', fixedWidth: 130 },
			{ label: 'Nombre de estado', fieldName: 'nombre_estado', type: 'text', fixedWidth: 160 },
			{ label: 'Importe', fieldName: 'importe', type: 'text', fixedWidth: 130 },
			{ label: 'Nombre de destinatario', fieldName: 'nombre_destinatario', type: 'text', fixedWidth: 220 },
			{ label: 'est_financiero', fieldName: 'est_financiero', type: 'text', fixedWidth: 130 },
			{ label: 'Estado financiero', fieldName: 'estado_financiero', type: 'text', fixedWidth: 160 },
            { label: 'Reintegros', type: 'button', initialWidth: 135, typeAttributes: { label: 'Ver reintegros', name: 'view_refunds', title: 'Click para ver detalles' } }
        ]);
    },

    handleRowAction: function(component, event, helper) {
		let action = event.getParam('action');
        let row = event.getParam('row');
		if(action.name == 'view_refunds') {
			$A.createComponent(
				"c:loteOrdenReintegroReintegrosModal",
				{
					"mydata" : row.reintegros
				},
				function(cmp, status, errorMessage){
					if (status === "SUCCESS") {
						let modalBody = cmp;
						//==================================================================
						component.find('overlayLib').showCustomModal({
							header: "Reintegros",
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
		}
	}
})