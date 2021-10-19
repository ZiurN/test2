({
	handleClickBtn: function (component, event, helper) {
		let caseId = component.get('v.ordenRecord').Caso__c;

		helper.sendMail(component, event, caseId);
	}
})