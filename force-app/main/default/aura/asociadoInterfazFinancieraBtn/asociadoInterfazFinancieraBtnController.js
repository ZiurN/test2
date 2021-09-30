({
	handleBtnClick: function (component, event, helper) {
		helper.getInterfazFinancieraFromApex(component, event, component.get('v.accountSimpleRecord'));
	}
})