({
	handleClickBtn: function (component, event, helper) {
		let cotId = component.get('v.recordId');
		helper.sendAtt(component, event, cotId);
	}
})