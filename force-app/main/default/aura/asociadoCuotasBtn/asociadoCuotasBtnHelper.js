({
	goToApex: function (component, event, idAsociado) {
		let helper = this;
        if(!idAsociado) {
			LightningUtils.showToast("Campo incompleto", 'El Afi Id no puede estar vacío');
			return;
		}
		if(!idAsociado.match(/^[0-9]*$/g)){
			LightningUtils.showToast("Error", 'El Afi Id debe ser en formato numérico', {"type":"error"});
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getAsociadoCuotas",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoCuotas.length > 0){
							helper.showModal(component, event, result.asociadoCuotas);
                            window.setTimeout(
                                $A.getCallback(function() {
                                	component.set('v.isLoading', false);
                                }), 3000
                            );
						}
						else{
							LightningUtils.showToast("No hay datos", 'No se encontraron cuotas para este afiliado en SaludSoft', {"type":"warning"});
                            component.set('v.isLoading', false);
						}
					}
					else{
						LightningUtils.showToast("Info", result.message, {"type":"error"});
                        component.set('v.isLoading', false);
					}
				}
			},
			{
				idAsociado : idAsociado
			}
		);
	},

	showModal: function(component, event, asociadoCuotas){
		$A.createComponent(
            "c:asociadoCuotasModal",
            {
                "mydata" : asociadoCuotas
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Cuotas",
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
})