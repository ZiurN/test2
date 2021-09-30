({
	goToApex: function (component, event, planId) {
		let helper = this;
		if(!planId) {
			LightningUtils.showToast("Campo incompleto", 'El id del plan es nulo');
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getEmpresaPlanConvenios",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.empresaPlanConvenios.length > 0) {
							helper.showModal(component, event, result.empresaPlanConvenios);
						} else {
							LightningUtils.showToast("No hay datos", 'No se encontaron planes para este convenio en SaludSoft', {"type":"warning"});
						}
					} else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", "Hubo un error", {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				planId : planId
			}
		);
	},

	showModal: function(component, event, planes){
		$A.createComponent(
            "c:empresaPlanConveniosModal",
            {
                "planes" : planes
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Detalle del convenio",
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