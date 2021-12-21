({
	sendToSS: function (component, event, caseId, aceptance) {
		let needAceptance = component.get("v.simpleRecord").Type == "Baja total";
		if (needAceptance && !aceptance) {
			component.set("v.showAcceptanceModal", true);
		} else if ((needAceptance && aceptance) || !needAceptance) {
			component.set('v.isLoading', true);
			LightningUtils.callApex(
				component,
				"sendToSS",
				function (succeed, result, errors) {
					if (succeed) {
						let hasError = result.hasError;
						let auraMessage = result.auraMessage;
						if (!hasError) {
							let operacion = "";
							if (auraMessage.message.includes("error")) {
								operacion = "Operación incompleta";
							}
							else {
								operacion = "Operación exitosa";
							}
							LightningUtils.showToast(operacion, auraMessage.message, { "type": auraMessage.status, "duration": 50000 });
							component.set('v.isLoading', false);
							$A.get('e.force:refreshView').fire();
						} else {
							LightningUtils.showToast("Se encontro un error procesando...", auraMessage.message, { "type": auraMessage.status, "duration": 60000 });
							component.set('v.isLoading', false);
							$A.get('e.force:refreshView').fire();
						}
					} else {
						let errorMsg = errors[0]['message'] != undefined && errors[0]['message'] != null ? errors[0]['message'] : 'Contacte con un administrador';
						LightningUtils.showToast("Info", errorMsg, { "type": "error", "duration": 50000 });
					}
					component.set('v.isLoading', false);
				},
				{
					recordId: caseId,
					isAttachmentResendFront: false
				}
			);
		}
	}
})