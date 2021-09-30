({
	handleClickBtn: function (component, event, helper) {
		let orId = component.get('v.recordId');
		helper.sendAtt(component, event, orId);
	}
})