({
	handleUpdate: function (component, event, helper) {
	    let changeType = event.getParams().changeType;

		if (changeType === "CHANGED" || changeType === "LOADED") { 
			
			if(component.get('v.isLeaderVarSetted')) {
				helper.ableDisableButton(component);
			}
			else {
				helper.isLeader(component)
					.then(function(result) {
						let isLeader = component.get('v.isLeader');
					
						helper.ableDisableButton(component);
				});
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
    },
})