({
	handleClickBtn: function (component, event, helper) {
		let afi = component.get('v.accountSimpleRecord').Codigo_de_Afiliado__c;
        helper.sendToSS(component, event, afi);
	}
})