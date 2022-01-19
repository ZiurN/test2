({
	goToApex: function (component, event, caseIdExterno) {
		let helper = this;
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"deleteAlertasRelatedToCaseAndChangeStatusFromCase",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if(result.message == 'ok') {
							LightningUtils.showToast(
								"Caso Revertido",
								'El caso ha sido revertido correctamente',
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
				caseId : caseIdExterno
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
	isLeader: function (component) {
		return new Promise(
		  $A.getCallback(function(resolve, reject) {
			let action = component.get("c.isLeader");
			action.setCallback(this, function(response) {
				if(response.getState() === 'SUCCESS') {
					component.set('v.isLeader', response.getReturnValue());
					component.set('v.isLeaderVarSetted', true);
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
	toggleEnableButton: function(component) {
		let button = component.find('disableRevertirAPId');
		let estado = component.get('v.caseSimpleRecord').Status;
		let rechazado = component.get('v.caseSimpleRecord').Caso_Rechazado__c || estado == 'Rechazado';
		let isLeader = component.get('v.isLeader');
		if (estado == 'CA-----G' || estado == 'CA-----E' || estado == 'CA-----N' || (rechazado && !isLeader)) {
			button.set('v.disabled', true);
		} else {
			button.set('v.disabled', false);
		}
	}
})