({
    handleClickBtn: function (component, event, helper) {
        let idInt = component.get('v.integranteRecord').Id;
        helper.goToApex(component, event, idInt);
    }
})