({
	goToApex: function (component, event) {
	    let id = component.get('v.recordId');
		let helper = this;
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"sendEventoMedicoToSS",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						if(result.message == 'ok') {
							LightningUtils.showToast(
								'Evento Médico enviado',
								'El evento médico ha sido enviado satisfactoriamente',
								{"type":"success"}
							);
						} else {
							LightningUtils.showToast('Info', result.message);
						}
						$A.get('e.force:refreshView').fire();
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
				idEm : id
			}
		);
	},

	showMissingFields : function (component, event) {
	    let message = '';
	    let stop = false;

        message += this.showRelationshipFieldMessage(component, 'Codigo_de_Afiliado__c', 'Asociado', 'Asociado__');
        message += this.showRelationshipFieldMessage(component, 'Codigo_del_Diagnostico__c', 'Diagnóstico', 'Diagnostico__');
        message += this.showFieldMessage(component, 'Tipo__c', 'Tipo');
        message += this.showRelationshipFieldMessage(component, 'Codigo_de_efector__c', 'Efector Solicitante', 'Efector_Solicitante__');
        message += this.showRelationshipFieldMessage(component, 'Codigo_de_delegacion__c', 'Delegación', 'Delegacion__');
        message += this.showFieldMessage(component, 'Fecha_y_Hora_inicio_EMS__c', 'Fecha y hora inicio EM');
        message += this.showFieldMessage(component, 'Sin_complicaciones__c', 'Sin complicaciones');
        if(message) {
            LightningUtils.showToast(
                "Campos incompletos",
                message
            );
            stop = true;
            message = '';
        }
        return stop;
    },

    showFieldMessage : function (component, fieldApi, fieldName) {
        let msg = '';
        if(!component.get('v.eventoMedicoSimpleRecord')[fieldApi]) {
            msg += '- ' + fieldName + ': debe estar completo \n';
        }
        return msg;
    },

    showRelationshipFieldMessage : function (component, fieldApi, fieldName, relationship) {
        let msg = '';
        if(!component.get('v.eventoMedicoSimpleRecord')[relationship + 'c']
                || (component.get('v.eventoMedicoSimpleRecord')[relationship + 'c']
                    && !component.get('v.eventoMedicoSimpleRecord')[relationship + 'r'][fieldApi])
            ) {
            msg += '- ' + fieldName + ': debe estar completo \n';
        }
        return msg;
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