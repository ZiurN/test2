({
	handleClickBtn: function (component, event, helper) {
		let alertaId = component.get('v.recordId');
		let alertaIdExt = component.get('v.alertaSimpleRecord').idalerta__c;
		helper.goToApex(component, event, alertaId, alertaIdExt);
	}
})