({
	goToApex: function (component, event, caseId) {
		let helper = this;
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"autorizarAPRechazada",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if (result.message == 'ok') {
							LightningUtils.showToast(
							    "AP Autorizada",
							    'La AP ha sido autorizada correctamente',
							    {"type":"success"}
                            );
							$A.get('e.force:refreshView').fire();
						} else {
							LightningUtils.showToast("No se pudo autorizar: ", result.message);
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
		
		if(errors[0].message) {
			errorMsg = errors[0].message;
		} 
		else {
			for(const key in errors[0].fieldErrors) {
				errorMsg += `${errors[0].fieldErrors[key][0].message}.`;
			}

			errorMsg += errors[0].pageErrors && errors[0].pageErrors.length ? errors[0].pageErrors[0].message : '';

			if(!errorMsg) {
				errorMsg = 'Contacte con un administrador';
			}
		}
    
		LightningUtils.showToast("Error", errorMsg , {"type":"error"});
	}
})