({
	getValoracion : function(component,event,id,afiId,period) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getValoracionAfi",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
                        LightningUtils.showToast(
                            "Valor de cuota bonificada actualizado",
                            'Verifique el valor en el campo Cuota Bonificada sin iva',
                            {"type":"success"}
                        );
                        $A.get('e.force:refreshView').fire();
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", 'Hubo un error en SF', {"type":"error"});
				}

				component.set('v.isLoading', false);
			},
			{
				caseId : id,
                afi: afiId,
                periodo: period
			}
		);
	}
})