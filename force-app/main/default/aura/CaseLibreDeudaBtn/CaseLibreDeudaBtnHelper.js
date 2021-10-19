({
	getAlertasFromApex: function (component, event, caseId) {
		let helper = this;

		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"generatePdf",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						LightningUtils.showToast("Operacion exitosa", result.message, {"type":"success"});
						helper.navigateToAttachedFiles(component);
					}
					else{
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", JSON.stringify(errors), {"type":"error"});
				}
				$A.get('e.force:refreshView').fire();
                component.set('v.isLoading', false);
			},
			{
				caseId : caseId
			}
		);
	},

	navigateToAttachedFiles: function(component) {
		let relatedListEvent = $A.get("e.force:navigateToRelatedList");
		relatedListEvent.setParams({
			"relatedListId": "CombinedAttachments",
			"parentRecordId": component.get("v.recordId")
		});
		relatedListEvent.fire();
	}

})