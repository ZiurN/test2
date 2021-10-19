({
	getConstancia: function (component, event, idAP, cod_afiliado) {
		component.set('v.isLoading',true);
		if(cod_afiliado == null){
			LightningUtils.showToast(
							"Error",
							"Afiliado no tiene Código de afiliado completo",
							{"type":"error"}
						);
			component.set('v.isLoading',false);
			return;
		}
		LightningUtils.callApex(
            component,
            "getConstanciaProvisoria",
            function(succeed, result, errors) {
                if(succeed) {
					if(!result.hasError){
						LightningUtils.showToast(
							"Operación éxitosa",
							result.message,
							{"type":"success"}
						);
					}
					else{
						LightningUtils.showToast(
							"Info",
							result.message
						);
					}
                    
                } else {
					LightningUtils.showToast(
							"Error",
							"Ocurrió un error, contacte a su administrador Salesforce",
							{"type":"error"}
						);
                }
				component.set('v.isLoading',false);
            },
            {
                case_id : idAP,
				codigo_asociado : cod_afiliado
            }
        );
	}
})