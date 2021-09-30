({
	goToApex: function (component, event, reintegroIdExterno) {
		let helper = this;
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"deleteAlertasRelatedToReintegroAndChangeStatusToReintegro",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
					    if(result.message == 'ok') {
                            LightningUtils.showToast(
                                "Reintegro Revertido",
                                'El reintegro ha sido revertido correctamente',
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
				reintegroId : reintegroIdExterno
			}
		);
	},

	showError: function(errors) {
		let errorMsg = '';

		for(const key in errors[0].fieldErrors) {
			errorMsg += `${errors[0].fieldErrors[key][0].message}.`;

		}
		errorMsg += errors[0].pageErrors.length ? errors[0].pageErrors[0].message : '' ;

		if(!errorMsg) {
			errorMsg = 'Contacte con un administrador';
		}

		LightningUtils.showToast("Error", errorMsg , {"type":"error"});
	}
})