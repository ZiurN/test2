({
	sendAtt: function (component, event, cotizacionId) {
		let helper = this;
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"sendAttachmentsToPrest",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						LightningUtils.showToast("Info", result.message, {"type":"success"});
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", 'Hubo un error en SF,  por favor contacte con un administrador', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				cotId : cotizacionId
			}
		);
	}
})