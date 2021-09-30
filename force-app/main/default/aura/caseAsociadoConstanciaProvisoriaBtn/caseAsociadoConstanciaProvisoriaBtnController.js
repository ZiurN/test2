({
	handleClickBtn: function (component, event, helper) {
		let idAP = component.get('v.caseSimpleRecord').Id;
		let cod_afiliado = component.get('v.caseSimpleRecord').Account.Codigo_de_Afiliado__c.replace('/','-');
		
        helper.getConstancia(component, event, idAP, cod_afiliado);
	}
})