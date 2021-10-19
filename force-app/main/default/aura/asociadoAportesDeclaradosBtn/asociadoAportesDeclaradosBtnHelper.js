({
	goToApex: function (component, event, codigoDeAsociado) {
		let helper = this;
		if(!codigoDeAsociado) {
			LightningUtils.showToast("Campo incompleto", 'El Código de Afiliado no puede estar vacío', {"type":"error"});
			return;
		}
		if(!codigoDeAsociado.match(/^[0-9]*\/[0-9][0-9]$/g)){
			LightningUtils.showToast("Error", 'El Codigo de Afiliado tiene un formato incorrecto. Ej formato: 180015/10', {"type":"error"});
			return;
		}
		component.set('v.isLoading', true);
        LightningUtils.callApex(
			component,
			"getAsociadoAportesDeclarados",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoAportesDeclarados.length > 0){
							helper.showModal(component, event, result.asociadoAportesDeclarados);
                            window.setTimeout(
                                $A.getCallback(function() {
                                	component.set('v.isLoading', false);
                                }), 1000
                            );
						}
						else{
                            LightningUtils.showToast("No hay datos", 'No se encontraron aportes declarados para este afiliado en SaludSoft', {"type":"warning"});
                            component.set('v.isLoading', false);
						}
					}
					else{
						LightningUtils.showToast("Error", result.message, {"type":"error"});
                        component.set('v.isLoading', false);
					}
				}
				else {
					LightningUtils.showToast("Error", errors[0].message, {"type":"error"});
                  	component.set('v.isLoading', false);
				}
			},
			{
				codigoDeAsociado : codigoDeAsociado
			}
		);
	},

	showModal: function(component, event, aportesDeclarados){

		$A.createComponent(
            "c:asociadoAportesDeclaradosModal",
            {
                "mydata" : aportesDeclarados
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Aportes declarados",
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