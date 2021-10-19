({
    doInit: function (component, event, helper) {
        
    },

    handleClickBtn: function (component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },

    handleConfirmDialog : function(component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },

    handleConfirmDialogYes : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
        let segIdExterno = component.get('v.segSimpleRecord').Semid__c;
        helper.goToApex(component, event, segIdExterno);
    },

    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
})