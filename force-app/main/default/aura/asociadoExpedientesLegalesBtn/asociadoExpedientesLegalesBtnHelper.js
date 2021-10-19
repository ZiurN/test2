({
	goToApex: function (component, event, accountId) {
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"updateCheckExpediente",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if (result.message == 'ok') {
							LightningUtils.showToast(
							    "Operacion correcta",
							    'El check de expedientes legales ha sido actualizado correctamente',
							    {"type":"success"}
                            );
							$A.get('e.force:refreshView').fire();
						} else {
							LightningUtils.showToast("No se pudo actualizar: ", result.message);
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", 'Hubo un error en SF', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				accountId : accountId
			}
		);
	}
})