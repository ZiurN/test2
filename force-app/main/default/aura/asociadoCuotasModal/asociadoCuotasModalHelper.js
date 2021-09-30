({
	showCuotaDetail: function (component, event) {
		let action = event.getParam('action');
        let selectedCuota = event.getParam('row');
        if(action.name === 'detalles') {
			$A.createComponent(
				"c:asociadoCuotaDetalleModal",
				{
					"cuotaDetalle" : selectedCuota.detalle
				},
				function(cmp, status, errorMessage){
					if (status === "SUCCESS") {
						let modalBody = cmp;
						//==================================================================
						component.find('overlayLib').showCustomModal({
							header: "Cuota - Detalle",
							body: modalBody,
							showCloseButton: true
						});
						//==================================================================
					}
					else if (status === "INCOMPLETE") {
						console.log("No response from server or client is offline.")
					}
					else if (status === "ERROR") {
						console.log("Error: " + errorMessage);
					}
				}
			);
		}
	}
})