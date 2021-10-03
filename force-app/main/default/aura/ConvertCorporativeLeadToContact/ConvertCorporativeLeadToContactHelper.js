({
    changeLeadStatus : function (component, event, leadId, newStatus) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"convertLead",
			function(succeed, result, errors) {
				
				if(succeed) {
					
					if(result == null) {
						LightningUtils.showToast("Candidato modificado ", "Estado actualizado");
					}
					else {
						var navEvt = $A.get("e.force:navigateToSObject");
						navEvt.setParams({
						  "recordId": result,
						  "slideDevName": "related"
						});
						navEvt.fire();
						LightningUtils.showToast("Ok", result.message, {"type":"success"});
					}
				} else {
					let messages = '';
					Object.keys(errors[0]['fieldErrors']).forEach(function(key) {
						messages = messages + key + ' : ' + errors[0]['fieldErrors'][key][0]['message'] + '\n';
					});
					LightningUtils.showToast("Error", messages, {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				leadId : leadId,
				newStatus: newStatus
			}
		);
	}
})