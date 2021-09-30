({
    handleSuccess: function(component, event, helper) {
        LightningUtils.showToast('Actualizado', 'El caso fue actualizado correctamente', {'type':'success'});
    },

    handleOnError: function(component, event, helper) {
        let error = event.getParam('error');
        let errors = event.getParams();
    },

    update: function(component, event, helper) {

    }
});