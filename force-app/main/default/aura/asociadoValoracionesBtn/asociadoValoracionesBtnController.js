({
	handleClickBtn: function (component, event, helper) {
		let idAsociado = component.get('v.accountSimpleRecord').Afi_Id__c;
		helper.showModal(component, event, idAsociado);
	}
})