({
	goToApex: function (component, event, idPresentacion) {
        let helper = this;
        if(!idPresentacion) {
            LightningUtils.showToast("Campo incompleto", 'El nro de Presentación está vacío');
            return;
        }
        component.set('v.isLoading', true);
        LightningUtils.callApex(
            component,
            "getEfectorDetallesPresentacion",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError) {
                        if(result.detallesPresentacion.length > 0) {
                            helper.showModal(component, event, result.detallesPresentacion);
                        } else {
                            LightningUtils.showToast("No hay datos",
                                'No se encontraron detalles del Comprobante para esta presentación en SaludSoft',
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
                        'Hubo un error al intentar acceder a Salud Soft',
                        {"type":"error"});
                }
                component.set('v.isLoading', false);
            },
            {
                idComprobante : idPresentacion
            }
        );
    },

    showModal: function(component, event, detalles) {
        $A.createComponent(
            "c:EfectorDetallesPresentacionModal",
            {
                "detalles" : detalles
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
                    //==================================================================
                    component.find('overlayLib').showCustomModal({
                        header: "Detalles del Comprobante",
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