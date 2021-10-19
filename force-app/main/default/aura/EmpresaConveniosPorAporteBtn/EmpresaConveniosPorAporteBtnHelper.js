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
            "getConveniosPorAporte",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError) {
                        if(result.convenios.length > 0) {
                            helper.showModal(component, event, result.convenios);
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
                        'Hubo un error, asegúrese que el Afi Id está en formato numérico',
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
            "c:EmpresaConveniosPorAporteModal",
            {
                "convenios" : convenios
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
                    //==================================================================
                    component.find('overlayLib').showCustomModal({
                        header: "Convenios por aporte",
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