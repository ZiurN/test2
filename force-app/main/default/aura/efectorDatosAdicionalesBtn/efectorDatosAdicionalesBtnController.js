({	
	handleClickBtn: function (component, event, helper) {
		let codEfector = component.get('v.accountSimpleRecord').Codigo_de_efector__c;
		helper.goToApex(component, event, codEfector);
	}
})