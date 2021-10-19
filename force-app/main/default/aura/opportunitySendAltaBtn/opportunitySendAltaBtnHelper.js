({
	goToApex: function (component, event, oportunidadId) {
		var helper = this;
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"sendAltaToSS",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
					    if(result.message == 'ok') {
					        LightningUtils.showToast(
					            'Solicitud Enviada',
								'La solicitud fue enviada correctamente',
								{ "type":"success" ,"mode":"pester"}
					        );
                        } else {
							helper.showToast(component,event,result.message,'info');
						}
						$A.get('e.force:refreshView').fire();
						component.set('v.showConfirmDialog', false);
					}
					else {
						component.set('v.showConfirmDialog', false);
						helper.showToast(component,event,result.message,'error');
					}
				} else {
					component.set('v.showConfirmDialog', false);
					helper.showToast(component,event,'Ha ocurrido un error inesperado, comunique a su administrador el error!','error');
                }
                component.set('v.isLoading', false);
			},
			{
				oppId : oportunidadId
			}
		);
	},
	showToast : function(component, event, message,type) {
        var toastEvent = $A.get("e.force:showToast");
        if(message != 'ok'){
            toastEvent.setParams({
                "message": message,
                "mode": 'sticky',
				"type":type
            });
            toastEvent.fire();
        }
    }

})