({
	handleClickBtn: function (component, event, helper) {
		let idEfector = component.get('v.recordId');
		helper.goToApex(component, event, idEfector);
	}
})