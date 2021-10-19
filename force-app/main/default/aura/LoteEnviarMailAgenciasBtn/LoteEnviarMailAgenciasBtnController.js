({
	handleClickBtn: function (component, event, helper) {
		let idLote = component.get('v.accountSimpleRecord').Id_lote_SS__c;
        helper.sendToSS(component, event, idLote);
	}
})