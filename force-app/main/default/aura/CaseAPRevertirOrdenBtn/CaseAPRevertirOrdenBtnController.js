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
        let caseId = component.get('v.recordId');

		console.log(caseId);
        
		helper.goToApex(component, event, caseId);
    },

    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
})