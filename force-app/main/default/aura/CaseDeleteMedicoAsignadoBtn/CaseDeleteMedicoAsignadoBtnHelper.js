({
	deleteMedicoAsignado: function (component, event, caseId) {
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"deleteMedico",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.message == 'ok') {
							LightningUtils.showToast("Operacioón exitosa", "Se eliminó el médico asignado.", {"type":"success"});
							component.set('v.isLoading', false);
							$A.get('e.force:refreshView').fire();
						}
						else {
							LightningUtils.showToast("Info", result.message);
							$A.get('e.force:refreshView').fire();
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
                        component.set('v.isLoading', false);
					}
				} else {
					let errorMsg = '';
					for(const key in errors[0].fieldErrors) {
						errorMsg += `${errors[0].fieldErrors[key][0].message};`;
						//errorMsg += errors[0].fieldErrors[key][0].message + '. ';
					}
					errorMsg += errors[0].pageErrors.length ? errors[0].pageErrors[0].message : '' ;
					//if(errors[0].pageErrors.length) {
						//errorMsg += errors[0].errors[0].pageErrors[0].message;
					//}
					if(!errorMsg) {
						errorMsg = 'Contacte con un administrador';
					}
				    LightningUtils.showToast("Error", errorMsg , {"type":"error"});
                }
				component.set('v.isLoading', false);
			},
			{
				caseId : caseId
			}
		);
	}
})