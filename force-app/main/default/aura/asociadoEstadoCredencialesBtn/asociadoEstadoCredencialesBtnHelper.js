({
	goToApex: function (component, event, codAsociado) {
		let helper = this;
		if(!codAsociado) {
			LightningUtils.showToast("Campo incompleto", 'Codigo de Afiliado no puede estar incompleto');
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getEstadoCredenciales",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.data.length > 0) {
							for(let i = 0 ; i < result.data.length ; i++) {
								result.data[i].disable_detalle = !result.data[i].id_oca || !result.data[i].codigo;
							}
							helper.showModal(component, event, result.data);
						}
						else {
							LightningUtils.showToast("No hay datos", 'No se encontraron estados de credenciales para el afiliado', {"type":"warning"});
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", 'Hubo un error en SF, contacte con un administrador', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				codAsociado : codAsociado
			}
		);
	},

	showModal: function(component, event, data) {
		$A.createComponent(
            "c:asociadoEstadoCredencialesModal",
            {
                "credenciales" : data
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Estado de las credenciales",
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