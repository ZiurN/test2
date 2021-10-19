({
	handleClickBtn: function (component, event, helper) {
		let idReintegro = component.get('v.caseSimpleRecord').Id;
        helper.sendToSS(component, event, idReintegro);
	}
})