({
	getAlertasFromApex: function (component, event, asociadoId) {
		let helper = this;
        if(!asociadoId) {
			LightningUtils.showToast("Campo incompleto", 'El Afi Id no puede estar vacío');
			return;
		}
		if(!asociadoId.match(/^[0-9]*$/g)){
			LightningUtils.showToast("Error", 'El Afi Id debe ser en formato numérico', {"type":"error"});
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getAsociadoAlertas",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoAlertas){
							let asociadoChecksAndAlerts = [];

							if(result.asociadoChecks){
								result.asociadoChecks.forEach(check => {
									asociadoChecksAndAlerts.push(check);
								});
							}

							result.asociadoAlertas.forEach(alerta => {
								asociadoChecksAndAlerts.push(alerta);
							});

							helper.showModal(component, event, asociadoChecksAndAlerts);
                            window.setTimeout(
                                $A.getCallback(function() {
                                	component.set('v.isLoading', false);
                                }), 3000
                            );
						}
						else{
							LightningUtils.showToast("No hay datos", 'No se encontraron alertas para este afiliado en SaludSoft', {"type":"warning"});
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
				asociadoId : asociadoId
			}
		);
	},

	showModal: function(component, event, asociadoChecksAndAlerts){

		$A.createComponent(
            "c:asociadoAlertasModal",
            {
                "mydata" : asociadoChecksAndAlerts
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Alertas",
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