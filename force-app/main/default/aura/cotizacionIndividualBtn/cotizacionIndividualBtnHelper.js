({
    cotizar: function (component, event, id) {
        component.set('v.isLoading', true);
        
		let helper = this;
        LightningUtils.callApex(
            component,
            "sendToWSCotizadorInd",
            function(succeed, result) {
                if(succeed) {
                    if(!result.hasError){
                        LightningUtils.showToast("Info", "Cotizacion exitosa", {"type":"success"});
                        component.set('v.isLoading', false);
						helper.createPDF(component,event,id);
						
                    }
                    else {
                        LightningUtils.showToast("Info", result.message, {"type":"error"});
                        component.set('v.isLoading', false);
                    }
                } else {
                    LightningUtils.showToast("Info", result.message, {"type":"error"});
                }
                component.set('v.isLoading', false);
            },
            {
                cotizacionId : id
            }
        );
    },
	createPDF: function (component, event, id) {
        component.set('v.isLoading', true);
        
        LightningUtils.callApex(
            component,
            "generatePDF",
            function(succeed, result, errors) {
                if(succeed) {
					$A.get('e.force:refreshView').fire();
                    LightningUtils.showToast("Info", "PDF generado", {"type":"success"});
                    component.set('v.isLoading', false);
						
                } else {
                    $A.get('e.force:refreshView').fire();
                    LightningUtils.showToast("Info", 'Ocurrio un error al generar el archivo .pdf. Por favor contacte a un administrador', {"type":"error"});
                }
                component.set('v.isLoading', false);
            },
            {
                cotId : id
            }
        );
    }
})