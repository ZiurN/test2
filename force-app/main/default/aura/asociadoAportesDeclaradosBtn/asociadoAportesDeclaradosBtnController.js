({
	handleClickBtn: function (component, event, helper) {
		let codigoDeAfiliado = 
            component.get('v.accountSimpleRecord').Codigo_de_Afiliado__c;
        helper.goToApex(component, event, codigoDeAfiliado);
	}
})