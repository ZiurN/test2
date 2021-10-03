({
	goToApex: function (component, event) {
		let id = component.get('v.recordId');
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"updateImporte",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
					    if(result.message == 'ok') {
					        LightningUtils.showToast(
					            "Importe actualizado",
					            'Importe actualizado correctamente',
					            { "type":"success" }
					        );
                        }
						$A.get('e.force:refreshView').fire();
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
                    LightningUtils.showToast("Error", JSON.stringify(errors), {"type":"error"});
                }
                component.set('v.isLoading', false);
			},
			{
				presId : id
			}
		);
		//$A.get('e.force:refreshView').fire();
	},

})