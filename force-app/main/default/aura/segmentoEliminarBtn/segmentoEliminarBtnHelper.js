({
    goToApex: function (component, event, segIdExterno) {
        let helper = this;
        let msg = helper.getErrorMessage(component, event, segIdExterno);
        if(msg) {
            LightningUtils.showToast("No se pudo eliminar el segmento porque:", msg, {"duration": 5000});
            return;
        }
        component.set('v.isLoading', true);
        LightningUtils.callApex(
            component,
            "deleteSegmento",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError) {
                        LightningUtils.showToast("Operacion exitosa", result.message, {"type":"success"});
						$A.get('e.force:refreshView').fire();
						helper.redirectToEM(component);
                    }
                    else {
                        LightningUtils.showToast("Error", result.message === '' ? 'Por favor chequear que evento medico y segmento esten cargados en SaludSoft' : result.message, {"type":"error"});
                    }
                } else {
                    LightningUtils.showToast("Error", 'Hubo un error', {"type":"error"});
                }
                component.set('v.isLoading', false);
				$A.get('e.force:refreshView').fire();
            },
            {
                segmentId : segIdExterno
            }
        );
    },

    disableBtn: function (component, event) {
//        let button = component.find('disableEliminarId');
//        button.set('v.disabled', false);
//        let estado = component.get('v.segSimpleRecord').Semid__c;
//        let actual = component.get('v.segSimpleRecord').Segmento_actual__c;
//        let automatico = component.get('v.segSimpleRecord').Creado_Automaticamente__c;
//        if (estado === null || automatico || !actual) {
//            button.set('v.disabled', true);
//        }
    },

    getErrorMessage: function (component, event, segIdExterno) {
        let actual = component.get('v.segSimpleRecord').Segmento_actual__c;
        //let automatico = component.get('v.segSimpleRecord').Creado_Automaticamente__c; 
        let msg = '';

        if(!segIdExterno) {
           msg += '- El segmento no fue enviado a SaludSoft\n';
        }
        //if(automatico) {
        //   msg += '- El segmento se creo automáticamente junto con el evento médico\n';
        //}
        if(!actual) {
          msg += '- El segmento no es el actual\n';
        }
        return msg;
    },

	redirectToEM: function(component) {
		let emId = component.get('v.segSimpleRecord').Evento_Medico__c;
		var navEvt = $A.get("e.force:navigateToSObject");
		navEvt.setParams({
		  "recordId": emId
		});
		navEvt.fire();
		$A.get('e.force:refreshView').fire();
	}
})