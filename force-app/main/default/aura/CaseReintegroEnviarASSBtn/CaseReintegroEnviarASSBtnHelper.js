({
	sendToSS: function (component, event, idReintegro) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"sendReintegroToSS",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.message == 'ok') {
							LightningUtils.showToast("Operacioón exitosa", "Carga de reintegro exitosa", {"type":"success"});
							component.set('v.isLoading', false);
							$A.get('e.force:refreshView').fire();
						}
						else {
							LightningUtils.showToast("Info", result.auraMessage.message);
							$A.get('e.force:refreshView').fire();
						}
					}
					else {
						LightningUtils.showToast("Error", result.auraMessage.message, {"type":result.auraMessage.status});
						component.set('v.isLoading', false);
					}
				} else {
					let errorMsg = errors[0]['message'] != undefined && errors[0]['message'] != null ? errors[0]['message'] : 'Contacte con un administrador';
					LightningUtils.showToast("Info", errorMsg , {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				caseToSend : idReintegro
			}
		);
	}
})