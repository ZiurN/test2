({
	sendToSS: function (component, event, idReintegro) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"sendReintegroToSS",
			function (succeed, result, errors) {
				if (succeed) {
					if (!result.hasError) {
						if (result.message == 'ok') {
							LightningUtils.showToast("Operación exitosa", "Carga de reintegro exitosa", { "type": "success" });
							component.set('v.isLoading', false);
							$A.get('e.force:refreshView').fire();
						}
						else {
							LightningUtils.showToast("Info", result.message);
							$A.get('e.force:refreshView').fire();
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, { "type": "error" });
						component.set('v.isLoading', false);
					}
				} else {
					let errorMsg = errors[0]['message'] != undefined && errors[0]['message'] != null ? errors[0]['message'] : 'Contacte con un administrador';

					LightningUtils.showToast("Info", errorMsg, { "type": "error" });
				}
				component.set('v.isLoading', false);
			},
			{
				idReintegro: idReintegro
			}
		);

	}
})