({
	goToApex: function (component, event, id_lote) {
		let helper = this;
		if(id_lote == null){
			LightningUtils.showToast("Error", 'El lote no tiene id externo', {"type":"error"});
            return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"sendLoteToSS",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						var urlEvent = $A.get("e.force:navigateToURL");
						urlEvent.setParams({
						  "url": result.lote
						});
						urlEvent.fire();
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", 'Hubo un error, contacte a su administrador Salesforce', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				id_lote : id_lote
			}
		);
	}
})