({
	getValoracionesFromApex: function(component, event, asociadoId, monthSelected, yearSelected){
        let helper = this;
        
		LightningUtils.callApex(
			component,
			"getAsociadoValorizaciones",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoValoraciones.length > 0){
							component.set('v.mydata', result.asociadoValoraciones);
                            window.setTimeout(
                                $A.getCallback(function() {
									component.set('v.haveToShowTable', true);
                                	component.set('v.isLoading', false);
                                }), 3000
                            );
						}
						else{
							LightningUtils.showToast("Info", 'No se encontraron datos en SaludSoft', {"type":"warning"});
                            component.set('v.isLoading', false);
						}
					}
					else{
						LightningUtils.showToast("Info", result.message, {"type":"error"});
                        component.set('v.isLoading', false);
					}
				}
			},
			{
				asociadoId : asociadoId,
				month : monthSelected,
                year: yearSelected
			}
		);
	}
})