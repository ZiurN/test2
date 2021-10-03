({
	handleClickBtn: function (component, event, helper) {
		let afi = component.get('v.accountSimpleRecord').Afi_Id__c;
        helper.sendToSS(component, event, afi);
	}
})