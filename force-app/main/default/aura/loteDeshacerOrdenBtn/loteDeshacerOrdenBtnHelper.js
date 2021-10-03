({
	goToApex: function (component, event, id_lote) {
		let helper = this;
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"generacionDeOrden",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						LightningUtils.showToast("Info", result.message, {"type":"success"});
						$A.get('e.force:refreshView').fire();
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
				id_lote : id_lote,
				accion : "DESHACER"
			}
		);
	}
})