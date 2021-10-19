({
	goToApex: function (component, event, alertaId, alertaIdExt) {
		let helper = this;
		 
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"autoasignarMedico",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						$A.get('e.force:refreshView').fire();
						component.set('v.isLoading', false);
						helper.rechazarAlerta(component, event, alertaIdExt);
					}
				} else {
                    LightningUtils.showToast("Error", 'Hubo un error en SF, por favor contacte con su administrador', {"type":"error"});
					component.set('v.isLoading', false);
                }
                
			},
			{
				alertaId : alertaId
			}
		);
	},
	
	rechazarAlerta: function (component, event, alertaId) {

		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"rechazarAlerta",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
					    if(!result.message) {
					        LightningUtils.showToast(
					            "Alerta Rechazada",
					            'La alerta fue rechazada correctamente',
					            { "type":"success" }
					        );
							$A.get('e.force:refreshView').fire();
                        }
					} else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
						$A.get('e.force:refreshView').fire();
					}
				} else {
                    LightningUtils.showToast("Error", 'Hubo un error en SF, por favor contacte con su administrador', {"type":"error"});
                }
                component.set('v.isLoading', false);
			},
			{
				alertaId : alertaId
			}
		);
	},

})