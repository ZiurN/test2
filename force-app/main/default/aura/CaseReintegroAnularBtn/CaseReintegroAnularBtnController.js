({
	doInit: function (component, event, helper) {
	    let changeType = event.getParams().changeType;

		if (changeType === "CHANGED" || changeType === "LOADED") { 
			let estado = component.get('v.caseSimpleRecord').Status;
			let rechazado = component.get('v.caseSimpleRecord').Caso_Rechazado__c;
			let button = component.find('button');

			if (estado == 'CA-----E' || estado == 'CA-----N' || rechazado) {
				button.set('v.disabled', true);
			} else {
				button.set('v.disabled', false);
			}
		}
	},

	handleClickBtn: function (component, event, helper) {
        component.set('v.showConfirmDialog', true);
	},

    handleConfirmDialogYes : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
        let caseId = component.get('v.recordId');
		
        helper.goToApex(component, event, caseId);
    },

    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },

})