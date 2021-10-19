({
	goToApex: function (component, event, idAsociado, modeloPlanCodigo) {
		let helper = this;
		if(!idAsociado || !modeloPlanCodigo) {
			LightningUtils.showToast("Campo incompleto", 'Afi Id y Modelo Plan Código no pueden estar vacíos');
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getAsociadoClausulasPlan",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoClausulasPlan.length > 0) {
							helper.showModal(component, event, result.asociadoClausulasPlan);
						}
						else {
							LightningUtils.showToast("No hay datos", 'No se encontraron clausulas del plan en SaludSoft para este afiliado con ese Modelo Plan Código', {"type":"warning"});
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
				idAsociado : idAsociado,
				modeloPlanCodigo : modeloPlanCodigo
			}
		);
	},

	showModal: function(component, event, clausulas){
		$A.createComponent(
            "c:asociadoClausulasPlanModal",
            {
                "clausulas" : clausulas
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Clausulas del Plan",
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