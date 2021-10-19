({
	goToApex: function (component, event, codEmpresa) {
		let helper = this;
		if(!codEmpresa) {
			LightningUtils.showToast("Campo incompleto", 'El código de empresa no puede estar vacío');
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getEmpresaDatosAdicionales",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if(result.asociadoDatosAdicionales.length > 0) {
							helper.showModal(component, event, result.asociadoDatosAdicionales);
						} else {
							LightningUtils.showToast("No hay datos", 'No se encontraron datos adicionales de la empresa en SaludSoft', {"type":"warning"});
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", "Hubo un error, asegúrese que el código de empresa esté en formato numérico y sea válido", {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				codEmpresa : codEmpresa
			}
		);
	},

	showModal: function(component, event, datos){
		$A.createComponent(
            "c:empresaDatosAdicionalesModal",
            {
                "datos" : datos
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Datos Adicionales",
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