({
    goToApex: function (component, event, codEmpresa) {
        let helper = this;
        if(!codEmpresa) {
            LightningUtils.showToast("Campo incompleto", 'El codigo de empresa no puede estar vacío');
            return;
        }
        component.set('v.isLoading', true);
        LightningUtils.callApex(
            component,
            "getConvenios",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError) {
                        if(result.data.convenios.detalles.length > 0) {
                            helper.showModal(component, event, result.data.convenios.detalles);
                        } else {
                            LightningUtils.showToast("No hay datos",
                                'No se encontraron convenios de la empresa en SaludSoft',
                                {"type":"warning"});
                        }
                    }
                    else {
                        LightningUtils.showToast("Error",
                            result.message,
                            {"type":"error"});
                    }
                } else {
                    LightningUtils.showToast("Error",
                        'Hubo un error, asegúrese que el Codigo de Empresa está en formato numérico',
                        {"type":"error"});
                }
                component.set('v.isLoading', false);
            },
            {
                codigoEmpresa : codEmpresa
            }
        );
    },

    showModal: function(component, event, convenios) {
        $A.createComponent(
            "c:empresaConveniosModal",
            {
                "convenios" : convenios
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
                    //==================================================================
                    component.find('overlayLib').showCustomModal({
                        header: "Convenios",
                        body: modalBody,
                        showCloseButton: true
                    });
                    //==================================================================
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.");
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
    }
})