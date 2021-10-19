({
	goToApex: function (component, event, codigoDeAfiliado) {
		let helper = this;
		if(!codigoDeAfiliado) {
			LightningUtils.showToast("Campo incompleto", 'El Código de Afiliado no puede estar vacío');
			return;
		}
		if(!codigoDeAfiliado.match(/^[0-9]*\/[0-9][0-9]$/g)){
			LightningUtils.showToast("Error", 'El Codigo de Afiliado tiene un formato incorrecto. Ej formato: 180015/10', {"type":"error"});
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getAsociadoAportesTransferidos",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoAportesTransferidos.length > 0){
							helper.showModal(component, event, result.asociadoAportesTransferidos);
						}
						else{
							LightningUtils.showToast("No hay datos", 'No se encontraron aportes transferidos para este afiliado en SaludSoft', {"type":"warning"});
						}
					}
					else{
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", errors[0].message, {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				codigoDeAsociado : codigoDeAfiliado
			}
		);
	},

	showModal: function(component, event, aportes){
		$A.createComponent(
            "c:asociadoAportesTransferidosModal",
            {
                "aportes" : aportes
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Aportes Transferidos",
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