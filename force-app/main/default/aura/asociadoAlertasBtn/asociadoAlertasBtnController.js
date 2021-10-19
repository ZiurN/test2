({
	handleClickBtn: function (component, event, helper) {
		let asociadoId = component.get('v.accountSimpleRecord').Afi_Id__c;
		helper.getAlertasFromApex(component, event, asociadoId);
	}
})