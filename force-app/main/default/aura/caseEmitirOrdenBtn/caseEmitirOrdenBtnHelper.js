({
	goToApex: function (component, event, caseIdExterno) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"changeStatusToOrdenEmitida",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if(result.message == 'ok') {
							LightningUtils.showToast("Orden Emitida", 'La orden ha sido emitida correctamente', {"type":"success"});
						}
						else {
							LightningUtils.showToast("Info", result.message);
						} 
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", result.message, {"type":"error"});
				}
				component.set('v.isLoading', false);
				$A.get('e.force:refreshView').fire();
			},
			{
				caseId : caseIdExterno
			}
		);
	}
})