({
	handleClickBtn: function (component, event, helper) {
		let codOS = component.get('v.accountSimpleRecord').Codigo_de_obra_social__c;
		helper.goToApex(component, event, codOS);
	}
})