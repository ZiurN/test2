({
	handleClickBtn: function (component, event, helper) {
		let codAsociado = component.get('v.accountSimpleRecord').Codigo_de_Afiliado__c;
		helper.goToApex(component, event, codAsociado);
	}
})