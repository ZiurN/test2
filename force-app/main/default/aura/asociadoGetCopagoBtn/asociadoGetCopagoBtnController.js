({
	handleClickBtn: function (component, event, helper) {
		let accountId = component.get('v.accountSimpleRecord').Afi_Id__c;
		
		helper.goToApex(component, event, accountId);
	}
})