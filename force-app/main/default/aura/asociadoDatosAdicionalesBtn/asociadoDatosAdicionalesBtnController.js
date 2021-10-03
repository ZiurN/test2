({	
	handleClickBtn: function (component, event, helper) {
		let idAsociado = component.get('v.accountSimpleRecord').Afi_Id__c;
		helper.goToApex(component, event, idAsociado);
	}
})