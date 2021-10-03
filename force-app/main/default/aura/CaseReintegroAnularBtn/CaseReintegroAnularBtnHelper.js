({
	goToApex: function (component, event, caseId) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"anularReintegro",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if (result.message == 'ok') {
							LightningUtils.showToast(
							    "Reintegro Anulado",
							    'El Reintegro ha sido anulado correctamente',
							    {"type":"success"}
                            );
							$A.get('e.force:refreshView').fire();
						} else {
							LightningUtils.showToast("No se pudo anular: ", result.message);
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", 'Hubo un error en SF, contacte con un administrador', {"type":"error"});
				}

				component.set('v.isLoading', false);
			},
			{
				caseId : caseId
			}
		);
	}
})