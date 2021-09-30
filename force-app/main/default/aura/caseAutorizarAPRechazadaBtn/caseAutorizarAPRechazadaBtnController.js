({
	doInit: function (component, event, helper) {
	    let changeType = event.getParams().changeType;

		if (changeType === "CHANGED" || changeType === "LOADED") { 
			//let estado = component.get('v.caseSimpleRecord').Status;
			let rechazado = component.get('v.caseSimpleRecord').Caso_Rechazado__c;
			let button = component.find('button');
			
			if (rechazado) {
				button.set('v.disabled', false);
			} else {
				button.set('v.disabled', true);
			}
		}
	},

	handleClickBtn: function (component, event, helper) {
		let caseId = component.get('v.recordId');
        helper.goToApex(component, event, caseId);
	},


})