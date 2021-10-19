({
	goToApex: function (component, event, idAsociado) {
		let helper = this;
		if(!idAsociado) {
			LightningUtils.showToast("Campo incompleto", 'El Afi Id no puede estar vacío');
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getAsociadoHistorico",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoHistorico.length > 0) {
							helper.showModal(component, event, result.asociadoHistorico);
						} else {
							LightningUtils.showToast("No hay datos", 'No se encontó el histórico del afiliado en SaludSoft', {"type":"warning"});
						}
					} else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", "Hubo un error, asegúrese que el Afi Id está en formato numérico", {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				idAsociado : idAsociado
			}
		);
	},

	showModal: function(component, event, historico){
		$A.createComponent(
            "c:asociadoHistoricoModal",
            {
                "historico" : historico
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Histórico",
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