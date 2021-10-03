({
	changeLeadStatus : function (component, event, leadId, newStatus) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"convertLead",
			function(succeed, result, errors) {
				if(succeed) {
					
					if(result == null) {
						component.set('v.isLoading', false);
						LightningUtils.showToast("Error", "Por favor, contactese con un administrador", {"type":"error"});
					}
					else {
						var navEvt = $A.get("e.force:navigateToSObject");
						navEvt.setParams({
						  "recordId": result,
						  "slideDevName": "related"
						});
						navEvt.fire();
						component.set('v.isLoading', false);
						LightningUtils.showToast("Ok", result.message, {"type":"success"});
					}
				} else {
					let messages = '';
					Object.keys(errors[0]['fieldErrors']).forEach(function(key) {
						messages = messages + key + ' : ' + errors[0]['fieldErrors'][key][0]['message'] + '\n';
					});
					errors[0]['pageErrors'].forEach(function(key) {
						messages = messages + key['statusCode'] + ' : ' + key['message'] + '\n';
					});
					component.set('v.isLoading', false);
					$A.get("e.force:closeQuickAction").fire();
					LightningUtils.showToast("Error", messages, {"type":"error"});
				}
				
			},
			{
				leadId : leadId,
				newStatus: newStatus
			}
		);
	}
})