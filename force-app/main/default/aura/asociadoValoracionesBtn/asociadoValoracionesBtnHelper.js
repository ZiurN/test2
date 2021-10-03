({
	showModal: function(component, event, asociadoId, asociadoMontoExcedente){
		if(!asociadoId) {
			LightningUtils.showToast("Campo incompleto", 'El Afi Id no puede estar vacío');
			return;
		}
		if(!asociadoId.match(/^[0-9]*$/g)){
			LightningUtils.showToast("Error", 'El Afi Id debe ser en formato numérico', {"type":"error"});
			return;
		}
		component.set('v.isLoading', true);
		$A.createComponent(
            "c:asociadoValoracionesModal",
            {
                "asociadoId": asociadoId
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==============================================
					component.find('overlayLib').showCustomModal({
						header: "Valorizaciones",
						body: modalBody,
						showCloseButton: true
					});
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
		component.set('v.isLoading', false);
	}
})