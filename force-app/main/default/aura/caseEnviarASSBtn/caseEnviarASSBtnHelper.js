({
	checkAttachmentAndSendToSS: function (component, event, idAP) {
        let helper = this;
		let emId = component.get('v.caseSimpleRecord').Evento_Medico__c;
        LightningUtils.callApex(
            component,
            "hasAttachments",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result) {
                        LightningUtils.showToast(
                            "Info",
                            "No se puede enviar porque no tiene archivos adjuntos"
                        );
                    } else {
                        helper.sendToSS(component, event, idAP);
                    }
                } else {

                }
            },
            {
                caseId : idAP,
				emId : emId
            }
        );
    },

	sendToSS: function (component, event, idAP) {
		component.set('v.isLoading', true);
		
		LightningUtils.callApex(
			component,
			"sendCaseToSS",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						LightningUtils.showToast("Info", "Carga de autorización previa exitosa", {"type":"success"});
						component.set('v.isLoading', false);
						$A.get('e.force:refreshView').fire();
					}
					else {
						LightningUtils.showToast("Info", result.message, {"type":"error"});
                        component.set('v.isLoading', false);
					}
				} else {
					let errorMsg = errors[0]['message'] != undefined && errors[0]['message'] != null ? errors[0]['message'] : 'Contacte con un administrador'; 
				    
				    LightningUtils.showToast("Info", errorMsg , {"type":"error"});
                }
				component.set('v.isLoading', false);
			},
			{
				caseToSend : idAP
			}
		);
		
	}
})