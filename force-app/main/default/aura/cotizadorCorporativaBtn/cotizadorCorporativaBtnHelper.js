({
	sendToWS: function(component, documentId, recordId){
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"sendToWSCotizadorCorp",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						LightningUtils.showToast("Resultado", "Carga de cotización exitosa", {"type":"success"});
                        component.set('v.isLoading', false);
                        $A.get('e.force:refreshView').fire();
                        $A.get("e.force:closeQuickAction").fire();
					}
					else {
						LightningUtils.showToast("Resultado", result.message, {"type":"error"});
                        component.set('v.isLoading', false);
					}
				} else {
				    LightningUtils.showToast("Internal error", errors, {"type":"error"});
					component.set('v.isLoading', false);
                }
				component.set('v.isLoading', false);
			},
			{
                opportunityId : recordId,
                fileId: documentId 
			}
		);
		
	}
})