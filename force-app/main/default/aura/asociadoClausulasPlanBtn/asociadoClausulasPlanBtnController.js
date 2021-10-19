({	
	handleClickBtn: function (component, event, helper) {
		let idAsociado = component.get('v.accountSimpleRecord').Afi_Id__c;
		let modeloPlanCodigo = component.get('v.accountSimpleRecord').Modelo_Plan_Codigo__c;
		helper.goToApex(component, event, idAsociado, modeloPlanCodigo);
	}
})