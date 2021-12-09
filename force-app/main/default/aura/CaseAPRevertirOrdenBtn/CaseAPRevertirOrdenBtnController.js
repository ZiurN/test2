({
	handleUpdate: function (component, event, helper) {
		let changeType = event.getParams().changeType;
		if (changeType === "CHANGED" || changeType === "LOADED") {
			if(component.get('v.canRevertOrdersVarSetted')) {
				helper.toggleToEnableButton(component);
			}
			else {
				helper.canRevertOrders(component)
					.then(function(result) {
						helper.toggleToEnableButton(component);
				});
			}
		}
	},
	handleClickBtn: function (component, event, helper) {
		component.set('v.showConfirmDialog', true);
	},
	handleConfirmDialog : function(component, event, helper) {
		component.set('v.showConfirmDialog', true);
	},
	handleConfirmDialogYes : function(component, event, helper) {
		component.set('v.showConfirmDialog', false);
		let caseId = component.get('v.recordId');
		helper.goToApex(component, event, caseId);
	},
	handleConfirmDialogNo : function(component, event, helper) {
		component.set('v.showConfirmDialog', false);
	},
})