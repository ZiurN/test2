({
    goToApex: function (component, event, codEfector) {
        let helper = this;
        if(!codEfector) {
            LightningUtils.showToast("Campo incompleto", 'El codigo de efector no puede estar vacío');
            return;
        }
        component.set('v.isLoading', true);
        LightningUtils.callApex(
            component,
            "getMatriculasEfector",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError) {
                        if(result.matriculas.length > 0) {
                            helper.showModal(component, event, result.matriculas);
                        } else {
                            LightningUtils.showToast("No hay datos",
                                'No se encontraron matriculas del efector en SaludSoft',
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
                        'Hubo un error, asegúrese que el codigo de efector está en formato numérico',
                        {"type":"error"});
                }
                component.set('v.isLoading', false);
            },
            {
                codigoEfector : codEfector
            }
        );
    },

    showModal: function(component, event, matriculas) {
        $A.createComponent(
            "c:efectorMatriculasModal",
            {
                "matriculas" : matriculas
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
                    //==================================================================
                    component.find('overlayLib').showCustomModal({
                        header: "Matrículas",
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