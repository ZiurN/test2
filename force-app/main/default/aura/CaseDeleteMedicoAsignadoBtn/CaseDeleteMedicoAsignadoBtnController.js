({
	handleClickBtn: function (component, event, helper) {
		let caseId = component.get('v.recordId');
        helper.deleteMedicoAsignado(component, event, caseId);
	}
})