({
	handleClickBtn: function (component, event, helper) {
		let asociadoId = component.get('v.accountSimpleRecord').Afi_Id__c;
		let asociadoMontoExcedente = component.get('v.accountSimpleRecord').Monto_excedente__c;
		helper.showModal(component, event, asociadoId, asociadoMontoExcedente);
	}
})