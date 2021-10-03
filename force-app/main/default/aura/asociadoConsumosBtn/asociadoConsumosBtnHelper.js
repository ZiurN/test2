({
	goToApex: function (component, event, codigoDeAfiliado) {
		let helper = this;
		if(!codigoDeAfiliado) {
			LightningUtils.showToast("Campo incompleto", 'El Código de Afiliado no puede estar vacío');
			return;
		}
		if(!codigoDeAfiliado.match(/^[0-9]*\/[0-9][0-9]$/g)){
			LightningUtils.showToast("Error", 'El Codigo de Afiliado tiene un formato incorrecto. Ej formato: 180015/10', {"type":"error"});
			return;
		}
		helper.showModal(component, event, codigoDeAfiliado);
	},

	showModal: function(component, event, codigoDeAfiliado){
		$A.createComponent(
            "c:asociadoConsumosModal",
            {
				"codigo" : codigoDeAfiliado
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Consumos",
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