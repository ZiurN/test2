({
	sendMail: function (component, event, caseId) {
		let helper = this;
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"envioNota",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						LightningUtils.showToast("Info", result.message, {"type":"success"});
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", 'Hubo un error', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				ap_id : caseId
			}
		);
	}
})