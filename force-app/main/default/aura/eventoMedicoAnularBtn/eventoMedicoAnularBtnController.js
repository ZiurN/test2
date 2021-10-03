({
	doInit: function (component, event, helper) {

	},

	handleClickBtn: function (component, event, helper) {
        component.set('v.showConfirmDialog', true);
	},

    handleConfirmDialogYes : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
        let emId = component.get('v.recordId');
        helper.goToApex(component, event, emId);
    },

    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },

})