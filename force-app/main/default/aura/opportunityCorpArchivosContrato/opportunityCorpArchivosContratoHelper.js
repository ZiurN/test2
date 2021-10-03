({
	goToApex: function (component, event, idAsociado) {
		let helper = this;

		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"getArchivosContrato",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						
						LightningUtils.showToast("Info", result.message, {"type":"success"});
						component.set('v.isLoading', false);
						$A.get("e.force:closeQuickAction").fire();
					}
					else {
						LightningUtils.showToast("Info", result.message, {"type":"warning"});
						$A.get("e.force:closeQuickAction").fire();
					}
				} else {
					LightningUtils.showToast("Info", 'Contacte a su administrador', {"type":"error"});
					$A.get("e.force:closeQuickAction").fire();
				}
				component.set('v.isLoading', false);
			},
			{
				oppId : idAsociado
			}
		);
	}
})