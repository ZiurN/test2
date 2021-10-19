({
	handleClickBtn: function (component, event, helper) {
		let id_lote = component.get('v.loteRecord').Id_lote_SS__c;
		helper.validate(component, event, id_lote);
	}
})