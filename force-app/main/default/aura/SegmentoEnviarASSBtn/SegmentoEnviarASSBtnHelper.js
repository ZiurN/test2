({
    goToApex: function (component, event, segIdExterno) {
        component.set('v.isLoading', true);

        LightningUtils.callApex(
            component,
            "enviarASS",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError) {
                        LightningUtils.showToast("Operacion exitosa", result.message, {"type":"success"});
						$A.get('e.force:refreshView').fire();
                    }
                    else {
                        LightningUtils.showToast("Error", result.message === '' ? 'Por favor chequear que evento medico esten cargados en SaludSoft' : result.message, {"type":"error"});
                    }
                } else {
                    LightningUtils.showToast("Error", 'Hubo un error en SF, por favor contacte con su administrador', {"type":"error"});
                }
                component.set('v.isLoading', false);
            },
            {
                segmentId : segIdExterno
            }
        );
    }
})