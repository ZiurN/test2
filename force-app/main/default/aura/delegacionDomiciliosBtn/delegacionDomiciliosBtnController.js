({
	handleClickBtn: function (component, event, helper) {
		let codDelegacion = component.get('v.accountSimpleRecord').Codigo_de_delegacion__c;
		helper.goToApex(component, event, codDelegacion);
	}
})