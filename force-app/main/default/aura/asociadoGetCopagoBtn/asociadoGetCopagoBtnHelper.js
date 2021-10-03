({
	goToApex: function (component, event, accountId) {
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"getAsociadoCopago",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
					    if(!result.message) {
							var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                "url": result.asociadoCopago.data.link
                            });
                            urlEvent.fire();
                        }
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
                    LightningUtils.showToast("Error", 'Hubo un error en SF, por favor contacte con su administrador', {"type":"error"});
                }
                component.set('v.isLoading', false);
			},
			{
				idAsociado : accountId
			}
		);
	},

})