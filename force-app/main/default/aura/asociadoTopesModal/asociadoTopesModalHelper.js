({
	goToApex: function (component, event, asociadoId, fechaHasta) {
        let helper = this;
        
		LightningUtils.callApex(
			component,
			"getAsociadoTopes",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoTopes.length > 0){
							for(let i = 0 ; i < result.asociadoTopes.length;i++){
								result.asociadoTopes[i]['sin_consumo'] = parseInt(result.asociadoTopes[i]['consumo']) === 0;
							}
							component.set('v.mydata', result.asociadoTopes);
                            window.setTimeout(
                                $A.getCallback(function() {
									component.set('v.haveToShowTable', true);
                                	component.set('v.isLoading', false);
                                }), 3000
                            );
						}
						else{
							LightningUtils.showToast("Info", 'No se encontraron datos en SaludSoft', {"type":"warning"});
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
				asociadoId : asociadoId,
				fecha : fechaHasta
			}
		);
	},
    
	getConsumoDeTopeFromApex: function(component, event, asociadoId, fechaHasta, topeTipo, topeId) {
		let helper = this;

		LightningUtils.callApex(
			component,
			"getAsociadoConsumoDeTope",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoConsumosDeTope.length > 0){
							let asociadoMontoExcedente = component.get('v.asociadoMontoExcedente');
                            helper.showConsumoDeTopeModal(component, event, result.asociadoConsumosDeTope, asociadoMontoExcedente);
							window.setTimeout(
                                $A.getCallback(function() {
                                	component.set('v.isLoading', false);
                                }), 3000
                            );
						}
						else{
							LightningUtils.showToast("Info", 'No se encontraron datos en SaludSoft', {"type":"warning"});
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
				asociadoId : asociadoId,
				fecha : fechaHasta,
				topeTipo: topeTipo,
				topeId: topeId

			}
		);
	},

    showConsumoDeTopeModal: function(component, event, asociadoConsumosDeTope, asociadoMontoExcedente){
		$A.createComponent(
            "c:asociadoConsumoDeTopeModal",
            {
                "mydata": asociadoConsumosDeTope,
				"asociadoMontoExcedente": asociadoMontoExcedente
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Consumo Analizado",
						body: modalBody,
						showCloseButton: true
					});
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
		component.set('v.isLoading', false);
    }
})