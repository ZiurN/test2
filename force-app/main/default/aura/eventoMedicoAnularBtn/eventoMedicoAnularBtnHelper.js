({
	goToApex: function (component, event, emId) { 
		let helper = this;
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"anularEM",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if(result.message == 'ok') {
							LightningUtils.showToast("Evento Médico Anulado", 'El evento medico ha sido anulado correctamente', {"type":"success"});
							$A.get('e.force:refreshView').fire();
						}
						else {
							LightningUtils.showToast('Info', result.message);
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
				emId : emId
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
})