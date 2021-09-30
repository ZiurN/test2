({
	goToApex: function (component, event, idAsociado) {
		let helper = this;
		if(!idAsociado) {
			LightningUtils.showToast("Campo incompleto", 'El Afi Id no puede estar vacío');
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getAsociadoCuentaCorriente",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.asociadoCuentaCorriente.length > 0) {
							let composedIds = result.asociadoCuentaCorriente.map(cta => {
								cta.id_index = cta.id + cta.cuota;
								return cta;
							});
							helper.showModal(component, event, composedIds);
						} else {
							LightningUtils.showToast("No hay datos",
								'No se encontraron cuentas corrientes del afiliado en SaludSoft',
								{"type":"warning"});
						}
					} else {
						LightningUtils.showToast("Error",
							result.message,
							{"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", "Hubo un error, asegúrese que el Afi Id está en formato numérico", {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				idAsociado : idAsociado
			}
		);
	},

	showModal: function(component, event, cuentaCorriente){
		let email = component.get('v.accountSimpleRecord').PersonEmail;
		$A.createComponent(
			"c:asociadoGenerarCuponModal",
			{
				"cuentaCorriente" : cuentaCorriente,
				"accountEmail": email
			},
			function(cmp, status, errorMessage){
				if (status === "SUCCESS") {
					let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Facturas",
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