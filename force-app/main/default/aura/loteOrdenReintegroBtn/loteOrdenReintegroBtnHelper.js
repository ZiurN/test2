({
    goToApex: function (component, event, lot_id) {
		let helper = this;
		if(!lot_id) {
			LightningUtils.showToast("Campo incompleto", 'Id lote SS no puede estar vacío');
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getOrdenReintegro",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.lote.length > 0) {
							helper.showModal(component, event, result.lote);
						}
						else {
							LightningUtils.showToast("No hay datos", 'No se encontraron ordenes de reintegro en SaludSoft para este afiliado', {"type":"warning"});
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", 'Hubo un error, asegúrese que el Afi Id está en formato numérico', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				lot_id : lot_id
			}
		);
    },

    showModal: function(component, event, ordenes){
		$A.createComponent(
            "c:loteOrdenReintegroModal",
            {
                "ordenes" : ordenes
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Ordenes de reintegro",
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