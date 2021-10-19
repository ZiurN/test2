({
	handleBtnClick: function (component, event, helper) {
        var codigoDeEntidad = component.get('v.accountSimpleRecord').Codigo_de_efector__c;
		helper.getInterfazFinancieraFromApex(component, event, codigoDeEntidad);
	}
})