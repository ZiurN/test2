({
	goToApex: function (component, event, caseIdExterno) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase",
			function (succeed, result, errors) {
				if (succeed) {
					if (!result.hasError) {
						if (result.message == 'ok') {
							LightningUtils.showToast(
							    "Caso Anulado",
							    'El caso ha sido anulado correctamente',
							    {"type":"success"}
                            );
							$A.get('e.force:refreshView').fire();
						} else {
							LightningUtils.showToast("No se pudo anular: ", result.message);
						}
					} else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", 'Hubo un error en SF', {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				caseId : caseIdExterno
			}
		);
	},
	canCancelAPs: function (component) {
		return new Promise(
			$A.getCallback(function(resolve, reject) {
				let action = component.get("c.canCancelAPs");
				action.setCallback(this, function(response) {
					if (response.getState() === 'SUCCESS') {
						component.set('v.canCancelAPs', response.getReturnValue());
						component.set('v.canCancelAPsVarSetted', true);
						resolve(response.getReturnValue());
					}
					else {
						resolve(false);
					}
				});
				$A.enqueueAction(action);
			})
		);
	},
	toggleToEnableButton: function (component) {
		let button = component.find('button');
		let canCancelAPs = component.get('v.canCancelAPs');
		let estado = component.get('v.caseSimpleRecord').Status;
		let rechazado = component.get('v.caseSimpleRecord').Caso_Rechazado__c;
		if (canCancelAPs) {
			button.set('v.disabled', false);
		} else if (estado == 'CA-----E' || estado == 'CA-----N' || rechazado) {
			button.set('v.disabled', true);
		} else {
			button.set('v.disabled', false);
		}
	}
})