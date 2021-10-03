({
	handleClickBtn: function (component, event, helper) {
		let caseId = component.get('v.recordId');
		helper.getAlertasFromApex(component, event, caseId);
	}
})