({
	doInit: function (component, event, helper) {
	   
	},

	handleClickBtn: function (component, event, helper) {
		let accountId = component.get('v.recordId');
        helper.goToApex(component, event, accountId);
	},

})