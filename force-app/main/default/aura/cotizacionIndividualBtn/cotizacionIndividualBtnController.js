({
    doInit: function (component, event, helper) {
    },

    handleClickBtn: function (component, event, helper) {
        let id = component.get('v.recordId');
        helper.cotizar(component, event, id);
    }
})