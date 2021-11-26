({
	goToApex: function (component, event, caseId) {
		let helper = this;
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"revertirOrden",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if(result.message == 'ok') {
							LightningUtils.showToast(
								"Orden Revertida",
								'La orden ha sido revertida correctamente',
								 {"type":"success"}
							 );
							 $A.get('e.force:refreshView').fire();
						} else {
							LightningUtils.showToast("No Se Pudo Revertir", result.message);
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					helper.showError(errors);
				}
				component.set('v.isLoading', false);
			},
			{
				caseId : caseId
			}
		);
	},
	showError: function(errors) {
		let errorMsg = '';
		for(const key in errors[0].fieldErrors) {
			errorMsg += `${errors[0].fieldErrors[key][0].message};`;
		}
		errorMsg += errors[0].pageErrors.length ? errors[0].pageErrors[0].message : '' ;
		if(!errorMsg) {
			errorMsg = 'Contacte con un administrador';
		}
		LightningUtils.showToast("Error", errorMsg , {"type":"error"});
	},
	canRevertOrders: function (component) {
		return new Promise(
			$A.getCallback(function(resolve, reject) {
				let action = component.get("c.canRevertOrders");
				action.setCallback(this, function(response) {
					if(response.getState() === 'SUCCESS') {
						component.set('v.canRevertOrders', response.getReturnValue());
						component.set('v.canRevertOrdersVarSetted', true);
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
	toggleToEnableButton: function(component) {
		let button = component.find('disableRevertirOrdenId');
		let estado = component.get('v.caseSimpleRecord').Status;
		let canRevertOrders = component.get('v.canRevertOrders');
		console.log('canRevertOrders: ' + canRevertOrders);
		if(canRevertOrders && estado == 'CA-----E') {
			button.set('v.disabled', false);
		}
		else {
			button.set('v.disabled', true);
		}
	}
})