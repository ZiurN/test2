({
	doInit: function (component, event, helper) {
	    let changeType = event.getParams().changeType;

		if (changeType === "CHANGED" || changeType === "LOADED") { 
			let estado = component.get('v.caseSimpleRecord').Status;
			let rechazado = component.get('v.caseSimpleRecord').Caso_Rechazado__c;
			let button = component.find('button');
			//estado == 'CA-----G' || 
			if (estado == 'CA-----E' || estado == 'CA-----N' || estado == 'CA-----A' || rechazado || estado == 'Autorizada') {
				button.set('v.disabled', true);
			} else {
				button.set('v.disabled', false);
			}
		}
	},

	handleClickBtn: function (component, event, helper) {
		let idAP = component.get('v.caseSimpleRecord').Id;
		
        helper.checkAttachmentAndSendToSS(component, event, idAP);
	}
})