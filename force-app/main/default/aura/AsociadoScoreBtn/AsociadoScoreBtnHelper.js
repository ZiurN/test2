({
	sendToSS: function (component, event, afi) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"sendAccount",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						LightningUtils.showToast("Info", "Score Actualizado con Exito", {"type":"success"});
						component.set('v.isLoading', false);
						$A.get('e.force:refreshView').fire();
					}
					else {
						LightningUtils.showToast("Info", result.message, {"type":"error"});
                        component.set('v.isLoading', false);
					}
				} else {
					let errorMsg = errors[0]['message'] != undefined && errors[0]['message'] != null ? errors[0]['message'] : 'Contacte con un administrador'; 
				    
				    LightningUtils.showToast("Info", errorMsg , {"type":"error"});
                }
				component.set('v.isLoading', false);
			},
			{
				afi : afi
			}
		);
		
	}
})