({
    doInit: function (component, event, helper) {

    },

    handleClickBtn : function(component, event, helper) {
        let segIdExterno = component.get('v.segSimpleRecord').Id;
        helper.goToApex(component, event, segIdExterno);
    },
})