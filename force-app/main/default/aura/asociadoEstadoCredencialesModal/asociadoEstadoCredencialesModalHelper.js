({
	goToApex: function (component, event) {
		let helper = this;
		let action = event.getParam('action');
        let selectedEstado = event.getParam('row');
		
		if(!selectedEstado.id_oca || !selectedEstado.codigo) {
			LightningUtils.showToast('Campo incompleto', 'El id Oca y el código deben estar completos');
			return;
		}

		if(action.name === 'detalles') {
			helper.showCredencialsDetail(component, event, selectedEstado, helper);
		} 
		else if(action.name === 'entregar') {
			helper.cargaCredencial(component, event, selectedEstado, helper);
		}
	},

	showCredencialsDetail: function(component, event, selectedEstado, helper) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getEstadoCredencialesDetalle",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.data.length > 0) {
							helper.showModal(component, event, result.data);
						}
						else {
							LightningUtils.showToast("No hay datos", 'No se encontró detalle para este estado de la credencial', {"type":"warning"});
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", 'Hubo un error en SF, contacte con un administrador', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				codAsociado : selectedEstado.codigo,
				idOca: selectedEstado.id_oca
			}
		);
	},

	cargaCredencial: function(component, event, selectedEstado, helper) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"cargaCredencial",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if(result.message == 'ok') {
							LightningUtils.showToast("Carga correcta", 'Se ha cargado la entrega de credencial al socio.', {"type":"success"});
						}
						else {
							LightningUtils.showToast("Info", result.message);
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", 'Hubo un error en SF, contacte con un administrador', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				codAsociado : selectedEstado.codigo,
				idOca: selectedEstado.id_oca
			}
		);
	},

	showModal: function(component, event, data) {
		$A.createComponent(
			"c:asociadoCredencialDetalle",
			{
				"detalle" : data
			},
			function(cmp, status, errorMessage){
				if (status === "SUCCESS") {
					let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Detalle del estado de la credencial",
						body: modalBody,
						showCloseButton: true
					});
					//==================================================================
				}
				else if (status === "INCOMPLETE") {
					console.log("No response from server or client is offline.")
				}
				else if (status === "ERROR") {
					console.log("Error: " + errorMessage);
				}
			}
		);
		
	}
})