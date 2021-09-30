({
	doInit: function (component, event, helper) {
	    let changeType = event.getParams().changeType;

		if (changeType === "CHANGED" || changeType === "LOADED") { 
			let estado = component.get('v.caseSimpleRecord').Status;
			let button = component.find('disableRevertirAPId');

			if (estado == 'CA-----G' || estado == 'CA-----E' || estado == 'CA-----N') {
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
        let caseIdExterno = component.get('v.caseSimpleRecord').Codigo_reintegro_SS__c;
        helper.goToApex(component, event, caseIdExterno);
    },

    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
})