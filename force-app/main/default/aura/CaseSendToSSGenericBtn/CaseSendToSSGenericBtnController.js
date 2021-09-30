({
	handleClickBtn: function (component, event, helper) {
		let caseId = component.get('v.recordId');
        helper.sendToSS(component, event, caseId, false);
	},
	activeField: function (component, event, helper){
		component.set('v.isLoading', false);
	},
	handleCancel: function (component, event, helper){
		component.set("v.showAcceptanceModal", false);
	},
	handleSubmit: function (component, event, helper) {
		component.set("v.showAcceptanceModal", false);
		let caseId = component.get('v.recordId');
		helper.sendToSS(component, event, caseId, true);
	}
})