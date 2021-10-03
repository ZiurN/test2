({
	doInit: function (component, event, helper) {
	    let changeType = event.getParams().changeType;

		if (changeType === "CHANGED" || changeType === "LOADED") { 
			let estado = component.get('v.caseSimpleRecord').Status;
			let rechazado = component.get('v.caseSimpleRecord').Caso_Rechazado__c;
			let button = component.find('button');
			//estado == 'CA-----G' || 
			if (estado == 'CA-----G' || estado == 'CA-----E' || estado == 'CA-----N' || rechazado) {
				button.set('v.disabled', true);
			} else {
				button.set('v.disabled', false);
			}
		}
	},

	handleClickBtn: function (component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },

    handleConfirmDialog : function(component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },

    handleConfirmDialogYes : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
        let caseIdExterno = component.get('v.caseSimpleRecord').Nro_AP__c;
        helper.goToApex(component, event, caseIdExterno);
    },

    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    }
})