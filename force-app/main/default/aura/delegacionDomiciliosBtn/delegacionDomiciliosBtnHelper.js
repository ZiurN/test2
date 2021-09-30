({
	goToApex: function (component, event, codDelegacion) {
		let helper = this;
		if(!codDelegacion) {
			LightningUtils.showToast("Campo incompleto", 'El codigo de delegación no puede estar vacío');
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getDelegacionDomicilios",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if(result.asociadoDomicilios.length > 0) {
							helper.showModal(component, event, result.asociadoDomicilios);
						} else {
							LightningUtils.showToast("No hay datos", 'No se encontraron domicilios de la delegación en SaludSoft', {"type":"warning"});
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", 'Hubo un error, asegúrese que el codigo de delegación está en formato numérico y sea válido', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				codDelegacion : codDelegacion
			}
		);
	},

	showModal: function(component, event, domicilios) {
		$A.createComponent(
            "c:delegacionDomiciliosModal",
            {
                "domicilios" : domicilios
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Domicilios",
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