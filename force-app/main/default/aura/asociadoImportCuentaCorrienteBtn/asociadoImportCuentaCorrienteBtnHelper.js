// ({
// 	goToApex: function (component, event, idAsociado) {
// 		let helper = this;
// 		let id = component.get('v.accountSimpleRecord').Id;
// 		if(!idAsociado) {
// 			LightningUtils.showToast("Campo incompleto", 'El Afi Id no puede estar vacío');
// 			return;
// 		}
// 		component.set('v.isLoading', true);
// 		LightningUtils.callApex(
// 			component,
// 			"getAsociadoCuentaCorriente",
// 			function(succeed, result, errors) {
// 				if(succeed) {
// 					if(!result.hasError){
// 						if(result.asociadoCuentaCorriente.length > 0) {
							
// 							LightningUtils.callApex(
// 								component,
// 								"fillCuentasCorrientesWithTheDataOfTheWS",
// 								function(succeed, result, errors) {
// 									if(succeed) {
// 										//if(!result.hasError){
// 										//	if(!result.asociadoCuentaCorriente.length > 0) {
// 										LightningUtils.showToast( "Datos actualizados", 'Las cuentas corrientes han sido importadas a Salesforce correctamente', {"type":"success"} );
// 										//	} else {
// 										//		LightningUtils.showToast("No hay datos", result.message, {"type":"warning"});
// 										//	}
// 										//}
// 										//else{
// 										//	LightningUtils.showToast("Error", result.message, {"type":"error"});
// 										//}
// 									}
// 									else {
// 										LightningUtils.showToast("Error", "Hubo un error, asegúrese que el Afi Id esté en formato numérico y no esté duplicado", {"type":"error"});
// 									}
// 								},
// 								{
// 									listCuentaCorriente: result.asociadoCuentaCorriente,
// 									accountId: id
// 								}
// 							);

// 						} else {
// 							LightningUtils.showToast("No hay datos", result.message, {"type":"warning"});
// 						}
// 					}
// 					else{
// 						LightningUtils.showToast("Error", result.message, {"type":"error"});
// 					}
// 				}
// 				else {
// 					LightningUtils.showToast("Error", "Hubo un error, asegúrese que el Afi Id esté en formato numérico y no esté duplicado", {"type":"error"});
// 				}
// 				component.set('v.isLoading', false);
// 			},
// 			{
// 				idAsociado: idAsociado,
// 				accountId: id
// 			}
// 		);
// 	}
// })

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
                    //console.log(JSON.stringify(result));
					if(!result.hasError){
                        //console.log(result.asociadoCuentaCorriente);
						if(result.asociadoCuentaCorriente.length > 0){
							helper.showModal(component, event, result.asociadoCuentaCorriente);
						} else {
							LightningUtils.showToast("No hay datos", 'No se encontraron cuentas corrientes para este afiliado en SaludSoft', {"type":"warning"});
						}
					}
					else{
						LightningUtils.showToast("Error", result.message, {"type":"error"});
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

	showModal: function(component, event, ctaCorriente){
		$A.createComponent(
            "c:asociadoCuentaCorrienteModal",
            {
                "ctaCorriente" : ctaCorriente
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Cuenta Corriente",
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