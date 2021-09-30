({	
	doInit: function (component, event, helper) {
		let changeType = event.getParams().changeType;

		if (changeType === "CHANGED" || changeType === "LOADED") { 
			let estado = component.get('v.oppSimpleRecord').StageName;
			let button = component.find('sendButton');

			if (estado != 'En tramitación') {
				button.set('v.disabled', true);
			} else {
				button.set('v.disabled', false);
			}
		}
	},

	handleClickBtn: function (component, event, helper) {
		if(component.get('v.oppSimpleRecord').Indicador_de_Afiliacion_de_Inmediata__c){
			component.set('v.showConfirmDialog', true);
		}
		else{
			let oppId = component.get('v.recordId');
			helper.goToApex(component, event, oppId);
		}
		
	},
	handleConfirmDialogYes : function(component, event, helper) {
		let oppId = component.get('v.recordId');
		helper.goToApex(component, event, oppId);
	},
	handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    }
})