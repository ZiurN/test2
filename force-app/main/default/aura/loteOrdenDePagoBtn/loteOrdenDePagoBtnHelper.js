({
    goToApex: function (component, event, id_lote) {
		let helper = this;

		if(id_lote == null){
			LightningUtils.showToast("Error", 'El lote no tiene id externo', {"type":"error"});
		}

		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getOrdenesDePago",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
                        helper.showModal(component, event, result.ordenesDePago);
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", 'Hubo un error, contacte a su administrador Salesforce', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				id_lote : id_lote
			}
		);
	},
	showModal: function(component, event, ordenesDePago){
		$A.createComponent(
            "c:loteOrdenDePagoModal",
            {
                "ordenesDePago" : ordenesDePago
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Órdenes de Pago",
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
})